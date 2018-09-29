AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Type 							= "anim"
ENT.Spawnable		            	=	true
ENT.AdminSpawnable		            =	true

ENT.PrintName		                =	"[OTHERS]Ammo box"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	"models/Items/ammocrate_smg1.mdl"
ENT.AutomaticFrameAdvance			= 	true

ENT.Opened							= 	false
ENT.NextUse							=	0
ENT.Life							=	300
ENT.CurLife							=	ENT.Life
ENT.Attacker						=	nil

ENT.ExplosionDamage					=	1000
ENT.ExplosionRadius					=	1000

ENT.ExplosionSound 					=	"explosions/cache_explode.wav"
ENT.FarExplosionSound 				=	"explosions/cache_explode_distant.wav"
ENT.DistExplosionSound 				=	"explosions/cache_explode_far_distant.wav"

if SERVER then
	util.AddNetworkString("gred_net_ammobox_cl_gui") 
	util.AddNetworkString("gred_net_ammobox_sv_createshell") 
	util.AddNetworkString("gred_net_ammobox_sv_close") 
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	local p = self:GetPhysicsObject()
	if IsValid(p) then
		p:Wake()
		p:SetMass(1000)
	end
	self:SetPos(self:GetPos() + Vector(0,0,50))
end

function ENT:Use(ply,cal)
	if self.NextUse >= CurTime() or self.CantBeOpened then return end
	if self.Opened then
		self.Opened = false
		self:ResetSequence("close")
	else
		self.Opened = true
		self:ResetSequence("open")
	end
	net.Start("gred_net_ammobox_cl_gui")
			net.WriteEntity(ply)
			net.WriteEntity(self)
	net.Broadcast()
	self.CantBeOpened = true
	self.NextUse = CurTime()+0.5
end

function ENT:OnTakeDamage(dmg)
	if not dmg:IsFallDamage() and dmg:GetDamage() > 5 then
		local n = dmg:GetDamage()
		if n < 0 then n = -n end
		self.Attacker = dmg:GetAttacker()
		self.CurLife = self.CurLife - dmg:GetDamage()
	end
end

function ENT:Explode()
	if SERVER then
	local pos = self:GetPos()
	ParticleEffect("ins_ammo_explosionOLD",pos+Vector(0,0,100),Angle(0,90,0),nil)
	local ent = ents.Create("shockwave_ent")
	ent:SetPos( pos ) 
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER", self.Attacker)
	ent:SetVar("SHOCKWAVEDAMAGE",self.ExplosionDamage)
	ent:SetVar("MAX_RANGE",self.ExplosionRadius)
	ent:SetVar("SHOCKWAVE_INCREMENT",100)
	ent:SetVar("DELAY",0.01)
	ent.trace=self.TraceLength
	ent.decal=self.Decal
	
	local ent = ents.Create("shockwave_sound_lowsh")
	ent:SetPos( pos ) 
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER", self.Attacker)
	ent:SetVar("MAX_RANGE",self.ExplosionDamage*self.ExplosionRadius)
	ent:SetVar("NOFARSOUND",0)
	ent:SetVar("SHOCKWAVE_INCREMENT",200)
	
	ent:SetVar("DELAY",0.01)
	ent:SetVar("SOUNDCLOSE", self.ExplosionSound)
	ent:SetVar("SOUND", self.FarExplosionSound)
	ent:SetVar("SOUNDFAR", self.DistExplosionSound)
	ent:SetVar("Shocktime", 0)
	 
	self:Remove()
	end
end

function ENT:Think()
	if self.CurLife <= 0 then self:Explode() end
end

net.Receive("gred_net_ammobox_sv_createshell",function()
	local shell = net.ReadString()
	local AP = net.ReadBool()
	local Smoke = net.ReadBool()
	local self = net.ReadEntity()
	local ply = net.ReadEntity()
	
	local ent = ents.Create(shell)
	ent:SetPos(self:GetPos() + Vector(0,0,70))
	ent.AP = AP
	ent.Smoke = Smoke
	ent.IsOnPlane = true
	ent:Spawn()
	ent:Activate()
	constraint.NoCollide(self,ent,0,0)
	ent:Use(ply,ply,2,1)
	
end)
net.Receive("gred_net_ammobox_sv_close",function()
	local self = net.ReadEntity()
	self:ResetSequence("close")
	self.Opened = false
	self.CantBeOpened = false
end)
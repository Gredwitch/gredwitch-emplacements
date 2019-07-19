AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

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
			net.WriteEntity(self)
	net.Send(ply)
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
	if self:GetInvincible() then return end
	if SERVER then
		local pos = self:GetPos()
		
		local effectdata = EffectData()
		effectdata:SetOrigin(pos+Vector(0,0,100))
		effectdata:SetFlags(table.KeyFromValue(gred.Particles,"ins_ammo_explosionOLD"))
		effectdata:SetAngles(Angle(0,90,0))
		util.Effect("gred_particle_simple",effectdata)
		
		gred.CreateExplosion(pos,self.ExplosionRadius,self.ExplosionDamage,self.Decal,self.TraceLength,self.Attacker,self,self.DEFAULT_PHYSFORCE,self.DEFAULT_PHYSFORCE_PLYGROUND,self.DEFAULT_PHYSFORCE_PLYAIR)
		
		gred.CreateSound(pos,false,self.ExplosionSound,self.FarExplosionSound,self.DistExplosionSound)
		self:Remove()
	end
end

function ENT:Think()
	if self.CurLife <= 0 then self:Explode() end
end

net.Receive("gred_net_ammobox_sv_createshell",function()
	local shell = net.ReadString()
	if string.StartWith(shell,"models/") then
		local self = net.ReadEntity()
		local ply = net.ReadEntity()
		local gun = net.ReadString()
		local body1 = net.ReadInt(1)
		local body2 = net.ReadInt(1)
		
		local ent = ents.Create("prop_physics")
		ent:SetPos(self:GetPos() + Vector(0,0,70))
		ent:SetModel(shell)
		ent.gredGunEntity = gun
		ent:SetBodygroup(body1,body2)
		ent:Spawn()
		ent:Activate()
		local p=ent:GetPhysicsObject()
		if IsValid(p) then
			p:SetMass(35)
		end
		constraint.NoCollide(self,ent,0,0)
		ply:PickupObject(ent)
	else
		local AP = net.ReadBool()
		local Smoke = net.ReadBool()
		local self = net.ReadEntity()
		local ply = net.ReadEntity()
		
		local ent = ents.Create(shell)
		if not string.StartWith(shell,"gb_shell") then
			ent.Use = function(self,activator,caller)
				local ct = CurTime()
				self.NextUse = self.NextUse or 0
				if self.NextUse >= ct then return end
				if(self.Exploded) then return end
				if(self.Dumb) then return end
				if self:IsPlayerHolding() then return end
				activator:PickupObject(self)
				self.PlyPickup = activator
				self.NextUse = ct + 0.1
			end
		end
		ent:SetPos(self:GetPos() + Vector(0,0,70))
		ent.AP = AP
		ent.Smoke = Smoke
		ent.IsOnPlane = true
		ent:Spawn()
		ent:Activate()
		constraint.NoCollide(self,ent,0,0)
		ent:Use(ply,ply,2,1)
	end
	
end)
net.Receive("gred_net_ammobox_sv_close",function()
	local self = net.ReadEntity()
	self:ResetSequence("close")
	self.Opened = false
	self.CantBeOpened = false
end)
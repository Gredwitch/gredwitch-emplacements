AddCSLuaFile()
ENT.Type 							= "anim"
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[EMP]Base shield"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	""
ENT.BaseEntity						=	nil
ENT.Mass							=	nil

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if (  !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal
		local ent = ents.Create(ClassName)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		return ent
	end

	function ENT:Initialize()
		self:SetModel(self.Model)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.phys = self:GetPhysicsObject()
		if IsValid(self.phys) then
			if self.Mass then self.phys:SetMass(self.Mass) end
			self.phys:Wake()
		end
	end
end
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:Use(activator,caller,useType,value)
	if self.BaseEntity == nil or !IsValid(self.BaseEntity) then return end
	self.BaseEntity:Use(activator,caller,useType,value)
end

function ENT:OnTakeDamage(dmg)
	if self.BaseEntity == nil or !IsValid(self.BaseEntity) then return end
	self.BaseEntity:TakeDamageInfo(dmg)
end
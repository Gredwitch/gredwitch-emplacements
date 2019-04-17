AddCSLuaFile()
ENT.Type 							= "anim"
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[EMP]Base shield"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	""
ENT.NextUse							=	0
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

	function ENT:Use(ply,caller,useType,value)
		if self.canPickUp then
			if self:IsPlayerHolding() then return end
			local ct = CurTime()
			if self.NextUse >= ct then return end
			local ang = self:GetAngles()
			ang.p = 0
			ang.r = 0
			self:SetAngles(ang)
			ply:PickupObject(self)
			self.PlyPickup = ply
			self.NextUse = ct + 0.3
		end
	end

	function ENT:OnTakeDamage(dmg)
		if self.GredEMPBaseENT == nil or !IsValid(self.GredEMPBaseENT) then return end
		if dmg:IsFallDamage() or dmg:IsExplosionDamage() then return end
		self.GredEMPBaseENT:TakeDamageInfo(dmg)
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:Think()
	if SERVER then
		if not self.SentToClient and self.GredEMPBaseENT then
			net.Start("gred_net_emp_prop")
				net.WriteEntity(self)
				net.WriteEntity(self.GredEMPBaseENT)
			net.Broadcast()
			self.SentToClient = true
		end
	end
end
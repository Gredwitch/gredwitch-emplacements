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
ENT.AutomaticFrameAdvance 			= true

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"GredEMPBaseENT")
	
	self:NetworkVarNotify("GredEMPBaseENT",function(ent,name,oldval,newval)
		self.GredEMPBaseENT = newval
	end)
end

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
		
		if IsValid(self.GredEMPBaseENT) then
			self.EmplacementClass = self.GredEMPBaseENT:GetClass()
		end
	end

	function ENT:Use(ply,caller,useType,value)
		local phy = self:GetPhysicsObject()
		local motionEnabled = false
		if IsValid(phy) then
			motionEnabled = phy:IsMotionEnabled()
		end
		if self.canPickUp and !IsValid(ply.ActiveEmplacement) and motionEnabled then
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
		else
			if IsValid(self.GredEMPBaseENT) then
				self.GredEMPBaseENT:Use(ply,caller,useType,value)
			end
		end
	end

	function ENT:OnTakeDamage(dmg)
		if self.GredEMPBaseENT == nil or !IsValid(self.GredEMPBaseENT) then return end
		if dmg:IsFallDamage() or dmg:IsExplosionDamage() then return end
		self.GredEMPBaseENT:TakeDamageInfo(dmg)
	end
	
	-------------------------------------
	
	function ENT:OnDuplicated(entTable)
	end
	
	function ENT:PreEntityCopy()
	
	end
	
	function ENT:PostEntityCopy()
	
	end
	
	function ENT:OnEntityCopyTableFinish(data)
	
	end
	
	function ENT:PostEntityPaste(ply,ent,createdEntities)
	end
	
	function ENT:OnDuplicated()
	
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
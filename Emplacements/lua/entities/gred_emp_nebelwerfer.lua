AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Spawnable		            	=	true
ENT.AdminSpawnable		            =	true

ENT.PrintName		                =	"[EMP]Nebelwerfer 41"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	"models/gredwitch/nebelwerfer/nebelwerfer_base.mdl"
ENT.Mass							=	35
ENT.ActivationSound                  =  "buttons/button14.wav"

if (SERVER) then
	function ENT:SpawnFunction( ply, tr, ClassName )
			if (  !tr.Hit ) then return end
			local SpawnPos = tr.HitPos + tr.HitNormal * 16
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
		phys = self.Entity:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:SetMass(self.Mass)
			phys:Wake()
		end
		self.nextUse = 0
		self:SetSkin(math.random(0,3))
		
		nebelAng = self:GetAngles() + Angle(0,0,math.random(5,-45))
		local nebelTubes = ents.Create("gred_emp_nebelwerfer_tubes")
		nebelTubes:SetPos(self:GetPos() + Vector(0,0,43.8))
		nebelTubes:SetAngles(nebelAng)
		nebelTubes.DefaultAng = nebelAng
		nebelTubes:Spawn()
		nebelTubes:Activate()
		nebelTubes:SetSkin(self:GetSkin())
		self.nebelTubes = nebelTubes
		self:DeleteOnRemove(self.nebelTubes)
		constraint.Axis(nebelTubes,self,0,0,Vector(0,0,0),self:WorldToLocal(nebelTubes:LocalToWorld(Vector(0,1,0))),0,0,10,1,Vector(90,0,0))
		
	end
elseif (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:Use(activator, caller)
	if self.nextUse>CurTime() then return end
	self.nextUse = CurTime()+0.5
	
	if !self.nebelTubes.Smoke then
		self.nebelTubes.Smoke = true
		self:EmitSound(self.ActivationSound)
		activator:ChatPrint("[NEBELWERFER] Smoke rockets selected")
	elseif self.nebelTubes.Smoke then
		self.nebelTubes.Smoke = false
		self:EmitSound(self.ActivationSound)
		activator:ChatPrint("[NEBELWERFER] HE rockets selected")
	end
end

function ENT:Think()
	if SERVER then
		if not IsValid(self.nebelTubes) then
			self:Remove()
		end
	end
end

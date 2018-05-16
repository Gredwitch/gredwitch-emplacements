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
		
		local nebelTubes = ents.Create("gred_emp_nebelwerfer_tubes")
		nebelTubes:SetPos(self:GetPos() + Vector(0,0,43.8))
		-- nebelTubes:SetParent(self)
		nebelTubes:SetAngles(self:GetAngles() + Angle(0,0,math.random(5,-45)))
		nebelTubes:Spawn()
		nebelTubes:Activate()
		self.nebelTubes = nebelTubes
		constraint.Axis(nebelTubes,self,0,0,Vector(0,0,0),self:WorldToLocal(nebelTubes:LocalToWorld(Vector(0,1,0))),0,0,10,1,Vector(90,0,0))
	end
	function ENT:Use()
		if self.nextUse>CurTime() then return end
		self.nextUse = CurTime()+0.5
		if !self.nebelTubes.Smoke then
			self.nebelTubes.Smoke = true
			self:EmitSound(self.ActivationSound)
			-- self.Owner:ChatPrint("[NEBELWERFER] Smoke rockets selected")
			print("[NEBELWERFER] Smoke rockets selected")
		elseif self.nebelTubes.Smoke then
			self.nebelTubes.Smoke = false
			self:EmitSound(self.ActivationSound)
			-- self.Owner:ChatPrint("[NEBELWERFER] HE rockets selected")
			print("[NEBELWERFER] HE rockets selected")
		end
	end
elseif (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
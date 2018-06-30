AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[OTHERS]Shell casing"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	"models/gredwitch/bombs/75mm_shell.mdl"
ENT.HasBodyGroups					=	true
ENT.BodyGroupA						=	0
ENT.BodyGroupB						=	0
ENT.Mass							=	70
ENT.TimeToRemove					=	5--GetConVar("gred_sv_shell_remove_time"):GetInt()

if (SERVER) then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		phys = self.Entity:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:SetMass(self.Mass)
			phys:AddVelocity(self:GetForward()*math.random(80,100))
			phys:AddVelocity(self:GetUp()*math.random(150,200))
			phys:Wake()
		end
		self:SetAngles(self:GetAngles()+Angle(math.random(5,-5),math.random(5,-5),math.random(5,-5))) 
		if self.TimeToRemove == nil then self.TimeToRemove = 20 end
		timer.Simple(self.TimeToRemove,function() if IsValid(self) then self:Remove() end end)
	end
	function ENT:Think()
		self:SetBodygroup(self.BodyGroupA,self.BodyGroupB)
	end
elseif (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end

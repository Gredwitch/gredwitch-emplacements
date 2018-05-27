
include		('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
		phys:SetVelocity( Vector( 0, 0, 0 ) )
	end
	self:StartMotionController()
	
	self:SetUseType(SIMPLE_USE)
	self.MuzzleAttachment=self:LookupAttachment("muzzle")
	self.HookupAttachment=self:LookupAttachment("hookup")
	self:DropToFloor()
	
	sound.Add( {
		name = self.SoundName,
		channel = CHAN_WEAPON,
		volume = 1.0,
		level = 100,
		pitch = {100},
		sound = self.ShootSound
	} )
end

function ENT:OnRemove()
	if self.Shooter != nil then
		net.Start("TurretBlockAttackToggle")
		net.WriteBit(false)
		net.Send(self.Shooter)
		self:SetShooter(nil)
		self:FinishShooting()
		self.Shooter=nil
	end
	self:StopSound(self.SoundName)
end

function ENT:StartShooting()
	self.Shooter:DrawViewModel(false)
	net.Start("TurretBlockAttackToggle")
	net.WriteBit(true)
	net.Send(self.Shooter)
end

function ENT:FinishShooting()
	if IsValid(self.ShooterLast) then
		self.ShooterLast:DrawViewModel(true)
		
		net.Start("TurretBlockAttackToggle")
		net.WriteBit(false)
		net.Send(self.ShooterLast)
		self.ShooterLast=nil
	end
end
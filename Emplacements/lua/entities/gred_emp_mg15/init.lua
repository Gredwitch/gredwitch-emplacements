
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include		('shared.lua')

ENT.turretBaseModel="models/gredwitch/mg81z/mg81z_tripod.mdl"

function ENT:CreateEmplacement()
	local turretBase=ents.Create("prop_physics")
	turretBase:SetModel(self.turretBaseModel)
	turretBase:SetAngles(self:GetAngles()+Angle(0,90,0))
	turretBase:SetPos(self:GetPos()-Vector(0,0,0))
	turretBase:Spawn()
	self.turretBase=turretBase
	
	local shootPos=ents.Create("prop_dynamic")
	shootPos:SetModel("models/mm1/box.mdl")
	shootPos:SetAngles(self:GetAttachment(self:LookupAttachment("muzzle")).Ang)
	shootPos:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos)
	shootPos:Spawn()
	shootPos:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.shootPos=shootPos
	shootPos:SetParent(self)
	shootPos:SetNoDraw(true)
	shootPos:DrawShadow(false)
    shootPos:Fire("setparentattachment","muzzle")
	self:SetDTEntity(1,shootPos)
	
	constraint.NoCollide(self.turretBase,self,0,0)
end


ENT.BasePos=Vector(0,0,0)
ENT.BaseAng=Angle(0,0,0)

ENT.OffsetPos=Vector(0,0,0)
ENT.OffsetAng=Angle(0,0,0)

ENT.Shooter=nil --player.GetHumans()[1]
ENT.ShooterLast=nil


function ENT:Initialize()
	self:SetModel("models/gredwitch/mg15/mg15_gun.mdl")
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	local phys = self.Entity:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
		phys:SetVelocity( Vector( 0, 0, 0 ) )
	end
	
	self.ShadowParams = {}
	self:StartMotionController()
	if not IsValid(self.turretBase) then
		self:CreateEmplacement()
	end
	self:SetUseType(SIMPLE_USE)
	self.MuzzleAttachment=self:LookupAttachment("muzzle")
	self.HookupAttachment=self:LookupAttachment("hookup")
	self:DropToFloor()
	self.shootPos:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.shootPos:SetColor(Color(255,255,255,1))
	if (SERVER) then
		greencolor = Color(0,255,0) 
		bcolor = Color(255,255,0)
		num1   = 5
		num2   = 0.05
		num3   = 1 / (15 + 1)
		num4   = 13 / 2
		num5   = 13 / 8
		num6   = 13 / 350
		num7   = 1 / 13 / 2 * 0.5
	end
	sound.Add( {
		name = "shootMG15",
		channel = CHAN_WEAPON,
		volume = 1.0,
		level = 100,
		pitch = {100},
		sound = "gred_emp/mg15/shoot.wav"
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
	SafeRemoveEntity(self.turretBase)
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

function ENT:GetDesiredShootPos()
	local shootPos=self.Shooter:GetShootPos()
	local playerTrace=util.GetPlayerTrace( self.Shooter )
	playerTrace.filter={self.Shooter,self,self.turretBase}

	local shootTrace=util.TraceLine(playerTrace)
	return shootTrace.HitPos
end


function ENT:PhysicsSimulate( phys, deltatime )
	phys:Wake()
 
	self.ShadowParams.secondstoarrive = 0.01 
	self.ShadowParams.pos = self.BasePos + self.turretBase:GetUp()*40
	self.ShadowParams.angle =self.BaseAng+self.OffsetAng+Angle(0,0,0)
	self.ShadowParams.maxangular = 5000
	self.ShadowParams.maxangulardamp = 10000
	self.ShadowParams.maxspeed = 1000000 
	self.ShadowParams.maxspeeddamp = 10000
	self.ShadowParams.dampfactor = 0.8
	self.ShadowParams.teleportdistance = 200
	self.ShadowParams.deltatime = deltatime
 
	phys:ComputeShadowControl(self.ShadowParams)
end

include		('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:CreateEmplacement()
	local turretBase=ents.Create("prop_physics")
	turretBase:SetModel(self.BaseModel)
	turretBase:SetAngles(self:GetAngles()+Angle(0,90,0))
	turretBase:SetPos(self:GetPos()-Vector(0,0,0))
	turretBase:Spawn()
	self.turretBase=turretBase
	if self.HasRotatingBarrel then
		local barrel=ents.Create("prop_physics")
		barrel:SetModel(self.SecondModel)
		barrel:SetAngles(self:GetAngles()+Angle(0,0,0))
		barrel:SetPos(self:GetPos()+Vector(0,0,self.BarrelHeight))
		barrel:SetParent(self)
		barrel:Spawn()
		constraint.NoCollide(self.barrel,self,0,0) 
		constraint.NoCollide(self.barrel,self.turretBase,0,0) 
		self.barrel=barrel
		self:SetDTEntity(5,barrel)
		
		local shootPos=ents.Create("prop_dynamic")
		shootPos:SetModel("models/mm1/box.mdl")
		shootPos:SetAngles(self.barrel:GetAttachment(self.barrel:LookupAttachment("muzzle")).Ang)
		shootPos:SetPos(self.barrel:GetAttachment(self.barrel:LookupAttachment("muzzle")).Pos)
		shootPos:Spawn()
		shootPos:SetCollisionGroup(COLLISION_GROUP_WORLD)
		shootPos:SetParent(self.barrel)
		shootPos:SetNoDraw(true)
		shootPos:DrawShadow(false)
		shootPos:Fire("setparentattachment","muzzle")
		self.shootPos=shootPos
		self:SetDTEntity(1,self.shootPos)
	else
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
	end
	if self.EmplacementType == "Mortar" then turretBase:SetMoveType(MOVETYPE_FLY) end
	
	constraint.NoCollide(self.turretBase,self,0,0) 
end

function ENT:CreateShield()
	local shield=ents.Create("prop_physics")
	shield:SetModel(self.SecondModel)
	shield:SetAngles(self:GetAngles()+Angle(0,90,0))
	shield:SetPos(self:GetPos()-Vector(0,0,0))
	shield:Spawn()
	self.shield=shield
	constraint.NoCollide(self.shield,self,0,0,true)
	constraint.NoCollide(self.shield,self.turretBase,0,0,true)
end

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self.Entity:PhysicsInit			(SOLID_VPHYSICS)
	self.Entity:SetMoveType			(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid			(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup	(COLLISION_GROUP_DEBRIS)
	
	local phys = self.Entity:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(Vector(0,0,0))
	end
	self.ShadowParams = {}
	self:StartMotionController()
	
	if not IsValid(self.turretBase) then
		self:CreateEmplacement()
	end
	if not IsValid(self.shield) and self.Seatable then
		self:CreateShield()
	end
	
	if self.Seatable then
		hook.Add("PlayerFootstep",self,function(ply,pos,foot,sound,volume)
			if !self:ShooterStillValid() then
				return false 
			else 
				return true 
			end
		end)
		hook.Add("KeyPress",self, function(ply,key)
			if self:ShooterStillValid() and key == IN_USE then
				self:FinishShooting()
			end
		end)
	end
	self.MuzzleAttachments = {}
	if self.HasRotatingBarrel then
		self.MuzzleAttachments[1] = self.barrel:LookupAttachment("muzzle")
		self.HookupAttachment=self.barrel:LookupAttachment("hookup")
		for v=1,self.MuzzleCount do
			if v>1 then
				self.MuzzleAttachments[v] = self.barrel:LookupAttachment("muzzle"..v.."")
			end
		end
	else
		self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
		self.HookupAttachment=self:LookupAttachment("hookup")
		for v=1,self.MuzzleCount do
			if v>1 then
				self.MuzzleAttachments[v] = self:LookupAttachment("muzzle"..v.."")
			end
		end
		self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
	end
	
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	
	self.shootPos:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.shootPos:SetColor(Color(255,255,255,1))
	if (SERVER) and self.EmplacementType == "MG" then
		red = Color(255,0,0)
		green = Color(0,255,0)
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
		name = self.SoundName,
		channel = CHAN_WEAPON,
		volume = 1.0,
		level = 100,
		pitch = {100},
		sound = self.ShootSound
	} )
	if self.HasStopSound then
		sound.Add( {
			name = self.StopSoundName,
			channel = CHAN_WEAPON,
			volume = 1.0,
			level = 100,
			pitch = {100},
			sound = self.StopSound
		} )
	end
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
	self:StopSound(self.StopSoundName)
	SafeRemoveEntity(self.turretBase)
	if self.Seatable then SafeRemoveEntity(self.shield) end
end

function ENT:StartShooting()
	if self.Seatable then 
		local seat = ents.Create("prop_vehicle_prisoner_pod")
		seat:SetAngles(self.shield:GetAttachment(self.shield:LookupAttachment("seat")).Ang-Angle(0,90,0))
		seat:SetPos(self.shield:GetAttachment(self.shield:LookupAttachment("seat")).Pos-Vector(0,0,5))
		seat:SetModel("models/nova/airboat_seat.mdl")
		seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
		seat:SetKeyValue("limitview","0")
		seat:Spawn()
		seat:Activate()
		seat:SetParent		  (self.shield)
		seat:PhysicsInit	  (SOLID_NONE)
		seat:SetRenderMode	  (RENDERMODE_NONE)
		seat:SetSolid		  (SOLID_NONE)
		seat:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self.Seat = seat
		
		self.Shooter:EnterVehicle(self.Seat)
	end
end

function ENT:FinishShooting()
	if IsValid(self.ShooterLast) then
		self.ShooterLast:DrawViewModel(true)
		
		net.Start("TurretBlockAttackToggle")
		net.WriteBit(false)
		net.Send(self.ShooterLast)
		self.ShooterLast:DrawViewModel(true)
		if self.Seatable and IsValid(self.Seat) then
			self.ShooterLast:ExitVehicle(self.Seat)
			self.Seat:Remove()
		end
		self.ShooterLast=nil
		self:StopSound(self.SoundName)
	end
end

function ENT:GetDesiredShootPos()
	if !self:ShooterStillValid() then return end
	local shootpos=self.Shooter:GetShootPos()
	local playerTrace=util.GetPlayerTrace( self.Shooter )
	playerTrace.filter={self.Shooter,self,self.turretBase}
	
	local shootTrace=util.TraceLine(playerTrace)
	return shootTrace.HitPos
end


function ENT:PhysicsSimulate( phys, deltatime )
	if IsValid(self) and IsValid(self.turretBase) then
		if self.Seatable and not IsValid(self.shield) then return end
		phys:Wake()
		
		self.ShadowParams.secondstoarrive = 0.01 
		
		if not self.Seatable then 
			self.ShadowParams.pos = self.BasePos + self.turretBase:GetUp()*self.TurretHeight
		else
			self.ShadowParams.pos = self.BasePos + self.shield:GetUp() + self.turretBase:GetUp()*self.TurretHeight 
		end
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
end
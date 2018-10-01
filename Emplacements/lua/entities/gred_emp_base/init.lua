
include		('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:CreateEmplacement()
	local turretBase=ents.Create("prop_physics")
	turretBase.GredEMPBaseENT = self
	turretBase:SetModel(self.BaseModel)
	turretBase:SetAngles(self:GetAngles()+Angle(0,90,0))
	turretBase:SetPos(self:GetPos()-Vector(0,0,0))
	turretBase:Spawn()
	self.turretBase=turretBase
	if self.EmplacementType == "MG" and GetConVar("gred_sv_cantakemgbase"):GetInt() == 1 and self.SecondModel == "" then
		local p = turretBase:GetPhysicsObject()
		if IsValid(p) then
			p:SetMass(35)
		end
	end
	if self.EmplacementType == "AT" and GetConVar("gred_sv_carriage_collision"):GetInt() == 0 then
		self.turretBase:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	end
	
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
	
	if self.EmplacementType == "Mortar" then turretBase:SetMoveType(MOVETYPE_FLY) end
	
	constraint.NoCollide(self.turretBase,self,0,0) 
end

function ENT:CreateShield()
	local shield=ents.Create("gred_prop_shield")
	shield.GredEMPBaseENT = self
	shield.Model = self.SecondModel
	shield:SetAngles(self:GetAngles()+Angle(0,90,0))
	shield:SetPos(self:GetPos()-Vector(0,0,0))
	shield.BaseEntity = self
	shield:Spawn()
	shield:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
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
	if CLIENT then self.m_initialized = true end
	if SERVER then self.m_initialized = true end
	if self.Seatable and GetConVar("gred_sv_enable_seats"):GetInt() == 0 then
		self.Seatable = false
	end
	local phys = self.Entity:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(Vector(0,0,0))
	end
	self.ShadowParams = {}
	self:StartMotionController()
	self.OldBulletType = self.BulletType
	if SERVER then
		if self.EmplacementType != "MG" and GetConVar("gred_sv_manual_reload"):GetInt() == 1 then
			self.CurAmmo = 0
			self.ShotInterval = 1
			if self.UseSingAnim then
				self:ResetSequence("reload")
				self:SetCycle(.5)
				self:SetPlaybackRate(0)
			else
				self:ResetSequence("reload_start")
			end
		end
		if not IsValid(self.turretBase) then
			self:CreateEmplacement()
		end
		if not IsValid(self.shield) and self.SecondModel != "" then
			self:CreateShield()
		end
		self.MuzzleAttachments = {}
		self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
		self.HookupAttachment=self:LookupAttachment("hookup")
		for v=1,self.MuzzleCount do
			if v>1 then
				self.MuzzleAttachments[v] = self:LookupAttachment("muzzle"..v.."")
			end
		end
		if GetConVar("gred_sv_enable_health"):GetInt() == 1 then
			if self.EmplacementType == "AT" or self.Seatable then
				self.Life = GetConVar("gred_sv_arti_health"):GetInt()
			end
			self.Life = self.Life + self:BoundingRadius()/10
			self.CurLife = self.Life
		else
			self.Destructible = false
		end
	end
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	
	self.shootPos:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.shootPos:SetColor(Color(255,255,255,1))
	self:AddSounds()
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
	if self.EmplacementType != "MG" then
		self:StopSound(self.SoundName)
	else
		self.sounds.shoot:Stop()
		self.sounds.empty:Stop()
		if self.HasStopSound then
			self.sounds.stop:Stop()
		end
	end
	if self.HasStopSound then self:StopSound(self.StopSoundName) end
	SafeRemoveEntity(self.turretBase)
	if self.SecondModel != "" then 
		if self.CanUseShield then hook.Remove("PlayerUse","gred_emp_use_shield") end
		SafeRemoveEntity(self.shield) 
	end
end

function ENT:StartShooting()
	if self.Seatable and IsValid(self.shield) then 
		local seat = ents.Create("prop_vehicle_prisoner_pod")
		local att = self.shield:GetAttachment(self.shield:LookupAttachment("seat"))
		seat:SetAngles(att.Ang-Angle(0,90,0))
		seat:SetPos(att.Pos-Vector(0,0,5))
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
		self:SetDTEntity(2,self.Seat)
		net.Start("gred_net_emp_getplayer")
			net.WriteEntity(self.Shooter)
			net.WriteEntity(self)
		net.Broadcast()
		if SERVER then
			self.Shooter.Gred_Emp_Ent = self
			self.Shooter.Gred_Emp_Class = self:GetClass()
		end
		self.Shooter:EnterVehicle(self.Seat)
		self.Shooter:ChatPrint("Press crouch to switch to a clearer view")
	end
	self.gwep = self.Shooter:GetActiveWeapon()
	self.Shooter:SetActiveWeapon("weapon_base")
end

function ENT:FinishShooting()
	if IsValid(self.ShooterLast) then
		self.ShooterLast:DrawViewModel(true)
		
		net.Start("TurretBlockAttackToggle")
		net.WriteBit(false)
		net.Send(self.ShooterLast)
		self.ShooterLast:DrawViewModel(true)
		if self.Seatable then
			self.ShooterLast:CrosshairEnable()
			self.ShooterLast.Gred_Emp_Ent = nil
			if IsValid(self.Seat) then
				self.ShooterLast:ExitVehicle(self.Seat)
				self.Seat:Remove()
			end
		else
			self.ShooterLast:SetActiveWeapon(self.gwep)
			self.ShooterLast:StripWeapon("weapon_base")
		end
		self.ShooterLast=nil
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
		
		self.ShadowParams.pos = self.BasePos + self.turretBase:GetUp()*self.TurretHeight + self:GetRight()*-self.TurretForward + self:GetForward()*self.TurretHorrizontal
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
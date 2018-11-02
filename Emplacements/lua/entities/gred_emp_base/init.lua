
include		('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:CreateEmplacement()
	local turretBase=ents.Create("gred_prop_shield")
	turretBase.GredEMPBaseENT = self
	turretBase:SetModel(self.BaseModel)
	turretBase:SetAngles(self:GetAngles()+Angle(0,90,0))
	turretBase:SetPos(self:GetPos()-Vector(0,0,0))
	turretBase.BaseEntity = self
	if self.Wheels != "" then
		turretBase.Mass = 500
	end
	turretBase:Spawn()
	turretBase:Activate()
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
	
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self.Entity:PhysicsInit			(SOLID_VPHYSICS)
	self.Entity:SetMoveType			(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid			(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup	(COLLISION_GROUP_DEBRIS)
	self.Entities = {}
	self.Entities[1] = self
	if self.Seatable and GetConVar("gred_sv_enable_seats"):GetInt() == 0 then
		self.Seatable = false
	end
	local phys = self.Entity:GetPhysicsObject()
	if IsValid(phys) then
		if self.Wheels != "" then
			phys:SetMass(phys:GetMass()/2)
		end
		phys:Wake()
		phys:SetVelocity(Vector(0,0,0))
	end
	self.ShadowParams = {}
	self:StartMotionController()
	self.OldBulletType = self.BulletType
	
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
		self.Entities[2] = self.turretBase
	end
	if not IsValid(self.shield) and self.SecondModel != "" then
		self:CreateShield()
		self.Entities[3] = self.shield
	end
	self.MuzzleAttachments = {}
	self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
	self.HookupAttachment=self:LookupAttachment("hookup")
	for v=1,self.MuzzleCount do
		if v>1 then
			self.MuzzleAttachments[v] = self:LookupAttachment("muzzle"..v.."")
		end
	end
	if GetConVar("gred_sv_enable_explosions"):GetInt() == 1 then
		if self.EmplacementType == "AT" or self.Seatable then
			self.Life = 150
		end
		for k,v in pairs(self.Entities) do
			self.Life = self.Life + v:BoundingRadius()/5
		end
		self.CurLife = self.Life
	else
		self.Destructible = false
	end
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	
	self.shootPos:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.shootPos:SetColor(Color(255,255,255,1))
	self:AddSounds()
	
	if self.Wheels != "" then
		self:CreateWheels()
		constraint.Axis(self.wheels,self.turretBase,0,0,Vector(0,0,0),self:WorldToLocal(self.wheels:LocalToWorld(Vector(0,1,0))),0,0,10,1,Vector(90,0,0))
		-- constraint.Weld(self.turretBase,self.wheels,0,0,0,true,true)
		self.Entities[4] = self.wheels
	end
	for k,v in pairs(self.Entities) do
		for a,b in pairs(self.Entities) do
			if v != b then
				constraint.NoCollide(v,b,0,0)
			end
		end
	end	
	-- local ang 
	-- self.OffsetAng=self.turretBase:GetAngles()
	-- self.OldOffsetAng=self.OffsetAng
end

function ENT:CreateWheels()
	local wheels=ents.Create("gred_prop_shield")
	wheels.GredEMPBaseENT = self
	wheels.Model = self.Wheels
	wheels:SetAngles(self:GetAngles()+Angle(0,90,0))
	wheels:SetPos(self.turretBase:GetPos()+self.WheelsPos)
	wheels.BaseEntity = self
	wheels.Mass		  = self.turretBase.phys:GetMass()/2
	wheels:Spawn()
	wheels:Activate()
	wheels:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.wheels=wheels
end

function ENT:OnRemove()
	if self.Shooter != nil then
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
	for k,v in pairs (self.Entities) do
	SafeRemoveEntity(v)
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
		net.Send(self.Shooter)
		self.Shooter.Gred_Emp_Ent = self
		self.Shooter.Gred_Emp_Class = self:GetClass()
		self.Shooter:EnterVehicle(self.Seat)
		
		net.Start("gred_net_message_ply")
			net.WriteEntity(self.Shooter)
			net.WriteString("["..self.NameToPrint.."] Press crouch to switch to a clearer view")
		net.Send(self.Shooter)
	else
		self.gwep = self.Shooter:GetActiveWeapon()
		self.Shooter:SetActiveWeapon("weapon_base")
	end
end

function ENT:FinishShooting()
	if IsValid(self.ShooterLast) then
		self.ShooterLast:DrawViewModel(true)
		
		if self.Seatable then
			net.Start("gred_net_emp_getplayer")
				net.WriteEntity(self.ShooterLast)
				net.WriteEntity(nil)
			net.Send(self.ShooterLast)
			self.ShooterLast.Gred_Emp_Ent = nil
			self.ShooterLast.Gred_Emp_Class = nil
			
			if IsValid(self.Seat) then
				self.ShooterLast:ExitVehicle(self.Seat)
				self.ShooterLast:CrosshairEnable()
				self.Seat:Remove()
			end
		else
			net.Start("TurretBlockAttackToggle")
				net.WriteBit(false)
			net.Send(self.ShooterLast)
			self.ShooterLast:DrawViewModel(true)
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
		-- if !self.NORESET then
			self.ShadowParams.angle =self.BaseAng+self.OffsetAng+Angle(0,0,0)
		-- end
		self.ShadowParams.maxangular = 5000
		self.ShadowParams.maxangulardamp = 10000
		self.ShadowParams.maxspeed = 1000000 
		self.ShadowParams.maxspeeddamp = 10000
		self.ShadowParams.dampfactor = 0.8
		if self.EmplacementType == "AT" then
			self.ShadowParams.teleportdistance = 50
		else
			self.ShadowParams.teleportdistance = 10
		end
		self.ShadowParams.deltatime = deltatime
	 
		phys:ComputeShadowControl(self.ShadowParams)
	end
end
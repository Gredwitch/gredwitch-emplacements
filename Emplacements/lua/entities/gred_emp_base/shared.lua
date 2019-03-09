ENT.Type 					= "anim"
ENT.Base 					= "base_anim"

ENT.Category				= "Gredwitch's Stuff"
ENT.PrintName 				= "[EMP]Base"
ENT.Author					= "Gredwitch"
ENT.Spawnable				= false
ENT.AdminSpawnable			= false

ENT.Editable 				= true
ENT.AutomaticFrameAdvance 	= true

---------------------

ENT.Entities				= {}
ENT.TurretModel				= nil
ENT.YawModel				= nil -- if any
ENT.WheelsModel				= nil -- if any
ENT.HullModel				= nil

---------------------

ENT.TurretMuzzles			= {}
ENT.TurretEjects 			= {}
ENT.TurretPos				= Vector(0,0,0)
ENT.WheelsPos				= Vector(0,0,0)
ENT.ShootAngleOffset		= Angle(0,-90,0)
ENT.ExtractAngle			= Angle(0,-90,0)
ENT.TurretMass				= 100
ENT.Ammo					= 100 -- set to -1 if you want infinite ammo
ENT.Spread					= 0
ENT.Recoil					= 100
ENT.ShootAnim				= nil -- string / int

---------------------

ENT.YawPos					= Vector(0,0,0)
ENT.YawMass					= 100
ENT.HullMass				= 100
ENT.WheelsMass				= 100

---------------------

ENT.MaxUseDistance			= 100

---------------------

-- ENT.AmmunitionTypes				= {}
ENT.AmmunitionType			= nil -- string
ENT.EmplacementType			= nil -- string : "MG" or "Cannon" or "Mortar"
ENT.Sequential				= nil -- bool
ENT.TracerColor				= nil -- string : "Red" or "Yellow" or "Green"
ENT.ShotInterval			= nil -- float : rounds per minute / 60

---------------------

ENT.ShootSound				= nil
ENT.StopShootSound			= nil

ENT.ReloadSound				= nil -- string : full reload sound
ENT.ReloadEndSound			= nil -- string : end reload sound : played after the gun loaded in manual reload mode
ENT.ReloadTime				= nil -- float : reload time in seconds
ENT.CycleRate				= nil -- float :
ENT.MagIn					= true -- bool

ENT.MaxViewModes			= 0 -- int
ENT.DefaultPitch			= 0
ENT.HP						= 200 --+ (ENT.HullModel and 75 or 0) + (ENT.YawModel and 75 or 0)
---------------------

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Hull")
	self:NetworkVar("Entity",1,"Shooter")
	self:NetworkVar("Entity",2,"PrevShooter")
	self:NetworkVar("Entity",3,"Target")
	self:NetworkVar("Entity",4,"Yaw")
	self:NetworkVar("Entity",5,"Seat")
	self:NetworkVar("Entity",6,"Wheels")
	
	self:NetworkVar("Int",0, "Ammo", { KeyName = "Ammo", Edit = { type = "Int", order = 0,min = 0, max = self.Ammo, category = "Ammo"} } )
	self:NetworkVar("Int",1,"CurrentMuzzle")
	self:NetworkVar("Int",2,"CurrentTracer")
	self:NetworkVar("Int",3,"RoundsPerMinute")
	self:NetworkVar("Int",4,"CurrentExtractor")
	self:NetworkVar("Int",5,"ViewMode", { KeyName = "Viewmode", Edit = { type = "Int", order = 0,min = 0, max = self.MaxViewModes} } )
	self:NetworkVar("Int",6,"AmmoType", { KeyName = "Ammotype", Edit = { type = "Int", order = 0,min = 1, max = self.AmmunitionTypes and table.Count(self.AmmunitionTypes) or 0, category = "Ammo"} } )
	-- self:NetworkVar("Int",7,"CurrentAmmoType")
	
	self:NetworkVar("Float",0,"ShootDelay")
	self:NetworkVar("Float",1,"UseDelay")
	self:NetworkVar("Float",2,"NextShot")
	self:NetworkVar("Float",3,"NextEmptySound")
	self:NetworkVar("Float",4,"Recoil")
	self:NetworkVar("Float",5,"NextShootAnim")
	self:NetworkVar("Float",6,"FuzeTime")
	self:NetworkVar("Float",7,"NextSwitchAmmoType")
	self:NetworkVar("Float",8,"NextSwitchViewMode")
	self:NetworkVar("Float",9,"NextSwitchTimeFuze")
	self:NetworkVar("Float",10,"NextShotCL")
	
	self:NetworkVar("Float",7,"HP", { KeyName = "HP", Edit = { type = "Int", order = 0,min = 0, max = self.HP} } )
	
	self:NetworkVar("String",0,"PrevPlayerWeapon")
	
	self:NetworkVar("Bool",0,"BotMode", { KeyName = "BotMode", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",1,"IsShooting")
	self:NetworkVar("Bool",2,"TargetValid")
	self:NetworkVar("Bool",3,"IsReloading")
	self:NetworkVar("Bool",4,"IsAntiAircraft", { KeyName = "IsAntiAircraft", Edit = {type = "Boolean", order = 0, category = "Bots"}})
	self:NetworkVar("Bool",5,"IsAntiGroundVehicles", { KeyName = "IsAntiGroundVehicles", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	
	
	
	self:SetBotMode(false)
	if SERVER then
		self:SetIsAntiAircraft(self.IsAAA)
		self:SetIsAntiGroundVehicles(self.EmplacementType == "Cannon")
		self:SetHP(self.HP)
		self:SetAmmoType(1)
		self:SetFuzeTime(0)
		self:SetAmmo(self.Ammo)
		self:SetCurrentMuzzle(1)
		self:SetRoundsPerMinute(self.ShotInterval*60)
	end
end

function ENT:AddEntity(ent)
	table.insert(self.Entities,ent)
	for k,v in pairs(self.Entities) do
		constraint.NoCollide(v,ent,0,0)
	end
end

function ENT:GrabTurret(ply)
	self:SetShooter(ply)
	if !self:GetBotMode() then
		self.Owner = ply
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) then
			self:SetPrevPlayerWeapon(wep:GetClass())
		end
		if self.Seatable then
			local seat = ents.Create("prop_vehicle_prisoner_pod")
			local yaw = self:GetYaw()
			local a = yaw:LookupAttachment("seat")
			local att = yaw:GetAttachment(a)
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
			seat:SetParent(yaw,a)
			self:SetSeat(seat)
			ply:EnterVehicle(seat)
			ply:CrosshairEnable()
		end
	end
end

function ENT:LeaveTurret(ply)
	if ply:IsPlayer() then
		ply:DrawViewModel(true)
		if ply.StripWeapon and not self.Seatable then
			ply:StripWeapon("weapon_base")
			ply:SelectWeapon(self:GetPrevPlayerWeapon())
		end
		if self.YawModel then
			local seat
			if IsValid(self:GetSeat()) then
				self:GetSeat():Remove()
				self:SetSeat(nil)
			end
		end
	end
	self:SetPrevShooter(ply)
	self:SetShooter(nil)
end

function ENT:ShooterStillValid(ply)
	if not ply then return false
	else
		if self:GetBotMode() then 
			return true 
		else 
			return ply:GetPos():Distance(self:GetPos()) <= self.MaxUseDistance 
		end
	end
end

function ENT:CanShoot(ammo,ct,ply)
	local nextShot
	if CLIENT then
		nextShot = self:GetNextShotCL()
	else
		nextShot = self:GetNextShot()
	end
	if self.EmplacementType != "MG" then
		if self.EmplacementType == "Mortar" then
			if CLIENT then
				return (ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0)) and nextShot <= ct and !self:GetIsReloading() and self:CalcMortarCanShootCL(ply)
			else
				return (ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0)) and nextShot <= ct and !self:GetIsReloading() and self:CalcMortarCanShoot(ply,ct)
			end
		else
			return (ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0)) and nextShot <= ct and !self:GetIsReloading()
		end
	else
		return (ammo > 0 or self.Ammo < 0) and nextShot <= ct and !self:GetIsReloading()
	end
end

function ENT:CheckMuzzle()
	local m = self:GetCurrentMuzzle()
	if m <= 0 or m > table.Count(self.TurretMuzzles) then
		self:SetCurrentMuzzle(1)
	end
end

function ENT:IsValidTarget(ent)
	-- if self.EmplacementType == "Cannon" then
		-- if self:GetIsAntiAircraft() then
			-- return IsValid(ent) and (self:IsValidAirTarget(ent) or self:IsValidGroundTarget(ent) or ent:IsNPC()) --or ent:IsPlayer())
		-- else
			-- return IsValid(ent) and (self:IsValidGroundTarget(ent) or ent:IsNPC()) --or ent:IsPlayer())
		-- end
	-- else
		-- return IsValid(ent) and (self:IsValidAirTarget(ent) or ent:IsNPC()) --or ent:IsPlayer())
	-- end
	return IsValid(ent) and ((self:IsValidAirTarget(ent) and self:GetIsAntiAircraft()) or (self:IsValidGroundTarget(ent) and self:GetIsAntiGroundVehicles()) or ent:IsNPC()) --or ent:IsPlayer())
end

function ENT:IsValidAirTarget(ent)
	return (ent.LFS and ent:GetHP() > 0 and (IsValid(ent:GetDriver()) or ent:GetAI())) or (ent.isWacAircraft and ent.engineHealth > 0 and IsValid(ent.seats[1]:GetDriver())) and !ent:IsOnGround()
end

function ENT:IsValidGroundTarget(ent)
	return (simfphys.IsCar and simfphys.IsCar(ent)) and IsValid(ent:GetDriver())
end

function ENT:KeyDown(key)
	if key == 1 then
		return self:GetTargetValid()
	elseif key == 8192 then
		local ammo = self:GetAmmo()
		if self.EmplacementType == "MG" then
			return !(ammo > 0 or self.Ammo < 0)
		else
			return !(ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0))
		end
	elseif key == 524288 then
		return false
	else
		return false
	end
end

function ENT:SwitchAmmoType(ply)
	self:SetAmmoType(self:GetAmmoType()+1)
	local ammotype = self:GetAmmoType()
	if ammotype <= 0 or ammotype > table.Count(self.AmmunitionTypes) then self:SetAmmoType(1) end
	net.Start("gred_net_message_ply")
		net.WriteEntity(ply)
		local t = self.AmmunitionTypes[self:GetAmmoType()]
		net.WriteString("["..self.NameToPrint.."] "..t[1].." shells selected")
	net.Send(ply)
end

function ENT:SetNewFuzeTime(ply,minus)
	if minus then
		self:SetFuzeTime(self:GetFuzeTime()-0.01)
	else
		self:SetFuzeTime(self:GetFuzeTime()+0.01)
	end
	local fuzetime = self:GetFuzeTime()
	if fuzetime <= 0 or fuzetime > 0.5 then self:SetFuzeTime(0.01) end
	net.Start("gred_net_message_ply")
		net.WriteEntity(ply)
		net.WriteString("["..self.NameToPrint.."] Time fuze set to "..math.Round(self:GetFuzeTime(),2).." seconds")
	net.Send(ply)
end

---------------------
local METERS_IN_UNIT = 0.01905
local g = METERS_IN_UNIT*600 -- Gs in m/s

function ENT:GetShootAngles(ply,botmode)
	local ang
	if botmode then
		if self.EmplacementType == "MG" then
			local target = self:GetTarget()
			if IsValid(target) then
				local pos = target:LocalToWorld(target:OBBCenter())
				local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				local vel = target:GetVelocity()/10
				local dist = attpos:Distance(pos)
				local v
				local ammotype = self.AmmunitionType or self.AmmunitionTypes[1][2]
				if ammotype == "wac_base_7mm" then
					v = 7000
				elseif ammotype == "wac_base_12mm" then
					v = 5000
				elseif ammotype == "wac_base_20mm" then
					v = 3500
				elseif ammotype == "wac_base_30mm" then
					v = 3000
				elseif ammotype == "wac_base_40mm" then
					v = 2000
				else 
					v = 5000 
				end
				local calcPos = pos+vel*(dist/v)
				local trace = util.QuickTrace(attpos,(pos-attpos)*100000,self.Entities)
				if ((trace.Entity == target or trace.Entity:IsPlayer() or trace.Entity:IsNPC()) or trace.HitSky) and dist > 0.015 then
					ang = (calcPos - attpos):Angle()
					ang = Angle(-ang.p,ang.y+180,ang.r)
					ang:RotateAroundAxis(ang:Up(),90)
					self:SetTargetValid(true)
				else
					self:SetTargetValid(false)
				end
				if self:GetIsAntiAircraft() and self:GetAmmoType() == 2 then
					self:SetFuzeTime(((dist/v)/(12+math.Rand(0,1)))+(vel:Length()*0.0002))
				end
				-- debugoverlay.Line(trace.StartPos,calcPos,FrameTime()+0.02,Color( 255, 255, 255 ),false )
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
				ang = self:GetHull():GetAngles()
			end
		elseif self.EmplacementType == "Cannon" then
			local target = self:GetTarget()
			if IsValid(target) then
				local pos = target:LocalToWorld(target:OBBCenter())
				local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				local vel = target:GetVelocity()/10
				local dist = attpos:Distance(pos)
				
				
				local ammotype = self:GetAmmoType()
				local properties = self:GetStoredShellProperties(ammotype)
				
				local velocity = properties[1]
				local fueloutTime = properties[2]
				local v_t = (g * fueloutTime) -- Distance before the shell falls
				local t_distance = dist*METERS_IN_UNIT / v_t  -- Time before the shell falls
				local calcHeight = (0.5 * g * t_distance^2)*METERS_IN_UNIT -- Another distance
				local _,mass = math.modf(properties[3]/100)
				calcHeight = calcHeight + (calcHeight/v_t*g)*fueloutTime  -- Don't question it, that actually works
				-- local calcPos = (pos+vel*(dist/velocity*0.36)) -- Calcs the offset based on the target's velocity
				local calcPos = (pos+vel*(dist/velocity*mass)) -- Calcs the offset based on the target's velocity
				calcPos.z = calcPos.z + calcHeight -- applies the Z offset
				
				local trace = util.QuickTrace(attpos,(pos-attpos)*100000,self.Entities)
				if ((trace.Entity == target or trace.Entity:IsPlayer() or trace.Entity:IsNPC()) or trace.HitSky) and dist > 0.015 then
					ang = (calcPos - attpos):Angle()
					ang = Angle(-ang.p,ang.y+180,ang.r)
					ang:RotateAroundAxis(ang:Up(),90)
					self:SetTargetValid(true)
				else
					self:SetTargetValid(false)
				end
				if self:GetIsAntiAircraft() then
					if ammotype != 2 then self:SetAmmoType(2) end
				end
				debugoverlay.Line(trace.StartPos,calcPos,FrameTime()+0.02,Color( 255, 255, 255 ),false )
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
				ang = self:GetHull():GetAngles()
			end
		elseif self.EmplacementType == "Mortar" then
			local target = self:GetTarget()
			if IsValid(target) then
				local pos = target:LocalToWorld(target:OBBCenter())
				local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				
				local trace = util.QuickTrace(attpos,(pos-attpos)*100000,self.Entities)
				
				ang = (pos - attpos):Angle()
				ang = Angle(-ang.p,ang.y+180,ang.r)
				ang:RotateAroundAxis(ang:Up(),90)
				self:SetTargetValid(true)
				
				-- debugoverlay.Line(trace.StartPos,pos,FrameTime()+0.02,Color( 255, 255, 255 ),false )
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
				ang = self:GetHull():GetAngles()
				local noAngleChange = true
			end
		end
	else
		if not self.Seatable then
			ply:DrawViewModel(false)
			ply:SetActiveWeapon("weapon_base")
		end
		local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
		trace = util.QuickTrace(attpos,ply:EyeAngles():Forward()*100000,self.Entities)
		
		ang = (trace.StartPos - trace.HitPos):Angle()
		ang:RotateAroundAxis(ang:Up(),90)
		
	end
	if self.EmplacementType == "Mortar" and !noAngleChange and ang then
		ang.r = -ang.r - self.DefaultPitch
	end
	if self.MaxRotation and !noAngleChange and ang then
		local hullAng = self:GetHull():GetAngles()
		local newang = ang - hullAng
		newang:Normalize()
		
		if newang.r > self.MaxRotation.p and self.EmplacementType != "Mortar" and self.MaxRotation.p > 0 then
		
			local oldang = hullAng+Angle(0,0,self.MaxRotation.p)
			oldang:Normalize()
			ang.r = oldang.r
			self:SetTarget(nil)
			self:SetTargetValid(false)
		elseif (self.MaxRotation.p > 0 and newang.r < -self.MaxRotation.p) and not (self.MaxRotation.p <= 0 and newang.r < self.MaxRotation.p) and self.EmplacementType != "Mortar" then
			local oldang = hullAng-Angle(0,0,self.MaxRotation.p)
			oldang:Normalize()
			ang.r = oldang.r
			self:SetTarget(nil)
			self:SetTargetValid(false)
		elseif not (self.MaxRotation.p > 0 and newang.r < -self.MaxRotation.p) and (self.MaxRotation.p <= 0 and newang.r < self.MaxRotation.p) and self.EmplacementType != "Mortar" then
			local oldang = hullAng+Angle(0,0,self.MaxRotation.p)
			oldang:Normalize()
			ang.r = oldang.r
			self:SetTarget(nil)
			self:SetTargetValid(false)
		end
		
		if self.MaxRotation.y != 0 then
			if newang.y > self.MaxRotation.y then
			
				local oldang = hullAng+self.MaxRotation
				oldang:Normalize()
				ang.y = oldang.y
				self:SetTarget(nil)
				self:SetTargetValid(false)
			elseif newang.y < -self.MaxRotation.y then
			
				local oldang = hullAng-self.MaxRotation
				oldang:Normalize()
				ang.y = oldang.y
				self:SetTarget(nil)
				self:SetTargetValid(false)
			end
		end
	end
	-- local ft = FrameTime()
	-- self:SetRecoil((self:GetRecoil() + math.Clamp((addRecoil - self:GetRecoil()),-ft,ft)))
	-- ang.r = ang.r + (self:GetRecoil() * self.Recoil)
	-- print(self:GetRecoil() * self.Recoil)
	return ang
end

function ENT:CheckTarget()
	local target = self:GetTarget()
	if !IsValid(target) then
		self:SetTarget(nil)
	else
		if target:IsPlayer() then
			if not target:Alive() then
				self:SetTarget(nil)
			else
				if target:InVehicle() then
					self:SetTarget(target:GetVehicle())
				end
			end
		end
	end
end

function ENT:Think()
	if not self.Initialized then return end 
	
	for k,v in pairs(self.Entities) do
		if IsValid(v) then
			v:SetSkin(self:GetSkin())
		end
	end
	local ct = CurTime()
	local botmode = self:GetBotMode()
	local ply = self:GetShooter()
	local ammo = self:GetAmmo()
	-- print(self:GetHP())
	-- print(botmode)
	if botmode then
		if ply != self then
			self:GrabTurret(self)
		end
		for k,v in pairs(ents.GetAll()) do
			if self:IsValidTarget(v) and not IsValid(self:GetTarget()) then
				self:SetTarget(v)
			end
		end
	end
	
	if IsValid(ply) then
		if not self:ShooterStillValid(ply) then 
			self:LeaveTurret(ply)
		else
			local ang = self:GetShootAngles(ply,botmode)
			if ang then
				if self.YawModel then
					local yaw = self:GetYaw()
					local yawang = yaw:GetAngles()
					local hullang = self:GetHull():GetAngles()
					yawang = Angle(hullang.p,ang.y,hullang.r)
					yawang:Normalize()
					yaw:SetAngles(yawang)
					self:SetAngles(ang)
					
				else
					self:SetAngles(ang)
				end
			end
			
			if self.Seatable then
				local seat = self:GetSeat()
				local seatValid = IsValid(seat)
				if botmode and seatValid then
					seat:Remove()
					self:SetSeat(nil)
				elseif !botmode then
					if seatValid then
						local seatDriver = seat:GetDriver()
						if seatDriver != ply then
							seat:Remove()
							self:SetSeat(nil)
						end
					else
						self:LeaveTurret(ply)
					end
				end
			end
			
			if botmode then
				self:CheckTarget()
				local target = self:GetTarget()
				if IsValid(target) then
				-- print("woof")
					if self:GetIsAntiAircraft() and self.EmplacementType == "MG" then
						if self:IsValidAirTarget(self:GetTarget()) and self:GetIsAntiAircraft() then
							self:SetAmmoType(2)
						else
							self:SetAmmoType(1)
						end
					elseif self.EmplacementType != "MG" then
						if target:IsPlayer() or target:IsNPC() then
							self:SetAmmoType(1)
						else
							if self.AmmunitionTypes[2][1] == "AP" then
								self:SetAmmoType(2)
							end
						end
					end
				end
			end
			
			-- addRecoil = 0
			local IsShooting = ply:KeyDown(IN_ATTACK)
			self:SetIsShooting(IsShooting)
			if IsShooting then
				if self:CanShoot(ammo,ct,ply) then
					if self.Sequential then
						self:CheckMuzzle()
						local m = self:GetCurrentMuzzle()
						local effectdata = EffectData()
						effectdata:SetEntity(self)
						util.Effect("gred_particle_emp_muzzle",effectdata)
						
						if self.EmplacementType == "MG" then
							self:FireMG(ply,ammo,self.TurretMuzzles[m])
						elseif self.EmplacementType == "Mortar" then
							self:FireMortar(ply,ammo,self.TurretMuzzles[m])
						elseif self.EmplacementType == "Cannon" then
							self:FireCannon(ply,ammo,self.TurretMuzzles[m])
						end
						
						self:SetCurrentMuzzle(m + 1)
						if self.EmplacementType == "MG" then
							self:SetAmmo(self:GetAmmo() - GetConVar("gred_sv_limitedammo"):GetInt())
						-- else
							-- self:SetAmmo(self:GetAmmo() - 1)
						end
					else
						for k,m in pairs(self.TurretMuzzles) do
							if self.EmplacementType == "MG" then
								self:FireMG(ply,ammo,m)
							elseif self.EmplacementType == "Mortar" then
								self:FireMortar(ply,ammo,m)
							elseif self.EmplacementType == "Cannon" then
								self:FireCannon(ply,ammo,m)
							end
							local effectdata = EffectData()
							effectdata:SetEntity(self)
							util.Effect("gred_particle_emp_muzzle",effectdata)
							if self.EmplacementType == "MG" then
								self:SetAmmo(self:GetAmmo() - GetConVar("gred_sv_limitedammo"):GetInt())
							-- else
								-- self:SetAmmo(self:GetAmmo() - 1)
							end
						end
					end
					-- addRecoil = 1
					if self.ShootAnim then 
						if self.AnimRestartTime and self.EmplacementType != "Cannon" then
							if self:GetNextShootAnim() < ct then
								self:ResetSequence(self.ShootAnim)
								self:SetNextShootAnim(ct + self.AnimRestartTime)
							end
						else
							self:ResetSequence(self.ShootAnim)
						end
					end
					if self.EmplacementType != "Mortar" then
						self:SetNextShot(ct + self.ShotInterval)
					end
					if self.EmplacementType == "Cannon" then
						self:PlayAnim()
					end
				end
				if self.EmplacementType == "Mortar" then
					self:SetNextShot(ct + self.ShotInterval)
				end
			end
			
			if ammo < self.Ammo and self.Ammo > 0 then
				if ply:KeyDown(IN_RELOAD) and not self:GetIsReloading() then
					self:Reload()
				end
			end
		
			if self.AmmunitionTypes then
				if ply:KeyDown(IN_ATTACK2) then
					if self:GetNextSwitchAmmoType() <= ct then
						if self.EmplacementType != "MG" then
							if GetConVar("gred_sv_manual_reload"):GetInt() == 0 then
								self:SwitchAmmoType(ply)
							end
						else
							self:SwitchAmmoType(ply)
						end
						self:SetNextSwitchAmmoType(ct + 0.3)
					end
				end
				if self.CanSwitchTimeFuze then
					if self.AmmunitionTypes[self:GetAmmoType()][1] == "Time-fuzed" then
						if self:GetNextSwitchTimeFuze() <= ct then
							if ply:KeyDown(IN_WALK) then
								self:SetNewFuzeTime(ply)
							end
							if ply:KeyDown(IN_SPEED) then
								self:SetNewFuzeTime(ply,true)
							end
							self:SetNextSwitchTimeFuze(ct + 0.2)
						end
					end
				end
			end
		end
	else
		if not botmode then
			self:LeaveTurret(ply)
		end
	end
	
	self:ManualReload(ammo)
	
	if self:GetHP() <= 0 then self:Explode() end
	self:OnTick(ct,ply,botmode)
	
	self:NextThink(ct)
	return true
end
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
ENT.HullFly					= false

---------------------

ENT.TurretMuzzles			= {}
ENT.TurretEjects 			= {}
ENT.TurretPos				= Vector(0,0,0)
ENT.WheelsPos				= Vector(0,0,0)
ENT.SeatAngle				= Angle(0,-90,0)
ENT.ShootAngleOffset		= Angle(0,-90,0)
ENT.ExtractAngle			= Angle(0,-90,0)
ENT.TurretMass				= 100
ENT.Ammo					= 100 -- set to -1 if you want infinite ammo
ENT.Spread					= 0
ENT.Recoil					= 1
ENT.CurRecoil				= 0
ENT.RecoilRate				= 0.05
ENT.ShootAnim				= nil -- string / int
ENT.BotAngleOffset			= Angle(0,0,0)

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

--------------------------------------------

local IsValid = IsValid

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
	self:NetworkVar("Float",6,"FuseTime")
	self:NetworkVar("Float",7,"NextSwitchAmmoType")
	self:NetworkVar("Float",8,"NextSwitchViewMode")
	self:NetworkVar("Float",9,"NextSwitchTimeFuse")
	self:NetworkVar("Float",10,"NextShotCL")
	
	self:NetworkVar("Float",7,"HP", { KeyName = "HP", Edit = { type = "Int", order = 0,min = 0, max = self.HP} } )
	
	self:NetworkVar("String",0,"PrevPlayerWeapon")
	
	self:NetworkVar("Vector",0,"TargetOrigin")
	
	self:NetworkVar("Bool",0,"BotMode", { KeyName = "BotMode", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:SetBotMode(false)
	self:NetworkVar("Bool",1,"IsShooting")
	self:NetworkVar("Bool",2,"TargetValid")
	self:NetworkVar("Bool",3,"IsReloading")
	self:NetworkVar("Bool",4,"IsAntiAircraft", { KeyName = "IsAntiAircraft", Edit = {type = "Boolean", order = 0, category = "Bots"}})
	self:NetworkVar("Bool",5,"IsAntiGroundVehicles", { KeyName = "IsAntiGroundVehicles", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",6,"AttackPlayers", { KeyName = "AttackPlayers", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",7,"ShouldNotCareAboutOwnersTeam", { KeyName = "ShouldNotCareAboutOwnersTeam", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",8,"AttackNPCs", { KeyName = "AttackNPCs", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",9,"ShouldSetAngles")
	
	
	self:SetShouldSetAngles(true)
	self:SetAttackPlayers(true)
	self:SetAttackNPCs(true)
	self:SetShouldNotCareAboutOwnersTeam(false)
	self:SetIsAntiAircraft(self.IsAAA)
	self:SetIsAntiGroundVehicles(self.EmplacementType == "Cannon")
	self:SetHP(self.HP)
	self:SetAmmoType(1)
	self:SetFuseTime(0)
	self:SetAmmo(self.Ammo)
	self:SetCurrentMuzzle(1)
	self:SetRoundsPerMinute(self.ShotInterval*60)
	
	self:AddDataTables()
end

function ENT:AddDataTables()

end

function ENT:AddEntity(ent)
	table.insert(self.Entities,ent)
	local noColl = constraint.NoCollide
	for k,v in pairs(self.Entities) do
		noColl(v,ent,0,0)
	end
end

function ENT:ShooterStillValid(ply,botmode)
	if not ply then return false
	else
		if botmode then 
			return true 
		else 
			return ply:GetPos():DistToSqr(self:GetPos()) <= self.MaxUseDistance
		end
	end
end

function ENT:CanShoot(ammo,ct,ply,IsReloading)
	local nextShot
	if CLIENT then
		nextShot = self:GetNextShotCL()
	else
		nextShot = self:GetNextShot()
	end
	if self.EmplacementType != "MG" then
		if self.EmplacementType == "Mortar" then
			if CLIENT then
				return (ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0)) and nextShot <= ct and !IsReloading and self:CalcMortarCanShootCL(ply)
			else
				return (ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0)) and nextShot <= ct and !IsReloading and self:CalcMortarCanShoot(ply,ct)
			end
		else
			return (ammo > 0 or (self.Ammo < 0 and GetConVar("gred_sv_manual_reload"):GetInt() == 0)) and nextShot <= ct and !IsReloading
		end
	else
		return (ammo > 0 or self.Ammo < 0) and nextShot <= ct and !IsReloading
	end
end

function ENT:CheckMuzzle()
	local m = self:GetCurrentMuzzle()
	if m <= 0 or m > table.Count(self.TurretMuzzles) then
		self:SetCurrentMuzzle(1)
	end
end

function ENT:SwitchAmmoType(ply)
	self:SetAmmoType(self:GetAmmoType()+1)
	local ammotype = self:GetAmmoType()
	if ammotype <= 0 or ammotype > table.Count(self.AmmunitionTypes) then self:SetAmmoType(1) end
	net.Start("gred_net_message_ply")
		local t = self.AmmunitionTypes[self:GetAmmoType()]
		net.WriteString("["..self.NameToPrint.."] "..t[1].." shells selected")
	net.Send(ply)
end

function ENT:SetNewFuseTime(ply,minus)
	if minus then
		self:SetFuseTime(self:GetFuseTime()-0.01)
	else
		self:SetFuseTime(self:GetFuseTime()+0.01)
	end
	local fusetime = self:GetFuseTime()
	if fusetime > 0.5 then self:SetFuseTime(0.01) elseif fusetime <= 0 then self:SetFuseTime(0.5) end
	net.Start("gred_net_message_ply")
		net.WriteString("["..self.NameToPrint.."] Time fuse set to "..math.Round(self:GetFuseTime(),2).." seconds")
	net.Send(ply)
end

local g = GetConVar("sv_gravity"):GetFloat()

local math = math
local util = util

local atan = math.atan
local acos = math.acos
local sqrt = math.sqrt
---------------------
local deg = math.deg
					-- FUCK GARRY, FUCK BREXIT LAND, FUCK RADIANS.
local rad = math.rad
---------------------
local function CALC_ANGLE(g,X,V,H) 
	return (deg(acos((g*X^2/V^2-H)/sqrt(H^2+X^2)))+deg(atan(X/H)))/2
end
function ENT:GetShootAngles(ply,botmode,target)
	local ang
	if botmode then
		local target = self:GetTarget()
		if self.EmplacementType == "MG" then
			if IsValid(target) then
				local pos = target:LocalToWorld(target:OBBCenter())
				local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				
				local vel = target:GetVelocity()/10 
				local dist = attpos:DistToSqr(pos)
				self:BulletCalcVel()
				local calcPos = pos+vel*(dist/self.BulletVelCalc)
				local trace = util.QuickTrace(attpos,(pos-attpos)*100000,self.Entities)
				local tv = target.GetVehicle and target:GetVehicle() or false
				if tv and IsValid(tv) then
					local p = tv:GetParent()
					tv = IsValid(p) and p or tv
				end
				if (((trace.Entity == target or target:GetParent() == trace.Entity) or trace.Entity:IsPlayer() or trace.Entity:IsNPC()) or trace.HitSky or (tv and trace.Entity == tv and (((tv.LFS and tv:GetHP() > 0 or tv.isWacAircraft) and self:GetIsAntiAircraft()) or self:GetIsAntiGroundVehicles()))) and dist > 0.015 then
					ang = (calcPos - attpos):Angle()
					ang = Angle(!self.Seatable and -ang.p - self.CurRecoil or -ang.p,ang.y+180,ang.r)
					ang:Add(self.BotAngleOffset)
					ang:RotateAroundAxis(ang:Up(),90)
					self:SetTargetValid(true)
				else
					self:SetTarget(nil)
					-- self:SetTargetValid(false)
				end
				if self:GetIsAntiAircraft() and self:GetAmmoType() == 2 then
					self:SetFuseTime(((dist/self.BulletVelCalc)/(10+math.Rand(0,1)))+(vel:Length()*0.0002))
				end
				-- debugoverlay.Line(trace.StartPos,calcPos,FrameTime()+0.02,Color( 255, 255, 255 ),false )
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
				-- ang = self:GetHull():GetAngles()
			end
		elseif self.EmplacementType == "Cannon" then
			if IsValid(target) then
				-- Don't look at this, pretty much everything here is wrong
				
				local ft = FrameTime()
				local pos = target:LocalToWorld(target:OBBCenter())
				local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				local attang = self:LocalToWorldAngles(self.TurretMuzzles[1].Ang)
				local vel = target:GetVelocity()
				local dist = attpos:Distance(pos) -- need to square it
				
				local ammotype = self:GetAmmoType()
				local properties = self:GetStoredShellProperties(ammotype)
				local SHELL_VEL = self.AmmunitionTypes[ammotype][1] == "AP" and properties.vel or properties.hevel
				
				-------------------------------------------
				
				ang = (attpos-pos):Angle()
				ang.y = ang.y + 90
				
				local H = self:WorldToLocal(pos).z
				print(
					H
				)
				ang.r = CALC_ANGLE(g,dist,SHELL_VEL,H)
				print("ang = "..ang.r,"    g = "..g,"    X = "..dist,"    V = "..SHELL_VEL,"    h = "..H)
				ang.p = 0
				
				-------------------------------------------
				-- print(ang)
				
				-- print(SHELL_MAX_Z)
				-- local TARGET_TOGROUND = util.QuickTrace(pos,Vector(pos.x,pos.y,-9999999),{target}).HitPos
				-- local MUZZLE_TOGROUND = util.QuickTrace(attpos,Vector(attpos.x,attpos.y,-9999999),self.Entities).HitPos
				
				local endpos = util.QuickTrace(attpos,self:GetRight()*-dist,self.Entities).HitPos
				
				debugoverlay.Line(attpos,endpos,FrameTime()+0.03,Color(0,0,255),false )
				-- debugoverlay.Line(SHELL_STOPTHRUST_POS,SHELL_STOPTHRUST_POS_TOGROUND,FrameTime()+0.03,Color(255,0,255),false )
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
				-- ang = self:GetHull():GetAngles()
			end
		elseif self.EmplacementType == "Mortar" then
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
				-- ang = self:GetHull():GetAngles()
				local noAngleChange = true
			end
		end
	else
		if ply:IsPlayer() then
			if not self.Seatable then
				ply:DrawViewModel(false)
				ply:SetActiveWeapon("weapon_base")
			end
			local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
			if self.CustomEyeTrace and self:GetViewMode() > 0 then
				trace = util.QuickTrace(attpos,self.CustomEyeTrace.HitPos,self.Entities)
				ang = (trace.StartPos - trace.HitPos):Angle()
				-- ang:RotateAroundAxis(ang:Up(),90)
			else
				trace = util.QuickTrace(attpos,ply:EyeAngles():Forward()*100000,self.Entities)
				ang = (trace.StartPos - trace.HitPos):Angle()
				ang:RotateAroundAxis(ang:Up(),90)
			end
			
			-- debugoverlay.Line(trace.StartPos,trace.HitPos,FrameTime()+0.02,Color( 255, 255, 255 ),false )
		end
	end
	
	if self.EmplacementType == "Mortar" and !noAngleChange and ang then
		ang.r = -ang.r - self.DefaultPitch
	end
	if self.OffsetAngle then
		ang = ang + self.OffsetAngle
		if self.OffsetAngle.p < 0 then
			ang.r = -ang.r
		end
		ang:Normalize()
	end
	local hullAng = self:GetHull():GetAngles()
	if self.MaxRotation and !noAngleChange and ang then
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
	return ang
end

function ENT:Think()
	if not self.Initialized then return end
	
	local ct = CurTime()
	local botmode = self:GetBotMode()
	local ply = self:GetShooter()
	local ammo = self:GetAmmo()
	local seat
	local canShoot
	local IsShooting
	local seatValid
	local shouldSetAngles = self:GetShouldSetAngles()
	local shouldProceed = true
	local target = self:GetTarget()
	local skin = self:GetSkin()
	local IsReloading = self:GetIsReloading()
	
	for k,v in pairs(self.Entities) do
		if IsValid(v) then
			v:SetSkin(skin)
		end
	end
	
	-- If bot mode is on, find a target
	if botmode then
		if self.EmplacementType == "Cannon" then
			self:SetBotMode(false)
			botmode = false
		else
			if ply != self then
				self:GrabTurret(self)
			end
			if not IsValid(target) then
				target = nil
				if simfphys and istable(simfphys.LFS) then
					for k,v in pairs(simfphys.LFS:PlanesGetAll()) do
						if self:IsValidTarget(v) then
							self:SetTarget(v)
							target = target
							break
						end
					end
				end
				if not target then
					for k,v in pairs(player.GetAll()) do
						if self:IsValidTarget(v) then
							self:SetTarget(v)
							target = v
							break
						end
					end
				end
				if not target then
					for k,v in pairs(gred.AllNPCs) do
						if self:IsValidTarget(v) then
							self:SetTarget(v)
							target = v
							break
						end
					end
				end
			end
		end
	else
		if ply == self then
			self:LeaveTurret(self)
		end
		if self.Seatable then
			seat = self:GetSeat()
			seatValid = IsValid(seat)
			if seatValid then
				if seat:GetDriver() != ply then
					shouldProceed = false
				end
			end
		end
	end
	
	if IsValid(ply) and shouldProceed then
		if not self:ShooterStillValid(ply,botmode) then 
			self:LeaveTurret(ply)
		else
			-- Angle Stuff
			if shouldSetAngles then
				local ang = self:GetShootAngles(ply,botmode,target)
				if ang then
					self:HandleRecoil(ang)
					if self.YawModel then
						local yaw = self:GetYaw()
						local yawang = yaw:GetAngles()
						local hullAng = self:GetHull():GetAngles()
						yawang = Angle(hullAng.p,ang.y,hullAng.r)
						ang = Angle(ang.p - hullAng.p,ang.y,ang.r - hullAng.r)
						yawang:Normalize()
						yaw:SetAngles(yawang)
						self:SetAngles(ang)
						
					else
						self:SetAngles(ang)
					end
				end
			end
			-- Seat checking
			if self.Seatable then
			
				seat = seat or self:GetSeat()
				seatValid = seatValid or IsValid(seat)
				
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
			
			-- Bot stuff (this might need to be optimised)
			if botmode then
				self:CheckTarget()
				if IsValid(target) then
					local tparent = target:GetParent()
					local isValidAirTarget = self:IsValidAirTarget(target)
					if target.GetDriver and not IsValid(target:GetDriver()) and not (tparent.LFS and isValidAirTarget) then
						self:SetTarget(nil)
						target = nil
					else
						if self:GetIsAntiAircraft() and self.EmplacementType == "MG" then
							if self.AmmunitionTypes then
								if isValidAirTarget then
									self:SetAmmoType(2)
								else
									self:SetAmmoType(1)
								end
							end
						elseif self.EmplacementType == "Cannon" then
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
			end
			
			-- Shooting stuff
			IsShooting = shouldSetAngles and ply:KeyDown(IN_ATTACK) or !shouldSetAngles
			self:SetIsShooting(IsShooting)
			self.ShouldDoRecoil = false
			if IsShooting then
				canShoot = self:CanShoot(ammo,ct,ply,IsReloading)
				if canShoot then
					self.ShouldDoRecoil = true
					self:fire(ammo,ct,ply,IsReloading)
				end
			end
			
			-- Reload stuff
			if ammo < self.Ammo and self.Ammo > 0 then
				if ply:KeyDown(IN_RELOAD) and not IsReloading then
					self:Reload()
				end
			end
			
			if self.AmmunitionTypes then
			
				-- Toggle ammo types
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
				
				-- Update fuse time
				if self.CanSwitchTimeFuse then
					if self.AmmunitionTypes[self:GetAmmoType()][1] == "Time-fused" then
						if self:GetNextSwitchTimeFuse() <= ct then self:GetSkin()
							if ply:KeyDown(IN_SPEED) then
								self:SetNewFuseTime(ply)
							end
							if ply:KeyDown(IN_WALK) then
								self:SetNewFuseTime(ply,true)
							end
							self:SetNextSwitchTimeFuse(ct + 0.2)
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
	self:OnTick(ct,ply,botmode,IsShooting,canShoot,ammo,IsReloading,shouldSetAngles)
	
	self:NextThink(ct)
	return true
end

function ENT:fire(ammo,ct,ply)
	if self.Sequential then
		self:CheckMuzzle()
		local m = self:GetCurrentMuzzle()
		
		if self.EmplacementType == "MG" then
			self:FireMG(ply,ammo,self.TurretMuzzles[m])
		elseif self.EmplacementType == "Mortar" then
			self:FireMortar(ply,ammo,self.TurretMuzzles[m])
		elseif self.EmplacementType == "Cannon" then
			self:FireCannon(ply,ammo,self.TurretMuzzles[m])
		end
		
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		util.Effect("gred_particle_emp_muzzle",effectdata)
		
		self:SetCurrentMuzzle(m + 1)
		if self.EmplacementType == "MG" or (self.EmplacementType == "Cannon" and self.Ammo > 1) then -- if MG or Nebelwerfer
			self:SetAmmo(ammo - (self.EmplacementType == "MG" and GetConVar("gred_sv_limitedammo"):GetInt() or 1))
		else
			self:SetAmmo(ammo > 0 and ammo - 1 or 0)
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
			
			if self.EmplacementType == "MG" or (self.EmplacementType == "Cannon" and self.Ammo > 1) then -- if MG or Nebelwerfer
				self:SetAmmo(ammo - (self.EmplacementType == "MG" and GetConVar("gred_sv_limitedammo"):GetInt() or 1))
			else
				self:SetAmmo(ammo > 0 and ammo - 1 or 0)
			end
		end
	end
	
	if self.CustomShootAnim then
		self:CustomShootAnim(self:GetCurrentMuzzle()-1)
	else
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
	end
	
	if self.EmplacementType == "Cannon" and ammo-1 <= 0 then
		self:PlayAnim()
	end
	
	self:SetNextShot(ct + self.ShotInterval)
end

-------------------------------------------- Bot stuff

function ENT:IsValidTarget(ent)
	self.Owner = self.Owner or self
	return IsValid(ent) and (self:IsValidBot(ent) or self:IsValidHuman(ent))
end

function ENT:IsValidBot(ent,b)
	self.Owner = self.Owner or self
	return (ent:IsNPC() and self:GetAttackNPCs() and (!self.Owner:IsPlayer() or ent:Disposition(self.Owner) == 1 or self:GetShouldNotCareAboutOwnersTeam())) 
	or (ent.LFS and ent:GetAI() and self:GetIsAntiAircraft() and (ent:GetAITEAM() != (self.Owner.lfsGetAITeam and self.Owner:lfsGetAITeam() or nil) or self:GetShouldNotCareAboutOwnersTeam()))
end

function ENT:IsValidGroundTarget(ply)
	ent = ply.GetVehicle and ply:GetVehicle() or nil
	if IsValid(ent) then
		local car = ent:GetParent()
		local driver = ent.GetDriver and ent:GetDriver() or nil
		return (simfphys and simfphys.IsCar and IsValid(car) and simfphys.IsCar(car) and (driver != self.Owner and (self.Owner:IsPlayer() and driver:Team() != self.Owner:Team())) or self:GetShouldNotCareAboutOwnersTeam())
	end
end 

function ENT:IsValidHuman(ent)
	return ((ent:IsPlayer() and self:GetAttackPlayers() and ent:Alive()) and ((ent != self.Owner and (self.Owner:IsPlayer() and ent:Team() != self.Owner:Team())) or self:GetShouldNotCareAboutOwnersTeam()) or (self:IsValidGroundTarget(ent) and self:GetIsAntiGroundVehicles()) or self:IsValidAirTarget(ent) and self:GetIsAntiAircraft() and self.EmplacementType != "Mortar")
end

function ENT:IsValidAirTarget(ent)
	local seat = (ent.GetVehicle and ent:GetVehicle() or nil) or ent
	if IsValid(seat) then
		local aircraft = seat:GetParent()
		if IsValid(aircraft) then
			if aircraft.LFS and (IsValid(aircraft:GetDriver()) or self:IsValidBot(aircraft,true)) then
				return aircraft:GetHP() > 0
			elseif aircraft.isWacAircraft then
				return aircraft.engineHealth > 0 and IsValid(seat:GetDriver())
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
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

function ENT:CheckTarget()
	local target = self:GetTarget()
	if !IsValid(target) then
		self:SetTarget(nil)
		self:SetTargetValid(false)
	else
		if target:IsPlayer() then
			if self:IsValidHuman(target) then
				if not target:Alive() then
					self:SetTarget(nil)
					self:SetTargetValid(false)
				else
					if target:InVehicle() then
						local veh = target:GetVehicle():GetParent()
						if (self.EmplacementType == "Mortar" and not self:IsValidAirTarget(veh)) or self.EmplacementType != "Mortar" then
							self:SetTarget(veh)
							self:SetTargetOrigin(veh:OBBCenter())
						else
							self:SetTarget(nil)
							self:SetTargetValid(false)
							target = nil
						end
					end
				end
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
			end
		elseif target:IsNPC() then
			if !self:IsValidBot(target) then
				self:SetTarget(nil)
				self:SetTargetValid(false)
			end
		end
	end
end


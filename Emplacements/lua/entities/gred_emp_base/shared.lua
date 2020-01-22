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
ENT.PitchRate				= 200
ENT.YawRate					= 200
ENT.TurretMass				= 100
ENT.Ammo					= 100 -- set to -1 if you want infinite ammo
ENT.Spread					= 0
ENT.Recoil					= 1
ENT.CurRecoil				= 0
ENT.RecoilRate				= 0.05
ENT.ShootAnim				= nil -- string / int
ENT.BotAngleOffset			= Angle(0,0,0)
ENT.DelayToNetwork = 0

---------------------

ENT.YawPos					= Vector(0,0,0)
ENT.YawMass					= 100
ENT.HullMass				= 100
ENT.WheelsMass				= 100

---------------------

ENT.MaxUseDistance			= 80

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
ENT.NextFindBot				= 0
ENT.HP						= 200 --+ (ENT.HullModel and 75 or 0) + (ENT.YawModel and 75 or 0)

----------------------------------------

local IsValid = IsValid
local ok = {
	["gred_prop_part"] = true,
}

function ENT:SetupDataTables()
	self.OldMaxViewModes = self.MaxViewModes
	
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
	self:NetworkVar("Int",5,"ViewMode")
	self:NetworkVar("Int",6,"AmmoType", { KeyName = "Ammotype", Edit = { type = "Int", order = 0,min = 1, max = self.AmmunitionTypes and table.Count(self.AmmunitionTypes) or 0, category = "Ammo"} } )
	-- self:NetworkVar("Int",7,"CurrentAmmoType")
	
	self:NetworkVar("Float",0,"ShootDelay")
	self:NetworkVar("Float",1,"UseDelay")
	self:NetworkVar("Float",2,"NextShot")
	self:NetworkVar("Float",3,"HP", { KeyName = "HP", Edit = { type = "Float", order = 0,min = 0, max = 1000} } )
	self:NetworkVar("Float",4,"Recoil")
	self:NetworkVar("Float",5,"NextShootAnim")
	self:NetworkVar("Float",6,"FuseTime")
	self:NetworkVar("Float",7,"NextSwitchAmmoType")
	self:NetworkVar("Float",8,"NextSwitchViewMode")
	self:NetworkVar("Float",9,"NextSwitchTimeFuse")
	
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
	self:NetworkVar("Bool",10,"IsAttacking")
	
	
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
			return ply:Alive() and (!self.Seatable and ply:GetPos():DistToSqr(self:GetPos()) <= self.MaxUseDistance or self.Seatable)
		end
	end
end


----------------------------------------
-- MATHS

function ENT:CheckMuzzle()
	local m = self:GetCurrentMuzzle()
	if m <= 0 or m > table.Count(self.TurretMuzzles) then
		self:SetCurrentMuzzle(1)
	end
end

----------------------------------------
-- BOT


function ENT:TargetTraceValid(trace,target)
	local tv = target.GetVehicle and target:GetVehicle() or false
	if tv and IsValid(tv) then
		local p = tv:GetParent()
		tv = IsValid(p) and p or tv
	end
	
	return ((trace.Entity == target or target:GetParent() == trace.Entity) and self:IsValidTarget(target)) 
	or (trace.HitSky and (IsValid(trace.Entity) and trace.Entity:IsPlayer() or trace.Entity:IsNPC() or ok[trace.Entity:GetClass()]))
	or (tv and trace.Entity == tv and (self:IsValidAirTarget(tv) or self:IsValidGroundTarget(tv,self:GetIsAntiGroundVehicles()))),tv
end

function ENT:IsValidTarget(ent)
	self.Owner = self.Owner or self
	return IsValid(ent) and ent:GetClass() != "prop_physics" and (self:IsValidBot(ent) or self:IsValidHuman(ent))
end

function ENT:IsValidBot(ent,b)
	self.Owner = self.Owner or self
	return ((ent:IsNPC() and self:GetAttackNPCs() and (!self.Owner:IsPlayer() or ent:Disposition(self.Owner) == 1 or self:GetShouldNotCareAboutOwnersTeam())) 
	or (ent.LFS and ent:GetAI() and self:GetIsAntiAircraft() and (ent:GetAITEAM() != (self.Owner.lfsGetAITeam and self.Owner:lfsGetAITeam() or nil) or self:GetShouldNotCareAboutOwnersTeam())))
end

function ENT:IsValidGroundTarget(ply,IsAntiGroundVehicles)
	ent = ply.GetVehicle and ply:GetVehicle() or ply
	if IsValid(ent) then
		local car = IsValid(ent:GetParent()) and ent:GetParent() or ent
		local driver = ent.GetDriver and ent:GetDriver() or nil
		return (simfphys and simfphys.IsCar and IsValid(car) and simfphys.IsCar(car) and (driver != self.Owner and (self.Owner:IsPlayer() and driver:Team() != self.Owner:Team())) or self:GetShouldNotCareAboutOwnersTeam()) and (IsAntiGroundVehicles or !car.IsArmored)
	end
end 

function ENT:IsValidHuman(ent)
	return ((ent:IsPlayer() and self:GetAttackPlayers() and ent:Alive()) and ((ent != self.Owner and (self.Owner:IsPlayer() and ent:Team() != self.Owner:Team())) or self:GetShouldNotCareAboutOwnersTeam()) or (self:IsValidGroundTarget(ent,self:GetIsAntiGroundVehicles())) or self:IsValidAirTarget(ent) and self:GetIsAntiAircraft() and self.EmplacementType != "Mortar") and ent:GetClass() != "prop_physics" and IsValid(ent)
end

function ENT:IsValidAirTarget(ent)
	local seat = (ent.GetVehicle and ent:GetVehicle() or nil) or ent
	if IsValid(seat) then
		local aircraft = (seat.LFS or seat.isWacAircraft) and seat or seat:GetParent()
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

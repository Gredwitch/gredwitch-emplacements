ENT.Type 					= "anim"
ENT.Base 					= "base_anim"

ENT.Category				= "Gredwitch's Stuff"
ENT.PrintName 				= "[EMP]Base"
ENT.Author					= "Gredwitch"
ENT.Spawnable				= false
ENT.AdminSpawnable			= false

ENT.Editable 				= true
ENT.AutomaticFrameAdvance 	= true

ENT.IsEmplacement			= true

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

ENT.NextShootAnim			= 0
ENT.NextSwitchTimeFuse		= 0
ENT.NextSwitchAmmoType		= 0
ENT.NextSwitchViewMode		= 0
ENT.CurShot					= 0
ENT.NextShot				= 0
ENT.FuseTime				= 0.01
ENT.MaxRotation				= Angle(180,180,180)
ENT.MinRotation				= Angle(-180,-180,-180)

----------------------------------------



local IsValid = IsValid
local noColl = constraint.NoCollide
local SERVER = SERVER
local CLIENT = CLIENT

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
	
	self:NetworkVar("Int",0,"Ammo", { KeyName = "Ammo", Edit = { type = "Int", order = 0,min = 0, max = self.Ammo, category = "Ammo"} } )
	-- self:NetworkVar("Int",1,"CurrentMuzzle")
	-- self:NetworkVar("Int",2,"CurrentTracer")
	self:NetworkVar("Int",3,"AmmoType", { KeyName = "Ammotype", Edit = { type = "Int", order = 0,min = 1, max = self.AmmunitionTypes and table.Count(self.AmmunitionTypes) or 0, category = "Ammo"} } )
	-- self:NetworkVar("Int",4,"CurrentExtractor")
	self:NetworkVar("Int",2,"ViewMode") -- 5
	self:NetworkVar("Int",4,"FuseTime")
	-- self:NetworkVar("Int",4,"RandomSeed")
	
	-- self:NetworkVar("Float",0,"Recoil")
	
	self:NetworkVar("Bool",0,"BotMode", { KeyName = "BotMode", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	-- self:NetworkVar("Bool",1,"IsShooting")
	self:NetworkVar("Bool",2,"TargetValid")
	self:NetworkVar("Bool",3,"IsReloading")
	self:NetworkVar("Bool",4,"IsAntiAircraft", { KeyName = "IsAntiAircraft", Edit = {type = "Boolean", order = 0, category = "Bots"}})
	self:NetworkVar("Bool",5,"IsAntiGroundVehicles", { KeyName = "IsAntiGroundVehicles", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",6,"AttackPlayers", { KeyName = "AttackPlayers", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",7,"ShouldNotCareAboutOwnersTeam", { KeyName = "ShouldNotCareAboutOwnersTeam", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",1,"AttackNPCs", { KeyName = "AttackNPCs", Edit = {type = "Boolean", order = 0, category = "Bots"} } )
	self:NetworkVar("Bool",9,"IsAttacking")
	
	
	self:SetBotMode(false)
	self.ShouldSetAngles = true
	self:SetAttackPlayers(true)
	self:SetAttackNPCs(true)
	self:SetShouldNotCareAboutOwnersTeam(false)
	self:SetIsAntiAircraft(self.IsAAA)
	self:SetIsAntiGroundVehicles(self.EmplacementType == "Cannon")
	self:SetAmmoType(1)
	self:SetAmmo(self.Ammo)
	
	if CLIENT then
		self:NetworkVarNotify("Shooter",function(ent,name,oldval,ply)
			if oldval != ply then
				self:OnPlayerTookEmplacement(ply)
				
				ply.Gred_Emp_Ent = self
			end
		end)
		
		self:NetworkVarNotify("PrevShooter",function(ent,name,oldval,ply)
			if oldval != ply then
				if IsValid(ply) and ply.Gred_Emp_Ent == ent then
					ply.Gred_Emp_Ent = nil
				end
				
				local ammo,IsReloading = ent:GetAmmo(),ent:GetIsReloading()
				
				ent:SetViewMode(0)
				ent:StopSoundStuff(ply,ammo,IsReloading,ent:CanShoot(ammo,CurTime(),ply,IsReloading))
			end
		end)
		
		self:NetworkVarNotify("AmmoType",function(ent,name,oldval,newval)
			if oldval != newval then
				local ply = self:GetShooter()
				
				if ply == LocalPlayer() then
					local t = self.AmmunitionTypes[newval]
					ply:PrintMessage(HUD_PRINTCENTER,(t.ShellType or t[1]).." shells selected")
				end
			end
		end)
		
		self:NetworkVarNotify("FuseTime",function(ent,name,oldval,newval)
			if oldval != newval then
				local ply = self:GetShooter()
				
				if ply == LocalPlayer() then
					ply:PrintMessage(HUD_PRINTCENTER,"Time fuse set to "..(newval*0.01).." seconds")
				end
			end
		end)
	else
		self:NetworkVarNotify("PrevShooter",function(ent,name,oldval,ply)
			if oldval != ply then
				if IsValid(ply) and ply.Gred_Emp_Ent == ent then
					ply.Gred_Emp_Ent = nil
				end
			end
		end)
		self:NetworkVarNotify("Shooter",function(ent,name,oldval,ply)
			if oldval != ply then
				if IsValid(ply) then
					ply.Gred_Emp_Ent = self
				end
			end
		end)
	end
	
	self:AddDataTables()
end

function ENT:AddDataTables()

end

function ENT:AddEntity(ent)
	for k,v in pairs(self.Entities) do
		noColl(v,ent,0,0)
	end
	
	table.insert(self.Entities,ent)
end

function ENT:ShooterStillValid(ply,botmode)
	return IsValid(ply) and (botmode or ((ply:IsPlayer() and ply:Alive()) and (!self.Seatable and ply:GetPos():DistToSqr(self:GetPos()) <= self.MaxUseDistance or self.Seatable)))
end


----------------------------------------
-- THINGS

local pi = math.pi*20

function ENT:IsPairable()
	return self.IsHowitzer or self.EmplacementType == "Mortar" or (self.EmplacementType == "Cannon" and gred.CVars.gred_sv_enable_cannon_artillery:GetBool())
end

function ENT:GetMuzzle()
	local m = self:GetCurrentMuzzle()
	
	if m <= 0 or m > #self.TurretMuzzles or not self.TurretMuzzles[m] then
		m = 1
		
		self:SetCurrentMuzzle(m)
	end
	
	return m
end

function ENT:GetSharedRandom(componement,min,max)
	return util.SharedRandom(self.ENT_INDEX..self.ClassName..componement.."_"..self._CurrentMuzzle,min,max,math.Round(CurTime()*pi,1))
end

function ENT:GetRandomSpreadAngle()
	local spread = self["GetSpread"]
	spread = Angle(self:GetSharedRandom(1,spread,-spread),self:GetSharedRandom(2,spread,-spread)+90,self:GetSharedRandom(3,spread,-spread))
	
	return spread
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
			return !(ammo > 0 or (self.Ammo < 0 and not gred.CVars["gred_sv_manual_reload"]:GetBool()))
		end
	else
		return false
	end
end

-----------------------------------------
-- MORE THINGS


ENT._CurrentMuzzle 		= 1
-- ENT._IsAttacking		= false
ENT._IsShooting			= false
ENT._Recoil				= 0
ENT._CurrentTracer		= 0

function ENT:SetCurrentMuzzle(val)
	self._CurrentMuzzle = val
end

function ENT:GetCurrentMuzzle()
	return self._CurrentMuzzle
end

function ENT:SetCurrentTracer(val)
	self._CurrentTracer = val
end

function ENT:GetCurrentTracer(val)
	return self._CurrentTracer
end

-- function ENT:SetIsAttacking(val)
	-- self._IsAttacking = val
-- end

-- function ENT:GetIsAttacking(val)
	-- return self._IsAttacking
-- end

function ENT:SetIsShooting(val)
	self._IsShooting = val
end

function ENT:GetIsShooting(val)
	return self._IsShooting
end

function ENT:SetRecoil(val)
	self._Recoil = val
end

function ENT:GetRecoil(val)
	return self._Recoil
end


function ENT:UpdateTracers()
	self:SetCurrentTracer(self:GetCurrentTracer() + 1)
	
	if self:GetCurrentTracer() >= gred.CVars.gred_sv_tracers:GetInt() then
		self:SetCurrentTracer(0)
		
		return self.TracerColor
	else
		return false
	end
end

function ENT:CalcSpread()
	if self.Spread > 0 then
		self.GetSpread = self.Spread
	else
		local ammotype = self.AmmunitionType or self.AmmunitionTypes[1][2]
		if ammotype == "wac_base_7mm" then
			self.GetSpread = 0.3
		elseif ammotype == "wac_base_12mm" then
			self.GetSpread = 0.5
		elseif ammotype == "wac_base_20mm" then
			self.GetSpread = 1.4
		elseif ammotype == "wac_base_30mm" then
			self.GetSpread = 1.6
		elseif ammotype == "wac_base_40mm" then
			self.GetSpread = 2
		end
	end
end

function ENT:CanShoot(ammo,ct,ply,IsReloading)
	if self.EmplacementType != "MG" then
		if self.EmplacementType == "Mortar" then
			return (ammo > 0 or (self.Ammo < 0 and not gred.CVars.gred_sv_manual_reload:GetBool())) and self.NextShot <= ct and !IsReloading and self:CalcMortarCanShoot(ply,ct)
		else
			return (ammo > 0 or (self.Ammo < 0 and not gred.CVars.gred_sv_manual_reload:GetBool())) and self.NextShot <= ct and !IsReloading and (not self.CustomEyeTrace or self:CalcMortarCanShoot(ply,ct))
		end
	else
		return (ammo > 0 or self.Ammo < 0) and self.NextShot <= ct and !IsReloading
	end
end

function ENT:PreFire(ammo,ct,ply)
	if self.Sequential then
		local m = self:GetMuzzle()
		
		if self.EmplacementType == "MG" then
			self:FireMG(ply,ammo,self.TurretMuzzles[m])
		elseif self.EmplacementType == "Mortar" then
			self:FireMortar(ply,ammo,self.TurretMuzzles[m])
		elseif self.EmplacementType == "Cannon" then
			if self.CustomEyeTrace then
				self:FireMortar(ply,ammo,self.TurretMuzzles[m])
			else
				self:FireCannon(ply,ammo,self.TurretMuzzles[m])
			end
		end
		
		self:SetCurrentMuzzle(m + 1)
		
		if SERVER then
			if self.EmplacementType == "MG" or (self.EmplacementType == "Cannon" and self.Ammo > 1) then -- if MG or Nebelwerfer
				self:SetAmmo(ammo - (self.EmplacementType == "MG" and gred.CVars.gred_sv_limitedammo:GetInt() or 1))
			else
				self:SetAmmo(ammo > 0 and ammo - 1 or 0)
			end
		end
		
	else
		for k,m in pairs(self.TurretMuzzles) do
			if self.EmplacementType == "MG" then
				self:FireMG(ply,ammo,m)
			elseif self.EmplacementType == "Mortar" then
				self:FireMortar(ply,ammo,m)
			elseif self.EmplacementType == "Cannon" then
				if self.CustomEyeTrace then
					self:FireMortar(ply,ammo,m)
				else
					self:FireCannon(ply,ammo,m)
				end
			end
			
			if SERVER then
				if self.EmplacementType == "MG" or (self.EmplacementType == "Cannon" and self.Ammo > 1) then -- if MG or Nebelwerfer
					self:SetAmmo(ammo - (self.EmplacementType == "MG" and gred.CVars.gred_sv_limitedammo:GetInt() or 1))
				else
					self:SetAmmo(ammo > 0 and ammo - 1 or 0)
				end
			end
		end
	end
	
	if SERVER then
		if self.CustomShootAnim then
			self:CustomShootAnim(self:GetCurrentMuzzle()-1)
		else
			if self.ShootAnim then 
				if self.AnimRestartTime and self.EmplacementType != "Cannon" then
					if self.NextShootAnim < ct then
						self:ResetSequence(self.ShootAnim)
						self.NextShootAnim = ct + self.AnimRestartTime
					end
				else
					self:ResetSequence(self.ShootAnim)
				end
			end
		end
	-- elseif self.EmplacementType == "Cannon" and ammo-1 <= 0 then
		if self.EmplacementType == "Cannon" and ammo-1 <= 0 then
			self:PlayAnim()
		end
	end
	
	self.NextShot = ct + self.ShotInterval
end

function ENT:HandleRecoil(ang)
	if self.EmplacementType == "MG" and !self.Seatable and self.EnableRecoil:GetBool() then
		if self.ShouldDoRecoil then
			self.CurRecoil = self.Recoil
		end
		
		self.CurRecoil = self.CurRecoil and self.CurRecoil + math.Clamp(0 - self.CurRecoil,-self.RecoilRate,self.RecoilRate) or 0
		self:SetRecoil(self.CurRecoil)
		
		if ang then
			ang.p = ang.p - self.CurRecoil
		end
	end
end

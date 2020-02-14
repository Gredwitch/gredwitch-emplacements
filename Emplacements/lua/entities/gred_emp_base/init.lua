
include		('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

----------------------------------------
-- INIT


local IsValid = IsValid
local reachSky = Vector(0,0,9999999999)
local add_alt = Vector(0,0,1000)
local math = math

local vector_zero = Vector(0,0,0)
local vector_axis = Vector(0,1,0)

function ENT:Initialize()
	self:SetModel(self.TurretModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:AddEntity(self)
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	self:InitAttachments()
	self:InitParts(pos,ang)
	
	self:BulletCalcVel()
	self:CalcSpread()
	
	self:ReloadSounds()
	self:ResetSequence("reload")
	self:SetCycle(1)
	
	self:OnInit()
	
	if self.AmmunitionTypes then
		local IsAAA = false
		for k,v in pairs(self.AmmunitionTypes) do
			if v[1] == "Time-fused" then 
				IsAAA = true
				self.TimeFuse = k
			end
		end
		self.IsAAA = IsAAA
	end
	
	for k,v in pairs(self.Entities) do
		self.HP = (self.HP+75+(v:BoundingRadius()/table.Count(self.Entities)))
	end
	timer.Simple(0.03,function() if !IsValid(self) then return end self:SetHP(self.HP) end)
	
	if self.EmplacementType != "MG" then
		if gred.CVars.gred_sv_manual_reload:GetInt() == 1 then
			if self.EmplacementType == "Mortar" then
				self:SetAmmo(0)
			else
				self:PlayAnim()
			end
		end
		-- if self.EmplacementType == "Cannon" then
			-- local dummy = ents.Create("prop_dynamic")
			-- dummy:SetModel("models/mm1/box.mdl")
			-- dummy:SetPos(self:LocalToWorld(self.TurretMuzzles[1].Pos))
			-- dummy:SetParent(self)
			-- self.DummyMuzzle = dummy
		-- end
	end
	
	if self.Seatable then
		self.Seatable = gred.CVars.gred_sv_enable_seats:GetInt() == 1
	end
	
	self.OldSeatable = self.Seatable
	self.CanTakeMultipleEmplacements = gred.CVars.gred_sv_canusemultipleemplacements
	self.EnableRecoil = gred.CVars.gred_sv_enable_recoil
	self.MaxUseDistance = self.MaxUseDistance*self.MaxUseDistance
	self.TracerColor = self.TracerColor and string.lower(self.TracerColor) or nil
	
	self.YawRate = self.YawRate * gred.CVars[self.EmplacementType == "MG" and "gred_sv_progressiveturn_mg" or "gred_sv_progressiveturn_cannon"]:GetFloat()
	self.PitchRate = self.PitchRate * gred.CVars[self.EmplacementType == "MG" and "gred_sv_progressiveturn_mg" or "gred_sv_progressiveturn_cannon"]:GetFloat()
	
	duplicator.CopyEnts(self.Entities)
	
	-- self.AirDensity = physenv.GetAirDensity()
	self.Initialized = true
end

function ENT:ReloadSounds()
	self.sounds = self.sounds or {}
	if self.ReloadSound then
		self.sounds["reload"] = CreateSound(self,self.ReloadSound)
		self.sounds.reload:SetSoundLevel(60)
		self.sounds.reload:ChangeVolume(1)
		
		self.sounds["reloadend"] = CreateSound(self,self.ReloadEndSound)
		self.sounds.reloadend:SetSoundLevel(60)
		self.sounds.reloadend:ChangeVolume(1)
		
		self.sounds["empty"] = CreateSound(self,"gred_emp/common/empty.wav")
		self.sounds.empty:SetSoundLevel(60)
		self.sounds.empty:ChangeVolume(1)
	end
	if self.EmplacementType == "Cannon" then
		if not self.ATReloadSound then self.ATReloadSound = "medium" end
		self.sounds["reload_start"] = CreateSound(self,"gred_emp/common/reload"..self.ATReloadSound.."_1.wav")
		self.sounds.reload_start:SetSoundLevel(80)
		self.sounds.reload_start:ChangeVolume(1)
		self.sounds["reload_finish"] = CreateSound(self,"gred_emp/common/reload"..self.ATReloadSound.."_2.wav")
		self.sounds.reload_finish:SetSoundLevel(80)
		self.sounds.reload_finish:ChangeVolume(1)
		self.sounds["reload_shell"] = CreateSound(self,"gred_emp/common/reload"..self.ATReloadSound.."_shell.wav")
		self.sounds.reload_shell:SetSoundLevel(80)
		self.sounds.reload_shell:ChangeVolume(1)
	end
end

function ENT:OnInit()
end

function ENT:InitAttachments()
	local attachments = self:GetAttachments()
	local tableinsert = table.insert
	local startsWith = string.StartWith
	local t
	for k,v in pairs(attachments) do
		if startsWith(v.name,"muzzle") then
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretMuzzles,t)
			
		elseif startsWith(v.name,"shelleject") then
		
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretEjects,t)
		end
	end
end

function ENT:InitParts(pos,ang)
	local hull = self:InitHull(pos,ang)
	self:InitYaw(pos,ang)
	self:InitWheels(ang,hull)
end

function ENT:InitHull(pos,ang)
	local hull = ents.Create("gred_prop_emp")
	hull.GredEMPBaseENT = self
	hull:SetModel(self.HullModel)
	hull:SetAngles(ang)
	hull:SetPos(pos)
	hull.HullFly = self.HullFly
	hull.IsCarriage = self.ToggleableCarriage
	hull:Spawn()
	hull:Activate()
	hull.canPickUp = self.EmplacementType == "MG" and gred.CVars.gred_sv_cantakemgbase:GetInt() == 1 and not self.YawModel
	
	if self.EmplacementType == "Mortar" or self.HullFly then hull:SetMoveType(MOVETYPE_FLY) end
	local phy = hull:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.HullMass)
	end
	
	self:SetHull(hull)
	self:AddEntity(hull)
	
	local newPos = pos + self.TurretPos
	self:SetPos(newPos)
	if not self.YawModel then
		self:SetParent(hull)
	end
	if self.EmplacementType == "Cannon" then
		if gred.CVars.gred_sv_carriage_collision:GetInt() == 0 then
			hull:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		end
	end
	-- constraint.Axis(self,hull,0,0,self.TurretPos,vector_zero,0,0,0,1,vector_zero,false)
	return hull
end

function ENT:InitYaw(pos,ang)
	if self.YawModel then
		local yaw = ents.Create("gred_prop_emp")
		yaw.GredEMPBaseENT = self
		yaw:SetModel(self.YawModel)
		yaw:SetAngles(ang)
		yaw:SetPos(pos+self.YawPos)
		yaw:Spawn()
		yaw:Activate()
		
		local phy = yaw:GetPhysicsObject()
		if IsValid(phy) then
			phy:SetMass(self.YawMass)
		end
		self:SetYaw(yaw)
		self:AddEntity(yaw)
		
		local newPos = pos + self.TurretPos + self.YawPos
		self:SetPos(newPos)
		yaw:SetParent(self:GetHull())
		self:SetParent(yaw)
		
		-- constraint.Axis(self,hull,0,0,self.TurretPos,vector_zero,0,0,0,1,vector_zero,false)
	end
end

function ENT:InitWheels(ang,hull)
	if not self.WheelsModel then return end
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel)
	wheels:SetAngles(ang)
	wheels:SetPos(hull:LocalToWorld(self.WheelsPos))
	wheels.BaseEntity = self
	wheels:Spawn()
	wheels:Activate()
	local phy = wheels:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.WheelsMass)
	end
	
	self:SetWheels(wheels)
	self:AddEntity(wheels)
	constraint.Axis(wheels,self:GetHull(),0,0,vector_zero,self:WorldToLocal(wheels:LocalToWorld(vector_zero)),0,0,10,1,vector_axis)
end


----------------------------------------
-- USE


function ENT:CanUse(ct,ply)
	return (ply.NEXT_EMPLACEMENT_USE and ply.NEXT_EMPLACEMENT_USE < ct or !ply.NEXT_EMPLACEMENT_USE) or self.TempPlayer
end

function ENT:Use(ply,caller,use,val)
	local ct = CurTime()
	if !self:CanUse(ct,ply) then return end
	local shooter = self:GetShooter()
	if ply:IsPlayer() and self:GetBotMode() then
		self:SetBotMode(false)
		self:SetShouldSetAngles(true)
		self:LeaveTurret(self)
		if self.EmplacementType == "Cannon" and ply:KeyDown(IN_RELOAD) then
			self.Seatable = false
			self.TempPlayer = true
			self:GrabTurret(ply,true)
			self:SetShouldSetAngles(false)
			
			local ammo = self:GetAmmo()
			local IsReloading = self:GetIsReloading()
			local canShoot = self:CanShoot(ammo,ct,ply,IsReloading)
			if canShoot then
				self.ShouldDoRecoil = true
				self:PreFire(ammo,ct,ply,IsReloading)
				net.Start("gred_net_emp_onshoot")
					net.WriteEntity(self)
				net.Broadcast()
			end
			timer.Simple(0.5,function()
				if !IsValid(self) then return end
				self.Seatable = self.OldSeatable
				self:LeaveTurret(ply)
				self.TempPlayer = false
				self:SetShouldSetAngles(true)
			end)
		else
			self:GrabTurret(ply)
			if self.Seatable then
				if self.MaxViewModes > 0 then
					if self.NameToPrint then
						net.Start("gred_net_message_ply")
							net.WriteString("["..self.NameToPrint.."] Press the Suit Zoom or the Crouch key to toggle aimsights")
						net.Send(ply)
					else
						net.Start("gred_net_message_ply")
							net.WriteString("["..string.gsub(self.PrintName,"%[EMP]","").."] Press the Suit Zoom or the Crouch key to toggle aimsights")
						net.Send(ply)
					end
				end
			else
				if self.MaxViewModes > 0 then
					if self.NameToPrint then
						net.Start("gred_net_message_ply")
							net.WriteString("["..self.NameToPrint.."] Press the Suit Zoom key to toggle aimsights")
						net.Send(ply)
					else
						net.Start("gred_net_message_ply")
							net.WriteString("["..string.gsub(self.PrintName,"%[EMP]","").."] Press the Suit Zoom key to toggle aimsights")
						net.Send(ply)
					end
				end
			end
		end
	else
		if shooter == ply then
			self:LeaveTurret(ply)
		else
			if not IsValid(shooter) then
				self:SetShouldSetAngles(true)
				if self.EmplacementType == "Cannon" and ply:KeyDown(IN_RELOAD) then
					self.Seatable = false
					self.TempPlayer = true
					self:GrabTurret(ply,true)
					self:SetShouldSetAngles(false)
					
					local ammo = self:GetAmmo()
					local IsReloading = self:GetIsReloading()
					local canShoot = self:CanShoot(ammo,ct,ply,IsReloading)
					if canShoot then
						self.ShouldDoRecoil = true
						self:PreFire(ammo,ct,ply,IsReloading)
						net.Start("gred_net_emp_onshoot")
							net.WriteEntity(self)
						net.Broadcast()
					end
					timer.Simple(0.5,function()
						if !IsValid(self) then return end
						self.Seatable = self.OldSeatable
						self:LeaveTurret(ply)
						self.TempPlayer = false
						self:SetShouldSetAngles(true)
					end)
				else
					self:GrabTurret(ply)
					if self.Seatable then
						if self.MaxViewModes > 0 then
							if self.NameToPrint then
								net.Start("gred_net_message_ply")
									net.WriteString("["..self.NameToPrint.."] Press the Suit Zoom or the Crouch key to toggle aimsights")
								net.Send(ply)
							else
								net.Start("gred_net_message_ply")
									net.WriteString("["..string.gsub(self.PrintName,"%[EMP]","").."] Press the Suit Zoom or the Crouch key to toggle aimsights")
								net.Send(ply)
							end
						end
					else
						if self.MaxViewModes > 0 then
							if self.NameToPrint then
								net.Start("gred_net_message_ply")
									net.WriteString("["..self.NameToPrint.."] Press the Suit Zoom key to toggle aimsights")
								net.Send(ply)
							else
								net.Start("gred_net_message_ply")
									net.WriteString("["..string.gsub(self.PrintName,"%[EMP]","").."] Press the Suit Zoom key to toggle aimsights")
								net.Send(ply)
							end
						end
					end
				end
			end
		end
	end
	ply.NEXT_EMPLACEMENT_USE = ct + 0.2
end

function ENT:GrabTurret(ply,shootOnly)
	self:SetShooter(ply)
	local botmode = self:GetBotMode()
	if !botmode then
		self.Owner = ply
		if self.CanTakeMultipleEmplacements:GetInt() == 0 then
			if IsValid(ply.ActiveEmplacement) then
				self:SetShooter(nil)
				return
			end
		end
		ply.ActiveEmplacement = self
		if !shootOnly then
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) then
				self.PrevPlayerWeapon = wep:GetClass()
			end
			if self.Seatable then
				local ang = self:GetAngles()
				ply:SetEyeAngles(ang)
				self:CreateSeat(ply)
			end
		end
	end
	self:OnGrabTurret(ply,botmode,shootOnly)
end

function ENT:OnGrabTurret(ply,botmode,shootOnly)
	
end

function ENT:CreateSeat(ply)
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	local yaw = self:GetYaw()
	local a = yaw:LookupAttachment("seat")
	local att = yaw:GetAttachment(a)
	
	-- local ang = Angle(att.Ang + self.SeatAngle)
	-- ang:Normalize()
	
	-- seat:SetAngles(yaw:LocalToWorldAngles(att.Ang))
	att.Ang:RotateAroundAxis(att.Ang:Up(),-90)
	seat:SetAngles(att.Ang)
	seat:SetPos(att.Pos-yaw:GetUp()*5)
	seat:SetModel("models/nova/airboat_seat.mdl")
	seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview","0")
	seat:Spawn()
	seat:Activate()
	seat:PhysicsInit	  (SOLID_NONE)
	seat:SetRenderMode	  (RENDERMODE_NONE)
	seat:SetSolid		  (SOLID_NONE)
	seat:SetCollisionGroup(COLLISION_GROUP_WORLD)
	seat:SetParent(yaw,a)
	self:SetSeat(seat)
	ply:EnterVehicle(seat)
	ply:CrosshairEnable()
end

function ENT:OnTick(ct,ply,botmode)
	
end

function ENT:LeaveTurret(ply)
	local isPlayer = ply:IsPlayer()
	if isPlayer and !self.TempPlayer then
		ply.NEXT_EMPLACEMENT_USE = CurTime() + (self.TempPlayer and 0.6 or 0.2)
		ply.ActiveEmplacement = nil
		if self:GetShouldSetAngles() then
			if ply.StripWeapon and !self.Seatable then
				ply:StripWeapon("gred_emp_empty")
				if self.PrevPlayerWeapon then
					ply:SelectWeapon(self.PrevPlayerWeapon)
				end
			end
			if self.Seatable then
				local seat = self:GetSeat()
				if IsValid(seat) then
					ply:ExitVehicle()
					seat:Remove()
					self:SetSeat(nil)
				end
				if self.YawModel then
					local yaw = self:GetYaw()
					local pos = IsValid(yaw) and yaw:BoundingRadius() or 10
					ply:SetPos(self:LocalToWorld(Vector(pos,0,0)))
				end
			end
		end
	end
	self.CustomEyeTrace = nil
	self:SetPrevShooter(ply)
	self:SetShooter(nil)
	self:OnLeaveTurret(ply,isPlayer)
end

function ENT:OnLeaveTurret(ply,isPlayer)
	
end


----------------------------------------
-- THINK

function ENT:CheckSeat(ply,seat,seatValid)
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
		return seat,seatValid
	end
end


local g = GetConVar("sv_gravity"):GetFloat()
local MortarNum = -1*10^(-6)
local math = math
local util = util

local atan = math.atan
local acos = math.acos
local sqrt = math.sqrt

local deg = math.deg
					-- FUCK GARRY, FUCK BREXIT LAND, FUCK RADIANS.
local rad = math.rad

local function CALC_ANGLE(g,X,V,H) 
	return (deg(acos((g*X^2/V^2-H)/sqrt(H^2+X^2)))+deg(atan(X/H)))/2
end

local METERS_TO_UNITS = 0.01905

function ENT:GetShootAngles(ply,botmode,target)
	local hull = self:GetHull()
	local hullAng = hull:GetAngles()
	local ang = Angle() + hullAng
	local ft
	if botmode then
		local target = self:GetTarget()
		if self.EmplacementType == "MG" then
			if IsValid(target) then
				local pos = target:LocalToWorld(target:OBBCenter())
				local attpos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				
				local vel = target:GetVelocity()*0.1
				local dist = attpos:DistToSqr(pos)
				self:BulletCalcVel()
				local calcPos = pos+vel*(dist/self.BulletVelCalc)
				
				if dist > 0.015 then
					ang = (calcPos - attpos):Angle()
					-- ang = Angle(!self.Seatable and -ang.p - self.CurRecoil or -ang.p,ang.y+180,ang.r)
					ang:Add(self.BotAngleOffset)
					ang = hull:WorldToLocalAngles(ang)
					self:SetTargetValid(true)
				else
					self:SetTarget(nil)
					-- self:SetTargetValid(false)
				end
				if self:GetIsAntiAircraft() and self:GetAmmoType() == 2 then
					self:SetFuseTime(((dist/self.BulletVelCalc)/(10+math.Rand(0,1)))+(vel:Length()*0.0003))
				end
				-- debugoverlay.Line(trace.StartPos,calcPos,FrameTime()+0.02,Color( 255, 255, 255 ),false )
			else
				self:SetTarget(nil)
				self:SetTargetValid(false)
				-- ang = self:GetHull():GetAngles()
			end
		elseif self.EmplacementType == "Cannon" then
			if IsValid(target) then
			
				ft = FrameTime()
				local TargetPos = target:LocalToWorld(target:OBBCenter())
				local OurPos = self:LocalToWorld(self.TurretMuzzles[1].Pos)
				local TargetVel = target:GetVelocity()
				local Dist = OurPos:DistToSqr(TargetPos)
				local Height = TargetPos.z - OurPos.z
				local AmmoType = self.AmmunitionTypes[self:GetAmmoType()]
				local MuzzleVelocity = AmmoType.MuzzleVelocity/METERS_TO_UNITS
				
				-------------------------------------------
				ang = (TargetPos - OurPos):Angle()
				
				g,Dist,MuzzleVelocity,Height = g,Dist*METERS_TO_UNITS,MuzzleVelocity*METERS_TO_UNITS,Height*METERS_TO_UNITS -- What needs to work but in meters
				
				
				local a = 0.5 * -g*METERS_TO_UNITS * (Dist * 0.0001)
				local c = a + Height
				local d = sqrt(Dist - 4 * a * c)
				local e = sqrt(Dist)
				local f = 2 * a
				local X1 = deg(atan((-e + d) / f)) -- Quadratic formula #1
				local X2 = deg(atan((-e - d) / f)) -- Quadratic formula #2
				local X3 = (deg(acos((((g*METERS_TO_UNITS*Dist) / (MuzzleVelocity*MuzzleVelocity)) - Height) / sqrt(Height*Height+Dist)) + atan(sqrt(Dist)/Height))) * 0.5 -- Something else
				
				-- local X = Dist / MuzzleVelocity
				print(X2)
				-- ang.r = Height < 0 and ang.r - 180 or ang.r
				
				local tr = util.QuickTrace(OurPos,self:GetRight()*-Dist,self)
				debugoverlay.Line(tr.StartPos,tr.HitPos,ft + 0.03)
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
				self.TargetTrace = trace
				
				ang = (pos - attpos):Angle()
				ang = hull:WorldToLocalAngles(Angle(-ang.p,ang.y,ang.r))
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
				ply:SetActiveWeapon(ply:Give("gred_emp_empty"))
			end
			
			-- if self.CustomEyeTrace then
				-- local vec = self:GetPos() - self.CustomEyeTraceHitPos
				-- ang = vec:Angle()
				
				-- ang.y = ang.y + 180
				-- ang.r = -ang.r + (self.EmplacementType == "Cannon" and (80 - vec:Length() * 0.001) or 0)
				-- ang:Normalize()
			-- elseif self.CustomAng then
				-- ang = self:CustomAng(ply,ang,hull,hullAng)
			-- else
				if self.Seatable then
					ang = hull:WorldToLocalAngles(self:GetSeat():WorldToLocalAngles(ply:EyeAngles()))
				else
					ang = hull:WorldToLocalAngles(ply:EyeAngles())
				end
				ang.r = 0
			-- end
		end
	end
	if self.EmplacementType == "Mortar" and !noAngleChange and ang then
		ang.p = -ang.p + self.DefaultPitch
	end
	if self.OffsetAngle then
		ang = ang + self.OffsetAngle
		if self.OffsetAngle.p < 0 then
			ang.p = -ang.p
		end
		ang:Normalize()
	end
	if !noAngleChange and ang then
		if self.EmplacementType != "Mortar" then
			local newp = -math.Clamp(-ang.p,self.MinRotation.p,self.MaxRotation.p)
			if newp != ang.p then
				self:SetTarget(nil)
				self:SetTargetValid(false)
			end
			ang.p = newp
		end
		
		local newy = math.Clamp(ang.y,self.MinRotation.y,self.MaxRotation.y)
		if newy != ang.y then
			self:SetTarget(nil)
			self:SetTargetValid(false)
		end
		ang.y = newy
	end
	
	self.RightPitch = 0
	self.RightYaw = 0
	if ang and self.EmplacementType != "Mortar" and gred.CVars.gred_sv_progressiveturn:GetInt() >= 1 then
		ft = ft or FrameTime()
		self.CurYaw = self.CurYaw and math.ApproachAngle(self.CurYaw,ang.y,self.YawRate*ft) or 0
		self.CurPitch = self.CurPitch and math.ApproachAngle(self.CurPitch,ang.p,self.PitchRate*ft) or 0
		self.RightPitch = math.abs(math.Round(ang.p,1) - math.Round(self.CurPitch,1)) == 0 and 0 or 1
		self.RightYaw = math.abs(math.Round(ang.y,1) - math.Round(self.CurYaw,1))
		self.RightYaw = (self.RightYaw <= 0.3 or (self.RightYaw >= 359.7 and self.RightYaw <= 360)) and 0 or 1
		ang.y = self.CurYaw
		ang.p = self.CurPitch
	end
	return ang
end

function ENT:FindBotTarget(botmode,target,ct)
	if self.EmplacementType == "Cannon" then
		self:SetBotMode(false)
		botmode = false
	else
		if ply != self then
			self:GrabTurret(self)
		end
		if not IsValid(target) then
			target = nil
			if self.NextFindBot < ct then
				self.NextFindBot = ct + 0.2
				local pos,entpos = self:LocalToWorld(self.TurretMuzzles[1].Pos),nil
				
				for k,v in pairs(ents.FindByClass("prop_physics")) do target = v break end
				if IsValid(target) then self:SetTarget(target) end
				
				if simfphys and istable(simfphys.LFS) and !target then
					for k,v in pairs(simfphys.LFS:PlanesGetAll()) do
						entpos = v:LocalToWorld(v:OBBCenter())
						if self:TargetTraceValid(util.QuickTrace(pos,(entpos - pos)*pos:DistToSqr(entpos),self),v) then
							self:SetTarget(v)
							target = target
							break
						end
					end
				end
				if not target then
					for k,v in pairs(player.GetAll()) do
						entpos = v:LocalToWorld(v:OBBCenter())
						if self:TargetTraceValid(util.QuickTrace(pos,(entpos - pos)*pos:DistToSqr(entpos),self),v) then
							self:SetTarget(v)
							target = v
							break
						end
					end
				end
				if not target then
					for k,v in pairs(gred.AllNPCs) do
						entpos = v:LocalToWorld(v:OBBCenter())
						if self:TargetTraceValid(util.QuickTrace(pos,(entpos - pos)*pos:DistToSqr(entpos),self),v) then
							self:SetTarget(v)
							target = v
							break
						end
					end
				end
			end
		end
	end
	return botmode,target
end

function ENT:BotAmmoType(target)
	if self.EmplacementType == "Cannon" then return end
	self:CheckTarget()
	if IsValid(target) then
		local pos,entpos = self:LocalToWorld(self.TurretMuzzles[1].Pos),target:LocalToWorld(target:OBBCenter())
		if !self:TargetTraceValid(util.QuickTrace(pos,(entpos - pos)*pos:DistToSqr(entpos),self),target) then
			self:SetTarget(nil)
			target = nil
		else
			if self:GetIsAntiAircraft() and self.EmplacementType == "MG" then
				if self.AmmunitionTypes then
					if self:IsValidAirTarget(target) then
						self:SetAmmoType(2)
					else
						self:SetAmmoType(1)
					end
				end
			elseif self.EmplacementType == "Cannon" then
				-- if target:IsPlayer() or target:IsNPC() then
					self:SetAmmoType(2)
				-- else
					-- if self.AmmunitionTypes[2][1] == "AP" then
						-- self:SetAmmoType(2)
					-- end
				-- end
			end
		end
	end
end

function ENT:CalcAmmoType(ammo,IsReloading,ct,ply)
	if ammo < self.Ammo and self.Ammo > 0 then
		if ply:KeyDown(IN_RELOAD) and not IsReloading then
			self:Reload()
		end
	end
	
	if self.AmmunitionTypes then
		-- Toggle ammo types
		if ply:KeyDown(IN_ATTACK2) then
			if self.NextSwitchAmmoType <= ct then
				if self.EmplacementType != "MG" then
					if gred.CVars.gred_sv_manual_reload:GetInt() == 0 then
						self:SwitchAmmoType(ply,ct)
					end
				else
					self:SwitchAmmoType(ply,ct)
				end
				self.NextSwitchAmmoType = ct + 0.3
			end
		end
		
		-- Update fuse time
		if self.CanSwitchTimeFuse then
			if self.AmmunitionTypes[self:GetAmmoType()][1] == "Time-fused" then
				if self.NextSwitchTimeFuse <= ct then
					if ply:KeyDown(IN_SPEED) then
						self:SetNewFuseTime(ply)
					end
					if ply:KeyDown(IN_WALK) then
						self:SetNewFuseTime(ply,true)
					end
					self.NextSwitchTimeFuse = ct + 0.2
				end
			end
		end
	end
end

function ENT:Think()
	if not self.Initialized then return end
	
	local ct = CurTime()
	local botmode = self:GetBotMode()
	local attacking
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
		botmode,target = self:FindBotTarget(botmode,target,ct)
	else
		self.TargetTrace = nil
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
			if shouldSetAngles or self.CustomEyeTrace then
				local ang = self:GetShootAngles(ply,botmode,target)
				if ang then
					local hull = self:GetHull()
					if self.YawModel then
						self:GetYaw():SetAngles(hull:LocalToWorldAngles(Angle(0,ang.y,0)))
					end
					ang = hull:LocalToWorldAngles(ang)
					self:HandleRecoil(ang)
					self:SetAngles(ang)
				end
			end
			-- Seat checking
			seat,seatValid = self:CheckSeat(ply,seat,seatValid)
			
			-- Bot stuff (this might need to be optimised)
			if botmode then
				target = self:BotAmmoType(target)
			end
			
			-- Shooting stuff
			self.ShouldDoRecoil = false
			attacking = shouldSetAngles and ply:KeyDown(IN_ATTACK) or !shouldSetAngles
			if attacking then
				canShoot = self:CanShoot(ammo,ct,ply,IsReloading)
				if canShoot then
					self.ShouldDoRecoil = true
					self:PreFire(ammo,ct,ply,IsReloading)
					net.Start("gred_net_emp_onshoot")
						net.WriteEntity(self)
					net.Broadcast()
				end
			end
			
			-- Reload stuff
			self:CalcAmmoType(ammo,IsReloading,ct,ply)
			
		end
	else
		if not botmode then
			self:LeaveTurret(ply)
		end
	end
	
	if self.FireMissions then
		self.MaxViewModes = table.Count(self.FireMissions)
	end
	
	self:ManualReload(ammo)
	
	self:SetIsAttacking(attacking)
	self:SetIsShooting(canShoot)
	if self:GetHP() <= 0 then self:Explode() return end
	self:OnTick(ct,ply,botmode,IsShooting,canShoot,ammo,IsReloading,shouldSetAngles)
	
	self:NextThink(ct)
	return true
end


----------------------------------------
-- SHOOT


function ENT:CanShoot(ammo,ct,ply,IsReloading)
	local nextShot
	nextShot = self:GetNextShot()
	if self.EmplacementType != "MG" then
		if self.EmplacementType == "Mortar" then
			if CLIENT then
				return (ammo > 0 or (self.Ammo < 0 and gred.CVars.gred_sv_manual_reload:GetInt() == 0)) and nextShot <= ct and !IsReloading and self:CalcMortarCanShootCL(ply)
			else
				return (ammo > 0 or (self.Ammo < 0 and gred.CVars.gred_sv_manual_reload:GetInt() == 0)) and nextShot <= ct and !IsReloading and self:CalcMortarCanShoot(ply,ct)
			end
		else
			return (ammo > 0 or (self.Ammo < 0 and gred.CVars.gred_sv_manual_reload:GetInt() == 0)) and nextShot <= ct and !IsReloading and (self.CustomEyeTrace and self:CalcMortarCanShoot(ply,ct) or !self.CustomEyeTrace)
		end
	else
		return (ammo > 0 or self.Ammo < 0) and nextShot <= ct and !IsReloading
	end
end

function ENT:CalcMortarCanShoot(ply,ct)
	local tr = util.QuickTrace(self:LocalToWorld(self.TurretMuzzles[1].Pos),reachSky,self.Entities)
	local canShoot = true
	local botmode = self:GetBotMode()
	local shootPos
	self.Time_Mortar = self.Time_Mortar or 0
	if tr.Hit and !tr.HitSky then
		canShoot = false
		noHitSky = true
		if !botmode and self.Time_Mortar <= ct then
			net.Start("gred_net_message_ply")
				net.WriteString("["..self.NameToPrint.."] Nothing must block the mortar's muzzle!")
			net.Send(ply)
			self.Time_Mortar = ct + 1
		end
	else
		noHitSky = false
		local ang = self:GetHull():WorldToLocalAngles(self.CustomEyeTrace and (self.CustomEyeTraceHitPos - self:GetPos()):Angle() or self:GetAngles())
		canShoot = not (ang.y > self.MaxRotation.y or ang.y-0.1 < self.MinRotation.y)
		
		if !canShoot then
			if !botmode and self.Time_Mortar <= ct then
				net.Start("gred_net_message_ply")
					net.WriteString("["..self.NameToPrint.."] You can't shoot there!")
				net.Send(ply)
				self.Time_Mortar = ct + 1
			end
		else
			if botmode then
				if self:GetTargetValid() then
					shootPos = self:GetTarget():GetPos()
				end
			else
				shootPos = ply:GetEyeTrace().HitPos
			end
			local tr = util.QuickTrace(shootPos,shootPos + reachSky,self.Entities)
			if tr.Hit and !tr.HitSky and !tr.Entity == self:GetTarget() then
				canShoot = false
				if !botmode and self.Time_Mortar <= ct then
					net.Start("gred_net_message_ply")
						net.WriteString("["..self.NameToPrint.."] You can't shoot in interiors!")
					net.Send(ply)
					self.Time_Mortar = ct + 1
				end
			end
		end
	end
	return canShoot
end

function ENT:BulletCalcVel(ammotype)
	ammotype = ammotype or (self.AmmunitionType or self.AmmunitionTypes[1][2])
	if hab and hab.Module.PhysBullet and not gred.CVars.gred_sv_override_hab:GetInt() == 0 then
		if ammotype == "wac_base_7mm" then
			self.BulletVelCalc = 100
		elseif ammotype == "wac_base_12mm" then
			self.BulletVelCalc = 5000
		elseif ammotype == "wac_base_20mm" then
			self.BulletVelCalc = 4000
		elseif ammotype == "wac_base_30mm" then
			self.BulletVelCalc = 3000
		elseif ammotype == "wac_base_40mm" then
			self.BulletVelCalc = 1500
		else 
			self.BulletVelCalc = 500 
		end
	else
		if ammotype == "wac_base_7mm" then
			self.BulletVelCalc = 15000
		elseif ammotype == "wac_base_12mm" then
			self.BulletVelCalc = 12000
		elseif ammotype == "wac_base_20mm" then
			self.BulletVelCalc = 8000
		elseif ammotype == "wac_base_30mm" then
			self.BulletVelCalc = 5000
		elseif ammotype == "wac_base_40mm" then
			self.BulletVelCalc = 2000
		else 
			self.BulletVelCalc = 10000
		end
	end
	self.BulletVelCalc = self.BulletVelCalc*self.BulletVelCalc
end

function ENT:FireMortar(ply,ammo,muzzle)
	
	local pos = self:GetPos()
	util.ScreenShake(pos,5,5,0.5,200)
	
	local EyeTrace = self.TargetTrace and self.TargetTrace or ply:GetEyeTrace()
	local viewmode = self:GetViewMode()
	local trace = {}				
	trace.start = self.CustomEyeTrace and viewmode > 0 and self.CustomEyeTraceHitPos or EyeTrace.HitPos
	trace.endpos = self.CustomEyeTrace and viewmode > 0 and self.CustomEyeTraceHitPos + Vector(0,0,1000) or EyeTrace.HitPos + Vector(0,0,1000) -- This calculates the spawn altitude
	trace.Mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine(trace)
	
	local spread = sqrt(tr.HitPos:Distance(EyeTrace.StartPos))*2.5
	local BPos = tr.HitPos + Vector(math.random(-spread,spread),math.random(-spread,spread),-1) -- Creates our spawn position
	BPos = self.TargetTrace and BPos + add_alt or BPos
	if !util.IsInWorld(BPos) then
		BPos = tr.HitPos
	end
	-- if !util.IsInWorld(BPos) then return end
	
	local HitBPos = Vector(0,0,util.QuickTrace(BPos,BPos - reachSky,self.Entities).HitPos.z) -- Defines the ground's pos
	local zpos = Vector(0,0,BPos.z) -- The exact spawn altitude
	local dist = HitBPos:DistToSqr(zpos) -- Calculates the distance between our spawn altitude and the ground
	
	----------------------
	
	local snd = "artillery/flyby/artillery_strike_incoming_0"..(math.random(1,4))..".wav"
	local sndDuration = SoundDuration(snd)
	local curShell = self:GetAmmoType()
	timer.Simple(gred.CVars.gred_sv_shell_arrival_time:GetFloat(),function()
		if not IsValid(self) then return end
		local time = (dist * MortarNum) + (sndDuration - 0.2) -- Calculates when to play the whistle sound
		if time < 0 then
			local b
			if self.IsRocketLauncher then
				b = ents.Create(self.AmmunitionTypes[curShell].Entity)
				b:SetPos(BPos)
				b:SetAngles(Angle(90))
				b.FuelBurnoutTime = self:GetMaxRange()
				if self.AmmunitionTypes[curShell].ShellType == "Smoke" then
					b.Smoke = true
					b.Effect = "doi_smoke_artillery"
					b.EffectAir = "doi_smoke_artillery"
					b.ExplosionRadius = 0
					b.ExplosionDamage = 0
					b.RSound = 1
					b.ExplosionSound = table.Random(self.SmokeExploSNDs)
					b.WaterExplosionSound = table.Random(self.SmokeExploSNDs)
				end
				b.IsOnPlane = true
				b:Spawn()
				b:SetOwner(ply)
				b:Activate()
				for k,v in pairs(self.Entities) do
					constraint.NoCollide(v,b,0,0)
				end
			else
				b = gred.CreateShell(BPos,Angle(90),ply,self.Entities,self.AmmunitionTypes[curShell].Caliber,self.AmmunitionTypes[curShell].ShellType,self.AmmunitionTypes[curShell].MuzzleVelocity,self.AmmunitionTypes[curShell].Mass,self.AmmunitionTypes[curShell].TracerColor,self.AmmunitionTypes[curShell].CustomDamage,self.AmmunitionTypes[curShell].CallBack,self.AmmunitionTypes[curShell].TNTEquivalent,self.AmmunitionTypes[curShell].ExplosiveMass,self.AmmunitionTypes[curShell].LinearPenetration,self.AmmunitionTypes[curShell].Normalization,self.AmmunitionTypes[curShell].CoreMass)
			end
			if self.EmplacementType == "Mortar" then
				b:SetModel("models/gredwitch/bombs/artillery_shell.mdl")
			end
			if b.IS_AP and b.IS_AP[b.ShellType] then
				b:Launch()
			else
				b:Arm()
				timer.Simple(-time,function()
					if !IsValid(b) then return end
					b:EmitSound(snd, 140, 100, 1)
				end)
			end
		else
			
			local b
			if self.IsRocketLauncher then
				b = ents.Create(self.AmmunitionTypes[curShell].Entity)
				b:SetPos(BPos)
				b:SetAngles(Angle(90))
				b.FuelBurnoutTime = self:GetMaxRange()
				if self.AmmunitionTypes[curShell].ShellType == "Smoke" then
					b.Smoke = true
					b.Effect = "doi_smoke_artillery"
					b.EffectAir = "doi_smoke_artillery"
					b.ExplosionRadius = 0
					b.ExplosionDamage = 0
					b.RSound = 1
					b.ExplosionSound = table.Random(self.SmokeExploSNDs)
					b.WaterExplosionSound = table.Random(self.SmokeExploSNDs)
				end
				b.IsOnPlane = true
				b:Spawn()
				b:SetOwner(ply)
				b:Activate()
				for k,v in pairs(self.Entities) do
					constraint.NoCollide(v,b,0,0)
				end
			else
				b = gred.CreateShell(BPos,Angle(90),ply,self.Entities,self.AmmunitionTypes[curShell].Caliber,self.AmmunitionTypes[curShell].ShellType,self.AmmunitionTypes[curShell].MuzzleVelocity,self.AmmunitionTypes[curShell].Mass,self.AmmunitionTypes[curShell].TracerColor,self.AmmunitionTypes[curShell].CustomDamage,self.AmmunitionTypes[curShell].CallBack,self.AmmunitionTypes[curShell].TNTEquivalent,self.AmmunitionTypes[curShell].ExplosiveMass,self.AmmunitionTypes[curShell].LinearPenetration,self.AmmunitionTypes[curShell].Normalization,self.AmmunitionTypes[curShell].CoreMass)
			end
			if self.EmplacementType == "Mortar" then
				b:SetModel("models/gredwitch/bombs/artillery_shell.mdl")
			end
			if b.IS_AP and b.IS_AP[b.ShellType] then
				b:Launch()
			else
				b:SetBodygroup(0,1)
				b:SetNoDraw(true)
				b:SetMoveType(MOVETYPE_NONE)
				b:EmitSound(snd,140,100,1)
				
				timer.Simple(time,function()
					if !IsValid(self) then return end
					
					b:SetNoDraw(false)
					b:SetMoveType(MOVETYPE_VPHYSICS)
					b:Arm()
					b.PhysicsUpdate = function(data,phys)
						phys:SetVelocityInstantaneous(Vector(0,0,-1000))
					end
				end)
			end
		end
	end)
end

function ENT:FireMG(ply,ammo,muzzle)
	local rand = math["Rand"]
	local spread  = self["GetSpread"]
	local pos = self:LocalToWorld(muzzle["Pos"])
	local ang = self:LocalToWorldAngles(muzzle["Ang"]) + self["ShootAngleOffset"] + Angle(rand(spread,-spread),rand(spread,-spread)+90,rand(spread,-spread))
	local ammotype = self["AmmunitionType"]
	local ammotypes = self["AmmunitionTypes"]
	local cal = ammotype or ammotypes[1][2]
	local fusetime = (ammotypes and ammotypes[self:GetAmmoType()][1] == "Time-fused" or false) and self.FuzeTime or nil
	gred.CreateBullet(ply,pos,ang,cal,self["Entities"],fusetime,self.ClassName == "gred_emp_phalanx",self:UpdateTracers())
	
end

function ENT:FireCannon(ply,ammo,muzzle)
	
	local pos = self:GetPos()
	util.ScreenShake(pos,5,5,0.5,200)
	pos = self:LocalToWorld(muzzle.Pos)
	local ang = self:LocalToWorldAngles(muzzle.Ang) + self.ShootAngleOffset
	
	local curShell = self:GetAmmoType()
	ang:Sub(Angle(self:GetBotMode() and (self.AddShootAngle or 2) + 2 or (self.AddShootAngle or 0),-90,0)) -- + Angle(math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter))
	if self.IsRocketLauncher then
		local b = ents.Create(self.AmmunitionTypes[curShell].Entity)
		b:SetPos(pos)
		b:SetAngles(ang)
		b.FuelBurnoutTime = self:GetMaxRange()
		if self.AmmunitionTypes[curShell].ShellType == "Smoke" then
			b.Smoke = true
			b.Effect = "doi_smoke_artillery"
			b.EffectAir = "doi_smoke_artillery"
			b.ExplosionRadius = 0
			b.ExplosionDamage = 0
			b.RSound = 1
			b.ExplosionSound = table.Random(self.SmokeExploSNDs)
			b.WaterExplosionSound = table.Random(self.SmokeExploSNDs)
		end
		b.IsOnPlane = true
		b:Spawn()
		b:SetOwner(ply)
		b:Activate()
		for k,v in pairs(self.Entities) do
			constraint.NoCollide(v,b,0,0)
		end
		b:Launch()
	else
		gred.CreateShell(pos,ang,ply,self.Entities,self.AmmunitionTypes[curShell].Caliber,self.AmmunitionTypes[curShell].ShellType,self.AmmunitionTypes[curShell].MuzzleVelocity,self.AmmunitionTypes[curShell].Mass,self.AmmunitionTypes[curShell].TracerColor,self.AmmunitionTypes[curShell].CustomDamage,self.AmmunitionTypes[curShell].CallBack,self.AmmunitionTypes[curShell].TNTEquivalent,self.AmmunitionTypes[curShell].ExplosiveMass,self.AmmunitionTypes[curShell].LinearPenetration,self.AmmunitionTypes[curShell].Normalization,self.AmmunitionTypes[curShell].CoreMass):Launch()
	end
	if self.TurretEjects[1] then
		timer.Simple(self.AnimPlayTime + (self.TimeToEjectShell or 0.2),function()
			if !IsValid(self) then return end
			shellEject = self.TurretEjects[self:GetCurrentMuzzle()-1]
			shellEject = shellEject or self.TurretEjects[1]
			local shell = ents.Create("gred_prop_casing")
			shell.Model = "models/gredwitch/bombs/75mm_shell.mdl"
			shell:SetPos(self:LocalToWorld(shellEject.Pos))
			shell:SetAngles(self:LocalToWorldAngles(shellEject.Ang))
			shell.BodyGroupA = 1
			shell.BodyGroupB = 2
			shell:Spawn()
			shell:Activate()
			shell:SetModelScale(self.AmmunitionTypes[curShell].Caliber / 75)
		end)
	end
end

function ENT:Reload()

end

function ENT:PlayAnim(noanimplaytime)
	if self.EmplacementType != "Cannon" and self:GetIsReloading() then print("NOT ANIMPLAYING") return end
	self.sounds.reload_finish:Stop()
	self.sounds.reload_start:Stop()
	self.sounds.reload_shell:Stop()
	
	local manualReload = gred.CVars.gred_sv_manual_reload:GetInt() == 1
	self:SetIsReloading(true)
	self:SetAmmo(0)
	local str = tostring(self)
	
	timer.Remove(str.."_stage_1")
	timer.Remove(str.."_stage_2")
	timer.Remove(str.."_stage_3")
	timer.Remove(str.."_stage_4")
	
	timer.Create(str.."_stage_1",noanimplaytime and 0 or self.AnimPlayTime,1,function()
		if !IsValid(self) then return end
		self:ResetSequence("reload")
		self.sounds.reload_start:Play()
		self:SetIsReloading(true)
		if manualReload then
			timer.Create(str.."_stage_2",self.AnimPauseTime or 0,1,function() 
				if !IsValid(self) then return end
				self:SetCycle(.6)
				self:SetPlaybackRate(0) 
			end)
		else
			timer.Create(str.."_stage_2",self.ShellLoadTime or self.AnimRestartTime/2,1,function()
				if !IsValid(self) then return end
				self.sounds.reload_shell:Play()
			end)
			timer.Create(str.."_stage_3",self:SequenceDuration()-0.6,1,function() 
				if !IsValid(self) then return end
				self.sounds.reload_finish:Play()
				timer.Create(str.."_stage_4",SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),1,function()
					if !IsValid(self) then return end
					self:SetIsReloading(false)
				end)
			end)
		end
	end)
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

function ENT:HandleRecoil(ang)
	if self.EmplacementType == "MG" and !self.Seatable and self.EnableRecoil:GetInt() == 1 then
		if self.ShouldDoRecoil then
			self.CurRecoil = self.Recoil
		end
		self.CurRecoil = self.CurRecoil and self.CurRecoil + math.Clamp(0 - self.CurRecoil,-self.RecoilRate,self.RecoilRate) or 0
		self:SetRecoil(self.CurRecoil)
		ang.p = ang.p - self.CurRecoil
	end
end

function ENT:PreFire(ammo,ct,ply)
	if self.Sequential then
		self:CheckMuzzle()
		local m = self:GetCurrentMuzzle()
		
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
		if self.EmplacementType == "MG" or (self.EmplacementType == "Cannon" and self.Ammo > 1) then -- if MG or Nebelwerfer
			self:SetAmmo(ammo - (self.EmplacementType == "MG" and gred.CVars.gred_sv_limitedammo:GetInt() or 1))
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
				if self.CustomEyeTrace then
					self:FireMortar(ply,ammo,m)
				else
					self:FireCannon(ply,ammo,m)
				end
			end
			
			if self.EmplacementType == "MG" or (self.EmplacementType == "Cannon" and self.Ammo > 1) then -- if MG or Nebelwerfer
				self:SetAmmo(ammo - (self.EmplacementType == "MG" and gred.CVars.gred_sv_limitedammo:GetInt() or 1))
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
				if self.NextShootAnim < ct then
					self:ResetSequence(self.ShootAnim)
					self.NextShootAnim = ct + self.AnimRestartTime
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

----------------------------------------
-- AMMO


function ENT:SwitchAmmoType(ply,ct)
	local ammotype = self:GetAmmoType()
	if self.EmplacementType == "Cannon" then
		
		self:SetNextShot(ct + self.ShotInterval)
		
		if self.TurretEjects[1] then
			if !self:GetIsReloading() then
				local oldammotype = ammotype
				timer.Simple(self.TimeToEjectShell or 0.2,function()
					if !IsValid(self) then return end
					shellEject = self.TurretEjects[self:GetCurrentMuzzle()-1]
					shellEject = shellEject or self.TurretEjects[1]
					local shell = ents.Create("gred_prop_casing")
					shell.Model = "models/gredwitch/bombs/75mm_shell.mdl"
					shell:SetPos(self:LocalToWorld(shellEject.Pos))
					shell:SetAngles(self:LocalToWorldAngles(shellEject.Ang))
					shell.BodyGroupA = 1
					shell.BodyGroupB = self.AmmunitionTypes[oldammotype].ShellType == "AP" and 0 or 1
					shell:Spawn()
					shell:Activate()
					shell:SetModelScale(self.AmmunitionTypes[oldammotype].Caliber / 75)
				end)
			end
		end
		
		self:PlayAnim(true)
		
	end
	ammotype = ammotype + 1
	self:SetAmmoType(ammotype)
	if ammotype <= 0 or ammotype > table.Count(self.AmmunitionTypes) then self:SetAmmoType(1) end
	net.Start("gred_net_message_ply")
		local t = self.AmmunitionTypes[self:GetAmmoType()]
		net.WriteString("["..self.NameToPrint.."] "..(t.ShellType or t[1]).." shells selected")
	net.Send(ply)
end

function ENT:SetNewFuseTime(ply,minus)
	self.FuzeTime = self.FuzeTime + (minus and -0.01 or 0.01)
	if self.FuzeTime > 0.5 then self.FuzeTime = 0.01 elseif self.FuzeTime <= 0 then self.FuzeTime = 0.5 end
	net.Start("gred_net_message_ply")
		net.WriteString("["..self.NameToPrint.."] Time fuse set to "..math.Round(self.FuzeTime,2).." seconds")
	net.Send(ply)
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

function ENT:CheckShellType(shelltype)
	for k,v in pairs(self.AmmunitionTypes) do
		if v.ShellType == shelltype then
			return true
		end
	end
end

function ENT:ManualReload(ammo)
	if ammo == 0 and self.EmplacementType != "MG" then
		if gred.CVars.gred_sv_manual_reload:GetInt() == 1 then
		
			local pos = self:GetPos()
			if !self.bboxMin then
				self.bboxMin,self.bboxMax = self:GetModelBounds()
			end
			
			for _,ent in pairs (ents.FindInBox(self.bboxMin+pos,self.bboxMax+pos)) do
				if ent.ClassName == "base_shell" then
					if !ent.Fired and self.AmmunitionTypes[1].Caliber == ent.Caliber and self:CheckShellType(ent.ShellType) then
						if self.EmplacementType == "Cannon" then
							self.AnimPlaying = true
						end
						for k,v in pairs(self.AmmunitionTypes) do
							if v.ShellType == ent.ShellType then -- AP
								self:SetAmmoType(k)
								break
							end
						end
						if IsValid(ent.PlyPickup) then
							ent.PlyPickup:ChatPrint("["..self.NameToPrint.."] "..ent.ShellType.." shell loaded!")
						end
						ent:Remove()
						if self.EmplacementType == "Cannon" then
							self.sounds.reload_shell:Stop()
							self.sounds.reload_shell:Play()
							timer.Simple(1.3,function()
								if !IsValid(self) then return end
								self.sounds.reload_start:Stop()
								self.sounds.reload_finish:Play()
								if self.UseSingAnim then
									self:SetCycle(.8)
									self:SetPlaybackRate(1)
									timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function() 
										if !IsValid(self) then return end
										self.AnimPlaying = false
										self:SetAmmo(1)
										self:SetIsReloading(false)
									end)
								else
									self:ResetSequence("reload_finish")
									timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function() 
										if !IsValid(self) then return end
										self.AnimPlaying = false
										self:SetAmmo(1)
										self:SetIsReloading(false)
									end)
								end
							end)
						else
							self:SetAmmo(1)
							self:SetIsReloading(false)
						end
						
						break
					else
						if IsValid(ent.PlyPickup) then
							ent.PlyPickup:PrintMessage(4,"["..self.NameToPrint.."] Wrong caliber / shell type !")
						end
					end
				end
			end
		end
	elseif self.EmplacementType == "MG" and (ammo >= 0 and ammo < self.Ammo) and self:GetIsReloading() then
		if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 1 then
			if !self.bboxMin then
				self.bboxMin,self.bboxMax = self:GetModelBounds()
			end
			local pos = self:GetPos()
			local ent
			for k,v in pairs (ents.FindInBox(self.bboxMin+pos,self.bboxMax+pos)) do
				if v.gredGunEntity then
					if v.gredGunEntity == self:GetClass() or v.gredGunEntity == self.AltClassName then
						ent = v
						break
					end
				end
			end
			
			if ent != nil then
				ent:Remove()
				self:SetPlaybackRate(1)
				if self.CycleRate then self:SetCycle(self.CycleRate) end
				self.sounds.reloadend:Stop()
				self.sounds.reloadend:Play()
				self.MagIn = true
				self.NewMagIn = true
				timer.Simple(self.ReloadTime, function()
					if !IsValid(self) then return end
					self:SetAmmo(self.Ammo)
					self:SetIsReloading(false)
					self.NewMagIn = false
				end)
			end
		end
	end
end


----------------------------------------
-- DUPES AND SAVES


local EmplacementEnts = {}

local function GetFlex(ent)
	local tab = {}
	
	for i = 0, ent:GetFlexNum() do
		tab[i] = ent:GetFlexWeight(i)
		tab[i] = tab[i] == 0 and nil or tab[i]
	end
	
	return tab
end

local function GetBodyGroups(ent)
	local tab = {}
	for k,v in pairs(ent:GetBodyGroups()) do
		tab[v.id] = ent:GetBodygroup(v.id)
	end
	return tab
end

local function GetEntityGeneric(ent)
	if !IsValid(ent) then return nil end
	
	return {
		Model = ent:GetModel(),
		Skin = ent:GetSkin(),
		Flex = GetFlex(ent),
		FlexScale = ent:GetFlexScale(),
		ModelScale = ent:GetModelScale(),
		ColGroup = ent:GetCollisionGroup(),
		Color = ent:GetColor(),
		BodyG = GetBodyGroups(ent),
	}
end

local function DuplicateEntityGeneric(ent1,ent2)
	if !IsValid(ent1) or !IsValid(ent2) then return end
	
	ent2:SetModel(ent1:GetModel())
	ent2:SetSkin(ent1:GetSkin())
	ent2:SetFlexScale(ent1:GetFlexScale())
	ent2:SetModelScale(ent1:GetModelScale(),0)
	ent2:SetCollisionGroup(ent1:GetCollisionGroup())
	
	for i = 0,ent1:GetBoneCount() do
		ent2:ManipulateBoneScale(i,ent1:GetManipulateBoneScale(i))
		ent2:ManipulateBoneAngles(i,ent1:GetManipulateBoneAngles(i))
		ent2:ManipulateBonePosition(i,ent1:GetManipulateBonePosition(i))
	end
	
	for k,v in pairs(ent:GetBodyGroups()) do
		ent2:SetBodygroup(v.id,ent1:GetBodygroup(v.id))
	end
	
	for i = 0, ent1:GetFlexNum() do
		ent2:SetFlexWeight(i,ent1:GetFlexWeight(i))
	end
end

function ENT:PreEntityCopy()
	local hull = self:GetHull()
	self.DUPE_OLD_ANG = hull:WorldToLocalAngles(self:GetAngles())
	self.DUPE_OLD_HULL_ANG = hull:GetAngles()
	
	self.OldEntitiesProperties = self.OldEntitiesProperties or {}
	for k,v in pairs(self.Entities) do
		if IsValid(v) then
			self.OldEntitiesProperties[k] = GetEntityGeneric(v)
		end
	end
	
	local phy = hull:GetPhysicsObject()
	if IsValid(phy) then
		self.DUPE_HULL_FROZEN = phy:IsMotionEnabled()
	end
end

function ENT:OnDuplicated(entTable)
	local index = self:EntIndex()
	local hull = self:GetHull()
	local hullpos = hull:GetPos()
	self.Entities = {}
	entTable.Entities = {}
	
	for k,v in pairs(EmplacementEnts[index].Entities) do
		self.Entities[k] = Entity(v)
		if !IsValid(self.Entities[k]) then
			self.Entities[k] = nil
		end
		entTable.Entities[k] = self.Entities[k]
	end
end

function ENT:PostEntityCopy()
	local index = self:EntIndex()
	EmplacementEnts[index] = {Entities = {}}
	for k,v in pairs(self.Entities) do
		EmplacementEnts[index].Entities[k] = v:EntIndex()
	end
end

function ENT:PostEntityPaste(ply,ent,createdEntities)
	local class = self:GetClass()
	local index = self:EntIndex()
	local plyValid = IsValid(ply)
	-- if class == "gred_emp_gau19" then PrintTable(createdEntities) end
	for k,v in pairs(createdEntities) do
		if v:GetClass() == "gred_prop_emp" then
			v:Remove()
			v = nil
			createdEntities[k] = nil
		else
			if self != v and plyValid then
				v:Remove()
				v = nil
				createdEntities[k] = nil
			end
		end
	end
	
	for k,v in pairs(self.Entities) do
		if self.OldEntitiesProperties[k] then
			duplicator.DoGeneric(v,self.OldEntitiesProperties[k])
			v:SetColor(self.OldEntitiesProperties[k].Color)
		end
	end
	
	local hull = self:GetHull()
	local oldang = hull:GetAngles()
	local hullpos
	
	if IsValid(ply) then
		oldang.p = 0
		oldang.r = 0
	
		if self.DUPE_OLD_HULL_ANG then
			oldang.y = self.DUPE_OLD_HULL_ANG.y + oldang.y
		end
		
		-- hullpos = ply:GetEyeTrace().HitPos + self.TurretPos
		hullpos = hull:GetPos() - self.TurretPos
	else
		hullpos = hull:GetPos() - self.TurretPos
	end
	
	local oldparent = self:GetParent()
	hull:SetPos(hullpos)
	hull:SetAngles(Angle(0,0,0))
	self:SetParent(nil)
	self:SetPos(hullpos + self.TurretPos)
	self:SetParent(oldparent)
	hull:SetAngles(oldang)
	
	local phy = hull:GetPhysicsObject()
	if IsValid(phy) then
		phy:EnableMotion(self.DUPE_HULL_FROZEN)
		if self.DUPE_HULL_FROZEN then
			phy:Wake()
		end
	end
	
	if self.DUPE_OLD_ANG then
		local yaw = self:GetYaw()
		if IsValid(yaw) then
			local ang = hull:LocalToWorldAngles(self.DUPE_OLD_ANG)
			local oldp = oldang.p
			ang.p = 0
			
			yaw:SetAngles(ang)
			
			ang.p = oldp
			
			self:SetAngles(ang)
		else
			self:SetAngles(hull:LocalToWorldAngles(self.DUPE_OLD_ANG))
		end
	end
	
	self.DUPE_HULL_FROZEN = false
	EmplacementEnts[index] = nil
end


----------------------------------------
-- DEATH


function ENT:Explode(ply)
	if self.Exploded then return end
	if gred.CVars.gred_sv_enable_explosions:GetInt() == 0 then return end
	self.Exploded = true
	
	if self.Seatable then
		local shooter = self:GetShooter()
		if shooter != self and IsValid(shooter) then
			shooter:TakeDamage(1500,ply,self)
		end
	end
	
	local b = self:BoundingRadius()
	local p = self:GetPos()
	local hull = self:GetHull()
	local tp = hull:GetPos()
	local tr = hull:GetRight()
	local u = self:GetUp()
	local r = self:GetRight()
	local f = self:GetForward()
	self.ExploPos = {}
	self.ExploPos[1] = p
	self.ExploPos[2] = tp
	if b >= 150 then
		b = b / 1.5
		p.z = p.z + (self.ExplodeHeight or 0)
		self.ExploPos[3] = p+r*b
		self.ExploPos[4] = p+r*-b
		self.ExploPos[5] = p+f*b
		self.ExploPos[6] = p+f*-b
		self.ExploPos[7] = p+u*b
		self.ExploPos[8] = p+u*-b
	else
		if self.EmplacementType == "Cannon" then
			self.ExploPos[3] = tp+tr*-(b*0.7)
			self.ExploPos[4] = tp+tr*(b/2)
		end
	end
	for k,v in pairs (self.ExploPos) do
		local effectdata = EffectData()
		effectdata:SetOrigin(v)
		util.Effect("Explosion",effectdata)
		ply = ply or self
		util.BlastDamage(ply,ply,v,100,100)
	end
	
	self:Remove()
end

function ENT:OnTakeDamage(dmg)
	if dmg:IsFallDamage() then return end
	local IsBulletDamage = dmg:IsBulletDamage()
	
	if (self.EmplacementType == "Cannon" and IsBulletDamage) then return end
	
	self:SetHP(self:GetHP() - dmg:GetDamage() * (IsBulletDamage and 0.3 or 1))
	
	if self:GetHP() <= 0 then 
		self:Explode(dmg:GetAttacker()) 
	end
end

function ENT:OnRemove()
	for k,v in pairs(self.Entities) do
		if IsValid(v) then
			v:Remove()
		end
	end
	self:LeaveTurret(self:GetShooter())
end

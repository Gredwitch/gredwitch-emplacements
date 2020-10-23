include("shared.lua")

local reachSky = Vector(0,0,9999999999)
local Z_CANNON = Vector(0,0,10)
local vector_zero = vector_zero
local angle_zero = Angle()
local soundSpeed = 18005.25*18005.25 -- 343m/s
local bigNum = 99999999999
local vector_down = Vector(0,0,-1)
local addvec = Vector(0,0,1000)
local col_red = Color(255,0,0)
local col_green = Color(0,255,0)
local col_blue = Color(0,0,255)
local COLOR_BLACK = Color(0,0,0,255)
local COLOR_ORANGE = Color(195,148,32,255)
local COLOR_GREEN = Color(34,177,76,255)
local COLOR_WHITE = Color(255,255,255,255)
local COLOR_RED = Color(255,0,0,255)
local MAT_BLANKSIGHT = Material("gredwitch/overlay_blank_tanksight")
local MAT_CARRIAGE = Material("vgui/gredwitch/carriage.png")
local MAT_GUN = Material("vgui/gredwitch/gun.png")

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

function ENT:Initialize()
	self:ReloadSounds()
	self:InitAttachmentsCL()
	self:OnInitializeCL()
	self:CalcSpread()
	self.StringedSelf = tostring(self)
	
	self.EnableRecoil = gred.CVars.gred_sv_enable_recoil
	self.ENT_INDEX = self:EntIndex()
	
	self.Initialized = true
	
end

function ENT:OnInitializeCL()

end

function ENT:InitAttachmentsCL()
	local tableinsert = table.insert
	local startsWith = string.StartWith
	local t
	for k,v in pairs(self:GetAttachments()) do
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

	

local function Stink(ply,ent)
	ent = ply.Gred_Emp_Ent
	
	if not IsValid(ent) or not ent.HasIK or not ply:Alive() then
		hook.Remove("PostPlayerDraw","gred_emp_ik_PostPlayerDraw")
		
		local lUpperArm = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
		local rUpperArm = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
		
		local lForeArm = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
		local rForeArm = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		
		local lHand = ply:LookupBone("ValveBiped.Bip01_L_Hand")
		local rHand = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		
		local Spine = ply:LookupBone("ValveBiped.Bip01_Spine2")
		
		ply:ManipulateBoneAngles(lHand,angle_zero)
		ply:ManipulateBoneAngles(lUpperArm,angle_zero)
		ply:ManipulateBoneAngles(lForeArm,angle_zero)
		
		ply:ManipulateBoneAngles(rHand,angle_zero)
		ply:ManipulateBoneAngles(rUpperArm,angle_zero)
		ply:ManipulateBoneAngles(rForeArm,angle_zero)
		ply:ManipulateBoneAngles(Spine,angle_zero)
		
		return
	end
		
	local lUpperArm = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
	local rUpperArm = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
	
	local lForeArm = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
	local rForeArm = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
	
	local lHand = ply:LookupBone("ValveBiped.Bip01_L_Hand")
	local rHand = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	
	local Spine = ply:LookupBone("ValveBiped.Bip01_Spine2")
	
	if not (lUpperArm and lForeArm and lHand and rUpperArm and rForeArm and rHand) then
		return
	end
	
	local IKLeftHandPos = ent:LocalToWorld(ent.IKLeftHandPos)
	local IKRightHandPos = ent:LocalToWorld(ent.IKRightHandPos)
	
	local lUpperArmPos,lUpperArmAng = ply:GetBonePosition(lUpperArm)
	local lForeArmPos,lForeArmAng = ply:GetBonePosition(lForeArm)
	local lHandPos,lHandAng = ply:GetBonePosition(lHand)
	local SpinePos,SpineAng = ply:GetBonePosition(Spine)
	
end

function ENT:OnPlayerTookEmplacement(ply)
	if ply == LocalPlayer() then
		hook.Add("AdjustMouseSensitivity","gred_emp_mouse",function(s)
			if not IsValid(self) or self != ply.Gred_Emp_Ent or not ply:Alive() then
				ply.Gred_Emp_Ent = nil
				
				hook.Remove("AdjustMouseSensitivity","gred_emp_mouse")
				
				return 
			end
			
			return gred.CVars.gred_cl_emp_mouse_sensitivity:GetFloat()
		end)
		
		hook.Add("CalcView","gred_emp_calcview",function(ply,pos,angles,fov)
			if not IsValid(self) or self != ply.Gred_Emp_Ent or not ply:Alive() then
				ply.Gred_Emp_Ent = nil
				
				hook.Remove("CalcView","gred_emp_calcview")
				
				return
			elseif ply:GetViewEntity() != ply then
				return
			end
			
			return ply.Gred_Emp_Ent:View(ply,pos,angles,fov)
		end)
		
		local trtab = {}
		
		hook.Add("HUDPaint","gred_emp_hudpaint",function()
			if not IsValid(self) or self != ply.Gred_Emp_Ent or not ply:Alive() then
				ply.Gred_Emp_Ent = nil
				
				hook.Remove("HUDPaint","gred_emp_hudpaint")
				
				return
			elseif ply:GetViewEntity() != ply then
				return
			end
			
			local ScrW,ScrH = self:PaintHUD(ply,self:GetViewMode())
			
			if ScrW and ScrH then
				local startpos = self:LocalToWorld(self.SightPos)
				
				trtab.start = startpos
				trtab.endpos = (startpos + ply:EyeAngles():Forward() * 1000)
				trtab.filter = self.Entities
				
				local scr = util.TraceLine(trtab).HitPos:ToScreen()
				scr.x = scr.x > ScrW and ScrW or (scr.x < 0 and 0 or scr.x)
				scr.y = scr.y > ScrH and ScrH or (scr.y < 0 and 0 or scr.y)
				
				
				surface.SetDrawColor(255,255,255)
				DrawCircle(scr.x,scr.y,19)
				surface.SetDrawColor(0,0,0)
				DrawCircle(scr.x,scr.y,20)
			end
		end)
		
		hook.Add("InputMouseApply","gred_emp_move",function(cmd,x,y,angle)
			if not IsValid(self) or self != ply.Gred_Emp_Ent or not ply:Alive() then
				ply.Gred_Emp_Ent = nil
				
				hook.Remove("InputMouseApply","gred_emp_move")
				
				return
			end
			
			if IsValid(self:GetSeat()) or self:GetViewMode() != 0 then
				local InvertX = gred.CVars.gred_cl_emp_mouse_invert_x:GetInt() == 1
				local InvertY = gred.CVars.gred_cl_emp_mouse_invert_y:GetInt() == 1
				local sensitivity = gred.CVars.gred_cl_emp_mouse_sensitivity:GetFloat()
				
				x = x * sensitivity
				y = y * sensitivity
				
				if InvertX then
					angle.yaw = angle.yaw + x / 50
				else
					angle.yaw = angle.yaw - x / 50
				end
				if InvertY then
					angle.pitch = math.Clamp( angle.pitch - y / 50, -89, 89 )
				else
					angle.pitch = math.Clamp( angle.pitch + y / 50, -89, 89 )
				end
				
				cmd:SetViewAngles( angle )
			   
				return true
			end
		end)
		
		if self.MaxViewModes > 0 then
			ply:ChatPrint("["..(self.NameToPrint and self.NameToPrint or string.gsub(self.PrintName,"%[EMP]","")).."] Press the Suit Zoom or the Crouch key to toggle aimsights")
		end
	elseif not IsValid(ply) and LocalPlayer().Gred_Emp_Ent == self then
		LocalPlayer().Gred_Emp_Ent = nil
		
		return
	end
	
	-- if self.HasIK then
		-- local ent
		
		-- hook.Add("PostPlayerDraw","gred_emp_ik_PostPlayerDraw",function(ply)
			-- Stink(ply)
		-- end)
	-- end
end

local MAT_DASHEDLINES = Material("vgui/gredwitch/dashed_lines.png")


function ENT:Think()
	if not self.Initialized then 
		self:Initialize() 
		return 
	end
	
	if not self.Entities[1] then
		table.insert(self.Entities,self)
		table.insert(self.Entities,self:GetHull())
		self:GetHull():SetGredEMPBaseENT(self)
		
		if IsValid(self:GetYaw()) then 
			table.insert(self.Entities,self:GetYaw()) 
			self:GetYaw():SetGredEMPBaseENT(self)
		end
		if IsValid(self:GetWheels()) then 
			table.insert(self.Entities,self:GetWheels()) 
			self:GetWheels():SetGredEMPBaseENT(self)
		end
	end
	
	local ply = self:GetShooter()
	local ct = CurTime()
	local CanShoot
	local ammo
	local IsAttacking
	local IsReloading
	
	self.ShouldDoRecoil = false
	
	if IsValid(ply) then
		ammo = self:GetAmmo()
		IsReloading = self:GetIsReloading()
		IsAttacking = ply == LocalPlayer() and ply:KeyDown(IN_ATTACK) or self:GetIsAttacking()
		CanShoot = self:CanShoot(ammo,ct,ply,IsReloading)
		
		if ply:KeyDown(IN_ZOOM) then
			if self.NextSwitchViewMode <= ct then
				self:UpdateViewMode(ply)
				self.NextSwitchViewMode = ct + 0.3  -- FIXME : don't do time things
			end
		end
		
		if IsAttacking and CanShoot then -- if attacking
			self.LastShotTimerCreated = false
			
			self:PreFire(ammo,ct,ply,IsReloading)
			self:OnShoot()
		else
			if ((ammo < 1 and self.Ammo > 0) or IsReloading) or not IsAttacking then
				local LastShot = (ct - self.NextShot)
				
				if LastShot < 1 then
					if not self.LastShotTimerCreated then
						self.LastShotTimerCreated = true
						timer.Simple((self.ShotInterval - LastShot)*0.5,function()
							if not IsValid(self) then return end
							
							self:StopSoundStuff(ply,ammo,IsReloading)
						end)
					end
				elseif not self.LastShotTimerCreated then
					self:StopSoundStuff(ply,ammo,IsReloading)
				end
			end
		end
		
		if (self.EmplacementType == "Mortar" or self.CustomEyeTrace) and not ply.MortarHookAdded and ply == LocalPlayer() then
			hook.Add("PostDrawOpaqueRenderables","gred_emplacement_mortar_PostDrawOpaqueRenderables",function()
				if not IsValid(self) or self != ply.Gred_Emp_Ent or not ply:Alive() or (self.EmplacementType != "Mortar" and (not self.CustomEyeTrace or not (self.FireMissions and self.FireMissions[self:GetViewMode() - self.OldMaxViewModes]))) then
					hook.Remove("PostDrawOpaqueRenderables","gred_emplacement_mortar_PostDrawOpaqueRenderables")
					ply.MortarHookAdded = false
					
					return
				end
				
				local tr
				
				if not self.CustomEyeTrace or not (self.FireMissions and self.FireMissions[self:GetViewMode() - self.OldMaxViewModes]) then
					tr = ply:GetEyeTrace()
					tr.IsEyeTrace = true
				else
					tr = self.CustomEyeTrace
				end
				
				local CanShoot = self:CalcMortarCanShoot(ply,0,tr)
				local spread = math.max((tr.HitPos + addvec):Distance((tr.IsEyeTrace and tr or ply:GetEyeTrace()).StartPos)*0.03,400)
				
				tr.HitPos.z = tr.HitPos.z + 2
				
				cam.Start3D2D(tr.HitPos,angle_zero,1)
					if CanShoot then
						surface.SetDrawColor(0,255,0,255)
					else
						surface.SetDrawColor(255,0,0,255)
					end
					
					surface.SetMaterial(MAT_DASHEDLINES)
					surface.DrawTexturedRect(-spread,-spread,spread*2,spread*2)
					
				cam.End3D2D()
			end)
			
			ply.MortarHookAdded = true
		end
		
		self:HandleRecoil()
		
		self.ShooterValid = true
	elseif self.ShooterValid then
		-- if not self.LastShotTimerCreated then
			-- self.LastShotTimerCreated = true
			
			-- timer.Simple(self.ShotInterval - LastShotRatio,function()
				-- if not IsValid(self) then return end
				
				self:StopSoundStuff(nil,self:GetAmmo(),false,false)
			-- end)
		-- end
		
		self.ShooterValid = false
	end
	
	
	self:OnThinkCL(ct,ply,canShoot,ammo,IsReloading,IsAttacking)
end

function ENT:OnThinkCL(ct,ply,canShoot,ammo,IsReloading,IsAttacking)

end



-- Shoot

function ENT:CalcMortarCanShoot(ply,ct,tr2)
	local trtab = {}
	trtab.start = self:LocalToWorld(self.TurretMuzzles[1].Pos)
	trtab.endpos = trtab.start + reachSky
	trtab.mask = MASK_PLAYERSOLID_BRUSHONLY
	trtab.filter = self.Entities
	
	local tr = util.TraceLine(trtab)
	local canShoot = true
	local botmode = self:GetBotMode()
	local shootPos
	
	if tr.Hit and !tr.HitSky then
		canShoot = false
		
	else
		local ang = self:GetHull():WorldToLocalAngles(self.CustomEyeTrace and (self.CustomEyeTrace.HitPos - self:GetPos()):Angle() or self:GetAngles())
		canShoot = not (math.Round(ang.y) >= self.MaxRotation.y or math.Round(ang.y) <= self.MinRotation.y)
		
		if canShoot then
			if botmode then
				if self:GetTargetValid() then
					shootPos = self:GetTarget():GetPos()
				end
			elseif IsValid(ply) then
				shootPos = tr2 and tr2.HitPos or ply:GetEyeTrace().HitPos
			end
			
			if not shootPos then
				canShoot = false
			else
				trtab.start = shootPos
				trtab.endpos = trtab.start + reachSky
				
				local tr = util.TraceLine(tr)
				
				if tr.Hit and !tr.HitSky and (botmode and tr.Entity != self:GetTarget() or !botmode) then
					canShoot = false
				end
			end
		end
	end
	
	return canShoot
end


function ENT:CheckExtractor()
	local m = self:GetCurrentExtractor()
	if m <= 0 or m > table.Count(self.TurretEjects) then
		self:SetCurrentExtractor(1)
	end
end

function ENT:OnShoot()
	self.PlayStopSound = true
	
	if self.sounds.stop then 
		self.sounds.stop:Stop() 
	elseif self.OnlyShootSound or self.EmplacementType != "MG" then
		self.sounds.shoot:Stop()
	end
	
	self.sounds.shoot:Play()
	
	-- if (self.EmplacementType != "MG" or self.OnlyShootSound) then
		-- self.sounds.shoot:Stop()
		-- self.sounds.shoot:Play()
	-- end
	
	local effectdata
	
	if self.Sequential then
		effectdata = EffectData()
		effectdata:SetEntity(self)
		util.Effect("gred_particle_emp_muzzle",effectdata)
	else
		for k,v in pairs(self.TurretMuzzles) do
			effectdata = EffectData()
			effectdata:SetEntity(self)
			util.Effect("gred_particle_emp_muzzle",effectdata)
		end
	end
	
	if self.EmplacementType != "MG" then
		effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() - (self.EmplacementType == "Mortar" and vector_zero or Z_CANNON))
		effectdata:SetAngles(Angle(90,0,0))
		effectdata:SetFlags(table.KeyFromValue(gred.Particles,"gred_mortar_explosion_smoke_ground"))
		util.Effect("gred_particle_simple",effectdata)
	end
	
	self.ShouldDoRecoil = true
	self.LastShoot = CurTime()
end

function ENT:FireMortar(ply,ammo,muzzle)

end

function ENT:FireMG(ply,ammo,muzzle)
	local ang = self:LocalToWorldAngles(muzzle["Ang"]) + self["ShootAngleOffset"] + self:GetRandomSpreadAngle()
	local pos = self:LocalToWorld(muzzle["Pos"])
	local ammotype = self["AmmunitionType"]
	local ammotypes = self["AmmunitionTypes"]
	local cal = ammotype or ammotypes[1][2]
	local fusetime = (ammotypes and ammotypes[self:GetAmmoType()][1] == "Time-fused" or false) and self:GetFuseTime()*0.01 or nil
	
	gred.CreateBullet(ply,pos,ang,cal,self["Entities"],fusetime,self.ClassName == "gred_emp_phalanx",self:UpdateTracers(),nil,nil,true)
end

function ENT:FireCannon(ply,ammo,muzzle)

end



-- Sounds



function ENT:StopSoundStuff(ply,ammo,IsReloading,IsShooting)
	-- timer.Simple(LocalPlayer():GetViewEntity():GetPos():DistToSqr(self:GetPos())/soundSpeed,function()
		-- if !IsValid(self) then return end
		if self.EmplacementType == "MG" and not self.OnlyShootSound then
			self.sounds.shoot:Stop()
			if self.PlayStopSound and self.sounds.stop then
				self.sounds.stop:Stop()
				self.sounds.stop:Play()
				self.PlayStopSound = false
			end
		end
		
		if self.PlayStopSound and self.sounds.stop then
			self.sounds.stop:Stop()
			self.sounds.stop:Play()
			self.PlayStopSound = false
		end
		
		if self.sounds.empty and (IsValid(ply) and IsShooting) and !IsReloading and ammo <= 0 then
			self.sounds.empty:Stop()
			self.sounds.empty:Play()
		end
	-- end)
end

function ENT:ReloadSounds()
	if self.sounds then
		for k,v in pairs(self.sounds) do
			v:Stop()
			v = nil
		end
	end
	self.sounds = {}
	if self.ShootSound then
		self.sounds["shoot"] = CreateSound(self,self.ShootSound)
		self.sounds.shoot:SetSoundLevel((self.EmplacementType == "Cannon" and !self.IsRocketLauncher) and 0 or 160)
		self.sounds.shoot:ChangeVolume(1)
	end
	if self.StopShootSound then
		self.sounds["stop"] = CreateSound(self,self.StopShootSound)
		self.sounds.stop:SetSoundLevel(140)
		self.sounds.stop:ChangeVolume(1)
	end
end



-- HUD / View



function ENT:UpdateViewMode(ply)
	local vm = self:GetViewMode() + 1
	vm = vm > self.MaxViewModes and 0 or vm
	
	self:SetViewMode(vm)
	
	net.Start("gred_net_emp_viewmode")
		net.WriteInt(vm,7) -- FIXME : stupid useless networking
	net.SendToServer()
	
end

function ENT:HUDPaint(ply,viewmode,scrW,scrH)
	
end

local function DrawRect(x,y,w,h,b,fc,bc,center)
	x = center and x - (w+b) or x
	-- y = y - (h+b)
	surface.SetDrawColor(fc.r,fc.g,fc.b,fc.a)
	surface.DrawRect(x,y,w+b,h+b)
	
	surface.SetDrawColor(bc.r,bc.g,bc.b,bc.a)
	surface.DrawRect(x + b,y + b,w - b,h - b)
end

function ENT:PaintHUD(ply,ViewMode)
	local viewmode = ViewMode - self.OldMaxViewModes
	
	if self.FireMissions and self.FireMissions[viewmode] then
		if not self.CustomEyeTrace then return end
		LANGUAGE = gred.CVars.gred_cl_lang:GetString() or "en"
		
		if not LANGUAGE then return end
		
		local ScrW,ScrH = ScrW(),ScrH()
		
		local IsOldFireMission = gred.CVars.gred_sv_firemissiontype:GetInt() == 0
		
		if IsOldFireMission then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(surface.GetTextureID("gredwitch/overlay_blank_tanksight"))
			surface.DrawTexturedRect((-(ScrW*1.25-ScrW)*0.5),(-(ScrW*1.25-ScrH)*0.5),ScrW*1.25,ScrW*1.25)
		end
		
		surface.SetFont("GFont_arti")
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(2,ScrH*0.1)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_missionid..self.FireMissions[viewmode][3])
		surface.SetTextPos(2,ScrH*0.14)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_caller..self.FireMissions[viewmode][1]:GetName())
		surface.SetTextPos(2,ScrH*0.18)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_timeleft..math.Round((self.FireMissions[viewmode][4] + gred.CVars.gred_sv_emplacement_artillery_time:GetFloat()) - CurTime()).."s")
		surface.SetTextPos(2,ScrH*0.22)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_requesttype..gred.Lang[LANGUAGE].EmplacementBinoculars["emplacement_requesttype_"..self.FireMissions[viewmode][5]])
		
		
		local ang = self:GetAngles()
		local hull = self:GetHull()
		local pos = self:GetPos()
		local mul
		local X,Y
		ang.p = 0
		ang.r = 0
		
		
		if IsOldFireMission then
			mul = (500 / ScrW) * 2
			X,Y = 421*mul,634*mul
			
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(MAT_CARRIAGE)
			surface.DrawTexturedRect(ScrW - X*1.5,ScrH*0.5 - Y,X,Y)
			surface.SetMaterial(MAT_GUN)
			surface.DrawTexturedRectRotated(ScrW - X,ScrH*0.5 - (X - 129*mul),X,1086*mul,hull:WorldToLocalAngles(ang).y)
		else
			DrawRect(0,ScrH*0.05 - 8,ScrW,3,1,COLOR_BLACK,COLOR_WHITE)
			
			DrawRect(0,ScrH*0.05 - 8,ScrW,3,1,COLOR_BLACK,COLOR_WHITE)
			DrawRect(ScrW*0.5,ScrH*0.035,ScrW*0.005,ScrH*0.02,2,COLOR_BLACK,COLOR_WHITE,true)
			
			local scr = self.CustomEyeTrace.HitPos:ToScreen()
			DrawRect(scr.x,ScrH*0.01,ScrW*0.01,ScrH*0.07,2,COLOR_BLACK,COLOR_ORANGE,true)
			
			scr = (pos + ang:Forward() * 10000):ToScreen()
			DrawRect(scr.x,ScrH*0.01,ScrW*0.01,ScrH*0.07,2,COLOR_BLACK,COLOR_GREEN,true)
		end
		
		
		local mintraverse = hull:LocalToWorldAngles(self.MinRotation)
		mintraverse.p = 0
		mintraverse.r = 0
		
		local maxtraverse = hull:LocalToWorldAngles(self.MaxRotation)
		maxtraverse.p = 0
		maxtraverse.r = 0
		
		
		if self.MinRotation.y > -180 and self.MaxRotation.y < 180 then
			if not IsOldFireMission then
				scr = (pos + maxtraverse:Forward() * 10000):ToScreen()
				DrawRect(scr.x,ScrH*0.01,ScrW*0.01,ScrH*0.07,2,COLOR_BLACK,COLOR_RED,true)
				
				scr = (pos + mintraverse:Forward() * 10000):ToScreen()
				DrawRect(scr.x,ScrH*0.01,ScrW*0.01,ScrH*0.07,2,COLOR_BLACK,COLOR_RED,true)
			else
				surface.SetDrawColor(255,0,0,255)
				
				local StartX,StartY,Length = ScrW - X,ScrH*0.5 - Y*0.45,100 * 3
				
				surface.DrawLine(StartX,StartY,StartX + math.Clamp(math.cos(math.rad(self.MinRotation.y + 90)),-1,1) * Length,StartY + math.Clamp(math.sin(math.rad(self.MinRotation.y - 90)),-1,1) * Length)
				surface.DrawLine(StartX,StartY,StartX + math.Clamp(math.cos(math.rad(self.MinRotation.y - 90)),-1,1) * Length,StartY + math.Clamp(math.sin(math.rad(self.MinRotation.y - 90)),-1,1) * Length)
				
				surface.SetDrawColor(COLOR_ORANGE.r,COLOR_ORANGE.g,COLOR_ORANGE.b,COLOR_ORANGE.a)
				
				local tang = (self.CustomEyeTrace.StartPos - pos):Angle()
				
				surface.DrawLine(StartX,StartY,StartX + math.Clamp(math.cos(math.rad(tang.y - 90)),-1,1) * Length,StartY + math.Clamp(math.sin(math.rad(tang.y - 90)),-1,1) * Length)
			end
		end
	else
		return self:HUDPaint(ply,ViewMode)
	end
end


function ENT:View(ply,pos,angles,fov)
	if self:IsPairable() then
		local viewmode = self:GetViewMode() - self.OldMaxViewModes
		
		if self.FireMissions and self.FireMissions[viewmode] then
			if gred.CVars.gred_sv_firemissiontype:GetInt() == 0 then
				local ct = CurTime()
				local view = {}
				local ang = self:GetAngles()
				local vec
				
				if self.LastShoot then
					local LastShoot = self.LastShoot + 1
					if LastShoot > ct then
						local dif = (LastShoot - ct) * 10
						vec = Vector(math.Rand(-dif,dif),math.Rand(-dif,dif),math.Rand(-dif,dif))
					else
						self.LastShoot = nil
					end
				end
				
				ang:RotateAroundAxis(ang:Right(),-180)
				angles.p = math.Clamp(angles.p,50,90)
				angles.y = self.Seatable and angles.y - ang.y or angles.y
				angles.r = 0
				view.angles = angles
				view.origin = self.FireMissions[viewmode][2] + Vector(0,0,2000)
				view.origin = vec and view.origin + vec or view.origin
				view.drawviewer = true
				
				local ang = Angle() + angles
				ang.p = ang.p + 180
				
				self.CustomEyeTraceRemoved = false
				self.CustomEyeTrace = util.QuickTrace(view.origin,view.origin + ang:Forward()*-bigNum)
				
				if self.DelayToNetwork < ct then
					net.Start("gred_net_sendeyetrace")
						net.WriteEntity(self)
						net.WriteVector(self.CustomEyeTrace.HitPos) -- i know it's retarded because it means that if you can run lua you can spawn shells anywhere on the map
					net.SendToServer()
					
					self.DelayToNetwork = ct + 0.1
				end
				
				return view
			else
				local ct = CurTime()
				local vec = self.FireMissions[viewmode][2] + Vector(0,0,2000)
				
				self.CustomEyeTraceRemoved = false
				self.CustomEyeTrace = util.QuickTrace(vec,vec + vector_down*bigNum)
				
				if self.DelayToNetwork < ct then
					net.Start("gred_net_sendeyetrace")
						net.WriteEntity(self)
						net.WriteVector(self.CustomEyeTrace.HitPos)
					net.SendToServer()
					
					self.DelayToNetwork = ct + 0.1
				end
				
			end
		else
			if !self.CustomEyeTraceRemoved then
			
				self.CustomEyeTrace = nil
				
				net.Start("gred_net_removeeyetrace")
					net.WriteEntity(self)
				net.SendToServer()
			end
			
			self.CustomEyeTraceRemoved = true
			
			return self:ViewCalc(ply,pos,angles,fov)
		end
	else
		return self:ViewCalc(ply,pos,angles,fov)
	end
end

function ENT:ViewCalc(ply,pos,angles,fov)
end



function ENT:OnRemove()
	for k,v in pairs(self.sounds) do
		v:Stop()
		v = nil
	end
end

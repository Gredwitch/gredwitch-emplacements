include("shared.lua")

local reachSky = Vector(0,0,9999999999)
local Z_CANNON = Vector(0,0,10)
local vector_zero = vector_zero
local soundSpeed = 18005.25*18005.25 -- 343m/s
local bigNum = 99999999999

function ENT:Initialize()
	self:ReloadSounds()
	self:InitAttachmentsCL()
	self:OnInitializeCL()
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
		self.sounds.shoot:SetSoundLevel(140)
		-- self.sounds.shoot:ChangeVolume(1)
	end
	if self.StopShootSound then
		self.sounds["stop"] = CreateSound(self,self.StopShootSound)
		self.sounds.stop:SetSoundLevel(140)
		-- self.sounds.stop:ChangeVolume(1)
	end
end

function ENT:CheckExtractor()
	local m = self:GetCurrentExtractor()
	if m <= 0 or m > table.Count(self.TurretEjects) then
		self:SetCurrentExtractor(1)
	end
end

function ENT:Think()
	if not self.Initialized then self:Initialize() return end
	
	if not self.Entities[1] then
		local tableinsert = table.insert
		tableinsert(self.Entities,self)
		tableinsert(self.Entities,self:GetHull())
		if IsValid(self:GetYaw()) then tableinsert(self.Entities,self:GetYaw()) end
	end
	
	local ply = self:GetShooter()
	local ct = CurTime()
	
	if IsValid(ply) then
		ply.Gred_Emp_Ent = self
		if ply:KeyDown(IN_ZOOM) then
			if self:GetNextSwitchViewMode() <= ct then
				self:UpdateViewMode()
				self:SetNextSwitchViewMode(ct + 0.3)
			end
		end
		local ammo = self:GetAmmo()
		local IsShooting = self:GetIsShooting()
		if (!self.OnlyShootSound and self.EmplacementType == "MG") and self:GetIsAttacking() and (ammo > 0 or self.Ammo < 0) and !self:GetIsReloading() then
			if self.sounds.stop then self.sounds.stop:Stop() end
			self.sounds.shoot:Play()
		else
			if not (self.EmplacementType != "MG" or self.OnlyShootSound) then
				self:StopSoundStuff(ply,ammo,self:GetIsReloading(),IsShooting)
			end
		end
	else
		self:SetViewMode(0)
		ply.Gred_Emp_Ent = nil
		self:StopSoundStuff(ply,ammo,self:GetIsReloading(),IsShooting)
	end
	self:GetPrevShooter().Gred_Emp_Ent = nil
	
	if self.FireMissions then
		self.MaxViewModes = table.Count(self.FireMissions) + (self.EmplacementType == "Cannon" and 1 or 0)
	end
	
	self:OnThinkCL(ct,ply)
end

function ENT:OnShoot()
	self.PlayStopSound = true
	if (self.EmplacementType != "MG" or self.OnlyShootSound) then
		self.sounds.shoot:Stop()
		self.sounds.shoot:Play()
	end
	
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
end

function ENT:OnThinkCL(ct,ply)

end

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

function ENT:OnRemove()
	for k,v in pairs(self.sounds) do
		v:Stop()
		v = nil
	end
end

function ENT:UpdateViewMode()
	self:SetViewMode(self:GetViewMode()+1)
	local vm = self:GetViewMode()
	if vm > self.MaxViewModes then
		net.Start("gred_net_emp_viewmode")
			net.WriteEntity(self)
			net.WriteInt(0,8)
		net.SendToServer()
		self:SetViewMode(0)
	else
		net.Start("gred_net_emp_viewmode")
			net.WriteEntity(self)
			net.WriteInt(vm,8)
		net.SendToServer()
	end
end

function ENT:HUDPaint(ply,viewmode,scrW,scrH)
	
end

function ENT:PaintHUD(ply,ViewMode)
	local viewmode = ViewMode - self.OldMaxViewModes
	
	if self.FireMissions and self.FireMissions[viewmode] then
		LANGUAGE = GetConVar("gred_cl_lang"):GetString() or "en"
		if not LANGUAGE then return end
		local ScrW,ScrH = ScrW(),ScrH()
		
		
		surface.SetFont("GFont_arti")
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(ScrW*0.01,ScrH*0.01)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_missionid..self.FireMissions[viewmode][3])
		surface.SetTextPos(ScrW*0.01,ScrH*0.07)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_caller..self.FireMissions[viewmode][1]:GetName())
		surface.SetTextPos(ScrW*0.01,ScrH*0.14)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_timeleft..math.Round((self.FireMissions[viewmode][4] + gred.CVars.gred_sv_emplacement_artillery_time:GetFloat()) - CurTime()).."s")
	else
		return self:HUDPaint(ply,ViewMode)
	end
end

function ENT:View(ply,pos,angles,fov)
	if (self.IsHowitzer or self.EmplacementType == "Mortar" or (self.EmplacementType == "Cannon" and gred.CVars.gred_sv_enable_cannon_artillery:GetBool())) then
		local viewmode = self:GetViewMode() - self.OldMaxViewModes
		if self.FireMissions and self.FireMissions[viewmode] then
			local ct = CurTime()
			local view = {}
			local ang = self:GetAngles()
			
			ang:RotateAroundAxis(ang:Right(),-180)
			angles = self.Seatable and angles - ang or angles
			angles.p = math.Clamp(angles.p,50,90)
			angles.r = 0
			view.angles = angles
			view.origin = self.FireMissions[viewmode][2] + Vector(0,0,2000)
			view.drawviewer = true
			
			local ang = Angle() + angles
			ang.p = ang.p + 180
			
			self.CustomEyeTraceRemoved = false
			self.CustomEyeTrace = util.QuickTrace(view.origin,view.origin + ang:Forward()*-bigNum)
			
			if self.DelayToNetwork < ct then
				net.Start("gred_net_sendeyetrace")
					net.WriteEntity(self)
					net.WriteVector(self.CustomEyeTrace.HitPos)
				net.SendToServer()
				
				self.DelayToNetwork = ct + 0.1
			end
			
			return view
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
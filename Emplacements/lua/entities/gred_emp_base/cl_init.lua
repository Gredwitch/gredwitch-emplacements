include("shared.lua")

local reachSky = Vector(0,0,9999999999)

function ENT:Initialize()
	self:ReloadSounds()
	self:SetNextShotCL(0)
	self:InitAttachmentsCL()
	
	self.Initialized = true
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
		self.sounds.shoot:SetSoundLevel(100)
		-- self.sounds.shoot:ChangeVolume(1)
	end
	if self.StopShootSound then
		self.sounds["stop"] = CreateSound(self,self.StopShootSound)
		self.sounds.stop:SetSoundLevel(100)
		-- self.sounds.stop:ChangeVolume(1)
	end
end

function ENT:CheckExtractor()
	local m = self:GetCurrentExtractor()
	if m <= 0 or m > table.Count(self.TurretEjects) then
		self:SetCurrentExtractor(1)
	end
end

function ENT:CalcMortarCanShootCL(ply)
	local tr = util.QuickTrace(self:LocalToWorld(self.TurretMuzzles[1].Pos),reachSky,self.Entities)
	local botmode = self:GetBotMode()
	local canShoot
	if botmode then
		canShoot = IsValid(self:GetTarget())
	else
		canShoot = true
	end
	if tr.Hit and !tr.HitSky then
		canShoot = false
		noHitSky = true
	else
		noHitSky = false
		if canShoot then
			local shootPos
			if botmode then
				shootPos = self:GetTarget():GetPos()
			else
				shootPos = util.TraceLine(util.GetPlayerTrace(ply)).HitPos
			end
			local ang = self:GetAngles() - self:GetHull():GetAngles()
			ang:Normalize()
			canShoot = not (ang.y > self.MaxRotation.y or ang.y < -self.MaxRotation.y)
			
			if !ang then
				local tr = util.QuickTrace(shootPos,shootPos + reachSky,self.Entities)
				if tr.Hit and !tr.HitSky and !tr.Entity == self:GetTarget() then
					canShoot = false
				end
			end
		end
	end
	return canShoot
end

function ENT:Think()
	if not self.Initialized then self:Initialize() return end
	
	local ply = self:GetShooter()
	local ct = CurTime() -- Tickrate
	for k,v in pairs(self.sounds) do
		v:ChangeVolume(tonumber(GetConVar("gred_cl_emp_volume"):GetFloat()))
	end
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
		local IsReloading = self:GetIsReloading()
		if IsShooting then
			if self:CanShoot(ammo,ct,ply) then
				if self.EmplacementType != "MG" or self.OnlyShootSound then
					self:SetNextShotCL(ct + self.ShotInterval)
					self.sounds.shoot:Stop()
					self.sounds.shoot:Play()
				else
					self.sounds.shoot:Play()
					if self.sounds.stop then
						self.sounds.stop:Stop()
						self.PlayStopSound = true
					end
				end
			else
				if self.EmplacementType == "MG" and not self.OnlyShootSound then
					self.sounds.shoot:Stop()
					self:StopSoundStuff(ply,ammo,IsReloading,IsShooting)
				end
			end
		else
			if self.EmplacementType == "MG" and not self.OnlyShootSound then
				self.sounds.shoot:Stop()
				self:StopSoundStuff(ply,ammo,IsReloading,IsShooting)
			end
		end
	else
		self:SetViewMode(0)
		ply.Gred_Emp_Ent = nil
		self:StopSoundStuff(ply,ammo,IsReloading,IsShooting)
		if self.EmplacementType == "MG" and not self.OnlyShootSound then
			self.sounds.shoot:Stop()
			if self.PlayStopSound and self.sounds.stop then
				self.sounds.stop:Stop()
				self.sounds.stop:Play()
				self.PlayStopSound = false
			end
		end
	end
	self:GetPrevShooter().Gred_Emp_Ent = nil
	
	self:OnThinkCL(ct,ply)
end

function ENT:OnThinkCL(ct,ply)

end

function ENT:StopSoundStuff(ply,ammo,IsReloading,IsShooting)
	if self.PlayStopSound and self.sounds.stop then
		self.sounds.stop:Stop()
		self.sounds.stop:Play()
		self.PlayStopSound = false
	end
	if self.sounds.empty and (IsValid(ply) and IsShooting) and !IsReloading and ammo <= 0 then
		self.sounds.empty:Stop()
		self.sounds.empty:Play()
	end
end

function ENT:OnRemove()
	for k,v in pairs(self.sounds) do
		v:Stop()
		v = nil
	end
end

function ENT:UpdateViewMode()
	self:SetViewMode(self:GetViewMode()+1)
	if self:GetViewMode() > self.MaxViewModes then
		self:SetViewMode(0)
	end
end
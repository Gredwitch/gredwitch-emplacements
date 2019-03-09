AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M60"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.092
ENT.TracerColor			= "Red"

ENT.ShootSound			= "gred_emp/m60/shoot.wav"
ENT.StopShootSound		= "gred_emp/m60/stop.wav"
ENT.ReloadSound			= "gred_emp/m60/m60_reload.wav"
ENT.ReloadEndSound		= "gred_emp/m60/m60_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/m60/m60_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/m60/m60_gun.mdl"

ENT.Ammo				= 300
ENT.ReloadTime			= 2.77
ENT.CycleRate			= 0.4

------------------------

ENT.TurretPos			= Vector(0,0,7)
ENT.SightPos			= Vector(0.41,-31,5)
ENT.MaxRotation			= Angle(30,45)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.9, function()
		if !IsValid(self) then return end
		self:SetBodygroup(1,1) -- Ammo bag hidden
		self:SetBodygroup(2,1)
		
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m60/m60_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + Angle(0,-90,0))
		prop:Spawn()
		prop:Activate()
		
		self.MagIn = false
		
		if self:GetAmmo() >= 0 then prop:SetBodygroup(1,1) end
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self:SetBodygroup(2,0)
			self:SetBodygroup(1,0)
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER then
		if !self:GetIsReloading() or self.MagIn then 
			self:SetBodygroup(1,0)
			if self:GetAmmo() <= 0 then
				self:SetBodygroup(2,1)
			else
				self:SetBodygroup(2,0)
			end
		end
	end
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_m60" then
			local ent = ply.Gred_Emp_Ent
			if ent:GetShooter() != ply then return end
			if IsValid(ent) then
				if ent:GetViewMode() == 1 then
					local ang = ent:GetAngles()
					local view = {}
					view.origin = ent:LocalToWorld(ent.SightPos)
					view.angles = Angle(-ang.r,ang.y+90,ang.p)
					view.fov = 35
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_m60_view", CalcView)
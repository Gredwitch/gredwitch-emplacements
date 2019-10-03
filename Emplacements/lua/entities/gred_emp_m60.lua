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

ENT.Recoil				= 0.8
ENT.HullFly				= true
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
 	ent.Owner = ply
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
		
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m60/m60_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-10,-20,0)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
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
	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		self:SetBodygroup(1,0)
		if self:GetAmmo() <= 0 then
			self:SetBodygroup(2,1)
		else
			self:SetBodygroup(2,0)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		angles = ply:EyeAngles()
		angles.p = angles.p - (self:GetRecoil())*0.8
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
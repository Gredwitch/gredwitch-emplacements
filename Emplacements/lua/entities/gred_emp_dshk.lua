AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]DShK"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_12mm"
ENT.ShotInterval		= 0.1
ENT.TracerColor			= "Green"

ENT.ShootSound			= "gred_emp/dshk/shoot.wav"
ENT.StopShootSound		= "gred_emp/dshk/stop.wav"

ENT.Recoil				= 1.5
ENT.RecoilRate			= 0.3
ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/dhsk/dhsk_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/dhsk/dhsk_gun.mdl"
ENT.ReloadSound			= "gred_emp/dshk/dhsk_reload.wav"
ENT.ReloadEndSound		= "gred_emp/dshk/dhsk_reloadend.wav"

ENT.Ammo				= 50
ENT.ReloadTime			= 1.73 - 0.7

------------------------

ENT.TurretPos			= Vector(0,0,43)
ENT.SightPos			= Vector(0.03,-35,16.25)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.7, function()
		if !IsValid(self) then return end
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/dhsk/dhsk_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-10,-4,15)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
					if IsValid(prop) then prop:Remove() end 
			end)
		end
		
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		self:SetBodygroup(2,1)
		self:SetBodygroup(3,1)
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.2,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(3,0)
			self.MagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(1.2,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		if self:GetAmmo() <= 0 then 
			self:SetBodygroup(3,1)
		else
			self:SetBodygroup(3,0)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = Angle(-ang.r,ang.y+90,ang.p)
		view.fov = 35
		view.drawviewer = false

		return view
	end
end

AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"
ENT.AltClassName		= "gred_emp_m2"
ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M2 Browning (alt tripod)"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_12mm"
ENT.ShotInterval		= 0.12
ENT.TracerColor			= "Red"

ENT.ShootSound			= "gred_emp/m2/shoot.wav"
ENT.StopShootSound		= "gred_emp/m2/stop.wav"
ENT.ReloadSound			= "gred_emp/m2/m2_reload.wav"
ENT.ReloadEndSound		= "gred_emp/m2/m2_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/m2browning/m2_tripod_low.mdl"
ENT.TurretModel			= "models/gredwitch/m2browning/m2_gun.mdl"

ENT.Ammo				= 105
ENT.ReloadTime			= 1.5
ENT.CycleRate			= 0.6

------------------------

ENT.TurretPos			= Vector(0,0,-11)
if game.SinglePlayer() then
	ENT.SightPos		= Vector(1.86,-25,5.5)
else
	ENT.SightPos		= Vector(1.92,-25,5.5)
end
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 27
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
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
	
	timer.Simple(0.6, function() 
		if !IsValid(self) then return end
		
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m2browning/m2_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-15,3,5)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.7,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self:SetBodygroup(2,0)
			self.MagIn = true
		end)
		
		timer.Simple(self:SequenceDuration(),function() 
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
		
	else
		timer.Simple(1.4,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
		end)
		
		timer.Simple(1.7,function() 
			if !IsValid(self) then return end
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		if self:GetAmmo() <= 0 then 
			self:SetBodygroup(2,1)
		else
			self:SetBodygroup(2,0)
		end
		self:SetBodygroup(1,0)
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		local a = game.SinglePlayer() and -0.1 or 0
		view.angles = Angle(-ang.r,ang.y+90 + a,ang.p)
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
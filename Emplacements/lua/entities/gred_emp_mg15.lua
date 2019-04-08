AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 15"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.057
ENT.TracerColor			= "Green"

ENT.ShootSound			= "gred_emp/mg15/shoot.wav"
ENT.StopShootSound		= "gred_emp/mg15/stop.wav"
ENT.ReloadSound			= "gred_emp/mg15/mg15_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg15/mg15_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/mg15/mg15_gun.mdl"

ENT.Ammo        		= 75
ENT.ReloadTime			= 2.4 - 0.8

ENT.TurretPos			= Vector(0,0,40)
ENT.ExtractAngle		= Angle(85,0,0)
ENT.SightPos			= Vector(-0.17,-25,8.76)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

local a = Angle(0,90,0)

function ENT:Reload(ply)

	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.6, function() 
		if !IsValid(self) then return end
		
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/mg15/mg15_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-15,0,10)))
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
		
		self:SetBodygroup(2,1)
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self:SetBodygroup(2,0)
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(1,function()
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
		end)
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then self:SetBodygroup(2,0) end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = Angle(-ang.r,ang.y+89.97,ang.p)
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Bren LMG"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.12
ENT.TracerColor			= "Red"

ENT.HullFly				= true
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/bren/shoot.wav"
ENT.ReloadSound			= "gred_emp/bren/bren_reload.wav"
ENT.ReloadEndSound		= "gred_emp/bren/bren_reloadend.wav"
ENT.EmplacementType		= "MG"

ENT.HullModel			= "models/gredwitch/bren/bren_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/bren/bren_gun.mdl"

ENT.Ammo				= 30
ENT.ReloadTime			= 1.6
ENT.CycleRate			= 0.6
ENT.ExtractAngle		= Angle(0,0,0)
ENT.MaxRotation			= Angle(30,45)
ENT.MaxViewModes		= 1
ENT.SightPos			= Vector(-0.95,-25,2.8)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(1.15)
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.8, function()
		if !IsValid(self) then return end
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/bren/bren_mag.mdl")
		prop:SetPos(att.Pos + self.TurretPos)
		prop:SetAngles(att.Ang + Angle(0,180,0))
		prop:SetModelScale(1.15)
		prop:Spawn()
		prop:Activate()
		if self:GetAmmo() < 1 then prop:SetBodygroup(1,1) end
		self.MagIn = false
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
	end)
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self:SetBodygroup(2,0)
			self.MagIn = true
			self.NewMagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
			self.NewMagIn = false
		end)
	else
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

if SERVER then
	function ENT:OnTick()
		if self.MagIn then
			self:SetBodygroup(1,0)
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(2,1)
			else
				self:SetBodygroup(2,0)
			end
		else
			self:SetBodygroup(1,1)
			self:SetBodygroup(2,1)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		angles = ply:EyeAngles()
		angles.y = angles.y - 0.25
		angles.p = angles.p - (self:GetRecoil())*0.8
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 40
		view.drawviewer = false

		return view
	end
end
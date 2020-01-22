AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 34"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.067
ENT.TracerColor			= "Green"

ENT.RecoilRate			= 1.3
ENT.RecoilRate			= 0.15
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/mg34/shoot.wav"
ENT.ReloadSound			= "gred_emp/mg34/mg34_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg34/mg34_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/mg34/mg34.mdl"

ENT.Ammo        		= 50
ENT.ReloadTime			= 1.4

------------------------

ENT.TurretPos			= Vector(0,0,43.5)
ENT.SightPos			= Vector(0.65,-15,2.95)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
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
	
	timer.Simple(0.6, function() 
		if !IsValid(self) then return end
		self:SetBodygroup(4,1)
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/mg34/mg34_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:Spawn()
		prop:SetModelScale(1.15)
		prop:Activate()
		self.MagIn = false
		-- if self.CurAmmo <= 0 then prop:SetBodygroup(1,1) end
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		self:SetBodygroup(3,1)
	end)
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.1,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self.NewMagIn = true
			self:SetBodygroup(3,0)
			self:SetBodygroup(4,0)
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self.NewMagIn = false
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(1.1,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

if SERVER then
	function ENT:OnTick()
		if self.MagIn then
			self:SetBodygroup(3,0)
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(4,1)
			else
				self:SetBodygroup(4,0)
			end
		else
			self:SetBodygroup(3,1)
			self:SetBodygroup(4,1)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		angles = ply:EyeAngles()
		angles.p = angles.p - (self:GetRecoil())*0.5
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 60
		view.drawviewer = false

		return view
	end
end
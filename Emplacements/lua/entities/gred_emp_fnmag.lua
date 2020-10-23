	AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]FN Mag"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.075
ENT.TracerColor			= "Red"

ENT.Recoil				= 0.8
ENT.RecoilRate			= 0.1
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/fnmag/shoot.wav"
ENT.ReloadSound			= "gred_emp/fnmag/fnmag_reload.wav"
ENT.ReloadEndSound		= "gred_emp/fnmag/fnmag_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/fnmag/fnmag_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/fnmag/fnmag_gun.mdl"
ENT.Ammo				= 50
ENT.ReloadTime			= 3.57

------------------------

ENT.ExtractAngle		= Angle(-90,0,0)
ENT.SightPos			= Vector(-25,0.01,5.15)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(2,math.random(0,1))
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.7, function() 
		if !IsValid(self) then return end
		self:SetBodygroup(2,2) -- Ammo bag hidden
		self:SetBodygroup(7,2)
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/fnmag/fnmag_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
	end)
	
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(7,0)
			self.MagIn = true
			self.NewMagIn = true
		end)
		timer.Simple(1.9,function() if IsValid(self) then self:SetBodygroup(7,0) end end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
			self.NewMagIn = false
		end)
	else
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

if SERVER then
	function ENT:OnTick()
		self:SetSkin(0)
		self:SetBodygroup(1,0) -- Gun
		self:SetBodygroup(5,0) -- Lid
		self:SetBodygroup(6,0) -- Mag Base
		
		if self.MagIn then
			self:SetBodygroup(2,0)
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(7,2)
			else
				self:SetBodygroup(7,0)
			end
		else
			self:SetBodygroup(2,2)
			self:SetBodygroup(7,2)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = ply:EyeAngles()
		view.angles.p = view.angles.p - (self:GetRecoil())*0.2
		view.angles.r = self:GetAngles().r
		view.fov = 40
		view.drawviewer = false

		return view
	end
end
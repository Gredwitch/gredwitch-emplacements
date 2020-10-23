AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M240B"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.092
ENT.TracerColor			= "Red"

ENT.Recoil				= 0.8
ENT.RecoilRate			= 0.1
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/m240b/shoot.wav"
ENT.ReloadSound			= "gred_emp/m240b/m240_reload.wav"
ENT.ReloadEndSound		= "gred_emp/m240b/m240_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/fnmag/fnmag_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/fnmag/fnmag_gun.mdl"

ENT.Ammo				= 200
ENT.ReloadTime			= 2.57

------------------------

ENT.ExtractAngle		= Angle(-90,0,0)
ENT.TurretPos			= Vector(0,0,-2)
ENT.SightPos			= Vector(-25,0.01,5.15)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
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
	
	timer.Simple(0.55, function() 
		if !IsValid(self) then return end
		self:SetBodygroup(2,2) -- Ammo box hidden
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/fnmag/m240b_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		prop:Spawn()
		prop:Activate()
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
	end)
	
	timer.Simple(0.6,function() if IsValid(self) then self.MagIn = false self:SetBodygroup(7,2) end end)
	timer.Simple(1.9,function() if IsValid(self) then self:SetBodygroup(7,0) end end)
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self.NewMagIn = true
			self:SetBodygroup(2,1)
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self.NewMagIn = false
			self:SetCurrentTracer(0)
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
		self:SetSkin(1)
		self:SetBodygroup(1,1) -- Gun
		self:SetBodygroup(5,1) -- Lid
		self:SetBodygroup(6,1) -- Mag Base
		
		if self.MagIn then
			self:SetBodygroup(2,1)
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(7,2)
			else
				self:SetBodygroup(7,1)
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
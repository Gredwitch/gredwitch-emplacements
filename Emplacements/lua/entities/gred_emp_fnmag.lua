AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]FN Mag"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.075
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/fnmag/fnamg_shoot.wav"
ENT.StopSoundName		= "gred_emp/fnmag/fnmag_stop.wav"
ENT.SoundName			= "shootFNMAG"
ENT.HasStopSound		= true

ENT.BaseModel			= "models/gredwitch/fnmag/fnmag_tripod.mdl"
ENT.Model				= "models/gredwitch/fnmag/fnmag_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 7
ENT.CanLookArround		= true
ENT.EndReloadSnd		= "FNMAGReloadEnd"
ENT.Ammo				= 50
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false
ENT.ReloadTime			= 4.07 - 1.5

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(2,math.random(0,1))
	return ent
end


local created = false

sound.Add( {
	name = "FNMAGReload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/fnmag/fnmag_reload.wav"
} )
sound.Add( {
	name = ENT.EndReloadSnd,
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/fnmag/fnmag_reloadend.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("FNMAGReload")
	timer.Simple(0.7, function() 
		if !IsValid(self) then return end
		if created then return end
		self:SetBodygroup(2,2) -- Ammo bag hidden
		self:SetBodygroup(7,2)
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/fnmag/fnmag_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + Angle(0,90,0))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		if self.CurAmmo <= 0 then prop:SetBodygroup(1,1) end
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		created = true
	end)
	created = false
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(7,0)
			self.MagIn = true
		end)
		timer.Simple(1.9,function() if IsValid(self) then self:SetBodygroup(7,0) end end)
		timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
			self.CurAmmo = self.Ammo
			self.tracer = 0
			self.IsReloading = false
		end)
	else
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self:StopSound("FNMAGReload")
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:AddOnThink()
	if SERVER then
		self:SetSkin(0)
		self:SetBodygroup(1,0) -- Gun
		self:SetBodygroup(5,0) -- Lid
		self:SetBodygroup(6,0) -- Mag Base
		if self.MagIn or !self.IsReloading then
			self:SetBodygroup(2,0) -- Ammo bag shown
			if self.CurAmmo <= 0 then
				self:SetBodygroup(7,2) -- Ammo belt hidden
			elseif self.CurAmmo >= 1 then
				self:SetBodygroup(7,0) -- FN MAG Ammo belt
			end
		end
	end
end
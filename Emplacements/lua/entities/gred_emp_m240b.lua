AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M240B"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.092
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/m240b/shoot.wav"
ENT.StopSoundName		= "gred_emp/m240b/stop.wav"
ENT.SoundName			= "shootM240B"
ENT.HasStopSound		= true

ENT.BaseModel			= "models/gredwitch/fnmag/fnmag_tripod.mdl"
ENT.Model				= "models/gredwitch/fnmag/fnmag_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 7
ENT.CanLookArround		= true

ENT.Ammo				= 200
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false
ENT.EndReloadSnd		= "M240ReloadEnd"

ENT.ReloadTime			= 4.07 - 1.5

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end


local created = false

sound.Add( {
	name = "M240Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/m240b/m240_reload.wav"
} )
sound.Add( {
	name = ENT.EndReloadSnd,
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/m240b/m240_reloadend.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("M240Reload")
	timer.Simple(0.7, function() 
		if !IsValid(self) then return end
		if created then return end
		self:SetBodygroup(2,2) -- Ammo box hidden
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/fnmag/m240b_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + Angle(0,90,0))
		prop:Spawn()
		prop:Activate()
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
	timer.Simple(0.6,function() if IsValid(self) then self.MagIn = false self:SetBodygroup(7,2) end end)
	timer.Simple(1.9,function() if IsValid(self) then self:SetBodygroup(7,0) end end)
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self:SetBodygroup(2,1)
		end)
		timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
			self.CurAmmo = self.Ammo
			self.tracer = 0
			self.IsReloading = false
		end)
	else
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self:StopSound("M240Reload")
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:AddOnThink()
	if SERVER then
		self:SetSkin(1)
		self:SetBodygroup(1,1) -- Gun
		self:SetBodygroup(5,1) -- Lid
		self:SetBodygroup(6,1) -- Mag Base
		if !self.IsReloading or self.MagIn then
			self:SetBodygroup(2,1) -- Ammo box shown
			if self.CurAmmo <= 0 then
				self:SetBodygroup(7,2) -- Ammo belt hidden
			else
				self:SetBodygroup(7,0) -- M240B Ammo belt
			end
		end
	end
end
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M2 Browning"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_12mm"
ENT.ShotInterval		= 0.12
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/m2/shoot.wav"
ENT.StopSoundName		= "gred_emp/m2/stop.wav"
ENT.HasStopSound		= true
ENT.SoundName			= "shootM2"

ENT.BaseModel			= "models/gredwitch/m2browning/m2_tripod.mdl"
ENT.Model				= "models/gredwitch/m2browning/m2_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 50
ENT.TurretForward		= -2
ENT.CanLookArround		= true

ENT.Ammo				= 105
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false
ENT.ReloadTime			= 2.7 - 1.2
ENT.CycleRate			= 0.6
ENT.EndReloadSnd		= "M2ReloadEnd"

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 27
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

local created = false

sound.Add( {
	name = "M2Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/m2/m2_reload.wav"
} )
sound.Add( {
	name = ENT.EndReloadSnd,
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/m2/m2_reloadend.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("M2Reload")
	timer.Simple(0.6, function() 
		if !IsValid(self) then return end
		if created then return end
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m2browning/m2_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang-Angle(0,90,0))
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
		timer.Simple(1.7,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self:SetBodygroup(2,0)
			self.MagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
			self.CurAmmo = self.Ammo
			self.IsReloading = false
			self.tracer = 0
		end)
	else
		timer.Simple(1.4,function() 
			if !IsValid(self) then return end
			self:StopSound("M2Reload")
		end)
		timer.Simple(1.7,function() 
			if !IsValid(self) then return end
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:AddOnThink()
	if SERVER and (!self.IsReloading or self.MagIn) then
		if self.CurAmmo <= 0 then 
			self:SetBodygroup(2,1)
		else
			self:SetBodygroup(2,0)
		end
		self:SetBodygroup(1,0)
	end
end
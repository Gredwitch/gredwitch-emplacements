AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]DHsK"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_12mm"
ENT.ShotInterval		= 0.1
ENT.Color				= "Green"

ENT.SoundName			= "shootDhSK"
ENT.ShootSound			= "gred_emp/dhsk/shoot.wav"

ENT.StopSoundName		= "gred_emp/dhsk/stop.wav"
ENT.HasStopSound		= true
ENT.StopSound			= "stopDhSK"

ENT.BaseModel			= "models/gredwitch/dhsk/dhsk_tripod.mdl"
ENT.Model				= "models/gredwitch/dhsk/dhsk_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 42

ENT.Ammo				= 50
ENT.CurAmmo				= ENT.Ammo
ENT.CanLookArround		= true
ENT.HasNoAmmo			= false
ENT.ReloadTime			= 2.43 - 0.7
ENT.EndReloadSnd		= "DHsKReloadEnd"

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	return ent
end

local created = false

sound.Add( {
	name = "DHsKReload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/dhsk/dhsk_reload.wav"
} )
sound.Add( {
	name = ENT.EndReloadSnd,
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/dhsk/dhsk_reloadend.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("DHsKReload")
	timer.Simple(0.7, function()
		if !IsValid(self) then return end
		if created then return end
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/dhsk/dhsk_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang - Angle(0,90,0))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
					if IsValid(prop) then prop:Remove() end 
			end)
		end
		created = true
		if self.CurAmmo <= 0 then prop:SetBodygroup(1,1) end
		self:SetBodygroup(2,1)
		self:SetBodygroup(3,1)
	end)
	created = false
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.2,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(3,0)
			self.MagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
			self.CurAmmo = self.Ammo
			self.IsReloading = false
			self.tracer = 0
		end)
	else
		timer.Simple(1.2,function() 
			if !IsValid(self) then return end
			self:StopSound("DHsKReload")
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:AddOnThink()
	if SERVER and (!self.IsReloading or self.MagIn) then
		self:SetBodygroup(2,0)
		if self.CurAmmo <= 0 then 
			self:SetBodygroup(3,1)
		elseif self.CurAmmo > 0 then
			self:SetBodygroup(3,0)
		end
	end
end
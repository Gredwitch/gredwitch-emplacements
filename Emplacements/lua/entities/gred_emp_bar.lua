AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Bar M1918"
ENT.Author				= "Gredwitch"
ENT.NameToPrint			= "Bar M1918"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.AmmoType			= "Slow fire"
ENT.ShotInterval		= 0.16 -- fast = 0.092
ENT.Color				= "Red"
ENT.EjectAngle			= Angle(0,0,0)

ENT.ShootSound			= "gred_emp/bar/shoot_slow.wav"
ENT.StopSoundName		= "gred_emp/bar/stop_slow.wav"
ENT.SoundName			= "shootBar"
ENT.HasStopSound		= true

ENT.BaseModel			= "models/gredwitch/bar/bar_bipod.mdl"
ENT.Model				= "models/gredwitch/bar/bar.mdl"
ENT.TurretHeight		= 1.5
ENT.TurretTurnMax		= 0.7
ENT.CanLookArround		= false

ENT.Ammo				= 20
ENT.MaxUseDistance		= 50
ENT.CurAmmo				= ENT.Ammo
ENT.EndReloadSnd		= "BarReloadEnd"
ENT.HasNoAmmo			= false
ENT.ReloadTime			= 2.9 - 1
ENT.CanSwitchAmmoTypes	= true
ENT.CycleRate			= 0.6


function ENT:SwitchAmmoType(plr)
	local ct = CurTime()
	if self.NextSwitch > ct then return end
	self.sounds.shoot:Stop()
	self.sounds.stop:Stop()
	self.sounds = nil
	if self.AmmoType == "Slow fire" then
		self.AmmoType = "Rapid fire"
		self.ShotInterval = 0.092
		self.ShootSound = "gred_emp/bar/shoot_fast.wav"
		self.StopSoundName = "gred_emp/bar/stop_fast.wav"
	elseif self.AmmoType == "Rapid fire" then
		self.AmmoType = "Slow fire"
		self.ShotInterval = 0.16
		self.ShootSound = "gred_emp/bar/shoot_slow.wav"
		self.StopSoundName = "gred_emp/bar/stop_slow.wav"
	end
	self:AddSounds()
	self.LastShot = ct + .3
	net.Start("gred_net_message_ply")
		net.WriteEntity(plr)
		net.WriteString("["..self.NameToPrint.."] "..self.AmmoType.." mode selected")
	net.Send(plr)
	self.NextSwitch = CurTime()+0.2
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(1.1)
	return ent
end

local created = false

sound.Add( {
	name = "BarReload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/bar/bar_reload.wav"
} )
sound.Add( {
	name = ENT.EndReloadSnd,
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/bar/bar_reloadend.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	if SERVER then self:EmitSound("BarReload") end
	timer.Simple(0.8, function()
		if !IsValid(self) then return end
		if created then return end
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/bar/bar_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + Angle(0,180,0))
		prop:Spawn()
		prop:Activate()
		if self.CurAmmo < 1 then prop:SetBodygroup(1,1) end
		self.MagIn = false
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		created = true
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
	end)
	created = false
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.6,function() 
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
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
			self:StopSound("BarReload")
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:AddOnThink()
	if SERVER then
		if !self.IsReloading or self.MagIn then 
			self:SetBodygroup(1,0)
			if self.CurAmmo <= 0 then
				self:SetBodygroup(2,1)
			elseif self.CurAmmo >= 1 then
				self:SetBodygroup(2,0)
			end
		end
	end
end
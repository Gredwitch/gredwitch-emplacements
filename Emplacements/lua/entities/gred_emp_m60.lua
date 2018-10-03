AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M60"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.092
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/m60/shoot.wav"
ENT.HasStopSound		= true
ENT.SoundName			= "shootM60"
ENT.StopSoundName		= "gred_emp/m60/stop.wav"

ENT.BaseModel			= "models/gredwitch/m60/m60_bipod.mdl"
ENT.Model				= "models/gredwitch/m60/m60_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 7
ENT.TurretTurnMax		= 0.7

ENT.Ammo				= 300
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false

ENT.Recoil				= 2000
ENT.ReloadTime			= 4.07 - 1.3
ENT.CycleRate			= 0.4

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end


local created = false

sound.Add( {
	name = "M60Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/m60/m60_reload.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("M60Reload")
	
	timer.Simple(0.9, function()
		if !IsValid(self) then return end
		if created then return end
		self:SetBodygroup(1,1) -- Ammo bag hidden
		self:SetBodygroup(2,1)
		
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m60/m60_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + Angle(0,-90,0))
		prop:Spawn()
		prop:Activate()
		
		self.MagIn = false
		
		if self.CurAmmo >= 0 then prop:SetBodygroup(1,1) end
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
			self.MagIn = true
			self:SetBodygroup(2,0)
			self:SetBodygroup(1,0)
		end)
		timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
			self.CurAmmo = self.Ammo
			self.tracer = 0
			self.IsReloading = false
		end)
	else
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
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
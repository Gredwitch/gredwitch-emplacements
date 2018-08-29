AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M1919 Browning"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.1
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/m1919/shoot.wav"
ENT.StopSoundName		= "gred_emp/m1919/stop.wav"
ENT.SoundName			= "shot"
ENT.HasStopSound		= true

ENT.BaseModel			= "models/gredwitch/m1919/m1919_bipod.mdl"
ENT.Model				= "models/gredwitch/m1919/m1919_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 0
ENT.TurretTurnMax		= 0.7
ENT.CanLookArround		= false

ENT.Ammo				= 250
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

local created = false

sound.Add( {
	name = "MG42Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/mg42/mg42_reload.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	if SERVER then self:EmitSound("MG42Reload") end
	if self.CurAmmo > 0 then
		timer.Simple(0.6, function()
			if !IsValid(self) then return end
			if created then return end
			local att = self:GetAttachment(self:LookupAttachment("mageject"))
			local prop = ents.Create("prop_physics")
			prop:SetModel("models/gredwitch/m1919/m1919_belt.mdl")
			prop:SetPos(att.Pos)
			prop:SetAngles(att.Ang - Angle(0,90,0))
			prop:Spawn()
			prop:Activate()
			local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
			if t > 0 then
				timer.Simple(t,function()
					if IsValid(prop) then prop:Remove() end 
				end)
			end
			created = true
			self:SetBodygroup(1,1)
		end)
	end
	created = false
	timer.Simple(1.6,function() 
		if !IsValid(self) then return end
		self:SetBodygroup(1,0)
	end)
	timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
		self.CurAmmo = self.Ammo
		self.IsReloading = false
		self.tracer = 0
	end)
end

function ENT:AddOnThink()
	if SERVER then
		if self.CurAmmo <= 0 and not self.IsReloading then 
			self:SetBodygroup(1,1)
		elseif self.CurAmmo > 0 and not self.IsReloading then
			self:SetBodygroup(1,0)
		end
	end
end
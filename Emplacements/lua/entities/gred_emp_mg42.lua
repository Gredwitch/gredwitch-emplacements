AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 42"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.046
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/mg42/shoot.wav"
ENT.SoundName			= "shootMG42"

ENT.BaseModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.Model				= "models/gredwitch/mg42/mg42_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 43.5
ENT.CanLookArround		= true

ENT.Ammo				= 250
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false
ENT.ReloadTime			= 2.4 - 1.2
ENT.CycleRate			= 0.6

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
	self:EmitSound("MG42Reload")
	if self.CurAmmo > 0 then
		timer.Simple(0.6, function()
			if !IsValid(self) then return end
			if created then return end
			local att = self:GetAttachment(self:LookupAttachment("mageject"))
			local prop = ents.Create("prop_physics")
			prop:SetModel("models/gredwitch/mg42/mg42_belt.mdl")
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
			self:SetBodygroup(1,1)
		end)
	end
	created = false
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self:SetBodygroup(1,0)
		end)
		timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
			self.CurAmmo = self.Ammo
			self.IsReloading = false
			self.tracer = 0
		end)
	else
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:AddOnThink()
	if SERVER and (!self.IsReloading or self.MagIn) then
		if self.CurAmmo <= 0 and not self.IsReloading then 
			self:SetBodygroup(1,1)
		elseif self.CurAmmo > 0 and not self.IsReloading then
			self:SetBodygroup(1,0)
		end
	end
end
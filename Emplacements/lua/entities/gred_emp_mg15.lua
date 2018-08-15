AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 15"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.057
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/mg15/shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/mg15/stop.wav"
ENT.SoundName			= "shootMG15"

ENT.BaseModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.Model				= "models/gredwitch/mg15/mg15_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 40
ENT.MaxUseDistance		= 40
ENT.CanLookArround		= true


ENT.Ammo        		= 75
ENT.CurAmmo      		= ENT.Ammo

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
local a = Angle(0,90,0)

sound.Add( {
	name = "MG15Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/mg15/mg15_reload.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("MG15Reload")
	timer.Simple(0.6, function() 
		if !IsValid(self) then return end
		if created then return end
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/mg15/mg15_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + a)
		prop:Spawn()
		prop:Activate()
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		created = true
		self:SetBodygroup(2,1)
	end)
	created = false
	timer.Simple(1.3,function() 
		if !IsValid(self) then return end
		self:SetBodygroup(2,0)
	end)
	timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
		self.CurAmmo = self.Ammo
		self.IsReloading = false
		self.tracer = 0
	end)
end

function ENT:AddOnThink()
	if SERVER and not self.IsReloading then self:SetBodygroup(2,0) end
end
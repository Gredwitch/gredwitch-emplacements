AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M134 Minigun"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.AnimRestartTime		= 0.1
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.015
ENT.Color				= "Red"
ENT.NoRecoil			= true

ENT.ShootSound			= "gred_emp/m134/shoot.wav"
ENT.SoundName			= "shootM134"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/m134/stop.wav"

ENT.BaseModel			= "models/gredwitch/M134/M134_tripod.mdl"
ENT.Model				= "models/gredwitch/M134/M134_gun.mdl"
ENT.HasRotatingBarrel	= true
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 0
ENT.MaxUseDistance		= 100
ENT.CanLookArround		= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
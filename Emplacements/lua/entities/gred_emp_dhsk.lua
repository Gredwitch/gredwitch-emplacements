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

ENT.ShootSound			= "gred_emp/dhsk/shoot.wav"
ENT.StopSoundName		= "gred_emp/dhsk/stop.wav"
ENT.HasStopSound		= true
ENT.SoundName			= "shootDhSK"

ENT.BaseModel			= "models/gredwitch/dhsk/dhsk_tripod.mdl"
ENT.Model				= "models/gredwitch/dhsk/dhsk_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 42

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
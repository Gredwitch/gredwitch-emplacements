AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]ZPU-4"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 4
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.1
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/m1910/shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/m1910/stop.wav"
ENT.SoundName			= "shootZPU"

ENT.BaseModel			= "models/gredwitch/zpu/zpu_tripod.mdl"
ENT.Model				= "models/gredwitch/zpu/zpu_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 40

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
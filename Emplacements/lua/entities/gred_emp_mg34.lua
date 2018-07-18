AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 34"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.067
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/mg34/shoot.wav"
ENT.SoundName			= "shootMG34"

ENT.BaseModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.Model				= "models/gredwitch/mg34/mg34.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 43.5

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
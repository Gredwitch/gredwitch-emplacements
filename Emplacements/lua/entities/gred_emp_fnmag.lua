AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]FN Mag"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.075
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/fnmag/fnamg_shoot.wav"
ENT.SoundName			= "shootFNMAG"

ENT.BaseModel			= "models/gredwitch/fnmag/fnmag_tripod.mdl"
ENT.Model				= "models/gredwitch/fnmag/fnmag_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 7

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
	return ent
end
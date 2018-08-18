AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 81Z"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 2
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.0375
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/mg81z/shoot.wav"
ENT.SoundName			= "shootMG81Z"

ENT.BaseModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.Model				= "models/gredwitch/mg81z/mg81z_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 42
ENT.CanLookArround		= true
ENT.TurretForward		= -3

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(2,math.random(0,1))
	return ent
end
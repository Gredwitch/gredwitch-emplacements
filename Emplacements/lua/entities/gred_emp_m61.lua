AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M61 Vulcan"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_20mm"
ENT.ShotInterval		= 0.01
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/m61/gun.wav"
ENT.SoundName			= "shootM61"

ENT.BaseModel			= "models/gredwitch/m61/m61_tripod.mdl"
ENT.Model				= "models/gredwitch/m61/m61_gun.mdl"
ENT.SecondModel			= "models/gredwitch/m61/m61_barrel.mdl"
ENT.HasRotatingBarrel	= true
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 0
ENT.MaxUseDistance		= 100
ENT.BarrelHeight		= 28

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
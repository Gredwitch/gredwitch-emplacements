ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M2 Browning"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_12mm"
ENT.ShotInterval		= 0.12
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/m2/shoot.wav"
ENT.SoundName			= "shootM2"

ENT.BaseModel			= "models/gredwitch/m2browning/m2_tripod.mdl"
ENT.Model				= "models/gredwitch/m2browning/m2_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 35

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
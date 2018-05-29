AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]PaK 40"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_rocket_75mm"
ENT.MuzzleCount			= 1
ENT.AmmoType			= "AP"

ENT.HERadius			= 450
ENT.HEDamage			= 75
ENT.EffectHE			= "ins_rpg_explosion"

ENT.SoundName			= "shootPaK"
ENT.ShootSound			= "gred_emp/pak40/shoot_reload.wav"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/pak40/pak40_carriage.mdl"
ENT.Model				= "models/gredwitch/pak40/pak40_base.mdl"
ENT.EmplacementType     = "AT"

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent:Spawn()
	ent:Activate()
	return ent
end
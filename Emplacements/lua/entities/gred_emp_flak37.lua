AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Flak 37"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "Flak 37"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_rocket_88mm"
ENT.MuzzleCount			= 1

ENT.HERadius			= 500
ENT.HEDamage			= 100
ENT.EffectHE			= "doi_artillery_explosion"

ENT.SoundName			= "shootPaK"
ENT.ShootSound			= "gred_emp/pak40/shoot_reload.wav"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/pak38/pak38_carriage.mdl"
ENT.Model				= "models/damik/flak 88mm/flak 37 (rargdoll).mdl"
ENT.EmplacementType     = "AT"

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 41
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,4))
	return ent
end
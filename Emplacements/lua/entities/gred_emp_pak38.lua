AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]PaK 38"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 38"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_rocket_50mm"
ENT.MuzzleCount			= 1

ENT.HERadius			= 350
ENT.HEDamage			= 100
ENT.EffectHE			= "gred_50mm"
ENT.EffectSmoke			= "m203_smokegrenade"

ENT.SoundName			= "shootPaK"
ENT.ShootSound			= "gred_emp/pak40/shoot_reload.wav"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/pak38/pak38_carriage.mdl"
ENT.Model				= "models/gredwitch/pak38/pak38_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.1

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
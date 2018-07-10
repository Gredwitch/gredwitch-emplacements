AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm KwK"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "KwK"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_rocket_50mm"
ENT.MuzzleCount			= 1

ENT.HERadius			= 300
ENT.HEDamage			= 75
ENT.EffectHE			= "gred_50mm"
ENT.EffectSmoke			= "m203_smokegrenade"

ENT.SoundName			= "shootPaK"
ENT.ShootSound			= "gred_emp/pak40/shoot_reload.wav"

ENT.TurretHeight		= 49.8
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/kwk/kwk_base.mdl"
ENT.SecondModel			= "models/gredwitch/kwk/kwk_shield.mdl"
ENT.Model				= "models/gredwitch/kwk/kwk_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.MaxUseDistance		= 130
ENT.Seatable			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
	return ent
end
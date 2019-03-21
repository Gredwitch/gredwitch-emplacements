AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]82mm PM-41 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "PM-41 Mortar"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 2.4
ENT.Spread				= 400

ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.MaxRotation			= Angle(35,45)
ENT.HullModel			= "models/gredwitch/pm41/pm41_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/pm41/pm41_tube.mdl"
ENT.DefaultPitch		= 30
ENT.EmplacementType     = "Mortar"
ENT.Ammo				= -1

ENT.AmmunitionTypes		= {
						{"HE","gb_shell_82mm"},
						{"Smoke","gb_shell_82mm"}
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 28
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end
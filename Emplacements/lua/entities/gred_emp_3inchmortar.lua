AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]3'' Ordnance Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "Ordnance 3'' Mortar"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 3.33
ENT.Spread				= 400

ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.HullModel			= "models/gredwitch/3inchmortar/3inchmortar_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/3inchmortar/3inchmortar_tube.mdl"
ENT.EmplacementType     = "Mortar"
ENT.DefaultPitch		= 60
ENT.MaxRotation			= Angle(35,45)

ENT.AmmunitionTypes		= {
						{"HE","gb_shell_81mm"},
						{"WP","gb_shell_81mmWP"},
						{"Smoke","gb_shell_81mm"}
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 28
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
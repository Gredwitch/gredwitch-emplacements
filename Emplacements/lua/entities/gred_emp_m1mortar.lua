AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]81mm M1 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "M1 Mortar"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 3.33
ENT.Spread				= 400

ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.HullModel			= "models/gredwitch/m1_mortar/m1_mortar_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/m1_mortar/m1_mortar.mdl"
ENT.EmplacementType     = "Mortar"
ENT.DefaultPitch		= 45
ENT.MaxRotation			= Angle(35,45)
ENT.Ammo				= -1

ENT.AmmunitionTypes		= {
						{"HE","gb_shell_81mm"},
						{"WP","gb_shell_81mmWP"},
						{"Smoke","gb_shell_81mm"}
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 38
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetAngles(Angle(0,0,-12))
	ent:Spawn()
	ent:Activate()
	return ent
end
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
ENT.DefaultPitch		= 30
ENT.CustomShootAng		= {Angle(0,0,-120)}
ENT.Ammo				= -1
ENT.TurretPos			= Vector(0,0,22.5)
ENT.MaxRotation			= Angle(80,25) -- actually 11 yaw
ENT.MinRotation			= Angle(45,-25)

ENT.AmmunitionTypes		= {
	{
		Caliber = 81,
		ShellType = "HE",
		MuzzleVelocity = 100,
		Mass = 4,
		TracerColor = "white",
	},
	{
		Caliber = 81,
		ShellType = "WP",
		MuzzleVelocity = 100,
		Mass = 4,
		TracerColor = "white",
	},
	{
		Caliber = 81,
		ShellType = "Smoke",
		MuzzleVelocity = 100,
		Mass = 4,
		TracerColor = "white",
	},
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

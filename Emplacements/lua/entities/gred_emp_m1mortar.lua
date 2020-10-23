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
ENT.DefaultPitch		= 80
ENT.MaxRotation			= Angle(90,23)
ENT.MinRotation			= Angle(-40,-23)
ENT.Ammo				= -1

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

local ang = Angle(12)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 45
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	return ent
end

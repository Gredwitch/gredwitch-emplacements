AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]152mm 2A65 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "2A65"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.AmmunitionTypes		= {
	{
		Caliber = 152,
		ShellType = "HE",
		MuzzleVelocity = 823,
		Mass = 43.56,
		TNTEquivalent = 5.900,
		LinearPenetration = 49,
		TracerColor = "white",
	},
	{
		Caliber = 152,
		ShellType = "APHE",
		MuzzleVelocity = 823,
		TNTEquivalent = 0.739,
		Normalization = -1,
		Mass = 43.56,
		TracerColor = "white",
	},
	{
		Caliber = 152,
		ShellType = "HEAT",
		MuzzleVelocity = 823,
		TNTEquivalent = 5.9121,
		LinearPenetration = 250,
		Mass = 43.56,
		TracerColor = "white",
	},
	{
		Caliber = 152,
		ShellType = "APHEBC",
		MuzzleVelocity = 823,
		TNTEquivalent = 1.0164,
		Normalization = 4,
		Mass = 43.56,
		TracerColor = "white",
	},
	{
		Caliber = 152,
		ShellType = "Smoke",
		MuzzleVelocity = 810,
		Mass = 43.56,
		TracerColor = "white",
	},
}
ENT.IsHowitzer			= true
ENT.AddShootAngle		= -3
ENT.PitchRate			= 20
ENT.YawRate				= 20
ENT.ShootAnim			= "shoot"
ENT.ShellLoadTime		= 1.5
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1.6
ENT.ShootSound			= "^gred_emp/common/152mm.wav"
ENT.ATReloadSound		= "big"

ENT.HullModel			= "models/gredwitch/2A65/2A65_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/2A65/2A65_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.Ammo				= -1
ENT.WheelsModel			= "models/gredwitch/2A65/2A65_wheels.mdl"
ENT.WheelsPos			= Vector(1,12,25)
ENT.AddShootAngle		= 0

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end
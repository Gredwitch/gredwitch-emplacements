AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm PaK 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 38"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 5.5
ENT.Spread				= 0.2
ENT.AmmunitionTypes		= {
	{
		Caliber = 50,
		ShellType = "HE",
		MuzzleVelocity = 835,
		Mass = 1,
		TracerColor = "white",
	},
	{
		Caliber = 50,
		ShellType = "AP",
		MuzzleVelocity = 1180,
		Mass = 2.06,
		TracerColor = "white",
	},
	{
		Caliber = 50,
		ShellType = "Smoke",
		MuzzleVelocity = 835,
		Mass = 1,
		TracerColor = "white",
	},
}

ENT.PitchRate			= 50
ENT.YawRate				= 50
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.6
ENT.ShellLoadTime		= 1.5
ENT.AnimPlayTime		= 1.3

ENT.ShootSound			= "^gred_emp/common/50mm.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/pak38/pak38_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/pak38/pak38_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.ATReloadSound		= "small"

ENT.WheelsModel			= "models/gredwitch/pak38/pak38_wheels.mdl"
ENT.WheelsPos			= Vector(2.5,7,0)
ENT.Ammo				= -1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 41
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,4))
	return ent
end
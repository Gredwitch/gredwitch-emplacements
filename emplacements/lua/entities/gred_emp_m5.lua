AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]76mm M5"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M5"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 5.6
ENT.AmmunitionTypes		= {
	{
		Caliber = 76,
		ShellType = "HE",
		MuzzleVelocity = 792,
		Mass = 6.5,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "AP",
		MuzzleVelocity = 792,
		Mass = 6.5,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "Smoke",
		MuzzleVelocity = 792,
		Mass = 6.5,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 40
ENT.YawRate				= 40
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4
ENT.AnimPlayTime		= 1

ENT.ShootSound			= "^gred_emp/common/76mm.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.TurretTurnMax		= 0.7
ENT.HullModel			= "models/gredwitch/M5/M5_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/M5/M5_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/M5/M5_wheels.mdl"
ENT.WheelsPos			= Vector(0,13,-4)
ENT.Ammo				= -1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,1))
	ent:Spawn()
	ent:Activate()
	return ent
end
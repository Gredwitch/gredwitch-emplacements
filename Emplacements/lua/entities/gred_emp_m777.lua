AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]155mm M777 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M777"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.AmmunitionTypes		= {
	{
		Caliber = 155,
		ShellType = "HE",
		MuzzleVelocity = 300, -- actually 827
		Mass = 43.2,
		TracerColor = "white",
	},
	{
		Caliber = 155,
		ShellType = "Smoke",
		MuzzleVelocity = 300,
		Mass = 43.2,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 20
ENT.YawRate				= 20
ENT.AnimPauseTime		= 1
ENT.AnimRestartTime		= 4.4
ENT.ShellEjectTime		= 0.2
ENT.AnimPlayTime		= 1
ENT.ShootAnim			= "shoot"

ENT.ShootSound			= "^gred_emp/common/155mm.wav"
ENT.ATReloadSound		= "big"

ENT.TurretPos			= Vector(0,-10,20)
ENT.YawPos				= Vector(0,0,21)
ENT.HullModel			= "models/gredwitch/M777/M777_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/M777/M777_gun.mdl"
ENT.YawModel			= "models/gredwitch/M777/M777_shield.mdl"
ENT.Ammo				= -1
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

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
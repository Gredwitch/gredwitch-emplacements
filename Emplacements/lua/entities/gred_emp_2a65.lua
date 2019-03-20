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
						{"HE","gb_shell_152mm"},
						{"Smoke","gb_shell_152mm"}
}
ENT.ShootAnim			= "shoot"
ENT.ShellLoadTime		= 1.5
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1.6
ENT.ShootSound			= "gred_emp/common/152mm.wav"
ENT.ATReloadSound		= "big"

ENT.HullModel			= "models/gredwitch/2A65/2A65_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/2A65/2A65_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.Ammo				= -1
ENT.WheelsModel			= "models/gredwitch/2A65/2A65_wheels.mdl"
ENT.WheelsPos			= Vector(1,12,25)
ENT.AddShootAngle		= 3.5

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
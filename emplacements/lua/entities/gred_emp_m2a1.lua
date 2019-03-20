AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]105mm M2A1 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M2A1"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 5.3
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_105mm"},
						{"WP","gb_shell_105mmWP"},
						{"Smoke","gb_shell_105mm"}
}
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1.6
ENT.ShellLoadTime		= 1.3

ENT.ShootSound			= "gred_emp/common/105mm.wav"
ENT.ATReloadSound		= "big"

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/M2A1/M2A1_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/M2A1/M2A1_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.WheelsModel			= "models/gredwitch/M2A1/M2A1_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,0)
ENT.Ammo				= -1
ENT.AddShootAngle		= 4

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
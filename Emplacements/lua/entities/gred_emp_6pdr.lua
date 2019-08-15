AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]6pdr Ordnance QF"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "6pdr"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 4.5
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_57mm"},
						{"AP","gb_shell_57mm"},
						{"Smoke","gb_shell_57mm"}
}
ENT.ShootAnim			= "shoot"

ENT.AnimRestartTime		= 2
ENT.ShellLoadTime		= 1.9
ENT.AnimPlayTime		= 1

ENT.ShootSound			= "gred_emp/common/6pdr.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/6pdr/6pdr_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/6pdr/6pdr_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.ATReloadSound    	= "small"
ENT.Spread				= 0.1
ENT.AnimPauseTime		= 0.3
ENT.TurretPos			= Vector(0,50,20)
ENT.WheelsPos			= Vector(0,5,-5)
ENT.WheelsModel			= "models/gredwitch/6pdr/6pdr_wheels.mdl"
ENT.Ammo				= -1
ENT.AddShootAngle		= 1


function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:SetSkin(math.random(0,1))
	ent:Spawn()
	ent:Activate()
	return ent
end

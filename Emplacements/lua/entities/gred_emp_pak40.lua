AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]75mm PaK 40"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 40"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.6
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_75mm"},
						{"AP","gb_shell_75mm"},
						{"Smoke","gb_shell_75mm"}
}
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 3.5
ENT.ShellLoadTime		= 1.5
ENT.AnimPlayTime		= 0.8

ENT.ShootSound			= "gred_emp/common/75mm_axis.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.TurretPos			= Vector(0,7,1)
ENT.HullModel			= "models/gredwitch/pak40/pak40_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/pak40/pak40_base.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/pak40/pak40_wheels.mdl"
ENT.WheelsPos			= Vector(0,1,0)
ENT.Ammo				= -1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
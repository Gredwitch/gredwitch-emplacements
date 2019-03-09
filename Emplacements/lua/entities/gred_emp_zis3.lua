AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]76mm ZiS-3 Divisional Gun"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "ZiS-3"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_75mm"},
						{"AP","gb_shell_75mm"},
						{"Smoke","gb_shell_75mm"}
}
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.6
ENT.AnimPlayTime		= 1

ENT.ShootSound			= "gred_emp/common/76mm.wav"


ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/zis3/zis3_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/zis3/zis3_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/zis3/zis3_wheels.mdl"
ENT.WheelsPos			= Vector(0,2,17)
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
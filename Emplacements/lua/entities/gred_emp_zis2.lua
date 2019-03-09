AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]57mm ZiS-2"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "ZiS-2"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_57mm"},
						{"AP","gb_shell_57mm"},
						{"Smoke","gb_shell_57mm"}
}
ENT.ShootAnim			= "shoot"

ENT.AnimRestartTime		= 4.5
ENT.AnimPlayTime		= 1.1

ENT.ShootSound			= "gred_emp/common/50mm.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/zis2/zis2_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/zis2/zis2_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.WheelsModel			= "models/gredwitch/zis2/zis2_wheels.mdl"
ENT.WheelsPos			= Vector(0,5,-6)
ENT.Ammo				= -1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 41
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,4))
	return ent
end
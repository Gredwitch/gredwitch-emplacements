AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm PaK 43"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 43"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_88mm"},
						{"AP","gb_shell_88mm"},
						{"Smoke","gb_shell_88mm"}
}
ENT.ShootAnim			= "shoot"

ENT.AnimRestartTime		= 4.6
ENT.ShellLoadTime		= 1.5
ENT.AnimPlayTime		= 1.3
ENT.ATReloadSound		= "big"

ENT.ShootSound			= "gred_emp/common/88mm.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/pak43/pak43_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/pak43/pak43_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/pak43/pak43_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,0)
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
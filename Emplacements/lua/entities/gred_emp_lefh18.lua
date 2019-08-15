AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]105mm LeFH18"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "LeFH18"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 5
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_105mm"},
						{"Smoke","gb_shell_105mm"}
}
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1
ENT.ShellLoadTime		= 1.5

ENT.ShootSound			= "gred_emp/common/105mm_axis.wav"
ENT.ATReloadSound		= "big"

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/lefh18/lefh18_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/lefh18/lefh18_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.WheelsModel			= "models/gredwitch/lefh18/lefh18_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,10)
ENT.Ammo				= -1
ENT.AddShootAngle		= 3.5

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,2))
	ent:Spawn()
	ent:Activate()
	return ent
end
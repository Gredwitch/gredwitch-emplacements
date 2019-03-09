AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]81mm Granatfwerfer 34"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "Granatfwerfer 34"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 2.4
ENT.Spread				= 400

ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.MaxRotation			= Angle(35,45)
ENT.HullModel			= "models/gredwitch/granatwerfer/granatwerfer_base.mdl"
ENT.TurretModel			= "models/gredwitch/granatwerfer/granatwerfer_tube.mdl"
ENT.DefaultPitch		= 50
ENT.EmplacementType     = "Mortar"

ENT.AmmunitionTypes		= {
						{"HE","gb_shell_81mm"},
						{"Smoke","gb_shell_81mm"}
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,2))
	ent:Spawn()
	ent:Activate()
	return ent
end
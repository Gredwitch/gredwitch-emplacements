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

ENT.HullModel			= "models/gredwitch/granatwerfer/granatwerfer_base.mdl"
ENT.TurretModel			= "models/gredwitch/granatwerfer/granatwerfer_tube.mdl"
ENT.DefaultPitch		= 50
ENT.EmplacementType     = "Mortar"
ENT.Ammo				= -1
ENT.MaxRotation			= Angle(90,23)
ENT.MinRotation			= Angle(-45,-23)

ENT.AmmunitionTypes		= {
	{
		Caliber = 81,
		ShellType = "HE",
		MuzzleVelocity = 100,
		Mass = 4,
		TracerColor = "white",
	},
	{
		Caliber = 81,
		ShellType = "Smoke",
		MuzzleVelocity = 100,
		Mass = 4,
		TracerColor = "white",
	},
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,2))
	ent:Spawn()
	ent:Activate()
	return ent
end

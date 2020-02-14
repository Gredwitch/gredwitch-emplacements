AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]155mm GPF Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "GPF"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 4
ENT.IsHowitzer			= true
ENT.AmmunitionTypes		= {
	{
		Caliber = 155,
		ShellType = "HE",
		MuzzleVelocity = 735,
		Mass = 43,
		TNTEquivalent = 6.800,
		LinearPenetration = 54,
		TracerColor = "white",
	},
	{
		Caliber = 155,
		ShellType = "Smoke",
		MuzzleVelocity = 735,
		Mass = 43,
		TracerColor = "white",
	},
}
ENT.AddShootAngle		= 0
ENT.MaxUseDistance		= 150
ENT.PitchRate			= 20
ENT.YawRate				= 20
ENT.AnimPauseTime		= 1
ENT.AnimRestartTime		= 4.4
ENT.ShellEjectTime		= 0.2
ENT.AnimPlayTime		= 1
ENT.ShootAnim			= "shoot"

ENT.ShootSound			= "^gred_emp/common/155mm.wav"
ENT.ATReloadSound		= "big"

ENT.TurretPos			= Vector(0,0,35)
ENT.YawPos				= Vector(0,0,26.0317)
ENT.WheelsPos			= Vector(25,0,23)
ENT.WheelsModel			= "models/gredwitch/gpf155/gpf155_wheels.mdl"
ENT.HullModel			= "models/gredwitch/gpf155/gpf155_base_open.mdl"
ENT.TurretModel			= "models/gredwitch/gpf155/gpf155_gun.mdl"
ENT.YawModel			= "models/gredwitch/gpf155/gpf155_turret.mdl"
ENT.Ammo				= -1
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4
ENT.MaxRotation			= Angle(35,60)
ENT.MinRotation			= Angle(0,-60)
ENT.ToggleableCarriage	= true

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

function ENT:OnThinkCL()
	local yaw = self:GetYaw()
	if !IsValid(yaw) then return end
	local hull = self:GetHull()
	if !IsValid(hull) then return end
	local ang = hull:WorldToLocalAngles(self:GetAngles())
	
	-- print(yaw:GetBoneName(1))
	yaw:ManipulateBoneAngles(1,Angle(0,  ang.y*30))
	yaw:ManipulateBoneAngles(2,Angle(0,0,ang.p*30))
end
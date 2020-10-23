AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]155mm M777 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M777"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.IsHowitzer			= true
ENT.AmmunitionTypes		= {
	{
		Caliber = 155,
		ShellType = "HE",
		MuzzleVelocity = 823,
		Mass = 43.56,
		TNTEquivalent = 5.900,
		LinearPenetration = 49,
		TracerColor = "white",
	},
	{
		Caliber = 155,
		ShellType = "APHE",
		MuzzleVelocity = 823,
		TNTEquivalent = 0.739,
		Normalization = -1,
		Mass = 43.56,
		TracerColor = "white",
	},
	{
		Caliber = 155,
		ShellType = "HEAT",
		MuzzleVelocity = 823,
		TNTEquivalent = 5.9121,
		LinearPenetration = 250,
		Mass = 43.56,
		TracerColor = "white",
	},
	{
		Caliber = 155,
		ShellType = "APHEBC",
		MuzzleVelocity = 823,
		TNTEquivalent = 1.0164,
		Normalization = 4,
		Mass = 43.56,
		TracerColor = "white",
	},
	{
		Caliber = 155,
		ShellType = "Smoke",
		MuzzleVelocity = 810,
		Mass = 43.56,
		TracerColor = "white",
	},
}
ENT.AddShootAngle		= 0
ENT.MaxUseDistance		= 120
ENT.PitchRate			= 20
ENT.YawRate				= 20
ENT.AnimPauseTime		= 1
ENT.AnimRestartTime		= 4.4
ENT.ShellEjectTime		= 0.2
ENT.AnimPlayTime		= 1
ENT.ShootAnim			= "shoot"

ENT.ShootSound			= "^gred_emp/common/155mm.wav"
ENT.ATReloadSound		= "big"

ENT.TurretPos			= Vector(-14.113,0,23.2157)
ENT.YawPos				= Vector(-15.8768,0,21.9047)
ENT.HullModel			= "models/gredwitch/M777/M777_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/M777/M777_gun.mdl"
ENT.YawModel			= "models/gredwitch/M777/M777_shield.mdl"
ENT.Ammo				= -1
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4
ENT.MaxRotation			= Angle(71.7,180)
ENT.MinRotation			= Angle(0,-180)

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
	
	for i=0, yaw:GetBoneCount()-1 do
		-- print( i, yaw:GetBoneName( i ) )
	end
	-- yaw:ManipulateBoneAngles(2,Angle(0,0,ang.y*15))
	-- yaw:ManipulateBoneAngles(3,Angle(0,0,ang.p*15))
end
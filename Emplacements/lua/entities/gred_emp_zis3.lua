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
	{
		Caliber = 76,
		ShellType = "HE",
		MuzzleVelocity = 680,
		Mass = 6.2,
		TNTEquivalent = 0.621,
		LinearPenetration = 10,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "APBC",
		MuzzleVelocity = 655,
		Mass = 6.78,
		Normalization = 4,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "HEAT",
		MuzzleVelocity = 355,
		Mass = 5.3,
		TNTEquivalent = 0.9594,
		LinearPenetration = 80,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "APHEBC",
		MuzzleVelocity = 662,
		Mass = 6.3,
		TNTEquivalent = 0.15,
		Normalization = 4,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "APCR",
		MuzzleVelocity = 950,
		Mass = 3.02,
		CoreMass = 8.55,
		Normalization = 1.5,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "Smoke",
		MuzzleVelocity = 680,
		Mass = 6.45,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 40
ENT.YawRate				= 40
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.6
ENT.AnimPlayTime		= 1
ENT.ShellLoadTime		= 1.1

ENT.ShootSound			= "^gred_emp/common/76mm.wav"

ENT.AddShootAngle		= 0.4
ENT.HullModel			= "models/gredwitch/zis3/zis3_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/zis3/zis3_gun.mdl"
ENT.YawModel			= "models/gredwitch/zis3/zis3_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/zis3/zis3_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,17.0459)
ENT.YawPos				= Vector(-2.85028,0,22.9786)
ENT.TurretPos			= Vector(-5.71739,0,7.83511)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_russian_tanksight_02"
ENT.SightPos			= Vector(-12,-15,55)
ENT.MaxRotation			= Angle(37,54)
ENT.MinRotation			= Angle(-5,-54)
ENT.ToggleableCarriage	= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,1)
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = self:GetAngles()
		view.fov = 20
		view.drawviewer = false

		return view
	end
end
function ENT:OnThinkCL()
	local yaw = self:GetYaw()
	if !IsValid(yaw) then return end
	local hull = self:GetHull()
	if !IsValid(hull) then return end
	local ang = hull:WorldToLocalAngles(self:GetAngles())
	
	-- for i=0, yaw:GetBoneCount()-1 do
		-- print( i, yaw:GetBoneName( i ) )
	-- end
	yaw:ManipulateBoneAngles(2,Angle(ang.y*15))
	yaw:ManipulateBoneAngles(3,Angle(ang.p*15))
end

function ENT:HUDPaint(ply,viewmode)
	if viewmode == 1 then
		local ScrW,ScrH = ScrW(),ScrH()
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(surface.GetTextureID(self.SightTexture))
		surface.DrawTexturedRect((-(ScrW*1.25-ScrW)*0.5),(-(ScrW*1.25-ScrH)*0.5),ScrW*1.25,ScrW*1.25)
		return ScrW,ScrH
	end
end


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
ENT.ShotInterval		= 5.9
ENT.AmmunitionTypes		= {
	{
		Caliber = 75,
		ShellType = "HE",
		MuzzleVelocity = 550,
		Mass = 5.7,
		LinearPenetration = 10,
		TNTEquivalent = 0.686,
		TracerColor = "white",
	},
	{
		Caliber = 75,
		ShellType = "APCBC",
		MuzzleVelocity = 790,
		Mass = 6.8,
		Normalization = 4,
		TNTEquivalent = 0.0289,
		TracerColor = "white",
	},
	{
		Caliber = 75,
		ShellType = "APCR",
		MuzzleVelocity = 990,
		Mass = 4.2,
		Normalization = 1.5,
		CoreMass = 12.7,
		TracerColor = "white",
	},
	{
		Caliber = 75,
		ShellType = "HEAT",
		MuzzleVelocity = 450,
		Mass = 4.4,
		LinearPenetration = 80,
		TNTEquivalent = 0.8721,
		TracerColor = "white",
	},
	{
		Caliber = 75,
		ShellType = "Smoke",
		MuzzleVelocity = 423,
		Mass = 6.8,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 40
ENT.YawRate				= 40
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 3.5
ENT.ShellLoadTime		= 1.5
ENT.AnimPlayTime		= 1.3

ENT.ShootSound			= "^gred_emp/common/75mm_axis.wav"

ENT.TurretPos			= Vector(5.70665,0,16.3967)
ENT.YawPos				= Vector(5,0,2)
ENT.HullModel			= "models/gredwitch/pak40/pak40_carriage_open.mdl"
ENT.YawModel			= "models/gredwitch/pak40/pak40_shield.mdl"
ENT.TurretModel			= "models/gredwitch/pak40/pak40_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/pak40/pak40_wheels.mdl"
ENT.WheelsPos			= Vector(8.95368,0,0)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_02"
ENT.SightPos			= Vector(15,15,0)
ENT.MaxRotation			= Angle(22,65)
ENT.MinRotation			= Angle(-5,-65)
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
	
	yaw:ManipulateBoneAngles(1,Angle(ang.y*15))
	yaw:ManipulateBoneAngles(2,Angle(0,ang.p*15))
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
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
	{
		Caliber = 105,
		ShellType = "HE",
		MuzzleVelocity = 472,
		Mass = 15,
		LinearPenetration = 22,
		TNTEquivalent = 1.75,
		TracerColor = "white",
	},
	{
		Caliber = 105,
		ShellType = "APHE",
		MuzzleVelocity = 475,
		Mass = 14,
		TNTEquivalent = 0.238,
		Normalization = -1,
		TracerColor = "white",
	},
	{
		Caliber = 105,
		ShellType = "HEAT",
		MuzzleVelocity = 495,
		Mass = 12,
		LinearPenetration = 115,
		TNTEquivalent = 2.55,
		TracerColor = "white",
	},
	{
		Caliber = 105,
		ShellType = "Smoke",
		MuzzleVelocity = 470,
		Mass = 14.81,
		TracerColor = "white",
	},
}
ENT.AddShootAngle		= 0.5
ENT.IsHowitzer			= true
ENT.PitchRate			= 30
ENT.YawRate				= 30
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1
ENT.ShellLoadTime		= 1.5

ENT.ShootSound			= "^gred_emp/common/105mm_axis.wav"
ENT.ATReloadSound		= "big"

ENT.HullModel			= "models/gredwitch/lefh18/lefh18_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/lefh18/lefh18_gun.mdl"
ENT.YawModel			= "models/gredwitch/lefh18/lefh18_shield.mdl"
ENT.YawPos				= Vector(-7.34871,0,5.36707)
ENT.TurretPos			= Vector(-4.11713,0,28.4555)
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.WheelsModel			= "models/gredwitch/lefh18/lefh18_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,10)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_02"
ENT.SightPos			= Vector(-5,-11,41)
ENT.MaxRotation			= Angle(42,56)
ENT.MinRotation			= Angle(-5,-56)
ENT.ToggleableCarriage	= true

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
	yaw:ManipulateBoneAngles(1,Angle(0,-ang.p))
	yaw:ManipulateBoneAngles(4,Angle(ang.y*15))
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
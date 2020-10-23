AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm PaK 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 38"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 5.5
ENT.Spread				= 0.2
ENT.AmmunitionTypes		= {
	{
		Caliber = 50,
		ShellType = "HE",
		MuzzleVelocity = 550,
		Mass = 1.8,
		TNTEquivalent = 0.17,
		LinearPenetration = 5,
		TracerColor = "white",
	},
	{
		Caliber = 50,
		ShellType = "AP",
		MuzzleVelocity = 835,
		Mass = 2.06,
		TracerColor = "white",
		TNTEquivalent = 0.0459,
		Normalization = 4,
	},
	{
		Caliber = 50,
		ShellType = "APC",
		MuzzleVelocity = 835,
		Mass = 2.1,
		TracerColor = "white",
		TNTEquivalent = 0.0459,
		Normalization = -1
	},
	{
		Caliber = 50,
		ShellType = "APCR",
		MuzzleVelocity = 1180,
		Mass = 0.93,
		TracerColor = "white",
		CoreMass = 4.26,
		Normalization = 1.5,
	},
	{
		Caliber = 50,
		ShellType = "Smoke",
		MuzzleVelocity = 550,
		Mass = 1,
		TracerColor = "white",
	},
}

ENT.PitchRate			= 50
ENT.YawRate				= 50
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.6
ENT.ShellLoadTime		= 1.5
ENT.AnimPlayTime		= 1.3

ENT.ShootSound			= "^gred_emp/common/50mm.wav"

ENT.HullModel			= "models/gredwitch/pak38/pak38_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/pak38/pak38_gun.mdl"
ENT.YawModel			= "models/gredwitch/pak38/pak38_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.ATReloadSound		= "small"

ENT.WheelsModel			= "models/gredwitch/pak38/pak38_wheels.mdl"
ENT.WheelsPos			= Vector(19.3277,-2.89306,-4.23103)
ENT.YawPos				= Vector(12.1486,0,1)
ENT.TurretPos			= Vector(-5.41885,0,16.4508)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_02"
ENT.SightPos			= Vector(10,15,6)
ENT.MaxRotation			= Angle(27,65)
ENT.MinRotation			= Angle(-8,-65)
ENT.ToggleableCarriage	= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 41
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,4))
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
	yaw:ManipulateBoneAngles(3,Angle(ang.y*15))
	yaw:ManipulateBoneAngles(2,Angle(ang.p*15))
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
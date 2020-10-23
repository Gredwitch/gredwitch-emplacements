AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm PaK 43/41"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 43/41"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
	{
		Caliber = 88,
		ShellType = "HE",
		MuzzleVelocity = 820,
		Mass = 11,
		TNTEquivalent = 0.935,
		LinearPenetration = 13,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "APCBC",
		MuzzleVelocity = 1000,
		Mass = 10,
		TNTEquivalent = 0.108,
		Normalization = 4,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "HEAT",
		MuzzleVelocity = 600,
		Mass = 7.6,
		TNTEquivalent = 1.1,
		LinearPenetration = 110,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "APCR",
		MuzzleVelocity = 1200,
		Mass = 7.3,
		CoreMass = 19.9,
		Normalization = 1.5,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "Smoke",
		MuzzleVelocity = 820,
		Mass = 9.4,
		TracerColor = "white",
	},
}
ENT.ShootAnim			= "shoot"

ENT.PitchRate			= 10
ENT.YawRate				= 20
ENT.AnimRestartTime		= 4.6
ENT.ShellLoadTime		= 1.5
ENT.AnimPlayTime		= 1.3
ENT.ATReloadSound		= "big"

ENT.ShootSound			= "^gred_emp/common/88mm.wav"

ENT.HullModel			= "models/gredwitch/pak43/pak43_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/pak43/pak43_gun.mdl"
ENT.YawModel			= "models/gredwitch/pak43/pak43_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/pak43/pak43_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,11.9288)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_02"
ENT.YawPos				= Vector(0,0,13.7482)
ENT.TurretPos			= Vector(0,0,22.1377)
ENT.SightPos			= Vector(15,-14,12)
ENT.MaxRotation			= Angle(38,56)
ENT.MinRotation			= Angle(-5,-56)
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

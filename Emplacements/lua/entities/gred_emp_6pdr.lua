AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]6-pdr Ordnance QF Mk III"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "6pdr"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 4.5
ENT.AmmunitionTypes		= {
	{
		Caliber = 57,
		ShellType = "HE",
		MuzzleVelocity = 807,
		LinearPenetration = 4,
		TNTEquivalent = 0.153,
		Mass = 3,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "AP",
		MuzzleVelocity = 853,
		Mass = 2.8,
		Normalization = -1,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "APC",
		MuzzleVelocity = 853,
		Mass = 2.87,
		Normalization = -1,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "APCBC",
		MuzzleVelocity = 801,
		Mass = 3.23,
		Normalization = 4,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "Smoke",
		MuzzleVelocity = 820,
		Mass = 3,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 50
ENT.YawRate				= 50
ENT.ShootAnim			= "shoot"

ENT.AnimRestartTime		= 2
ENT.ShellLoadTime		= 1.9
ENT.AnimPlayTime		= 1

ENT.ShootSound			= "^gred_emp/common/6pdr.wav"

ENT.HullModel			= "models/gredwitch/6pdr/6pdr_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/6pdr/6pdr_gun.mdl"
ENT.YawModel			= "models/gredwitch/6pdr/6pdr_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.ATReloadSound    	= "small"
ENT.Spread				= 0.1
ENT.AnimPauseTime		= 0.3
ENT.TurretPos			= Vector(0,0,9)
-- ENT.YawPos				= Vector(50,0,20)
ENT.YawPos				= Vector(50,0,19)
ENT.WheelsPos			= Vector(55,0,15)
ENT.WheelsModel			= "models/gredwitch/6pdr/6pdr_wheels.mdl"
ENT.Ammo				= -1
ENT.AddShootAngle		= 0
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_british_canonsight_01"
ENT.SightPos			= Vector(5,14,11.5)
ENT.MaxRotation			= Angle(15,90)
ENT.MinRotation			= Angle(-5,-90)
ENT.ToggleableCarriage	= true


function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:SetSkin(math.random(0,1))
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

function ENT:HUDPaint(ply,viewmode)
	if viewmode == 1 then
		local ScrW,ScrH = ScrW(),ScrH()
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(surface.GetTextureID(self.SightTexture))
		surface.DrawTexturedRect((-(ScrW*1.25-ScrW)*0.5),(-(ScrW*1.25-ScrH)*0.5),ScrW*1.25,ScrW*1.25)
		return ScrW,ScrH
	end
end

function ENT:OnThinkCL()
	local yaw = self:GetYaw()
	if !IsValid(yaw) then return end
	local hull = self:GetHull()
	if !IsValid(hull) then return end
	
	yaw:ManipulateBoneAngles(2,Angle(hull:WorldToLocalAngles(self:GetAngles()).p*15))
end

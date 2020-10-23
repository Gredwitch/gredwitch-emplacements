AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]57mm ZiS-2"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "ZiS-2"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 5.5
ENT.AmmunitionTypes		= {
	{
		Caliber = 57,
		ShellType = "HE",
		MuzzleVelocity = 700,
		Mass = 3.75,
		TNTEquivalent = 0.22,
		LinearPenetration = 5,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "APHE",
		MuzzleVelocity = 990,
		Mass = 3.14,
		Normalization = -1,
		TNTEquivalent = 0.0277,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "APHEBC",
		MuzzleVelocity = 990,
		Mass = 3.14,
		Normalization = 4,
		TNTEquivalent = 0.0216,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "Smoke",
		MuzzleVelocity = 700,
		Mass = 3.75,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 45
ENT.YawRate				= 45
ENT.ShootAnim			= "shoot"

ENT.AnimRestartTime		= 4.5
ENT.AnimPlayTime		= 1.1
ENT.ShellLoadTime		= 1.7

ENT.ShootSound			= "^gred_emp/common/50mm.wav"

ENT.HullModel			= "models/gredwitch/zis2/zis2_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/zis2/zis2_gun.mdl"
ENT.YawModel			= "models/gredwitch/zis2/zis2_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.WheelsModel			= "models/gredwitch/zis2/zis2_wheels.mdl"
ENT.WheelsPos			= Vector(3.92317,0,-5)
ENT.TurretPos			= Vector(-12.621,0,14.8384)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_russian_tanksight_02"
ENT.SightPos			= Vector(10,10,10)
ENT.MaxRotation			= Angle(25,56)
ENT.MinRotation			= Angle(-5,-56)
ENT.ToggleableCarriage	= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 41
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
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

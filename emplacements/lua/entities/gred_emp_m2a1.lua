AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]105mm M2A1 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M2A1"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 5.3
ENT.IsHowitzer			= true
ENT.AmmunitionTypes		= {
	{
		Caliber = 105,
		ShellType = "HE",
		MuzzleVelocity = 472,
		Mass = 15,
		LinearPenetration = 26,
		TNTEquivalent = 2.18,
		TracerColor = "white",
	},
	{
		Caliber = 105,
		ShellType = "HEAT",
		MuzzleVelocity = 381,
		Mass = 13,
		LinearPenetration = 130,
		TNTEquivalent = 1.61,
		TracerColor = "white",
	},
	{
		Caliber = 105,
		ShellType = "WP",
		MuzzleVelocity = 472,
		Mass = 18.3,
		TracerColor = "white",
	},
	{
		Caliber = 105,
		ShellType = "Smoke",
		MuzzleVelocity = 472,
		Mass = 18.3,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 30
ENT.YawRate				= 30
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1.6
ENT.ShellLoadTime		= 1.3

ENT.ShootSound			= "^gred_emp/common/105mm.wav"
ENT.ATReloadSound		= "big"

ENT.HullModel			= "models/gredwitch/M2A1/M2A1_carriage_open.mdl"
ENT.TurretModel			= "models/gredwitch/M2A1/M2A1_gun.mdl"
ENT.YawModel			= "models/gredwitch/M2A1/M2A1_yaw.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.WheelsModel			= "models/gredwitch/M2A1/M2A1_wheels.mdl"
ENT.YawPos				= Vector(-5.40738,0,4.08412)
ENT.TurretPos			= Vector(-13.0314,0,14.3401)
ENT.WheelsPos			= Vector(0,0,0)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_american_canonsight_01"
ENT.SightPos			= Vector(25,-13,18)
ENT.MaxRotation			= Angle(66,56)
ENT.MinRotation			= Angle(-5,-56)
ENT.ToggleableCarriage	= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
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
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

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/zis2/zis2_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/zis2/zis2_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.WheelsModel			= "models/gredwitch/zis2/zis2_wheels.mdl"
ENT.WheelsPos			= Vector(0,5,-6)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_russian_tanksight_02"
ENT.SightPos			= Vector(-10,-10,28)

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
		local ang = self:GetAngles()
		angles.p = -ang.r
		angles.y = ang.y + 90
		angles.r = -ang.p
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
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
		surface.DrawTexturedRect(0,-(ScrW-ScrH)*0.5,ScrW,ScrW)
		return ScrW,ScrH
	end
end

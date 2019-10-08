AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm PaK 43"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 43"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
	{
		Caliber = 88,
		ShellType = "HE",
		MuzzleVelocity = 820,
		Mass = 9.4,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "AP",
		MuzzleVelocity = 820,
		Mass = 9.4,
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

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/pak43/pak43_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/pak43/pak43_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/pak43/pak43_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,0)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_02"
ENT.SightPos			= Vector(17,20,33)

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
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
ENT.AmmunitionTypes		= {
	{
		Caliber = 105,
		ShellType = "HE",
		MuzzleVelocity = 472,
		Mass = 18.3,
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

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/M2A1/M2A1_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/M2A1/M2A1_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.4

ENT.WheelsModel			= "models/gredwitch/M2A1/M2A1_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,0)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_american_canonsight_01"
ENT.SightPos			= Vector(13.5,0,33)

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
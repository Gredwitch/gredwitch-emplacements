AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]76mm M5"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M5"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 5.6
ENT.AmmunitionTypes		= {
	{
		Caliber = 76,
		ShellType = "HE",
		MuzzleVelocity = 792,
		Mass = 6.5,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "AP",
		MuzzleVelocity = 792,
		Mass = 6.5,
		TracerColor = "white",
	},
	{
		Caliber = 76,
		ShellType = "Smoke",
		MuzzleVelocity = 792,
		Mass = 6.5,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 40
ENT.YawRate				= 40
ENT.ShootAnim			= "shoot"
ENT.AnimRestartTime		= 4
ENT.AnimPlayTime		= 1

ENT.ShootSound			= "^gred_emp/common/76mm.wav"

ENT.MaxRotation			= Angle(27,65)
ENT.TurretTurnMax		= 0.7
ENT.HullModel			= "models/gredwitch/M5/M5_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/M5/M5_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1

ENT.WheelsModel			= "models/gredwitch/M5/M5_wheels.mdl"
ENT.WheelsPos			= Vector(0,13,-4)
ENT.Ammo				= -1
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_american_canonsight_01"
ENT.SightPos			= Vector(13.5,15,33)

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
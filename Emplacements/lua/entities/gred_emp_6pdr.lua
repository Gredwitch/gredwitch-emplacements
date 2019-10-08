AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]6pdr Ordnance QF"
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
		MuzzleVelocity = 820,
		Mass = 2.86,
		TracerColor = "white",
	},
	{
		Caliber = 57,
		ShellType = "AP",
		MuzzleVelocity = 853,
		Mass = 3,
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

ENT.MaxRotation			= Angle(27,65)
ENT.HullModel			= "models/gredwitch/6pdr/6pdr_carriage.mdl"
ENT.TurretModel			= "models/gredwitch/6pdr/6pdr_shield.mdl"
ENT.EmplacementType     = "Cannon"
ENT.ATReloadSound    	= "small"
ENT.Spread				= 0.1
ENT.AnimPauseTime		= 0.3
ENT.TurretPos			= Vector(0,50,20)
ENT.WheelsPos			= Vector(0,5,-5)
ENT.WheelsModel			= "models/gredwitch/6pdr/6pdr_wheels.mdl"
ENT.Ammo				= -1
ENT.AddShootAngle		= 0
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_british_canonsight_01"
ENT.SightPos			= Vector(-15,5,22)


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

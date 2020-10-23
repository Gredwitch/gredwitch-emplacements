AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm KwK"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "KwK"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
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

ENT.ShellLoadTime		= 1.3
ENT.AnimPlayTime		= 1.3
ENT.AnimPauseTime		= 0.3

ENT.ShootSound			= "^gred_emp/common/50mm.wav"

ENT.TurretPos			= Vector(0,0,49.8)
ENT.HullModel			= "models/gredwitch/kwk/kwk_base.mdl"
ENT.YawModel			= "models/gredwitch/kwk/kwk_shield.mdl"
ENT.TurretModel			= "models/gredwitch/kwk/kwk_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.ATReloadSound		= "small"
ENT.ViewPos				= Vector(-1.5,-6,30)
ENT.MaxViewModes		= 1
ENT.SightTexture		= "gredwitch/overlay_german_tanksight_01"
ENT.SightPos			= Vector(12,-27,3)
ENT.MaxRotation			= Angle(20,180)
ENT.MinRotation			= Angle(-10,-180)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	local seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
	
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = self:GetAngles()
		view.fov = 20
		view.drawviewer = false

		return view
	else
		if seatValid then
			local view = {}
			view.origin = seat:LocalToWorld(self.ViewPos)
			view.angles = ply:EyeAngles()
			view.angles.r = self:GetAngles().r
			view.fov = fov
			view.drawviewer = false
	 
			return view
		end
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
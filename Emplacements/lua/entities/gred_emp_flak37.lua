AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm Flak 37"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 37"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 4.5
ENT.AmmunitionTypes		= {
	{
		Caliber = 88,
		ShellType = "HE",
		MuzzleVelocity = 820,
		Mass = 11,
		LinearPenetration = 13,
		TNTEquivalent = 0.935,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "APCBC",
		MuzzleVelocity = 820,
		Mass = 9.5,
		TNTEquivalent = 1.6,
		Normalization = 4,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "Smoke",
		MuzzleVelocity = 820,
		Mass = 11,
		TracerColor = "white",
	},
}

ENT.PitchRate			= 10
ENT.YawRate				= 20
ENT.ShellLoadTime		= 1.2
ENT.AnimPlayTime		= 1
ENT.AnimPauseTime		= 0.3
ENT.ATReloadSound		= "big"
ENT.ShootAnim			= "shoot"
ENT.ShootSound			= "^gred_emp/common/88mm.wav"

ENT.TurretPos			= Vector(1.39031,-30.1991,40)
ENT.YawPos				= Vector(0,0,0)

ENT.IsAAA				= true
ENT.HullModel			= "models/gredwitch/flak37/flak37_base.mdl"
ENT.YawModel			= "models/gredwitch/flak37/flak37_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flak37/flak37_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.MaxRotation			= Angle(-20)
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.SightPos			= Vector(30,55,-13)
ENT.AddShootAngle		= 0
ENT.ViewPos				= Vector(-4,0,40)
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_01"
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	ent:GetHull():SetBodygroup(1,math.random(0,1))
	local yaw = ent:GetYaw()
	yaw:SetBodygroup(1,math.random(0,3))
	yaw:SetBodygroup(2,math.random(0,1))
	yaw:SetBodygroup(3,math.random(0,1))
	yaw:SetBodygroup(4,math.random(0,1))
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	local seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
	angles = ply:EyeAngles()
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
	else
		if seatValid then
			local view = {}
			angles.y = angles.y
			angles.p = angles.p
			view.origin = seat:LocalToWorld(self.ViewPos)
			view.angles = angles
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
		surface.DrawTexturedRect(0,-(ScrW-ScrH)*0.5,ScrW,ScrW)
		return ScrW,ScrH
	end
end
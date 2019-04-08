AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M134 Minigun"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.AnimRestartTime		= 0.1
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.015
ENT.TracerColor			= "Red"
ENT.ShootAnim			= "spin"

ENT.EmplacementType		= "MG"
ENT.ShootSound			= "gred_emp/m134/shoot.wav"
ENT.StopShootSound		= "gred_emp/m134/stop.wav"

ENT.HullModel			= "models/gredwitch/M134/M134_tripod.mdl"
ENT.TurretModel				= "models/gredwitch/M134/M134_gun.mdl"

ENT.TurretPos			= Vector(0,0,0)
ENT.Ammo				= -1
ENT.ExtractAngle		= Angle(0,0,0)

-- ENT.SightPos			= Vector(-0.2,-25,11.65)
-- ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = Angle(-ang.r,ang.y+90,ang.p)
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
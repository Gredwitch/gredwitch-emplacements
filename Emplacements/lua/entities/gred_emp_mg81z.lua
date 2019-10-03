AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 81Z"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.0375
ENT.TracerColor			= "Green"
ENT.ExtractAngle		= Angle(110,0,0)

ENT.ShootSound			= "gred_emp/mg81z/shoot.wav"

ENT.RecoilRate			= 1.3
ENT.RecoilRate			= 0.3
ENT.HullModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/mg81z/mg81z_gun.mdl"
ENT.Sequential			= false

ENT.EmplacementType		= "MG"
ENT.Ammo				= -1
ENT.TurretPos			= Vector(0,-3,42)
ENT.SightPos			= Vector(-0.07,-15,7.15)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		angles = ply:EyeAngles()
		angles.p = angles.p - (self:GetRecoil())*0.5
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
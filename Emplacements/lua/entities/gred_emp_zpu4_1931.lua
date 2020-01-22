AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M4 ZPU"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.1
ENT.TracerColor			= "Green"

ENT.RecoilRate			= 0.15
ENT.ShootSound			= "gred_emp/m1910/shoot.wav"
ENT.StopShootSound		= "gred_emp/m1910/stop.wav"

ENT.HullModel			= "models/gredwitch/zpu/zpu_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/zpu/zpu_gun.mdl"

ENT.PitchRate			= 130
ENT.YawRate				= 130
ENT.EmplacementType		= "MG"
ENT.Ammo				= -1
ENT.TurretPos			= Vector(0,0,40)
ENT.SightPos			= Vector(0,-15,28.1)
ENT.MaxViewModes		= 1
ENT.IsAAA				= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
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
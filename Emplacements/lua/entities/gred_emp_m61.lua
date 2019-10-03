AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M61 Vulcan"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.AnimRestartTime		= 0.05
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_20mm"
ENT.ShotInterval		= 0.01
ENT.TracerColor			= "Red"
ENT.ShootAnim			= "spin"

ENT.EmplacementType		= "MG"
ENT.ShootSound			= "gred_emp/phalanx/gun.wav"
ENT.StopShootSound		= "gred_emp/phalanx/gun_sotp.wav"

ENT.HullModel			= "models/gredwitch/m61/m61_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/m61/m61_gun.mdl"
ENT.Recoil				= 0
ENT.Ammo				= -1
ENT.TurretPos			= Vector(0,4.4,18.5)

ENT.SightPos			= Vector(0.15,-25,14.8)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
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
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
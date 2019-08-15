AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]GAU-19 Minigun"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.EjectAngle			= Angle(0,0,0)

ENT.AnimRestartTime		= 0.2
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_12mm"
ENT.ShotInterval		= 0.03
ENT.TracerColor			= "Red"
ENT.ShootAnim			= "spin"

ENT.Recoil				= 0
ENT.ShootSound			= "gred_emp/gau19/shoot.wav"
ENT.StopShootSound		= "gred_emp/gau19/stop.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/M134/M134_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/gau19/gau19.mdl"

ENT.TurretPos			= Vector(0,0,0)
ENT.SightPos			= Vector(-0.2,-25,11.65)
ENT.MaxViewModes		= 1
ENT.Ammo				= -1
ENT.ExtractAngle		= Angle(0,0,0)


function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
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
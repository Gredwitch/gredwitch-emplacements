AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]30mm Artemis 30"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Artemis 30"

ENT.Sequential			= true
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.0375

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_30mm"},
						{"Time-fused","wac_base_30mm"},
}

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_01.wav"

ENT.TurretPos			= Vector(0,0,64)
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/artemis30/artemis30_base.mdl"
ENT.YawModel			= "models/gredwitch/artemis30/artemis30_shield.mdl"
ENT.TurretModel			= "models/gredwitch/artemis30/artemis30_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.TracerColor			= "Yellow"
ENT.Seatable			= true
ENT.MaxRotation			= Angle(-18)
ENT.SightPos			= Vector(-1,70,-10)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
	local a = self:GetAngles()
	local ang = Angle(-a.r,a.y+90,a.p)
	ang:Normalize()
	if (seatValid and seat:GetThirdPersonMode()) or self:GetViewMode() == 1 then
		local view = {}
		
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = ang
		view.fov = 35
		view.drawviewer = true
	
		return view
	else
		if seatValid then
			local view = {}
			view.origin = pos
			view.angles = ang
			view.fov = fov
			view.drawviewer = false
	
			return view
		end
	end
end

AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]40mm Bofors L/60"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Bofors L/60"

ENT.MuzzleEffect		= "ins_weapon_rpg_frontblast"
ENT.ShotInterval		= 0.5
ENT.TracerColor			= "Red"
ENT.Spread				= 0.7
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_40mm"},
						{"Time-fused","wac_base_40mm"},
}

ENT.ShootSound			= "gred_emp/bofors/shoot.wav"
ENT.OnlyShootSound		= true

ENT.HullModel			= "models/gredwitch/bofors/bofors_base.mdl"
ENT.YawModel			= "models/gredwitch/bofors/bofors_shield.mdl"
ENT.TurretModel			= "models/gredwitch/bofors/bofors_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.SightPos			= Vector(37.65,18,15.85)
ENT.ViewPos				= Vector(37.7,0,16)
ENT.MaxRotation			= Angle(-10)
ENT.MaxViewModes		= 1
ENT.CanSwitchTimeFuse	= true
ENT.IsAAA				= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:SetSkin(math.random(0,1))
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	m = math.random(0,2)
	if m == 0 then
		ent:GetHull():SetBodygroup(1,0)
	elseif m == 1 then
		ent:GetHull():SetBodygroup(1,1)
	else
		ent:GetHull():SetBodygroup(1,2)
	end
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
	local a = self:GetAngles()
	local ang = Angle(-a.r+1,a.y+90,a.p)
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
			view.origin =  self:LocalToWorld(self.ViewPos)
			view.angles = ang
			view.fov = fov
			view.drawviewer = false

			return view
		end
	end
end
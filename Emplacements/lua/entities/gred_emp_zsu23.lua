AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm ZU-23-2"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "ZU-23-2"

ENT.Sequential			= true
-- ENT.SeatAngle			= Angle(0,0,0)
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.06
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fused","wac_base_20mm"},
}
ENT.TracerColor			= "Green"

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_01.wav"


ENT.MaxUseDistance		= 200
-- ENT.Seatable			= true
ENT.EmplacementType     = "MG"
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/zsu23/zsu23_turret.mdl"
ENT.YawModel			= "models/gredwitch/zsu23/zsu23_shield.mdl"
ENT.TurretModel			= "models/gredwitch/zsu23/zsu23_gun.mdl"
ENT.TurretPos			= Vector(0,33,43)
ENT.MaxRotation			= Angle(-10)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true

if game.SinglePlayer() then
	ENT.SightPos		= Vector(0,70,10)
else
	ENT.SightPos		= Vector(1,70,10)
end
ENT.ViewPos				= Vector(-30,0,0)
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
	-- seat = self:GetSeat()
	-- local seatValid = IsValid(seat)
	-- if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
	local a = self:GetAngles()
	local ang = Angle(-a.r,a.y+90,a.p)
	ang:Normalize()
	if --[[(seatValid and seat:GetThirdPersonMode()) or]] self:GetViewMode() == 1 then
		local view = {}
		
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = ang
		view.fov = 35
		view.drawviewer = true

		return view
	-- else
		-- if seatValid then
			-- local view = {}
			-- view.origin = seat:LocalToWorld(self.ViewPos)
			-- view.angles = ang
			-- view.fov = fov
			-- view.drawviewer = false

			-- return view
		-- end
	end
end

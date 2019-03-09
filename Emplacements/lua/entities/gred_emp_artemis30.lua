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
						{"Time-fuzed","wac_base_30mm"},
}

ENT.ShootSound			= "gred_emp/artemis30/shoot.wav"
ENT.StopShootSound		= "gred_emp/artemis30/stop.wav"

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
ENT.CanSwitchTimeFuze	= true
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_artemis30" then
				if ent:GetShooter() != ply then return end
				seat = ent:GetSeat()
				local seatValid = IsValid(seat)
				if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
				ang:Normalize()
				if (seatValid and seat:GetThirdPersonMode()) or ent:GetViewMode() == 1 then
					local view = {}
					
					view.origin = ent:LocalToWorld(ent.SightPos)
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
		end
	end
end
hook.Add("CalcView", "gred_emp_artemis30_view", CalcView)

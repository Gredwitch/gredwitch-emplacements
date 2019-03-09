AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]40mm Bofors L/60"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Bofors L/60"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.5
ENT.TracerColor			= "Red"
ENT.Spread				= 0.7
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_40mm"},
						{"Time-fuzed","wac_base_40mm"},
}

ENT.ShootSound			= "gred_emp/bofors/shoot.wav"
ENT.StopShootSound		= "gred_emp/bofors/stop.wav"

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
ENT.CanSwitchTimeFuze	= true
ENT.IsAAA				= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
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

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_bofors" then
				if ent:GetShooter() != ply then return end
				seat = ent:GetSeat()
				local seatValid = IsValid(seat)
				if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
				local a = ent:GetAngles()
				local ang = Angle(-a.r+1,a.y+90,a.p)
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
						view.origin =  ent:LocalToWorld(ent.ViewPos)
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
hook.Add("CalcView", "gred_emp_bofors_view", CalcView)
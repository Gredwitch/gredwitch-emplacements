AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flak 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 38"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.214

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fuzed","wac_base_20mm"},
}
ENT.TracerColor			= "Yellow"

ENT.ShootSound			= "gred_emp/flak38/20mm_shoot.wav"
ENT.StopShootSound		= "gred_emp/flak38/20mm_stop.wav"

ENT.Spread				= 0.5
ENT.Seatable			= true
ENT.EmplacementType		= "MG"
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/flak38/flak38_base.mdl"
ENT.YawModel			= "models/gredwitch/flak38/flak38_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flak38/flak38_gun.mdl"
ENT.TurretPos			= Vector(-0.6,12,20)
ENT.MaxRotation			= Angle(-20)
ENT.SightPos			= Vector(0.5,15,10)
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
	ent:SetSkin(math.random(0,3))
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_flak38" then
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
-- local function CalcView(ply, pos, angles, fov)
	-- if ply:GetViewEntity() != ply then return end
	-- if ply.Gred_Emp_Ent then
		-- local ent = ply.Gred_Emp_Ent
		-- if IsValid(ent) then
			-- if ent:GetClass() == "gred_emp_flak38" then
				-- if ent:GetShooter() != ply then return end
				-- seat = ent:GetSeat()
				-- if !IsValid(seat) then return end
				-- local a = ent:GetAngles()
				-- local ang = Angle(-a.r,a.y+90,a.p)
				-- ang:Normalize()
				-- if ent:GetViewMode() == 1 and not seat:GetThirdPersonMode() then
					-- local view = {}
					
					-- view.origin = ent:LocalToWorld(ent.SightPos)
					-- view.angles = ang
					-- view.fov = 35
					-- view.drawviewer = true

					-- return view
				-- else
					-- if seat:GetThirdPersonMode() then
						-- local view = {}
						-- local camDist = seat:GetCameraDistance()
						-- camDist = camDist*(ent:GetModelRadius()/10)
						-- view.origin = pos
						-- view.angles = ply:EyeAngles()
						-- view.fov = fov
						-- view.drawviewer = true
	 
						-- return view
					-- else
						-- local view = {}
						-- view.origin = pos
						-- view.angles = ang
						-- view.fov = fov
						-- view.drawviewer = false
	 
						-- return view
					-- end
				-- end
			-- end
		-- end
	-- end
-- end
hook.Add("CalcView", "gred_emp_flak38_view", CalcView)
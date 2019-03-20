AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flakvierling 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flakvierling 38"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.0535
ENT.TracerColor			= "Yellow"

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fuzed","wac_base_20mm"},
}

ENT.Sequential			= true
ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_02.wav"

ENT.HullModel			= "models/gredwitch/flakvierling38/flakvierling_base.mdl"
ENT.YawModel			= "models/gredwitch/flakvierling38/flakvierling_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flakvierling38/flakvierling_guns.mdl"
ENT.EmplacementType     = "MG"
ENT.Ammo				= -1
ENT.Seatable			= true
ENT.TurretPos			= Vector(0,15,50)
ENT.MaxRotation			= Angle(-50)
ENT.SightPos			= Vector(0,0,20)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuze	= true
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
	ent:SetSkin(math.random(0,3))
	if math.random(0,1) == 0 then
		ent:GetYaw():SetBodygroup(1,0)
	else
		ent:GetYaw():SetBodygroup(1,1)
	end
	
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_flakvierling38" then
				if ent:GetShooter() != ply then return end
				seat = ent:GetSeat()
				local seatValid = IsValid(seat)
				if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
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
hook.Add("CalcView", "gred_emp_flakvierling38_view", CalcView)
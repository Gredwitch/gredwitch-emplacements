AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M61 Vulcan"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.AnimRestartTime		= 0.05
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_20mm"
ENT.ShotInterval		= 0.01
ENT.TracerColor			= "Red"
ENT.ShootAnim			= "spin"

ENT.EmplacementType		= "MG"
ENT.ShootSound			= "gred_emp/m61/gun.wav"
ENT.StopShootSound		= "gred_emp/m61/gun_stop.wav"

ENT.HullModel			= "models/gredwitch/m61/m61_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/m61/m61_gun.mdl"

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

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_m61" then
			local ent = ply.Gred_Emp_Ent
			if ent:GetShooter() != ply then return end
			if IsValid(ent) then
				if ent:GetViewMode() == 1 then
					local ang = ent:GetAngles()
					local view = {}
					view.origin = ent:LocalToWorld(ent.SightPos)
					view.angles = Angle(-ang.r,ang.y+90,ang.p+1)
					view.fov = 35
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_m61_view", CalcView)
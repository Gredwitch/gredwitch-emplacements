AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 81Z"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.0375
ENT.TracerColor			= "Green"
ENT.ExtractAngle		= Angle(110,0,0)

ENT.ShootSound			= "gred_emp/mg81z/shoot.wav"

ENT.HullModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/mg81z/mg81z_gun.mdl"
ENT.Sequential			= false

ENT.EmplacementType		= "MG"
ENT.Ammo				= -1
ENT.TurretPos			= Vector(0,-3,42)
ENT.SightPos			= Vector(-0.07,-15,7.15)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_mg81z" then
			local ent = ply.Gred_Emp_Ent
			if ent:GetShooter() != ply then return end
			if IsValid(ent) then
				if ent:GetViewMode() == 1 then
					local ang = ent:GetAngles()
					local view = {}
					view.origin = ent:LocalToWorld(ent.SightPos)
					view.angles = Angle(-ang.r,ang.y+90,ang.p)
					view.fov = 35
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_mg81z_view", CalcView)
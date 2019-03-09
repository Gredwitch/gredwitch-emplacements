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
	ent:Spawn()
	ent:Activate()
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_gau19" then
			local ent = ply.Gred_Emp_Ent
			-- print(ent:GetViewMode())
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
hook.Add("CalcView", "gred_emp_gau19_view", CalcView)
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]81mm M1 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "M1 Mortar"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 3.33
ENT.Spread				= 400

ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.HullModel			= "models/gredwitch/m1_mortar/m1_mortar_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/m1_mortar/m1_mortar.mdl"
ENT.EmplacementType     = "Mortar"
ENT.DefaultPitch		= 45
ENT.MaxRotation			= Angle(35,45)
ENT.Ammo				= -1

ENT.AmmunitionTypes		= {
						{"HE","gb_shell_81mm"},
						{"WP","gb_shell_81mmWP"},
						{"Smoke","gb_shell_81mm"}
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 38
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetAngles(Angle(0,0,-12))
	ent:Spawn()
	ent:Activate()
	return ent
end

-- local function CalcView(ply, pos, angles, fov)
	-- if ply:GetViewEntity() != ply then return end
	-- if ply.Gred_Emp_Ent then
		-- if ply.Gred_Emp_Ent.ClassName == "gred_emp_m1mortar" then
			-- local ent = ply.Gred_Emp_Ent
			-- if ent:GetShooter() != ply then return end
			-- if IsValid(ent) then
				-- local a = ply:EyeAngles()
				-- local entAng = ent:GetAngles()
				-- local ang = entAng+a
				-- print(ang)
				-- if ang.y > 120 or ang.y < -120 then
					-- local view = {}

					-- view.origin = pos + Vector(0,0,200)
					-- if ang.y > 70 or ang.y < 110 then
						-- view.angles = ent.oldA
					-- else
						-- ent.oldA = a
						-- view.angles = a
					-- end
					-- view.fov = fov
					-- view.drawviewer = true

					-- return view
				-- end
			-- end
		-- end
	-- end
-- end
-- hook.Add("CalcView", "gred_emp_m1mortar_view", CalcView)
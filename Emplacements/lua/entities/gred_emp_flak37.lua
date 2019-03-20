AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm Flak 37"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 37"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.5
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_88mm"},
						{"AP","gb_shell_88mm"},
						{"Smoke","gb_shell_88mm"}
}

ENT.ShellLoadTime		= 1.2
ENT.AnimPlayTime		= 1
ENT.AnimPauseTime		= 0.3
ENT.ATReloadSound		= "big"
ENT.ShootAnim			= "shoot"
ENT.ShootSound			= "gred_emp/common/88mm.wav"

ENT.TurretPos			= Vector(1.39031,-30.1991,40)
ENT.YawPos				= Vector(0,0,0)

ENT.IsAAA				= true
ENT.HullModel			= "models/gredwitch/flak37/flak37_base.mdl"
ENT.YawModel			= "models/gredwitch/flak37/flak37_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flak37/flak37_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.MaxRotation			= Angle(-20)
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.SightPos			= Vector(-1.3,30,23)
ENT.AddShootAngle		= 2

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	ent:GetHull():SetBodygroup(1,math.random(0,1))
	local yaw = ent:GetYaw()
	yaw:SetBodygroup(1,math.random(0,3))
	yaw:SetBodygroup(2,math.random(0,1))
	yaw:SetBodygroup(3,math.random(0,1))
	yaw:SetBodygroup(4,math.random(0,1))
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_flak37" then
				if ent:GetShooter() != ply then return end
				seat = ent:GetSeat()
				if !IsValid(seat) then return end
				local a = ent:GetAngles()
				local ang = Angle(-a.r+0.5,a.y+90,a.p)
				ang:Normalize()
				if seat:GetThirdPersonMode() then
					local view = {}
					
					view.origin = ent:LocalToWorld(ent.SightPos)
					view.angles = ang
					view.fov = 35
					view.drawviewer = true

					return view
				else
					local view = {}
					view.origin = ply:LocalToWorld(Vector(6,6,30))
					view.angles = ang
					view.fov = fov
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_flak37_view", CalcView)
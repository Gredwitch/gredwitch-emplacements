AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm KwK"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "KwK"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
						{"HE","gb_shell_50mm"},
						{"AP","gb_shell_50mm"},
						{"Smoke","gb_shell_50mm"}
}
ENT.ShootAnim			= "shoot"

ENT.ShellLoadTime		= 1.7
ENT.AnimPlayTime		= 1.3
ENT.AnimPauseTime		= 0.3

ENT.ShootSound			= "gred_emp/common/50mm.wav"

ENT.TurretPos			= Vector(0,0,49.8)
ENT.HullModel			= "models/gredwitch/kwk/kwk_base.mdl"
ENT.YawModel			= "models/gredwitch/kwk/kwk_shield.mdl"
ENT.TurretModel			= "models/gredwitch/kwk/kwk_gun.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Seatable			= true
ENT.ATReloadSound		= "small"
ENT.SightPos			= Vector(0,10,5)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_kwk" then
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
hook.Add("CalcView", "gred_emp_kwk_view", CalcView)
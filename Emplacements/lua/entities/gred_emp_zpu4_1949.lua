AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]14mm ZPU-4 (1949)"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "ZPU-4"

ENT.Sequential			= true
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.025
ENT.TracerColor			= "Green"
ENT.AmmunitionType		= "wac_base_12mm"

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_02.wav"

ENT.PitchRate			= 120
ENT.YawRate				= 120
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/zpu4_1949/zpu4_base.mdl"
ENT.YawModel			= "models/gredwitch/zpu4_1949/zpu4_shield.mdl"
ENT.TurretModel			= "models/gredwitch/zpu4_1949/zpu4_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxRotation			= Angle(-10)

ENT.SightPos			= Vector(-0.25,27,5)
ENT.TurretPos			= Vector(0,0,50)
ENT.IsAAA				= true
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
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
	angles = ply:EyeAngles()
	if self:GetViewMode() == 1 then
		local view = {}
		local ang = self:GetAngles()
		angles.p = -ang.r
		angles.y = ang.y + 90
		angles.r = -ang.p
		
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 35
		view.drawviewer = true

		return view
	else
		if seatValid then
			local view = {}
			view.origin = pos
			view.angles = angles
			view.fov = fov
			view.drawviewer = false

			return view
		end
	end
end
function ENT:HUDPaint(ply,viewmode)
	if viewmode == 1 then
		local ScrW,ScrH = ScrW(),ScrH()
		-- surface.SetDrawColor(255,255,255,255)
		-- surface.SetTexture(surface.GetTextureID(self.SightTexture))
		-- surface.DrawTexturedRect(0,-(ScrW-ScrH)*0.5,ScrW,ScrW)
		return ScrW,ScrH
	end
end
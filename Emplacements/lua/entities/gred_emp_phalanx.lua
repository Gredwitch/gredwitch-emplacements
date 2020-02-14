AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Phalanx CIWS"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.AnimRestartTime		= 0.3
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fused","wac_base_20mm"},
}
ENT.CanSwitchTimeFuse	= true
ENT.NameToPrint			= "Phalanx CIWS"
ENT.ShotInterval		= 0.01
ENT.TracerColor			= "Red"
ENT.ShootAnim			= "spin"

ENT.EmplacementType		= "MG"
ENT.ShootSound			= "gred_emp/phalanx/shoot.wav"
ENT.StopShootSound		= "gred_emp/phalanx/stop.wav"

ENT.HullModel			= "models/gredwitch/phalanx/phalanx_hull.mdl"
ENT.YawModel			= "models/gredwitch/phalanx/phalanx_yaw.mdl"
ENT.TurretModel			= "models/gredwitch/phalanx/phalanx_turret.mdl"

ENT.Seatable			= true
ENT.MaxUseDistance		= 200
ENT.Spread				= 0.4
ENT.Ammo				= -1

ENT.IsAAA				= true
ENT.ViewPos				= Vector(30,0,30)
ENT.SightPos			= Vector(30,0,30)
ENT.MaxViewModes		= 1
ENT.MaxRotation			= Angle(85,180)
ENT.MinRotation			= Angle(-25,-180)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end
local Hidden = Color(255,255,255,0)
local NotHidden = Color(255,255,255,255)

function ENT:OnGrabTurret(ply,botmode)
	if !botmode then
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor(Hidden)
	end
end
function ENT:OnLeaveTurret(ply,notbotmode)
	if notbotmode then
		ply:SetRenderMode(RENDERMODE_NORMAL)
		ply:SetColor(NotHidden)
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	local seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
	
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = self:GetAngles()
		view.fov = 35
		view.drawviewer = false

		return view
	else
		if seatValid then
			local view = {}
			view.origin = self:LocalToWorld(self.ViewPos)
			view.angles = ply:EyeAngles()
			view.angles.r = self:GetAngles().r
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
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm ZU-23-2"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "ZU-23-2"

ENT.Sequential			= true
-- ENT.SeatAngle			= Angle(0,0,0)
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.06
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fused","wac_base_20mm"},
}
ENT.TracerColor			= "Green"

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_01.wav"

ENT.Recoil				= 0
ENT.PitchRate			= 100
ENT.YawRate				= 100
ENT.MaxUseDistance		= 200
ENT.Seatable			= true
ENT.EmplacementType     = "MG"
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/zsu23/zsu23_turret.mdl"
ENT.YawModel			= "models/gredwitch/zsu23/zsu23_shield.mdl"
ENT.TurretModel			= "models/gredwitch/zsu23/zsu23_gun.mdl"
ENT.TurretPos			= Vector(87.0727*0.32,0,129.025*0.32)
ENT.YawPos				= Vector(14.5429*0.32,0,0)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true
ENT.SightPos			= Vector(70,0,10)
ENT.MaxViewModes		= 1
ENT.MaxRotation			= Angle(90,180)
ENT.MinRotation			= Angle(-10,-180)


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

function ENT:OnThinkCL()
	local yaw = self:GetYaw()
	if !IsValid(yaw) then return end
	local hull = self:GetHull()
	if !IsValid(hull) then return end
	local ang = hull:WorldToLocalAngles(self:GetAngles())
	
	-- for i=0, yaw:GetBoneCount()-1 do
		-- print( i, yaw:GetBoneName( i ) )
	-- end
	yaw:ManipulateBoneAngles(3,Angle(ang.y*15))
	yaw:ManipulateBoneAngles(4,Angle(0,0,ang.p*15))
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
		view.fov = 20
		view.drawviewer = false

		return view
	else
		if seatValid then
			local view = {}
			view.origin = pos
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
		-- surface.DrawTexturedRect((-(ScrW*1.25-ScrW)*0.5),(-(ScrW*1.25-ScrH)*0.5),ScrW*1.25,ScrW*1.25)
		return ScrW,ScrH
	end
end

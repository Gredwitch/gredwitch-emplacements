AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Breda 35"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Breda 35"
ENT.SeatAngle			= Angle(0,0,0)
ENT.ExtractAngle		= Angle(90,-90,0)

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.25

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fused","wac_base_20mm"},
}
ENT.PitchRate			= 60
ENT.YawRate				= 60
ENT.TracerColor			= "Yellow"
ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/breda35/shoot.wav"

ENT.Ammo				= -1
ENT.Spread				= 0.5
ENT.Seatable			= true
ENT.EmplacementType		= "MG"
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/breda35/breda35_hull.mdl"
ENT.YawModel			= "models/gredwitch/breda35/breda35_yaw.mdl"
ENT.AimsightModel		= "models/gredwitch/breda35/breda35_aimsight.mdl"
ENT.TurretModel			= "models/gredwitch/breda35/breda35_gun.mdl"
ENT.TurretPos			= Vector(3.63057,0,24)
ENT.ViewPos				= Vector(0,0,35)
ENT.SightPos			= Vector(-10,2.36,2.58)
ENT.AimSightPos			= Vector(-22,-6.5,41.5)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true
ENT.MaxViewModes		= 1
ENT.MaxRotation			= Angle(80,180)
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
	ent:SetSkin(math.random(0,3))
	return ent
end

function ENT:AddDataTables()
	self:NetworkVar("Entity",10,"AimSight")
end

function ENT:AddOnPartsInit(pos,ang,hull,yaw)
	local aimsight = ents.Create("gred_prop_emp")
	aimsight.GredEMPBaseENT = self
	aimsight:SetModel(self.AimsightModel)
	aimsight:SetAngles(yaw:GetAngles())
	aimsight:SetPos(yaw:LocalToWorld(self.AimSightPos))
	aimsight:Spawn()
	
	aimsight:Activate()
	aimsight:SetParent(yaw)
	
	self:SetAimSight(aimsight)
	self:AddEntity(aimsight)
end

function ENT:OnTick(ct,ply,botmode)
	local aimsight = self:GetAimSight()
	local ang = aimsight:GetAngles()
	ang.p = self:GetAngles().p
	-- ang.r = 0
	aimsight:SetAngles(ang)
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	local seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
	
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:GetAimSight():LocalToWorld(self.SightPos)
		view.angles = self:GetAngles()
		view.fov = 20
		view.drawviewer = false

		return view
	else
		if seatValid then
			local view = {}
			view.origin = seat:LocalToWorld(self.ViewPos)
			view.angles = ply:EyeAngles()
			view.angles.r = self:GetAngles().r
			view.fov = fov
			view.drawviewer = false
	 
			return view
		end
	end
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
	
	yaw:ManipulateBoneAngles(4,Angle(ang.y*15))
	yaw:ManipulateBoneAngles(5,Angle(ang.p*15))
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
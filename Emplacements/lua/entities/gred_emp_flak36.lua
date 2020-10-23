	AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]37mm Flak 36"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 36"

-- ENT.SeatAngle			= Angle(180,90,-90)
ENT.ExtractAngle		= Angle(0,0,0)
ENT.MuzzleEffect		= "ins_weapon_rpg_frontblast"
ENT.ShotInterval		= 0.375
ENT.TracerColor			= "Yellow"
ENT.ShootAnim			= "shoot"
ENT.Spread				= 0.7
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_40mm"},
						{"Time-fused","wac_base_40mm"},
}

ENT.PitchRate			= 40
ENT.YawRate				= 40
ENT.ShootSound			= "gred_emp/flak36/shoot.wav"
ENT.OnlyShootSound		= true

ENT.HullModel			= "models/gredwitch/flak36/flak36_hull.mdl"
ENT.YawModel			= "models/gredwitch/flak36/flak36_yaw.mdl"
ENT.TurretModel			= "models/gredwitch/flak36/flak36_turret.mdl"
ENT.AimsightModel		= "models/gredwitch/flak36/flak36_aimsight.mdl"
ENT.EmplacementType     = "MG"
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.ViewPos				= Vector(2,0,30)
ENT.TurretPos			= Vector(-2,0,24.6584)
ENT.MaxViewModes		= 1
ENT.CanSwitchTimeFuse	= true
ENT.IsAAA				= true
ENT.AimSightPos			= Vector(-37,0,39)
ENT.SightPos			= Vector(5,-22,5)
ENT.MaxRotation			= Angle(90,180)
ENT.MinRotation			= Angle(-10,-180)

-- function ENT:AltShootAngles(ply)
	-- local ang = ply:EyeAngles()
	-- return ang
-- end


function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	m = math.random(0,3)
	local yaw = ent:GetYaw()
	yaw:SetBodygroup(1,math.random(0,1))
	if m == 0 then
		yaw:SetBodygroup(3,0)
		yaw:SetBodygroup(2,0)
	elseif m == 1 then
		yaw:SetBodygroup(3,1)
		yaw:SetBodygroup(2,0)
	elseif m == 2 then
		yaw:SetBodygroup(3,0)
		yaw:SetBodygroup(2,1)
	else
		yaw:SetBodygroup(3,1)
		yaw:SetBodygroup(2,1)
	end
	return ent
end

function ENT:AddDataTables()
	self:NetworkVar("Entity",10,"AimSight")
end

function ENT:AddOnPartsInit(pos,ang,hull,yaw)
	local aimsight = ents.Create("gred_prop_emp")
	aimsight.GredEMPBaseENT = self
	aimsight:SetAngles(yaw:GetAngles())
	aimsight:SetPos(yaw:LocalToWorld(self.AimSightPos))
	aimsight:Spawn()
	
	aimsight:Activate()
	aimsight:SetParent(yaw)
	aimsight:SetModel(self.AimsightModel)
	
	self:SetAimSight(aimsight)
	self:AddEntity(aimsight)
end

function ENT:OnTick(ct,ply,botmode)
	local aimsight = self:GetAimSight()
	local ang = aimsight:GetAngles()
	ang.p = self:GetAngles().p
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
	
	yaw:ManipulateBoneAngles(4,Angle(0,0,ang.y*15))
	yaw:ManipulateBoneAngles(5,Angle(0,0,ang.p*15))
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
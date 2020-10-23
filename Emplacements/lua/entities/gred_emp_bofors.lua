AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]40mm Bofors L/60"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Bofors L/60"

ENT.ExtractAngle		= Angle()
ENT.ShootAnim			= "shoot"
ENT.MuzzleEffect		= "ins_weapon_rpg_frontblast"
ENT.ShotInterval		= 0.5
ENT.TracerColor			= "Red"
ENT.Spread				= 0.7
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_40mm"},
						{"Time-fused","wac_base_40mm"},
}

ENT.PitchRate			= 20
ENT.YawRate				= 30
ENT.ShootSound			= "gred_emp/bofors/shoot.wav"
ENT.OnlyShootSound		= true

ENT.HullModel			= "models/gredwitch/bofors/bofors_base_open.mdl"
ENT.YawModel			= "models/gredwitch/bofors/bofors_turret.mdl"
ENT.TurretModel			= "models/gredwitch/bofors/bofors_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.SightPos			= Vector(0,-26.96,13.76)
ENT.ViewPos				= Vector(0,-0.1,40.9)
ENT.TurretPos			= Vector(-7,-0,37.1763)
ENT.MaxViewModes		= 1
ENT.CanSwitchTimeFuse	= true
ENT.IsAAA				= true
ENT.WheelsPos			= Vector(-78,5,-6)
ENT.WheelsPos2			= Vector(62,0,-6)
ENT.WheelsModel			= "models/gredwitch/bofors/bofors_wheels_front.mdl"
ENT.WheelsModel2		= "models/gredwitch/bofors/bofors_wheels_rear.mdl"
ENT.MaxRotation			= Angle(90,180)
ENT.MinRotation			= Angle(-5,-180)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:SetSkin(math.random(0,1))
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

local vector_zero = Vector(0,0,0)
local vector_axis = Vector(0,1,0)

function ENT:InitWheels(ang,hull)
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel)
	wheels:SetAngles(ang)
	wheels:SetPos(hull:LocalToWorld(self.WheelsPos))
	wheels.BaseEntity = self
	wheels:Spawn()
	wheels:Activate()
	local phy = wheels:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.WheelsMass)
	end
	
	self:SetWheels(wheels)
	self:AddEntity(wheels)
	constraint.Axis(wheels,self:GetHull(),0,0,vector_zero,self:WorldToLocal(wheels:LocalToWorld(vector_zero)),0,0,10,1,vector_axis)
	
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel2)
	wheels:SetAngles(ang)
	wheels:SetPos(hull:LocalToWorld(self.WheelsPos2))
	wheels.BaseEntity = self
	wheels:Spawn()
	wheels:Activate()
	local phy = wheels:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.WheelsMass)
	end
	
	self:SetWheels(wheels)
	self:AddEntity(wheels)
	constraint.Axis(wheels,self:GetHull(),0,0,vector_zero,self:WorldToLocal(wheels:LocalToWorld(vector_zero)),0,0,10,1,vector_axis)
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
	
	-- print(yaw:GetBoneName(1))
	yaw:ManipulateBoneAngles(3,Angle(0,0,ang.y*15))
	yaw:ManipulateBoneAngles(4,Angle(0,0,ang.p*15))
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
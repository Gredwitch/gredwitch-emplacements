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

ENT.HullModel			= "models/gredwitch/bofors/bofors_base.mdl"
ENT.YawModel			= "models/gredwitch/bofors/bofors_turret.mdl"
ENT.TurretModel			= "models/gredwitch/bofors/bofors_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.SightPos			= Vector(26.92,0,13.75)
ENT.ViewPos				= Vector(0,-0.1,40.9)
ENT.TurretPos			= Vector(-0,-7,37.1763)
ENT.MaxViewModes		= 1
ENT.CanSwitchTimeFuse	= true
ENT.IsAAA				= true
ENT.WheelsPos1			= Vector(-10,-80.884,-46)
ENT.WheelsPos2			= Vector(-10,59.6308,-46)
ENT.WheelsModel1		= "models/gredwitch/bofors/bofors_wheels_front.mdl"
ENT.WheelsModel2		= "models/gredwitch/bofors/bofors_wheels_rear.mdl"

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

function ENT:CustomAng(ply,ang,hull,hullang)
	ang = ply:EyeAngles()
	ang.y = ang.y - self:GetYaw():GetAngles().y
	ang:RotateAroundAxis(ang:Up(),-90)
	ang.p = 0
	ang.r = ang.r + hullang.r
	
	return ang
end

function ENT:InitWheels(ang)
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel1)
	wheels:SetAngles(ang)
	wheels:SetPos(self:LocalToWorld(self.WheelsPos1))
	wheels.BaseEntity = self
	wheels:Spawn()
	wheels:Activate()
	local phy = wheels:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.WheelsMass)
	end
	
	self:SetWheels(wheels)
	self:AddEntity(wheels)
	constraint.Axis(wheels,self:GetHull(),0,0,Vector(0,0,0),self:WorldToLocal(wheels:LocalToWorld(Vector(0,1,0))),0,0,10,1,Vector(90,0,0))
	
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel2)
	wheels:SetAngles(ang)
	wheels:SetPos(self:LocalToWorld(self.WheelsPos2))
	wheels.BaseEntity = self
	wheels:Spawn()
	wheels:Activate()
	local phy = wheels:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.WheelsMass)
	end
	
	self:SetWheels(wheels)
	self:AddEntity(wheels)
	constraint.Axis(wheels,self:GetHull(),0,0,Vector(0,0,0),self:WorldToLocal(wheels:LocalToWorld(Vector(0,1,0))),0,0,10,1,Vector(90,0,0))
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	local seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
	angles = ply:EyeAngles()
	angles.y = angles.y - 5
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		angles.p = -ang.r
		angles.y = ang.y + 90
		angles.r = -ang.p
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 20
		view.drawviewer = false

		return view
	else
		if seatValid then
			local view = {}
			view.origin = seat:LocalToWorld(self.ViewPos)
			view.angles = angles
			view.fov = fov
			view.drawviewer = false
	 
			return view
		end
	end
end
function ENT:OnThinkCL()
	local yaw = self:GetYaw()
	local ang = self:GetHull():WorldToLocalAngles(self:GetAngles())
	
	-- print(yaw:GetBoneName(1))
	yaw:ManipulateBoneAngles(3,Angle(0,0,ang.y*30))
	yaw:ManipulateBoneAngles(4,Angle(0,0,ang.r*30))
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
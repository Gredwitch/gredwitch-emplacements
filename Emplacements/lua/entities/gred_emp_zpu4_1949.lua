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

ENT.SightPos			= Vector(27,0,0)
ENT.TurretPos			= Vector(1.949830,0,53.4302)
ENT.IsAAA				= true
ENT.MaxViewModes		= 1
ENT.WheelsPos			= Vector(49.9752,0, -34)
ENT.WheelsPos2			= Vector(-49.9752,0,-34)
ENT.WheelsModel			= "models/gredwitch/zpu4_1949/zpu4_wb.mdl"
ENT.WheelsModel2		= "models/gredwitch/zpu4_1949/zpu4_wf.mdl"
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
	yaw:ManipulateBoneAngles(2,Angle(0,0,ang.y*15))
	yaw:ManipulateBoneAngles(3,Angle(0,0,ang.p*15))
end

function ENT:InitWheels(ang)
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel)
	wheels:SetAngles(ang)
	wheels:SetPos(self:LocalToWorld(self.WheelsPos))
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
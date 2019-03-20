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
ENT.ExtractAngle		= Angle(90,0,0)

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.25

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fuzed","wac_base_20mm"},
}
ENT.TracerColor			= "Yellow"
ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/breda35/shoot.wav"

ENT.Spread				= 0.5
ENT.Seatable			= true
ENT.EmplacementType		= "MG"
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/breda35/breda35_hull.mdl"
ENT.YawModel			= "models/gredwitch/breda35/breda35_yaw.mdl"
ENT.AimsightModel		= "models/gredwitch/breda35/breda35_aimsight.mdl"
ENT.TurretModel			= "models/gredwitch/breda35/breda35_gun.mdl"
ENT.TurretPos			= Vector(0,3.63057,24)
ENT.MaxRotation			= Angle(-20)
ENT.ViewPos				= Vector(32,0,35)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuze	= true
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
	ent:SetSkin(math.random(0,3))
	return ent
end

function ENT:AddDataTables()
	self:NetworkVar("Entity",10,"AimSight")
end

function ENT:OnInit()
	local yaw = self:GetYaw()
	local aimsight = ents.Create("gred_prop_emp")
	aimsight.GredEMPBaseENT = self
	aimsight:SetModel(self.AimsightModel)
	aimsight:SetAngles(yaw:GetAngles())
	aimsight:SetPos(yaw:LocalToWorld(Vector(1,-18,38.8094)))
	aimsight:Spawn()
	
	aimsight:Activate()
	aimsight:SetParent(yaw)
	
	self:SetAimSight(aimsight)
	self:AddEntity(aimsight)
end

function ENT:OnTick(ct,ply,botmode)
	local aimsight = self:GetAimSight()
	local ang = aimsight:GetAngles()
	ang.r = self:GetAngles().r
	aimsight:SetAngles(ang)
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:GetClass() == "gred_emp_breda35" then
				if ent:GetShooter() != ply then return end
				seat = ent:GetSeat()
				local seatValid = IsValid(seat)
				if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
				ang:Normalize()
				if (seatValid and seat:GetThirdPersonMode()) or ent:GetViewMode() == 1 then
					local view = {}
					
					view.origin = ent:GetAimSight():LocalToWorld(Vector(-2.35,-10,2.59))
					view.angles = ang
					view.fov = 35
					view.drawviewer = false

					return view
				else
					if seatValid then
						local view = {}
						local yaw = ent:GetYaw()
						view.origin = yaw:GetPos() + yaw:GetForward()*ent.ViewPos.y + yaw:GetRight()*ent.ViewPos.x + yaw:GetUp()*ent.ViewPos.z --seat:LocalToWorld(ent.ViewPos)
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
hook.Add("CalcView", "gred_emp_breda35_view", CalcView)
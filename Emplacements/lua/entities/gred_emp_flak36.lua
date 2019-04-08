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
ENT.Spread				= 0.7
ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_40mm"},
						{"Time-fused","wac_base_40mm"},
}

ENT.ShootSound			= "gred_emp/flak36/shoot.wav"
ENT.OnlyShootSound		= true

ENT.HullModel			= "models/gredwitch/flak36/flak36_hull.mdl"
ENT.YawModel			= "models/gredwitch/flak36/flak36_yaw.mdl"
ENT.TurretModel			= "models/gredwitch/flak36/flak36_turret.mdl"
ENT.AimsightModel		= "models/gredwitch/flak36/flak36_aimsight.mdl"
ENT.EmplacementType     = "MG"
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.ViewPos				= Vector(45,25,40)
ENT.TurretPos			= Vector(0,-2,24.6584)
ENT.SightPos			= Vector(0,-37,39)
ENT.MaxRotation			= Angle(-10)
ENT.MaxViewModes		= 1
ENT.CanSwitchTimeFuse	= true
ENT.IsAAA				= true
ENT.AimSightPos			= Vector(22,6,4.7)

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

function ENT:OnInit()
	local yaw = self:GetYaw()
	local aimsight = ents.Create("gred_prop_emp")
	aimsight.GredEMPBaseENT = self
	aimsight:SetAngles(yaw:GetAngles())
	aimsight:SetPos(yaw:LocalToWorld(self.SightPos))
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
	ang.r = self:GetAngles().r
	aimsight:SetAngles(ang)
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
	local a = self:GetAngles()
	local ang = Angle(-a.r,a.y+90,a.p)
	ang:Normalize()
	if (seatValid and seat:GetThirdPersonMode()) or self:GetViewMode() == 1 then
		local view = {}
		
		view.origin = self:GetAimSight():LocalToWorld(self.AimSightPos)
		view.angles = ang
		view.fov = 35
		view.drawviewer = false

		return view
	else
		if seatValid then
			local view = {}
			local yaw = self:GetYaw()
			view.origin = yaw:GetPos() + yaw:GetForward()*self.ViewPos.y + yaw:GetRight()*self.ViewPos.x + yaw:GetUp()*self.ViewPos.z --seat:LocalToWorld(self.ViewPos)
			view.angles = ang
			view.fov = fov
			view.drawviewer = false

			return view
		end
	end
end
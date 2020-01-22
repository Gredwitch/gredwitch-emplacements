AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flakvierling 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flakvierling 38"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.0535
ENT.TracerColor			= "Yellow"

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fused","wac_base_20mm"},
}

ENT.PitchRate			= 30
ENT.YawRate				= 60
ENT.Sequential			= true
ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_02.wav"

ENT.AimsightModel		= "models/gredwitch/flakvierling38/flakvierling_sight.mdl"
ENT.AimsightModel2		= "models/gredwitch/flakvierling38/flakvierling_sight2.mdl"
ENT.HullModel			= "models/gredwitch/flakvierling38/flakvierling_base.mdl"
ENT.YawModel			= "models/gredwitch/flakvierling38/flakvierling_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flakvierling38/flakvierling_guns.mdl"
ENT.EmplacementType     = "MG"
ENT.Ammo				= -1
ENT.Seatable			= true
ENT.TurretPos			= Vector(0,15,50)
ENT.MaxRotation			= Angle(-50)
ENT.SightPos			= Vector(0,0,20)
ENT.AimSightPos			= Vector(-12.6561,-23.561,63.7105)
ENT.AimSightPos2		= Vector(5.09928,13.2088,4.36973)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true
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
	if math.random(0,1) == 0 then
		ent:GetYaw():SetBodygroup(1,0)
	else
		ent:GetYaw():SetBodygroup(1,1)
	end
	
	return ent
end

function ENT:AddDataTables()
	self:NetworkVar("Entity",10,"AimSight")
	self:NetworkVar("Entity",11,"AimSight2")
end

function ENT:OnInit()
	local yaw = self:GetYaw()
	local ang = yaw:GetAngles()
	local aimsight = ents.Create("gred_prop_emp")
	aimsight.GredEMPBaseENT = self
	aimsight:SetModel(self.AimsightModel)
	aimsight:SetAngles(ang)
	aimsight:SetPos(yaw:LocalToWorld(self.AimSightPos))
	aimsight:Spawn()
	
	aimsight:Activate()
	aimsight:SetParent(yaw)
	
	self:SetAimSight(aimsight)
	self:AddEntity(aimsight)
	
	local aimsight2 = ents.Create("gred_prop_emp")
	aimsight2.GredEMPBaseENT = self
	aimsight2:SetModel(self.AimsightModel2)
	aimsight2:SetAngles(ang)
	aimsight2:SetPos(aimsight:LocalToWorld(self.AimSightPos2))
	aimsight2:Spawn()
	
	aimsight2:Activate()
	aimsight2:SetParent(aimsight)
	
	self:SetAimSight2(aimsight2)
	self:AddEntity(aimsight2)
end

if SERVER then
	function ENT:OnTick(ct,ply,botmode)
		local aimsight = self:GetAimSight()
		local ang = aimsight:GetAngles()
		ang.r = self:GetAngles().r
		local r2 = ang.r
		ang.r = ang.r*0.745 - 29
		aimsight:SetAngles(ang)
		ang.r = r2
		self:GetAimSight2():SetAngles(ang)
		
	end
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
			view.origin = pos - angles:Forward() * 10 - angles:Right() * -0.15
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
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm Flak 37"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 37"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 4.5
ENT.AmmunitionTypes		= {
	{
		Caliber = 88,
		ShellType = "HE",
		MuzzleVelocity = 820,
		Mass = 11,
		LinearPenetration = 13,
		TNTEquivalent = 0.935,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "APCBC",
		MuzzleVelocity = 820,
		Mass = 9.5,
		TNTEquivalent = 1.6,
		Normalization = 4,
		TracerColor = "white",
	},
	{
		Caliber = 88,
		ShellType = "Smoke",
		MuzzleVelocity = 820,
		Mass = 11,
		TracerColor = "white",
	},
}

ENT.PitchRate			= 10
ENT.YawRate				= 20
ENT.ShellLoadTime		= 1.2
ENT.AnimPlayTime		= 1
ENT.AnimPauseTime		= 0.3
ENT.ATReloadSound		= "big"
ENT.ShootAnim			= "shoot"
ENT.ShootSound			= "^gred_emp/common/88mm.wav"

ENT.TurretPos			= Vector(-30.1991,-2,80)
ENT.YawPos				= Vector(0,0,0)

ENT.IsAAA				= true
ENT.HullModel			= "models/gredwitch/flak37/flak37_base.mdl"
ENT.YawModel			= "models/gredwitch/flak37/flak37_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flak37/flak37_gun.mdl"
ENT.AimsightModel		= "models/gredwitch/flak37/flak37_aimsight.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.Seatable			= true
ENT.Ammo				= -1
ENT.SightPos			= Vector(30,55,-13)
ENT.AddShootAngle		= 0
ENT.ViewPos				= Vector(-4,0,40)
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_01"
ENT.MaxViewModes		= 1
ENT.AimSightPos			= Vector(15.3851,-26.8885,66.7237)
ENT.MaxRotation			= Angle(85,180)
ENT.MinRotation			= Angle(-8,-180)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	ent:GetHull():SetBodygroup(1,math.random(0,1))
	local yaw = ent:GetYaw()
	yaw:SetBodygroup(1,math.random(0,3))
	yaw:SetBodygroup(2,math.random(0,1))
	yaw:SetBodygroup(3,math.random(0,1))
	yaw:SetBodygroup(4,math.random(0,1))
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

if SERVER then
	function ENT:OnTick(ct,ply,botmode)
		local aimsight = self:GetAimSight()
		local ang = aimsight:GetAngles()
		ang.p = self:GetAngles().p
		aimsight:SetAngles(ang)
		
		self:SetBodygroup(1,self.MagIn and 0 or 1)
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

function ENT:HUDPaint(ply,viewmode)
	if viewmode == 1 then
		local ScrW,ScrH = ScrW(),ScrH()
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(surface.GetTextureID(self.SightTexture))
		surface.DrawTexturedRect((-(ScrW*1.25-ScrW)*0.5),(-(ScrW*1.25-ScrH)*0.5),ScrW*1.25,ScrW*1.25)
		return ScrW,ScrH
	end
end

function ENT:OnThinkCL()
	local yaw = self:GetYaw()
	if !IsValid(yaw) then return end
	local hull = self:GetHull()
	if !IsValid(hull) then return end
	local ang = hull:WorldToLocalAngles(self:GetAngles())
	
	yaw:ManipulateBoneAngles(7,Angle(ang.y*60))
	yaw:ManipulateBoneAngles(6,Angle(ang.p*90))
end
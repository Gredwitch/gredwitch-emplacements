AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]150mm Nebelwerfer 41"

ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "Nebelwerfer"
ENT.MuzzleEffect		= "ins_weapon_at4_frontblast"
ENT.AmmunitionTypes		= {
	{
		Caliber = 150,
		ShellType = "HE",
		Entity = "gb_rocket_nebel",
	},
	{
		Caliber = 150,
		ShellType = "Smoke",
		Entity = "gb_rocket_nebel",
	},
}
ENT.IsHowitzer			= true
ENT.IsRocketLauncher	= true
ENT.ShotInterval		= 1

ENT.ShootSound			= "gred_emp/common/empty.wav"

ENT.HullModel			= "models/gredwitch/nebelwerfer/nebelwerfer_base_open.mdl"
ENT.TurretModel			= "models/gredwitch/nebelwerfer/nebelwerfer_tubes.mdl"
ENT.YawModel			= "models/gredwitch/nebelwerfer/nebelwerfer_yaw.mdl"
ENT.Sequential			= true

ENT.YawPos				= Vector(1.43531,0,14.7211)
ENT.TurretPos			= Vector(1.30202,0,27.1435)
ENT.WheelsModel			= "models/gredwitch/nebelwerfer/nebelwerfer_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,17.3949)
ENT.PitchRate			= 30
ENT.YawRate				= 30
ENT.EmplacementType		= "Cannon"
ENT.Ammo				= 6
ENT.SightPos			= Vector(-30,0,22)
ENT.MaxViewModes		= 1
ENT.AddShootAngle		= 4
ENT.MaxRotation			= Angle(45,27)
ENT.MinRotation			= Angle(-5,-27) -- actually 5 for elevation

ENT.SmokeExploSNDs		= {}
ENT.SmokeExploSNDs[1]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
ENT.SmokeExploSNDs[2]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
ENT.SmokeExploSNDs[3]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
ENT.SmokeExploSNDs[4]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

function ENT:AddDataTables()
	self:NetworkVar("Float",11,"MaxRange", { KeyName = "MaxRange", Edit = { type = "Float", order = 0,min = 0, max = 5, category = "Ammo"} } )
	self:NetworkVar("Float",12,"ReloadTime", { KeyName = "ReloadTime", Edit = { type = "Float", order = 0,min = 0, max = 300, category = "Ammo"} } )
	self:NetworkVar("Bool",10,"AutoFire", { KeyName = "AutoFire", Edit = {type = "Boolean", order = 0, category = "Ammo"} } )
	self:SetMaxRange(2)
	self:SetReloadTime(10)
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:OnTick(ct,ply,botmode,IsShooting,canShoot,ammo,IsReloading,shouldSetAngles)
	if canShoot or !shouldSetAngles then
		if self:GetAutoFire() then
			self.AutoFire = true
		end
	end
	
	if !IsShooting and self.AutoFire then
		if self:CanShoot(ammo,ct,ply,IsReloading) then
			self:PreFire(ammo,ct,ply)
		end
		
		if self:GetAmmo() <= 0 then self.AutoFire = false end
	end
end

function ENT:OnThinkCL(ct,ply,canShoot,ammo,IsReloading,IsAttacking)
	ammo = ammo or self:GetAmmo()
	IsReloading = IsReloading or self:GetIsReloading()
	
	self:OnTick(ct,ply,self:GetBotMode(),nil,canShoot or self:CanShoot(ammo,ct,ply,IsReloading),ammo,IsReloading,IsAttacking)
end

function ENT:PlayAnim()
	self:SetIsReloading(true)
	timer.Simple(self:GetReloadTime(),function()
		if not IsValid(self) then return end
		self:SetAmmo(self.Ammo)
		self:SetIsReloading(false)
	end)
end

function ENT:ViewCalc(ply, pos, angles, fov)
	-- debugoverlay.Sphere(self:LocalToWorld(self.SightPos),5,0.1,Color(255,255,255))
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = self:GetAngles()
		view.fov = 20
		view.drawviewer = false

		return view
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
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flak 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 38"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.2

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_20mm"},
						{"Time-fused","wac_base_20mm"},
}
ENT.TracerColor			= "Yellow"
ENT.ShootAnim			= "shoot"

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_02.wav"

ENT.PitchRate			= 40
ENT.YawRate				= 70
ENT.Spread				= 0.5
ENT.Seatable			= true
ENT.EmplacementType		= "MG"
ENT.Ammo				= 20
ENT.AimsightModel		= "models/gredwitch/flak38/flak38_sight.mdl"
ENT.HullModel			= "models/gredwitch/flak38/flak38_base.mdl"
ENT.YawModel			= "models/gredwitch/flak38/flak38_shield.mdl"
ENT.TurretModel			= "models/gredwitch/flak38/flak38_gun.mdl"
ENT.ReloadSound			= "gred_emp/flak38/reload.wav"
ENT.ReloadEndSound		= "gred_emp/flak38/reloadend.wav"
ENT.TurretPos			= Vector(12.734,-1.66126,22.7944)
ENT.SightPos			= Vector(-10,-13.52,8.1)
ENT.AimSightPos			= Vector(-11.47,-4.78,30.01)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true
ENT.MaxViewModes		= 1
ENT.BotAngleOffset		= Angle(2.5,0,0)
ENT.ViewPos				= Vector(5,0,35)
ENT.MaxRotation			= Angle(90,180)
ENT.MinRotation			= Angle(-12,-180)
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

if SERVER then
	function ENT:OnTick(ct,ply,botmode)
		local aimsight = self:GetAimSight()
		local ang = aimsight:GetAngles()
		ang.p = self:GetAngles().p
		aimsight:SetAngles(ang)
		
		self:SetBodygroup(1,self.MagIn and 0 or 1)
	end
end

local magpos = Vector(0,20,2)
local magang = Angle()

function ENT:Reload(ply)
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.7,function()
		if !IsValid(self) then return end
		local att = self:GetAttachment(self:LookupAttachment("mag"))
		
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/flak38/flak38_mag.mdl")
		prop:SetPos(self:LocalToWorld(magpos))
		prop:SetAngles(self:LocalToWorldAngles(magang))
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:Spawn()
		prop:Activate()
		if self:GetAmmo() < 1 then prop:SetBodygroup(1,1) end
		self.MagIn = false
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		self:SetBodygroup(1,1)
	end)
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(0.73,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self.MagIn = true
			self.NewMagIn = true
		end)
		timer.Simple(self:SequenceDuration() + 0.2,function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
			self.NewMagIn = false
		end)
	else
		timer.Simple(0.7,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
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
	
	yaw:ManipulateBoneAngles(5,Angle(ang.y*15))
	yaw:ManipulateBoneAngles(4,Angle(0,ang.p*15))
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
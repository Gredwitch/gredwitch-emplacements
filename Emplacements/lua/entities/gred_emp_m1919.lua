AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M1919 Browning"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.1
ENT.TracerColor			= "Red"

ENT.ShootSound			= "gred_emp/m1919/shoot.wav"
ENT.StopShootSound		= "gred_emp/m1919/stop.wav"
ENT.ReloadSound			= "gred_emp/mg42/mg42_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg42/mg42_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/m1919/m1919_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/m1919/m1919_gun.mdl"

ENT.Ammo				= 250
ENT.MaxRotation			= Angle(30,45)
ENT.ReloadTime			= 1.6
ENT.SightPos			= Vector(0,-32,3.1)
ENT.MaxViewModes		= 1
ENT.CycleRate			= 0.6

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetModelScale(1.1)
	ent:Spawn()
	ent:Activate()
	return ent
end


function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.6, function()
		if !IsValid(self) then return end
		
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m1919/m1919_belt.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang - Angle(0,90,0))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		
		self:SetBodygroup(1,1)
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self.MagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function() 
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER then
		if !self:GetIsReloading() or self.MagIn then 
			if self:GetAmmo() <= 0 then
				self:SetBodygroup(1,1)
			else
				self:SetBodygroup(1,0)
			end
		end
	end
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_m1919" then
			local ent = ply.Gred_Emp_Ent
			if ent:GetShooter() != ply then return end
			if IsValid(ent) then
				if ent:GetViewMode() == 1 then
					local ang = ent:GetAngles()
					local view = {}
					view.origin = ent:LocalToWorld(ent.SightPos)
					view.angles = Angle(-ang.r,ang.y+90,ang.p)
					view.fov = 35
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_m1919_view", CalcView)
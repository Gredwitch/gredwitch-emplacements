AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]FN Mag"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.075
ENT.TracerColor			= "Red"

ENT.ShootSound			= "gred_emp/fnmag/fnamg_shoot.wav"
ENT.StopShootSound		= "gred_emp/fnmag/fnmag_stop.wav"
ENT.ReloadSound			= "gred_emp/fnmag/fnmag_reload.wav"
ENT.ReloadEndSound		= "gred_emp/fnmag/fnmag_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/fnmag/fnmag_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/fnmag/fnmag_gun.mdl"
ENT.Ammo				= 50
ENT.ReloadTime			= 3.57

------------------------

ENT.TurretPos			= Vector(0,0,7)
ENT.SightPos			= Vector(-0.005,-25,5.655)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(2,math.random(0,1))
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.7, function() 
		if !IsValid(self) then return end
		self:SetBodygroup(2,2) -- Ammo bag hidden
		self:SetBodygroup(7,2)
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/fnmag/fnmag_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang + Angle(0,90,0))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(7,0)
			self.MagIn = true
		end)
		timer.Simple(1.9,function() if IsValid(self) then self:SetBodygroup(7,0) end end)
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
		self:SetSkin(0)
		self:SetBodygroup(1,0) -- Gun
		self:SetBodygroup(5,0) -- Lid
		self:SetBodygroup(6,0) -- Mag Base
		if self.MagIn or !self:GetIsReloading() then
			self:SetBodygroup(2,0) -- Ammo bag shown
			if self:GetAmmo() <= 0 then
				self:SetBodygroup(7,2) -- Ammo belt hidden
			else
				self:SetBodygroup(7,0) -- FN MAG Ammo belt
			end
		end
	end
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_fnmag" then
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
hook.Add("CalcView", "gred_emp_fnmag_view", CalcView)
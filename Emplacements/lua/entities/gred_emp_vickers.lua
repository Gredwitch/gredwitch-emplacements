AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Vickers"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_garand_3p"
ENT.ExtractAngle		= Angle(0,90,0)
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.12
ENT.TracerColor			= "Red"

ENT.ShootSound			= "gred_emp/vickers/shoot.wav"
-- ENT.StopShootSound		= "gred_emp/vickers/stop.wav"
ENT.ReloadSound			= "gred_emp/vickers/vickers_reload.wav"
ENT.ReloadEndSound		= "gred_emp/vickers/vickers_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/vickers/vickers_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/vickers/vickers_gun.mdl"

ENT.Ammo				= 250
ENT.ReloadTime			= 1.77
------------------------

ENT.TurretPos			= Vector(0,0,40)
ENT.SightPos			= Vector(-0.4,-15,-4.4)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(1, function() 
		if !IsValid(self) then return end
		for i = 2,4 do
			self:SetBodygroup(i,1)
		end
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/vickers/vickers_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang - Angle(0,90,0))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		if self:GetAmmo() <= 0 then 
			prop:SetBodygroup(1,1)
			prop:SetBodygroup(2,2)
		elseif self:GetAmmo() <= 7 then
			prop:SetBodygroup(1,1)
			prop:SetBodygroup(2,1)
		else
			prop:SetBodygroup(1,0)
			prop:SetBodygroup(2,1)
		end
		local p = prop:GetPhysicsObject()
		if IsValid(p) then p:SetMass(100) end
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		self:SetBodygroup(3,1)
	end)
	
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(2,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(3,0)
			self:SetBodygroup(4,0)
			self.MagIn = true
		end)
		timer.Simple(self:SequenceDuration() + 0.1,function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
		end)
		timer.Simple(2,function() 
			if !IsValid(self) then return end
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER and (!self:GetIsReloading() or self.MagIn) then
		if self:GetAmmo() <= 7 then 
			self:SetBodygroup(3,1)
			self:SetBodygroup(4,0)
		elseif self:GetAmmo() <= 0 then 
			self:SetBodygroup(3,1)
			self:SetBodygroup(4,1)
		else
			self:SetBodygroup(3,0)
			self:SetBodygroup(4,0)
		end
		self:SetBodygroup(2,0)
	end
end

local function CalcView(ply, pos, angles, fov)
	if ply:GetViewEntity() != ply then return end
	if ply.Gred_Emp_Ent then
		if ply.Gred_Emp_Ent.ClassName == "gred_emp_vickers" then
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
hook.Add("CalcView", "gred_emp_vickers_view", CalcView)
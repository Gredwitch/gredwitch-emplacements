AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]RPK"
ENT.Author				= "Gredwitch"
ENT.NameToPrint			= "RPK"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.1
ENT.TracerColor			= "Green"
ENT.AmmunitionType		= "wac_base_7mm"

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/rpk/shoot.wav"
ENT.ReloadSound			= "gred_emp/rpk/rpk_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg34/mg34_reloadend.wav"
ENT.EmplacementType		= "MG"

ENT.TurretModel			= "models/gredwitch/rpk/rpk.mdl"
ENT.HullModel			= "models/gredwitch/rpk/rpk_tripod.mdl"

ENT.Ammo				= 75
ENT.ReloadTime			= 1.9
ENT.CycleRate			= 0.4
ENT.ShootAngleOffset	= Angle(1,-90,0)
ENT.ExtractAngle		= Angle(0,0,0)
ENT.MaxRotation			= Angle(30,45)
if game.SinglePlayer() then
	ENT.SightPos		= Vector(0.09,-28,1.8)
else
	ENT.SightPos		= Vector(0,-28,1.8)
end
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(1.1)
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.6, function()
		if !IsValid(self) then return end
		
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/rpk/rpk_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-5,-25,-5)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
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
		
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
	end)
	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self:SetBodygroup(2,0)
			self.MagIn = true
		end)

		timer.Simple(self:SequenceDuration(),function() 
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
		
	else
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
	if SERVER then
		local ammo = self:GetAmmo()
		if (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
			self:SetBodygroup(1,0)
			if ammo <= 0 then
				self:SetBodygroup(2,1)
			elseif ammo >= 1 then
				self:SetBodygroup(2,0)
			end
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		local a = game.SinglePlayer() and 0.13 or 0
		view.angles = Angle(-ang.r,ang.y+90 + a,ang.p)
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
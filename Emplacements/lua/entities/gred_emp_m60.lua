AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M60"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.092
ENT.TracerColor			= "Red"

ENT.Recoil				= 0.8
ENT.HullFly				= true
ENT.ShootSound			= "gred_emp/m60/shoot.wav"
ENT.StopShootSound		= "gred_emp/m60/stop.wav"
ENT.ReloadSound			= "gred_emp/m60/m60_reload.wav"
ENT.ReloadEndSound		= "gred_emp/m60/m60_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/m60/m60_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/m60/m60_gun.mdl"

ENT.Ammo				= 300
ENT.ReloadTime			= 2.77
ENT.CycleRate			= 0.4

------------------------

ENT.TurretPos			= Vector(0,0,-1)
ENT.SightPos			= Vector(-45,-0.43,5)
ENT.MaxRotation			= Angle(15,30)
ENT.MinRotation			= Angle(-30,-30)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.9, function()
		if !IsValid(self) then return end
		self:SetBodygroup(1,1) -- Ammo bag hidden
		self:SetBodygroup(2,1)
		
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/m60/m60_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-20,10,0)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:Spawn()
		prop:Activate()
		
		self.MagIn = false
		
		if self:GetAmmo() >= 0 then prop:SetBodygroup(1,1) end
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
	end)
	
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self.NewMagIn = true
			self:SetBodygroup(2,0)
			self:SetBodygroup(1,0)
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
			self.NewMagIn = false
		end)
	else
		timer.Simple(1.3,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

if SERVER then
	function ENT:OnTick()
		if self.MagIn then
			self:SetBodygroup(1,0)
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(2,1)
			else
				self:SetBodygroup(2,0)
			end
		else
			self:SetBodygroup(1,1)
			self:SetBodygroup(2,1)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetViewMode() == 1 then
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = ply:EyeAngles()
		view.angles.p = view.angles.p - (self:GetRecoil())*0.2
		view.angles.r = self:GetAngles().r
		view.fov = 40
		view.drawviewer = false

		return view
	end
end
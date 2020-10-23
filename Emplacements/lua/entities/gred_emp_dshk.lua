AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]DShK"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.AmmunitionType		= "wac_base_12mm"
ENT.ShotInterval		= 0.1
ENT.TracerColor			= "Green"

ENT.ShootSound			= "gred_emp/dshk/shoot.wav"
ENT.StopShootSound		= "gred_emp/dshk/stop.wav"

ENT.Recoil				= 1.5
ENT.RecoilRate			= 0.3
ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/dhsk/dhsk_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/dhsk/dhsk_gun.mdl"
ENT.YawModel			= "models/gredwitch/dhsk/dhsk_yaw.mdl"
ENT.ReloadSound			= "gred_emp/dshk/dhsk_reload.wav"
ENT.ReloadEndSound		= "gred_emp/dshk/dhsk_reloadend.wav"

ENT.Ammo				= 50
ENT.ReloadTime			= 1.73 - 0.7

------------------------

ENT.YawPos				= Vector(0,0,42.5)
ENT.TurretPos			= Vector(-4,0,5.5)
ENT.SightPos			= Vector(-33,0,10.4)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	return ent
end

function ENT:Reload(ply)
	
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.7, function()
		if !IsValid(self) then return end
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/dhsk/dhsk_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
					if IsValid(prop) then prop:Remove() end 
			end)
		end
		
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		self:SetBodygroup(2,1)
		self:SetBodygroup(3,1)
	end)
	
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.2,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(3,0)
			self.MagIn = true
			self.NewMagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
			self.NewMagIn = false
		end)
	else
		timer.Simple(1.2,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end


if SERVER then
	function ENT:OnTick()
		if self.MagIn then
			self:SetBodygroup(2,0)
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(3,1)
			else
				self:SetBodygroup(3,0)
			end
		else
			self:SetBodygroup(2,1)
			self:SetBodygroup(3,1)
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
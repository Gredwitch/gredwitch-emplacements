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

ENT.HullFly				= true
ENT.RecoilRate			= 0.1
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/rpk/shoot.wav"
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
ENT.SightPos			= Vector(-35,0,1.85)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 11
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(1.15)
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
		prop:SetPos(self:LocalToWorld(Vector(-25,5,-5)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:Spawn()
		prop:SetModelScale(1.15)
		prop:Activate()
		self.MagIn = false
		
		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
	end)
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self:SetBodygroup(2,0)
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
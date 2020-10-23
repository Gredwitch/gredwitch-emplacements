AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 42"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= 0.046
ENT.TracerColor			= "Green"

ENT.RecoilRate			= 0.25
ENT.ShootSound			= "gred_emp/mg42/shoot.wav"
ENT.ReloadSound			= "gred_emp/mg42/mg42_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg42/mg42_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/mg42/mg42_gun.mdl"

ENT.Ammo				= 250
ENT.TurretPos			= Vector(0,0,0)
ENT.SightPos			= Vector(-16,-0.08,3.45)
ENT.ExtractAngle		= Angle(0,0,0)
ENT.MaxViewModes		= 1
ENT.ReloadTime			= 1.2
ENT.CycleRate			= 0.6

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:SetModelScale(1.15)
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
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		if self:GetAmmo() > 0 then
			local prop = ents.Create("prop_physics")
			prop:SetModel("models/gredwitch/mg42/mg42_belt.mdl")
			prop:SetPos(self:LocalToWorld(Vector(0,7,5)))
			prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
			prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			prop:Spawn()
			prop:SetModelScale(1.15)
			prop:Activate()
			local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
			if t > 0 then
				timer.Simple(t,function()
					if IsValid(prop) then prop:Remove() end 
				end)
			end
		end
		self.MagIn = false
		self:SetBodygroup(1,1)
	end)
	
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self.MagIn = true
			self.NewMagIn = true
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
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

if SERVER then
	function ENT:OnTick()
		if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
			self:SetBodygroup(1,1)
		else
			self:SetBodygroup(1,0)
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
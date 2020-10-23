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

ENT.HullFly				= true
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/m1919/shoot.wav"
ENT.ReloadSound			= "gred_emp/mg42/mg42_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg42/mg42_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/m1919/m1919_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/m1919/m1919_gun.mdl"

ENT.Ammo				= 250
ENT.MaxRotation			= Angle(15,30)
ENT.MinRotation			= Angle(-30,-30)
ENT.ReloadTime			= 1.6
ENT.SightPos			= Vector(-32,0,3.1)
ENT.MaxViewModes		= 1
ENT.CycleRate			= 0.6

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 12
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
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
		if self:GetAmmo() > 0 then
			local att = self:GetAttachment(self:LookupAttachment("mageject"))
			local prop = ents.Create("prop_physics")
			prop:SetModel("models/gredwitch/m1919/m1919_belt.mdl")
			prop:SetPos(att.Pos)
			prop:SetAngles(att.Ang)
			prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			prop:Spawn()
			-- prop:SetModelScale(1.1)
			prop:Activate()
			local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
			if t > 0 then
				timer.Simple(t,function()
					if IsValid(prop) then prop:Remove() end 
				end)
			end
		end
		self.MagIn = false
		-- self:SetBodygroup(1,1)
	end)
	
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(1.6,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
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
		timer.Simple(1.5,function() 
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end


if SERVER then
	function ENT:OnTick()
		if self.MagIn then
			if (self:GetAmmo() < 1 and !self.NewMagIn) or !self.MagIn then
				self:SetBodygroup(1,1)
			else
				self:SetBodygroup(1,0)
			end
		else
			self:SetBodygroup(1,1)
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
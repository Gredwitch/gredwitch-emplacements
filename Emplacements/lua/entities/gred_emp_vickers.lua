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

ENT.Recoil				= 0.4
ENT.RecoilRate			= 0.1
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/vickers/shoot.wav"
ENT.ReloadSound			= "gred_emp/vickers/vickers_reload.wav"
ENT.ReloadEndSound		= "gred_emp/vickers/vickers_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/gredwitch/vickers/vickers_tripod.mdl"
ENT.TurretModel			= "models/gredwitch/vickers/vickers_gun.mdl"

ENT.Ammo				= 385
ENT.ReloadTime			= 1.77
------------------------

ENT.TurretPos			= Vector(0,0,0)
ENT.SightPos			= Vector(-15,0.4,13.9)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 37
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
	
	timer.Simple(1, function() 
		if !IsValid(self) then return end
		for i = 2,4 do
			self:SetBodygroup(i,1)
		end
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/vickers/vickers_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(10,-20,0)))
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
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
		local t = gred.CVars.gred_sv_shell_remove_time:GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end 
			end)
		end
		self:SetBodygroup(3,1)
	end)
	
	if gred.CVars.gred_sv_manual_reload_mgs:GetInt() == 0 then
		timer.Simple(2,function() 
			if !IsValid(self) then return end
			self:SetBodygroup(2,0)
			self:SetBodygroup(3,0)
			self:SetBodygroup(4,0)
			self.MagIn = true
			self.NewMagIn = true
		end)
		timer.Simple(self:SequenceDuration() + 0.1,function()
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
		end)
		timer.Simple(2,function() 
			if !IsValid(self) then return end
			self:SetPlaybackRate(0)
		end)
	end
end

-- function ENT:OnTick()
	-- if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		-- if self:GetAmmo() <= 7 then 
			-- self:SetBodygroup(3,1)
			-- if self:GetAmmo() <= 0 then 
				-- self:SetBodygroup(4,1)
			-- else
				-- self:SetBodygroup(4,0)
			-- end
		-- else
			-- self:SetBodygroup(3,0)
			-- self:SetBodygroup(4,0)
		-- end
		-- self:SetBodygroup(2,0)
	-- end
-- end

if SERVER then
	function ENT:OnTick()
		if self.MagIn then
			self:SetBodygroup(2,0)
			if !self.NewMagIn or !self.MagIn then
				local ammo = self:GetAmmo()
				if ammo <= 7 then
					self:SetBodygroup(3,1)
					if ammo < 1 then
						self:SetBodygroup(4,1)
					else
						self:SetBodygroup(4,0)
					end
				else
					self:SetBodygroup(3,0)
				end
			else
				self:SetBodygroup(2,0)
			end
		else
			self:SetBodygroup(2,1)
			self:SetBodygroup(3,1)
			self:SetBodygroup(4,1)
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
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG3"
ENT.Author				= "Gredwitch"
ENT.NameToPrint			= "MG3"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.067
ENT.TracerColor			= "Red"
ENT.AmmunitionType		= "wac_base_7mm"

ENT.HullFly				= true
ENT.Recoil				= 0.5
ENT.RecoilRate			= 0.15
ENT.ShootSound			= "gred_emp/mg3/mg3_loop.wav"
ENT.StopShootSound		= "gred_emp/mg3/shoot.wav"
ENT.ReloadSound			= "gred_emp/mg3/mg3_reload.wav"
ENT.ReloadEndSound		= "gred_emp/mg34/mg34_reloadend.wav"
ENT.EmplacementType		= "MG"

ENT.TurretModel			= "models/gredwitch/mg3/mg3_turret.mdl"
ENT.HullModel			= "models/gredwitch/mg3/mg3_tripod.mdl"

ENT.Ammo				= 100
ENT.ReloadTime			= 1.9
ENT.CycleRate			= 0.5

ENT.ExtractAngle		= Angle(0,0,0)
ENT.MaxRotation			= Angle(30,45)

if game.SinglePlayer() then
	ENT.SightPos		= Vector(0.02,-30,3.65)
else
	ENT.SightPos		= Vector(0,-30,3.65)
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
		prop:SetModel("models/gredwitch/mg3/mg3_mag.mdl")
		prop:SetPos(self:LocalToWorld(Vector(-10,-20,5)))
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
	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		self:SetBodygroup(1,0)
		local ammo = self:GetAmmo()
		if ammo <= 0 then
			self:SetBodygroup(2,1)
		elseif ammo >= 1 then
			self:SetBodygroup(2,0)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		angles = ply:EyeAngles()
		angles.p = angles.p - (self:GetRecoil())*0.5
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 41
		view.drawviewer = false
				
		return view
	end
end
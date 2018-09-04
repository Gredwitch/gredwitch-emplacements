AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Vickers"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_garand_3p"
ENT.EjectAngle			= Angle(0,90,0)
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.12
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/vickers/shoot.wav"--[[
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/vickers/stop.wav"]]
ENT.SoundName			= "shootVICKERS"

ENT.BaseModel			= "models/gredwitch/vickers/vickers_tripod.mdl"
ENT.Model				= "models/gredwitch/vickers/vickers_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 40
ENT.CanLookArround		= true

ENT.Ammo				= 250
ENT.MaxUseDistance		= 55
ENT.CurAmmo				= ENT.Ammo
ENT.HasNoAmmo			= false

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

local created = false

sound.Add( {
	name = "VickersReload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/vickers/vickers_reload.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("VickersReload")
	timer.Simple(1, function() 
		if !IsValid(self) then return end
		if created then return end
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
		if self.CurAmmo <= 0 then 
			prop:SetBodygroup(1,1)
			prop:SetBodygroup(2,2)
		elseif self.CurAmmo <= 7 then
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
		created = true
		self:SetBodygroup(3,1)
	end)
	created = false
	timer.Simple(2,function() 
		if !IsValid(self) then return end
		self:SetBodygroup(2,0)
		self:SetBodygroup(3,0)
		self:SetBodygroup(4,0)
	end)
	timer.Simple(self:SequenceDuration() + 0.1,function() if !IsValid(self) then return end
		self.CurAmmo = self.Ammo
		self.IsReloading = false
		self.tracer = 0
	end)
end

function ENT:AddOnThink()
	if SERVER and not self.IsReloading then
		if self.CurAmmo <= 7 then 
			self:SetBodygroup(3,1)
			self:SetBodygroup(4,0)
		elseif self.CurAmmo <= 0 then 
			self:SetBodygroup(3,1)
			self:SetBodygroup(4,1)
		else
			self:SetBodygroup(3,0)
			self:SetBodygroup(4,0)
		end
		self:SetBodygroup(2,0)
	end
end
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]MG 34"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.067
ENT.Color				= "Green"

ENT.ShootSound			= "gred_emp/mg34/shoot.wav"
ENT.SoundName			= "shootMG34"

ENT.BaseModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.Model				= "models/gredwitch/mg34/mg34.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 43.5
ENT.MaxUseDistance		= 45
ENT.CanLookArround		= true

ENT.Ammo        		= 50
ENT.CurAmmo      		= ENT.Ammo
ENT.HasNoAmmo			= false

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(1.1)
	return ent
end

local created = false

sound.Add( {
	name = "MG34Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100},
	sound = "gred_emp/mg34/mg34_reload.wav"
} )

function ENT:ReloadMG(ply)
	if self.IsReloading then return end
	self.IsReloading = true
	self:ResetSequence(self:LookupSequence("reload"))
	self:EmitSound("MG34Reload")
	timer.Simple(0.6, function() 
		if !IsValid(self) then return end
		if created then return end
		self:SetBodygroup(4,1)
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/mg34/mg34_mag.mdl")
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:Spawn()
		prop:Activate()
		-- if self.CurAmmo <= 0 then prop:SetBodygroup(1,1) end
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
	timer.Simple(1.1,function() 
		if !IsValid(self) then return end
		self:SetBodygroup(3,0)
		self:SetBodygroup(4,0)
	end)
	timer.Simple(self:SequenceDuration(),function() if !IsValid(self) then return end
		self.CurAmmo = self.Ammo
		self.IsReloading = false
		self.tracer = 0
	end)
end

function ENT:AddOnThink()
	if SERVER and not self.IsReloading then
		if self.CurAmmo <= 0 then 
			self:SetBodygroup(4,1)
		else
			self:SetBodygroup(4,0)
		end
		self:SetBodygroup(3,0)
	end
end
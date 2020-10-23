AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Bar M1918"
ENT.Author				= "Gredwitch"
ENT.NameToPrint			= "Bar M1918"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.16 -- fast = 0.092
ENT.TracerColor			= "Red"
ENT.AmmunitionTypes		= {
						{"Slow fire","wac_base_7mm"},
						{"Fast fire","wac_base_7mm"},
}
ENT.HullFly				= true
ENT.OnlyShootSound		= true
ENT.ShootSound			= "^gred_emp/bar/shoot.wav"
ENT.ReloadSound			= "gred_emp/bar/bar_reload.wav"
ENT.ReloadEndSound		= "gred_emp/bar/bar_reloadend.wav"
ENT.EmplacementType		= "MG"

ENT.HullModel			= "models/gredwitch/bar/bar_bipod.mdl"
ENT.TurretModel			= "models/gredwitch/bar/bar.mdl"

ENT.Recoil				= 0.4
ENT.Ammo				= 20
ENT.ReloadTime			= 1.9
ENT.CycleRate			= 0.6

ENT.TurretPos			= Vector(0,0,0)
ENT.ExtractAngle		= Angle(0,0,0)
ENT.MaxRotation			= Angle(15,30)
ENT.MinRotation			= Angle(-30,-30)
ENT.SightPos			= Vector(-33.5,0,1.175)
ENT.MaxViewModes		= 1

function ENT:SwitchAmmoType(ply)
	self:SetAmmoType(self:GetAmmoType()+1)
	local ammotype = self:GetAmmoType()
	if ammotype <= 0 or ammotype > table.Count(self.AmmunitionTypes) then self:SetAmmoType(1) end
	
	local t = self.AmmunitionTypes[self:GetAmmoType()]
	-- net.Start("gred_net_message_ply")
		-- net.WriteString("["..self.NameToPrint.."] "..t[1].." mode selected")
	-- net.Send(ply)
	if t[1] == self.AmmunitionTypes[1][1] then
		self.ShotInterval = 0.16
	else
		self.ShotInterval = 0.092
	end
	net.Start("gred_net_emp_reloadsounds")
		net.WriteEntity(self)
		net.WriteFloat(self.ShotInterval)
	net.Broadcast()
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(1.15)
	return ent
end

local MagAngle = Angle(0,-90,0)

function ENT:Reload(ply)
	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)
	
	timer.Simple(0.8, function()
		if !IsValid(self) then return end
		
		local att = self:GetAttachment(self:LookupAttachment("mageject"))
		
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/gredwitch/bar/bar_mag.mdl")
		prop:SetAngles(att.Ang + MagAngle)
		prop:SetPos(att.Pos)
		prop:Spawn()
		prop:SetModelScale(1.15)
		prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
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
			self.NewMagIn = false
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
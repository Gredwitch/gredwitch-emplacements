AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]105mm M2A1 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M2A1"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.BulletType			= "gb_shell_105mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.AnimRestartTime		= 3.4
ENT.AnimPlayTime		= 1.6
ENT.AmmoType			= "HE"

ENT.SoundName			= "shootM2A1"
ENT.ShootSound			= "gred_emp/common/105mm.wav"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.MaxUseDistance		= 100
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/M2A1/M2A1_carriage.mdl"
ENT.Model				= "models/gredwitch/M2A1/M2A1_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.4

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,1))
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	
	if self.AmmoType == "HE" then
		self.AmmoType = "WP"
		self.BulletType = "gb_rocket_81mmWP"
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] WP shells selected") end
	
	elseif self.AmmoType == "WP" then
		self.AmmoType = "Smoke"
		self.BulletType = "gb_shell_105mm"
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] Smoke shells selected") end
	
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "HE"
		self.BulletType = "gb_shell_105mm"
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] HE shells selected") end
	end
	self.NextSwitch = CurTime()+0.2
end
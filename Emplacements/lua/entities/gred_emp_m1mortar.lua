ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base_mortar"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M1 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.TurretTurnMax		= 0.8

ENT.ShotInterval		= 3
ENT.AmmoType			= "HE"
ENT.Scatter				= 400

ENT.Model 				= "models/gredwitch/m1_mortar/m1_mortar.mdl"
ENT.SoundName 			= "81mmMortar"
ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"
ENT.ShellType			= "gb_rocket_81mm"
function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	
	if self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[M1 Mortar] Smoke Shells selected") end
	
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "HE"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[M1 Mortar] HE Shells selected") end
	end
	
	self.NextSwitch = CurTime()+0.2
end
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]82mm PM-41 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "PM-41 Mortar"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 2.4
ENT.AmmoType			= "HE"
ENT.EffectSmoke			= "m203_smokegrenade"
ENT.BulletType			= "gb_shell_82mm"
ENT.Scatter				= 400
ENT.MuzzleCount			= 1

ENT.SoundName 			= "81mmMortar"
ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.TurretHeight		= 0
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.5
ENT.BaseModel			= "models/gredwitch/pm41/pm41_tripod.mdl"
ENT.Model				= "models/gredwitch/pm41/pm41_tube.mdl"
ENT.EmplacementType     = "Mortar"
ENT.MaxUseDistance		= 80

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 28
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "HE" then
		if CLIENT then self.AmmoType = "Smoke" end
		if SERVER then self.AmmoType = "Smoke" end
	elseif self.AmmoType == "Smoke" then
		if CLIENT then self.AmmoType = "HE" end
		if SERVER then self.AmmoType = "HE" end
	end
	if self.serv then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." shells selected") end
	self.NextSwitch = CurTime()+0.2
end
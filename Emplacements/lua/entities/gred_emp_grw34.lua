AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Granatfwerfer 34"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "Granatfwerfer 34"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 2.4
ENT.AmmoType			= "HE"
ENT.EffectSmoke			= "m203_smokegrenade"
ENT.BulletType			= "gb_rocket_81mm"
ENT.Scatter				= 400
ENT.MuzzleCount			= 1

ENT.SoundName 			= "81mmMortar"
ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.TurretHeight		= 0
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.5
ENT.BaseModel			= "models/gredwitch/granatwerfer/granatwerfer_base.mdl"
ENT.Model				= "models/gredwitch/granatwerfer/granatwerfer_tube.mdl"
ENT.EmplacementType     = "Mortar"
ENT.MaxUseDistance		= 80


function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,2))
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if SERVER then
		if self.AmmoType == "HE" then
			self.AmmoType = "Smoke"
		
		elseif self.AmmoType == "Smoke" then
			self.AmmoType = "HE"
		end
		if CLIENT or not game.IsDedicated() then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." shells selected") end
	end
	self.NextSwitch = CurTime()+0.2
end
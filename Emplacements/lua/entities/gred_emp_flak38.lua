AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flak 38"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 38"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 0.214
ENT.BulletType			= "wac_base_20mm"
ENT.MuzzleCount			= 1

ENT.SoundName			= "shootFlak"
ENT.ShootSound			= "gred_emp/flak38/20mm_shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/flak38/20mm_stop.wav"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 20
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/flak38/flak38_base.mdl"
ENT.SecondModel			= "models/gredwitch/flak38/flak38_shield.mdl"
ENT.Model				= "models/gredwitch/flak38/flak38_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 200
ENT.Seatable			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,3))
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() and !IsValid(ply) then return end
	if SERVER then
		if self.AmmoType == "Direct Hit" then
			self.AmmoType = "Time-Fuze"
		
		elseif self.AmmoType == "Time-Fuze" then
			self.AmmoType = "Direct Hit"
		end
		if LAN then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." rounds selected") end
	end
	self.NextSwitch = CurTime()+0.2
end
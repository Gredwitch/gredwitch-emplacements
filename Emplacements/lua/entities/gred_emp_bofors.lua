AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]40mm Bofors L/60"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.IsInDev				= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Bofors L/60"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.5
ENT.BulletType			= "wac_base_40mm"
ENT.MuzzleCount			= 1
ENT.num					= 0.7

ENT.SoundName			= "shootArtemis"
ENT.ShootSound			= "gred_emp/bofors/shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/bofors/stop.wav"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 0
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/bofors/bofors_base.mdl"
ENT.SecondModel			= "models/gredwitch/bofors/bofors_shield.mdl"
ENT.Model				= "models/gredwitch/bofors/bofors_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 70
ENT.CanLookArround		= true
-- ENT.Seatable			= true
ENT.created				= false
ENT.Recoil				= 5000000

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,1))
	ent:Spawn()
	ent:Activate()
	m = math.random(0,2)
	if m == 0 then
		ent.turretBase:SetBodygroup(1,0)
	elseif m == 1 then
		ent.turretBase:SetBodygroup(1,1)
	else
		ent.turretBase:SetBodygroup(1,2)
	end
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "Direct Hit" then
		self.AmmoType = "Time-Fuze"
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] Time-Fuze rounds selected") end
	elseif self.AmmoType == "Time-Fuze" then
		self.AmmoType = "Direct Hit"
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] Direct hit rounds selected") end
	end
	self.NextSwitch = CurTime()+0.2
end
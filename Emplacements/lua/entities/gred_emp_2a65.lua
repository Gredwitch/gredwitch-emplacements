AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]152mm 2A65 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "2A65"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.BulletType			= "gb_shell_152mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= false
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1.6
ENT.AmmoType			= "HE"

ENT.SoundName			= "shoot2A65"
ENT.ShootSound			= "gred_emp/common/152mm.wav"
ENT.ATReloadSound		= "big"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.MaxUseDistance		= 100
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/2A65/2A65_carriage.mdl"
ENT.Model				= "models/gredwitch/2A65/2A65_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.4

ENT.Wheels				= "models/gredwitch/2A65/2A65_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,20)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "HE"
	end
	net.Start("gred_net_message_ply")
		net.WriteEntity(plr)
		net.WriteString("["..self.NameToPrint.."] "..self.AmmoType.." shells selected")
	net.Send(plr)
	self.NextSwitch = CurTime()+0.2
end
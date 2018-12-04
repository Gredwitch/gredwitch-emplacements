AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]155mm M777 Howitzer"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "M777"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.BulletType			= "gb_shell_155mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= false
ENT.AnimRestartTime		= 4.4
ENT.ShellEjectTime		= 0.2
ENT.AnimPlayTime		= 0
ENT.AmmoType			= "HE"

ENT.SoundName			= "shootM777"
ENT.ShootSound			= "gred_emp/common/155mm.wav"
ENT.ATReloadSound		= "big"

ENT.TurretHeight		= 0
ENT.TurretForward		= 10
ENT.MaxUseDistance		= 100
ENT.ShieldUp			= 21
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/M777/M777_carriage.mdl"
ENT.Model				= "models/gredwitch/M777/M777_gun.mdl"
ENT.SecondModel			= "models/gredwitch/M777/M777_shield.mdl"
ENT.CanLookArround		= true
ENT.Seatable			= false
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.4
ENT.HasShootAnim		= true
ENT.NoRecoil			= true

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
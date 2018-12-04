AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]105mm LeFH18"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "LeFH18"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4
ENT.BulletType			= "gb_shell_105mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.AnimRestartTime		= 4.4
ENT.AnimPlayTime		= 1
ENT.AmmoType			= "HE"
ENT.ShellSoundTime		= 2
ENT.NoWP				= true

ENT.SoundName			= "shootLeFH18"
ENT.ShootSound			= "gred_emp/common/105mm_axis.wav"
ENT.ATReloadSound		= "big"

ENT.TurretHeight		= 0
ENT.TurretFloatHeight	= 0
ENT.MaxUseDistance		= 100
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/lefh18/lefh18_carriage.mdl"
ENT.Model				= "models/gredwitch/lefh18/lefh18_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.4

ENT.Wheels				= "models/gredwitch/lefh18/lefh18_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,10)
ENT.UseSingAnim			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,2))
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
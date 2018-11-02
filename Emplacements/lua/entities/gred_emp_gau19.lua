AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]GAU-19 Minigun"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.EjectAngle			= Angle(0,0,0)

ENT.AnimRestartTime		= 0.2
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_12mm"
ENT.ShotInterval		= 0.03
ENT.Color				= "Red"
ENT.NoRecoil			= true

ENT.ShootSound			= "gred_emp/gau19/shoot.wav"
ENT.SoundName			= "shootM134"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/gau19/stop.wav"

ENT.BaseModel			= "models/gredwitch/M134/M134_tripod.mdl"
ENT.Model				= "models/gredwitch/gau19/gau19.mdl"
ENT.HasRotatingBarrel	= true
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 0
ENT.MaxUseDistance		= 50
ENT.CanLookArround		= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
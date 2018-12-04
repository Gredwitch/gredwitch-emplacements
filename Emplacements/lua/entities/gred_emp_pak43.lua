AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm PaK 43"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "PaK 43"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_shell_88mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.UseSingAnim			= true

ENT.AnimRestartTime		= 4.6
ENT.ShellSoundTime		= 1.5
ENT.AnimPlayTime		= 1.3
ENT.ATReloadSound		= "big"

ENT.SoundName			= "shootpak43"
ENT.ShootSound			= "gred_emp/common/88mm.wav"

ENT.MaxUseDistance		= 75
ENT.TurretHeight		= 0
ENT.TurretForward		= 0
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/pak43/pak43_carriage.mdl"
ENT.Model				= "models/gredwitch/pak43/pak43_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.1

ENT.Wheels				= "models/gredwitch/pak43/pak43_wheels.mdl"
ENT.WheelsPos			= Vector(0,0,0)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent:Spawn()
	ent:Activate()
	return ent
end
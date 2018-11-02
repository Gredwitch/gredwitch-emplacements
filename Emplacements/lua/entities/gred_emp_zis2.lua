AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]57mm ZiS-2"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "ZiS-2"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_shell_57mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.AnimRestartTime		= 4.5
ENT.AnimPlayTime		= 1.1
ENT.MaxUseDistance		= 100

ENT.SoundName			= "shootZiS2"
ENT.ShootSound			= "gred_emp/common/50mm.wav"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.7
ENT.BaseModel			= "models/gredwitch/zis2/zis2_carriage.mdl"
ENT.Model				= "models/gredwitch/zis2/zis2_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.1
ENT.CustomRecoil		= true
ENT.Recoil				= 2000000

ENT.Wheels				= "models/gredwitch/zis2/zis2_wheels.mdl"
ENT.WheelsPos			= Vector(0,-5,-6)

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 41
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,4))
	return ent
end
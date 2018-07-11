AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Vickers"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MuzzleEffect		= "muzzleflash_garand_3p"
ENT.MuzzleCount			= 1
ENT.BulletType			= "wac_base_7mm"
ENT.ShotInterval		= 0.12
ENT.Color				= "Red"

ENT.ShootSound			= "gred_emp/vickers/shoot.wav"--[[
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/vickers/stop.wav"]]
ENT.SoundName			= "shootVICKERS"

ENT.BaseModel			= "models/gredwitch/vickers/vickers_tripod.mdl"
ENT.Model				= "models/gredwitch/vickers/vickers_gun.mdl"
ENT.TurretTurnMax		= 0
ENT.TurretHeight		= 40

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
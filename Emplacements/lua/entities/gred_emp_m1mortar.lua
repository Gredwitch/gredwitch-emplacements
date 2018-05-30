AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base_mortar"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]M1 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.TurretTurnMax		= 0.8

ENT.ShotInterval		= 3
ENT.AmmoType			= "HE"
ENT.Scatter				= 400

ENT.Model 				= "models/gredwitch/m1_mortar/m1_mortar.mdl"
ENT.SoundName 			= "81mmMortar"
ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"
ENT.ShellType			= "gb_rocket_81mm"

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end
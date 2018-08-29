AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm Flak 37"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.IsInDev				= true
ENT.NameToPrint			= "Flak 37"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 5
ENT.BulletType			= "gb_shell_88mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.AnimRestartTime		= 2
ENT.AnimPlayTime		= 1


ENT.SoundName			= "shootFlak37"
ENT.ShootSound			= "gred_emp/common/88mm.wav"

ENT.TurretHeight		= 0
ENT.TurretForward		= -40

ENT.MaxUseDistance		= 100
ENT.TurretTurnMax		= 0.9
ENT.BaseModel			= "models/gredwitch/flak37/flak37_base.mdl"
ENT.SecondModel			= "models/gredwitch/flak37/flak37_shield.mdl"
ENT.Model				= "models/gredwitch/flak37/flak37_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.1
ENT.CanLookArround		= true
-- ENT.Seatable			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	ent.turretBase:SetBodygroup(1,math.random(0,1))
	ent.shield:SetBodygroup(1,math.random(0,3))
	ent.shield:SetBodygroup(2,math.random(0,1))
	ent.shield:SetBodygroup(3,math.random(0,1))
	ent.shield:SetBodygroup(4,math.random(0,1))
	return ent
end

function ENT:PlayAnim()
	if SERVER then
		-- if self.AnimPlaying then return end
		timer.Simple(self.AnimPlayTime,function()
			if !IsValid(self) then return end
			self:ResetSequence(self:LookupSequence("reload"))
			self.AnimPlaying = true
		end)
		timer.Simple(self:SequenceDuration(),function() 
			if !IsValid(self) then return end
			self.AnimPlaying = false
		end)
	end
end
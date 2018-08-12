AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]6pdr Ordnance QF"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NameToPrint			= "6pdr"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.5
ENT.BulletType			= "gb_shell_50mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.AnimRestartTime		= 4
ENT.AnimPlayTime		= 1

ENT.SoundName			= "shoot6pdr"
ENT.ShootSound			= "gred_emp/common/6pdr.wav"

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.MaxUseDistance		= 100
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.9
ENT.BaseModel			= "models/gredwitch/6pdr/6pdr_carriage.mdl"
ENT.Model				= "models/gredwitch/6pdr/6pdr_shield.mdl"
ENT.EmplacementType     = "AT"
ENT.Scatter				= 0.1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 36
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,1))
	ent:Spawn()
	ent:Activate()
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
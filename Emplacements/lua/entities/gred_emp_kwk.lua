AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm KwK"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "KwK"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 4.8
ENT.BulletType			= "gb_shell_50mm"
ENT.MuzzleCount			= 1
ENT.HasReloadAnim		= true
ENT.AnimPlayTime		= 1.3

ENT.HERadius			= 300
ENT.HEDamage			= 75
ENT.EffectHE			= "gred_50mm"
ENT.EffectSmoke			= "m203_smokegrenade"

ENT.SoundName			= "shootPaK"
ENT.ShootSound			= "gred_emp/common/50mm.wav"

ENT.TurretHeight		= 49.8
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/kwk/kwk_base.mdl"
ENT.SecondModel			= "models/gredwitch/kwk/kwk_shield.mdl"
ENT.Model				= "models/gredwitch/kwk/kwk_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.MaxUseDistance		= 60
ENT.CanLookArround		= true
ENT.CanUseShield		= false
ENT.CustomRecoil		= true
ENT.Recoil				= 700000
ENT.Seatable			= true
ENT.ATReloadSound		= "small"
ENT.UseSingAnim			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
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

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_kwk" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) then
				if ent:GetDTEntity(2):GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*-26 + ent:GetRight()*-40 + ent:GetUp()*10
					view.angles = angles
					view.fov = fov
					view.drawviewer = true

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_kwk_view", CalcView)
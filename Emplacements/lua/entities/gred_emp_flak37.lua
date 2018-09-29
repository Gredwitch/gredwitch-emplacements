AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]88mm Flak 37"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.ExplodeHeight		= -60
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 37"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 5
ENT.BulletType			= "gb_shell_88mm"
ENT.MuzzleCount			= 1

ENT.HasReloadAnim		= true
ENT.ShellSoundTime		= 1.7
ENT.AnimPlayTime		= 1
ENT.AnimPauseTime		= 0.3
ENT.UseSingAnim			= true
ENT.ATReloadSound		= "big"


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
ENT.ShieldForward		= -30
ENT.TurretHorrizontal 	= -3.5
ENT.Seatable			= true

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

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_flak37" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) then
				if ent:GetDTEntity(2):GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*-36 + ent:GetRight()*-10 + ent:GetUp()*30
					view.angles = angles
					view.fov = fov
					view.drawviewer = true

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_flak37_view", CalcView)
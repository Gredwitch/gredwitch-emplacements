AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flak 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flak 38"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.214
ENT.BulletType			= "wac_base_20mm"
ENT.MuzzleCount			= 1

ENT.SoundName			= "shootFlak"
ENT.ShootSound			= "gred_emp/flak38/20mm_shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/flak38/20mm_stop.wav"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 20
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/flak38/flak38_base.mdl"
ENT.SecondModel			= "models/gredwitch/flak38/flak38_shield.mdl"
ENT.Model				= "models/gredwitch/flak38/flak38_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 100
ENT.CanLookArround		= true
ENT.TurretForward		= 12
ENT.Color				= "Yellow"
ENT.num					= 0.5
ENT.Seatable			= true
ENT.TurretHorrizontal 	= -0.6

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,3))
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "Direct Hit" then
		self.AmmoType = "Time-Fuze"
		if CLIENT or game.IsDedicated() or !game.IsDedicated() then plr:ChatPrint("["..self.NameToPrint.."] Time-Fuze rounds selected") end
	elseif self.AmmoType == "Time-Fuze" then
		self.AmmoType = "Direct Hit"
		if CLIENT or game.IsDedicated() or !game.IsDedicated() then plr:ChatPrint("["..self.NameToPrint.."] Direct hit rounds selected") end
	end
	self.NextSwitch = CurTime()+0.2
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_flak38" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) then
				if ent:GetDTEntity(2):GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*-16 + ent:GetRight()*-70 + ent:GetUp()*-10
					view.angles = angles
					view.fov = fov
					view.drawviewer = true

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_flak38_view", CalcView)
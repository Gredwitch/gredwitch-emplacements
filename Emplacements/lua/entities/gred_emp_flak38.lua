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
ENT.CustomRecoil		= true
ENT.Recoil				= 5000

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
	elseif self.AmmoType == "Time-Fuze" then
		self.AmmoType = "Direct Hit"
	end
	net.Start("gred_net_message_ply")
		net.WriteEntity(plr)
		net.WriteString("["..self.NameToPrint.."] "..self.AmmoType.." rounds selected")
	net.Send(plr)
	self.NextSwitch = CurTime()+0.2
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_flak38" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			seat = ent:GetDTEntity(2)
			if ent:ShooterStillValid() and IsValid(seat) then
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
				if seat:GetThirdPersonMode() then
					local view = {}
					
					view.origin = pos + ent:GetForward()*-14.5 + ent:GetRight()*-70 + ent:GetUp()*-10
					view.angles = ang
					view.fov = fov
					view.drawviewer = true

					return view
				else
					local view = {}
					view.origin = pos
					view.angles = ang
					view.fov = fov
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_flak38_view", CalcView)
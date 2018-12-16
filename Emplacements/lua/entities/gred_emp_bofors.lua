AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]40mm Bofors L/60"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Bofors L/60"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.5
ENT.BulletType			= "wac_base_40mm"
ENT.MuzzleCount			= 1
ENT.num					= 0.7
ENT.ExplodeHeight		= -70
ENT.SoundName			= "shootBofors"
ENT.StopSound			= "stopBofors"
ENT.ShootSound			= "gred_emp/bofors/shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/bofors/stop.wav"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 0
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/bofors/bofors_base.mdl"
ENT.SecondModel			= "models/gredwitch/bofors/bofors_shield.mdl"
ENT.Model				= "models/gredwitch/bofors/bofors_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 70
ENT.CanLookArround		= true
ENT.Seatable			= true
ENT.created				= false
ENT.Recoil				= 5000000
ENT.HasShellEject		= false
ENT.Color				= "Red"

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,1))
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	m = math.random(0,2)
	if m == 0 then
		ent.turretBase:SetBodygroup(1,0)
	elseif m == 1 then
		ent.turretBase:SetBodygroup(1,1)
	else
		ent.turretBase:SetBodygroup(1,2)
	end
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
	if ply.Gred_Emp_Class == "gred_emp_bofors" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			seat = ent:GetDTEntity(2)
			if ent:ShooterStillValid() and IsValid(seat) then
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
				if seat:GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*-40.5 + ent:GetRight()*-70 + ent:GetUp()*15
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
hook.Add("CalcView", "gred_emp_bofors_view", CalcView)
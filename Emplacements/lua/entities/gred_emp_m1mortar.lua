AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]81mm M1 Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "M1 Mortar"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 3.33
ENT.AmmoType			= "HE"
ENT.EffectSmoke			= "m203_smokegrenade"
ENT.BulletType			= "gb_shell_81mm"
ENT.Scatter				= 400
ENT.MuzzleCount			= 1

ENT.SoundName 			= "81mmMortar"
ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.TurretHeight		= 0
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.5
ENT.BaseModel			= "models/gredwitch/m1_mortar/m1_mortar_bipod.mdl"
ENT.Model				= "models/gredwitch/m1_mortar/m1_mortar.mdl"
ENT.EmplacementType     = "Mortar"
ENT.MaxUseDistance		= 80

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 38
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(Angle(0,0,-12))
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
		self.BulletType = "gb_shell_81mm"
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "WP"
		self.BulletType = "gb_shell_81mmWP"
	elseif self.AmmoType == "WP" then
		self.AmmoType = "HE"
		self.BulletType = "gb_shell_81mm"
	end
	net.Start("gred_net_message_ply")
		net.WriteEntity(plr)
		net.WriteString("["..self.NameToPrint.."] "..self.AmmoType.." shells selected")
	net.Send(plr)
	self.NextSwitch = CurTime()+0.2
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_m1mortar" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() then
				local a = ply:EyeAngles()
				local entAng = ent:GetAngles()
				local ang = entAng+a
				print(ang)
				-- if ang.y > 120 or ang.y < -120 then
					local view = {}

					view.origin = pos + Vector(0,0,200)
					if ang.y > 70 or ang.y < 110 then
						view.angles = ent.oldA
					else
						ent.oldA = a
						view.angles = a
					end
					view.fov = fov
					view.drawviewer = true

					return view
				-- end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_m1mortar_view", CalcView)
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]20mm Flakvierling 38"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flakvierling 38"

ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.0535
ENT.BulletType			= "wac_base_20mm"
ENT.MuzzleCount			= 4

ENT.Sequential			= true
ENT.SoundName			= "shootFlakvierling"
ENT.ShootSound			= "gred_emp/flakvierling38/20mm_shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/flakvierling38/20mm_stop.wav"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 50
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/flakvierling38/flakvierling_base.mdl"
ENT.SecondModel			= "models/gredwitch/flakvierling38/flakvierling_shield.mdl"
ENT.Model				= "models/gredwitch/flakvierling38/flakvierling_guns.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 150
ENT.CanLookArround		= true
ENT.TurretForward		= 15
ENT.Color				= "Yellow"
ENT.Seatable			= true
ENT.HasShellEject		= false
ENT.TurretHorrizontal 	= 0

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,3))
	if math.random(0,1) == 0 then
		ent.shield:SetBodygroup(1,0)
	else
		ent.shield:SetBodygroup(1,1)
	end
	
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

function ENT:DoShot(plr)
	if m == nil or m > self.MuzzleCount or m == 0 then m = 1 end
	
	attPos = self:GetAttachment(self.MuzzleAttachments[m]).Pos
	attAng = self:GetAttachment(self.MuzzleAttachments[m]).Ang
	
	local b = ents.Create("gred_base_bullet")
				
	if self.num > 0 then
		num = self.num
	else
		num = 1.4
	end
	ang = attAng + Angle(math.Rand(num,-num), math.Rand(num,-num), math.Rand(num,-num))
	b:SetPos(attPos)
	b:SetAngles(ang)
	b.Speed=1000
	b.Size=0
	b.Width=0
	b.Damage=20
	b.Radius=70
	if self.AmmoType == "Time-Fuze" then b.FuzeTime=self.FuzeTime end
	b.sequential=1
	b.gunRPM=3600
	b.Caliber=self.BulletType
	b:Spawn()
	b:Activate()
	constraint.NoCollide(b,self,0,0,true)
	b.Owner=plr
	
	self.tracer = self.tracer + 1
	if self.tracer >= GetConVar("gred_sv_tracers"):GetInt() then
		b:SetSkin(0)
		b:SetModelScale(7)
		if self.CurAmmo <= 20 then 
			self.tracer = GetConVar("gred_sv_tracers"):GetInt() - 2
		else
			self.tracer = 0
		end
	else 
		b.noTracer = true
	end
	-- if GetConVar("gred_sv_limitedammo"):GetInt() == 1 then self:SetCurAmmo(self:GetCurAmmo() - 1) end
	
	self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*700000)
	m = m + 1
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_flakvierling38" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) then
				if ent:GetDTEntity(2):GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*0 + ent:GetRight()*-20 + ent:GetUp()*10
					view.angles = angles
					view.fov = fov
					view.drawviewer = true

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_flakvierling38_view", CalcView)
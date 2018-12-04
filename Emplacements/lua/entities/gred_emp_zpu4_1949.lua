AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]ZPU-4 (1949)"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "ZPU-4"

ENT.Sequential			= true
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.025
ENT.BulletType			= "wac_base_12mm"
ENT.MuzzleCount			= 2
-- ENT.ExplodeHeight		= -30

ENT.SoundName			= "shootZSU"
ENT.ShootSound			= "gred_emp/flakvierling38/20mm_shoot.wav"
ENT.HasStopSound		= true
ENT.ShootSound			= "gred_emp/flakvierling38/20mm_shoot.wav"
ENT.StopSound			= "stopZSU"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 64
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/zpu4_1949/zpu4_base.mdl"
ENT.SecondModel			= "models/gredwitch/zpu4_1949/zpu4_shield.mdl"
ENT.Model				= "models/gredwitch/zpu4_1949/zpu4_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 80
ENT.CanLookArround		= true
ENT.Color				= "Green"
ENT.Seatable			= true
ENT.created				= false
ENT.HasShellEject		= false

ENT.ViewForward			= 1
ENT.ViewRight			= -70
ENT.ViewUp				= -10

ENT.TurretHeight		= 50
ENT.TurretForward		= 0


function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
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

function ENT:DoShot(plr)
	if m == nil or m > self.MuzzleCount or m == 0 then m = 1 end
	
	attPos = self:GetAttachment(self.MuzzleAttachments[m]).Pos
	attAng = self:GetAttachment(self.MuzzleAttachments[m]).Ang
	
	local b = ents.Create("gred_base_bullet")
				
	if self.num > 0 then
		num = self.num
	else
		num = 0.5
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
	
	if self.SecondModel then
		b.Filter = {self,self.turretBase,self.shield}
	else
		b.Filter = {self,self.turretBase}
	end
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
	
	self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*200000)
	m = m + 1
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_zpu4_1949" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) then
				if ent:GetDTEntity(2):GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*0 + ent:GetRight()*-60 + ent:GetUp()*10
					view.angles = angles - Angle(3)
					view.fov = fov
					view.drawviewer = true

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_zpu4_view", CalcView)

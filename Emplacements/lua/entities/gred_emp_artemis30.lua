AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]30mm Artemis 30"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Artemis 30"

ENT.Sequential			= true
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.0375
ENT.BulletType			= "wac_base_30mm"
ENT.MuzzleCount			= 2
ENT.ExplodeHeight		= -30

ENT.SoundName			= "shootArtemis"
ENT.ShootSound			= "gred_emp/artemis30/shoot.wav"
ENT.HasStopSound		= true
ENT.StopSoundName		= "gred_emp/artemis30/stop.wav"
ENT.StopSound			= "stopArtemis"
ENT.FuzeEnabled			= true
ENT.FuzeTime			= 0.01
ENT.AmmoType			= "Direct Hit"
ENT.CanSwitchAmmoTypes	= true

ENT.TurretHeight		= 64
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/artemis30/artemis30_base.mdl"
ENT.SecondModel			= "models/gredwitch/artemis30/artemis30_shield.mdl"
ENT.Model				= "models/gredwitch/artemis30/artemis30_gun.mdl"
ENT.EmplacementType     = "MG"
ENT.MaxUseDistance		= 80
ENT.CanLookArround		= true
ENT.Color				= "Yellow"
ENT.Seatable			= true
ENT.created				= false
ENT.HasShellEject		= false

ENT.ViewForward			= 1
ENT.ViewRight			= -70
ENT.ViewUp				= -10
ENT.Recoil				= 80000

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
		num = 2
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
	b.gunRPM=self.GunRPM
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
	
	self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*self.Recoil)
	m = m + 1
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_artemis30" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			seat = ent:GetDTEntity(2)
			if ent:ShooterStillValid() and IsValid(seat) then
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
				if seat:GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*1 + ent:GetRight()*-70 + ent:GetUp()*-10
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
hook.Add("CalcView", "gred_emp_artemis30_view", CalcView)

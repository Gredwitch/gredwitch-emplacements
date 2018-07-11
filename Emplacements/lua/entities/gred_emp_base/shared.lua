ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Base"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Base"

ENT.LastShot			= 0
ENT.MuzzleEffect		= ""
ENT.ShotInterval		= 0
ENT.BulletType			= ""
ENT.MuzzleCount			= 1
ENT.NextSwitch			= 0.5
ENT.tracer 				= 0
ENT.Color				= "Green"
ENT.EmplacementType     = "MG"

ENT.AnimPlaying			= false
ENT.AmmoType			= "AP"
ENT.FuzeTime			= 0
ENT.CanSwitchAmmoTypes	= false
ENT.AnimRestartTime		= 0
ENT.NextAnim			= 0
ENT.HasReloadAnim		= false
ENT.AnimPlayTime		= 0.5
ENT.ShellEjectTime		= 0.2

ENT.SoundName			= "shootSound"
ENT.StopSound			= ""
ENT.HasStopSound		= false
ENT.StopSoundName		= "stopSound"
ENT.ShootSound			= ""
ENT.NoStopSound			= false

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0
ENT.BaseModel			= ""
ENT.Model				= ""
ENT.Scatter				= 1
ENT.MaxUseDistance		= 60
ENT.Seatable			= false
ENT.SecondModel			= ""
ENT.HasRotatingBarrel	= false
ENT.BasePos				= Vector(0,0,0)
ENT.BaseAng				= Angle(0,0,0)
ENT.OffsetPos			= Vector(0,0,0)
ENT.OffsetAng			= Angle(0,0,0)
ENT.Shooter				= nil
ENT.ShooterLast			= nil
ENT.SeatShooting		= false
ENT.BarrelHeight		= 0
ENT.NextAmmoSwitch		= 0

local CanPlayStopSnd = false

local SmokeSnds = {}
SmokeSnds[1]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
SmokeSnds[2]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
SmokeSnds[3]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
SmokeSnds[4]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

local noHitSky = false
local reachSky = Vector(0,0,9999999999)

function ENT:SetupDataTables()
	self:DTVar("Entity",0,"Shooter")
	self:DTVar("Entity",1,"ShootPos")
end

function ENT:SetShooter(plr)
	self.Shooter=plr
	self:SetDTEntity(0,plr)
end

function ENT:GetShooter(plr)
	if SERVER then
		return self.Shooter
	elseif CLIENT then
		return self:GetDTEntity(0)
	end
end

function ENT:AddOnThink()
end

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "AP" then
		self.AmmoType = "HE"
	
	elseif self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
	
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "AP"
	end
	if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." shells selected") end
	self.NextSwitch = CurTime()+0.2
end

function ENT:SetTimeFuze(plr)
	if self.NextAmmoSwitch > CurTime() and !IsValid(ply) then return end
	if self.FuzeTime >= 0.2 or self.FuzeTime <= 0 then self.FuzeTime = 0.01
	else self.FuzeTime = self.FuzeTime + 0.01 end
	plr:ChatPrint("["..self.NameToPrint.."] Time fuze set to "..self.FuzeTime.." seconds")
	self.NextAmmoSwitch = CurTime()+0.2
end

function ENT:Use(plr)
	if not self:ShooterStillValid() then
		self:SetShooter(plr)
		self:StartShooting()
		self.ShooterLast=plr
	else
		if plr==self.Shooter then
			self:SetShooter(nil)
			self:FinishShooting()
		end
	end
end

function ENT:ShooterStillValid()
	local shooter=nil
	if SERVER then
		shooter=self.Shooter
	elseif CLIENT then
		shooter=self:GetDTEntity(0)
	end
	if self.Seatable then
		return IsValid(shooter) and shooter:Alive()
	else
		return IsValid(shooter) and shooter:Alive() and
		((self:GetPos()+self.TurretModelOffset):Distance(shooter:GetShootPos())<=self.MaxUseDistance)
	end
end

function ENT:DoShot(plr)
	if self.LastShot+self.ShotInterval<CurTime() then
		if self.EmplacementType == "Mortar" then
			
			local aimpos = self:GetAttachment(self:LookupAttachment("muzzle"))
			local tr = util.QuickTrace(aimpos.Pos,aimpos.Pos + reachSky,{self,self,self.turretBase,self.shootpos} )
			
			if !tr.HitSky or (!tr.HitWorld and !tr.HitSky and !tr.Hit) then
				canShoot = false
				noHitSky = true
				if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] Nothing must block the mortar's muzzle!") end
			else
				noHitSky = false
			end
			
			if !canShoot then
				-- if !noHitSky and CLIENT then plr:ChatPrint("["..self.NameToPrint.."] You can't shoot there!") end
				self.LastShot=CurTime()-self.ShotInterval/1.2
				return 
			end
			
		end
		if self.EmplacementType == "Mortar" or self.EmplacementType == "AT" then
			local pos = self:GetPos()
			util.ScreenShake(pos,5,5,0.5,200)
			ParticleEffect("gred_mortar_explosion_smoke_ground", pos-Vector(0,0,30),Angle(90,0,0))
		end
		for m = 1,self.MuzzleCount do
			if self.HasRotatingBarrel then
				newEnt = self:GetDTEntity(5)
			else
				newEnt = self
			end
			if !game.IsDedicated() then
				self.MuzzleAttachmentsClient = {}
				self.MuzzleAttachmentsClient[1] = newEnt:LookupAttachment("muzzle")
				for v=1,self.MuzzleCount do
					if v>1 then
						self.MuzzleAttachmentsClient[v] = newEnt:LookupAttachment("muzzle"..v.."")
					end
				end
				attPos = newEnt:GetAttachment(self.MuzzleAttachmentsClient[m]).Pos
				attAng = newEnt:GetAttachment(self.MuzzleAttachmentsClient[m]).Ang
			elseif SERVER then
				attPos = newEnt:GetAttachment(self.MuzzleAttachments[m]).Pos
				attAng = newEnt:GetAttachment(self.MuzzleAttachments[m]).Ang
			end
			if SERVER then
				if GetConVar("gred_sv_altmuzzleeffect"):GetInt() == 1 or (self.EmplacementType != "MG" and self.EmplacementType != "Mortar") then
					ParticleEffect(self.MuzzleEffect,attPos,attAng,nil)
				else
					local effectdata=EffectData()
					effectdata:SetOrigin(attPos)
					effectdata:SetAngles(attAng)
					effectdata:SetEntity(self)
					effectdata:SetScale(1)
					util.Effect("MuzzleEffect", effectdata)
				end
			end
			if SERVER then
				if self.EmplacementType == "MG" then
					local b = ents.Create("gred_base_bullet")
					
					if self.BulletType == "wac_base_7mm" then
						num = 0.3
					elseif self.BulletType == "wac_base_12mm" then
						num = 0.5
					elseif self.BulletType == "wac_base_20mm" then
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
					if self.tracer >= GetConVarNumber("gred_sv_tracers") then
						util.SpriteTrail(b, 0, bcolor, false, num1, num1, num2, num3, "trails/laser.vmt")
						if self.Color == "Red" then
							util.SpriteTrail(b, 0, red, false, num4, num5, num6, num7, "trails/smoke.vmt")
						elseif self.Color == "Green" then
							util.SpriteTrail(b, 0, green, false, num4, num5, num6, num7, "trails/smoke.vmt")
						end
						self.tracer = 0
					end
					
				elseif self.EmplacementType == "AT" then
					local b=ents.Create(self.BulletType)
					ang = attAng + Angle(math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter))
					local shootpos = attPos
					b:SetPos(shootpos)
					b:SetAngles(attAng)
					b.GBOWNER=plr
					b:Spawn()
					b:Activate()
					b:SetBodygroup(0,1)
					b:SetBodygroup	  (1,1)
					if self.AmmoType == "AP" then
						b:SetBodygroup	  (1,0)
						b.AP = true
					elseif self.AmmoType == "Smoke" then
						b.Smoke = true
					end
					b:Launch()
					local bphys = b:GetPhysicsObject()
					if IsValid(bphys) then 
						velocity = self:GetRight()*-9999999999999
						if !game.IsDedicated() then
							bphys:ApplyForceCenter(velocity) 
						else
							bphys:AddVelocity(velocity)
						end
					end
					b.Owner=plr
					timer.Simple(self.AnimPlayTime + self.ShellEjectTime,function()
						if !IsValid(self) then return end
						shellEject = self:GetAttachment(self:LookupAttachment("shelleject"))
						local shell = ents.Create("gred_prop_casing")
						shell.Model = "models/gredwitch/bombs/75mm_shell.mdl"
						shell:SetPos(shellEject.Pos)
						shell:SetAngles(shellEject.Ang)
						shell.BodyGroupA = 1
						shell.BodyGroupB = 2
						shell:Spawn()
						shell:Activate()
					end)
				elseif self.EmplacementType == "Mortar" then
					local b=ents.Create(self.BulletType)
					local shootPos=util.TraceLine(util.GetPlayerTrace(self.Shooter)).HitPos
					timer.Simple(4,function()
						if not IsValid(self) then return end
						
						local b=ents.Create(self.BulletType)
						local spawnAtt = GetConVar("gred_sv_mortar_shellspawnaltitude"):GetInt()
						if spawnAtt == nil then spawnAtt = 1000 end
						b:SetPos(shootPos + Vector(math.random(-self.Scatter,self.Scatter),math.random(-self.Scatter,self.Scatter),spawnAtt))
						b:SetAngles(Angle(90,0,0))
						b:SetOwner(self.Shooter)
						if self.AmmoType == "Smoke" then
							b.Effect 		  				   = self.EffectSmoke
							b.EffectAir 	  				   = self.EffectSmoke
							b.ExplosionRadius 				   = 0
							b.ExplosionDamage 				   = 0
							b.SpecialRadius   				   = 0
							b.PhysForce						   = 0
							b.RSound						   = 1
							b.DEFAULT_PHYSFORCE                = 0
							b.DEFAULT_PHYSFORCE_PLYAIR         = 0
							b.DEFAULT_PHYSFORCE_PLYGROUND      = 0
							b.ExplosionSound				   = table.Random(SmokeSnds)
							b.WaterExplosionSound			   = table.Random(SmokeSnds)
							b.Smoke = true
						end
						b.GBOWNER=plr
						b:Spawn()
						b:Activate()
						b:EmitSound("artillery/flyby/artillery_strike_incoming_0"..(math.random(1,4))..".wav", 140, 100, 1)
						b:Arm()
						b.Owner=plr
					end)
				end
				if self.EmplacementType == "MG" then
					self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*50000)
				elseif self.EmplacementType == "AT" then
					self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*500000000)
				end
			end
		end
		self:EmitSound(self.SoundName)
		if self.EmplacementType == "AT" then self:PlayAnim() end
		self.LastShot=CurTime()
	end
end

function ENT:PlayAnim()
	if SERVER then
		if self.HasRotatingBarrel then
			if self.NextAnim < CurTime() then
				self.barrel:ResetSequence(self.barrel:LookupSequence("spin"))
				self.NextAnim = CurTime() + self.AnimRestartTime
			end
		end
		if self.HasShootAnim then
			shoot = self:LookupSequence("shoot")
			self:ResetSequence(shoot)
		end
		if self.HasReloadAnim then
			if self.AnimPlaying then return end
			timer.Simple(self.AnimPlayTime,function()
				if !IsValid(self) then return end
				self:ResetSequence(self:LookupSequence("reload_finish"))
				self.AnimPlaying = true
			end)
			timer.Simple(self.AnimRestartTime,function() 
				if !IsValid(self) then return end
				self:ResetSequence(self:LookupSequence("reload_start")) 
				self.AnimPlaying = false
			end)
		end
	end
end

function ENT:SetShootAngles()
	if SERVER then
		self:GetShooter():DrawViewModel(false)
		net.Start("TurretBlockAttackToggle")
		net.WriteBit(true)
		net.Send(self:GetShooter())
		if self.Seatable and !self:GetShooter():InVehicle() then
			self:SetShooter(nil)
			self:FinishShooting()
			if !self:ShooterStillValid() then return end
		end
		if self.HasRotatingBarrel then
			offsetAng=(self.barrel:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
			offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
		else
			offsetAng=(self:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
			offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
		end
		if self.TurretTurnMax > -1 or self.EmplacementType != "MG" or !self.Seatable then
			if offsetDot>=self.TurretTurnMax then
				local offsetAngNew=offsetAng:Angle()
				offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
				
				self.OffsetAng=offsetAngNew
				if self.EmplacementType == "Mortar" then canShoot = true end
			else
				if self.EmplacementType == "Mortar" then canShoot = false end
			end
		end
	end
end

function ENT:SetPlayerKeys(ply)
	local pressKey  = IN_BULLRUSH
	local switchKey = IN_ATTACK2
	local fuzekey   = IN_RELOAD
	local fuzereset = IN_SPEED
	local camera	= IN_DUCK
	if CLIENT and game.SinglePlayer() then
		pressKey  = IN_ATTACK
		switchKey = IN_ATTACK2
		fuzekey	  = IN_RELOAD
		fuzereset = IN_SPEED
		camera	  = IN_DUCK
	end
	self.Secondary			= ply:KeyDown(switchKey)
	self.Firing				= ply:KeyDown(pressKey)
	self.SwitchedFuzeKey	= ply:KeyDown(fuzekey)
	self.ResetFuzeKey		= ply:KeyDown(fuzereset)
	self.SwitchCamKey		= ply:KeyDown(camera)
end

function ENT:PlayerSetSecondary(ply)
	if self.Secondary then
		if self.EmplacementType != "MG" or (self.CanSwitchAmmoTypes and self.EmplacementType == "MG") then 
			self:SwitchAmmoType(ply) 
		end
	end
	if self.SwitchedFuzeKey and self.CanSwitchAmmoTypes and self.EmplacementType == "MG" and self.AmmoType == "Time-Fuze" then
		self:SetTimeFuze(ply)
	end
	if self.ResetFuzeKey and self.CanSwitchAmmoTypes and self.EmplacementType == "MG" and self.AmmoType == "Time-Fuze" then
		if self.NextAmmoSwitch < CurTime() then
			self.FuzeTime = 0.01
			ply:ChatPrint("["..self.NameToPrint.."] Time fuze reseted to "..self.FuzeTime.." seconds")
			self.NextAmmoSwitch = CurTime()+0.2
		end
	end
end

function ENT:ShieldThink()
	if SERVER then
		self.shield:SetSkin(self:GetSkin())
		self.shield:SetPos(self.BasePos)
		self.shield:SetAngles(Angle(self.turretBase:GetAngles().p,self:GetAngles().y,self.turretBase:GetAngles().r))
	end
end

function ENT:Think()
	if SERVER and (!IsValid(self.turretBase) or (self.Seatable and !IsValid(self.shield))) then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			self:AddOnThink()
			local player = self:GetShooter()
			if SERVER then
				self.turretBase:SetSkin(self:GetSkin())
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
			end
			if self.Seatable then
				self:ShieldThink()
			end
			if self:ShooterStillValid() then
				self:SetShootAngles()
				self:SetPlayerKeys(player)
			else
				self.Firing=false
				if SERVER then
					self.OffsetAng=self.turretBase:GetAngles()
					
					self:SetShooter(nil)
					self:FinishShooting()
				end
			end
			if self.Firing then
				self:DoShot(player)
				CanPlayStopSnd = true
				if self.EmplacementType == "MG" then self:PlayAnim() end
			end
			if !self.Firing and self.EmplacementType == "MG" and CanPlayStopSnd then
				self:StopSound(self.SoundName)
				if self.HasStopSound then 
					self:EmitSound(self.StopSoundName)
					CanPlayStopSnd = false
				end
			end
			self:PlayerSetSecondary(player)
			self:NextThink(CurTime())
			return true
		end
	end
end
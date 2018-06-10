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

ENT.HERadius			= 0
ENT.HEDamage			= 0
ENT.EffectHE			= ""
ENT.EffectSmoke			= "doi_smoke_artillery"
ENT.AmmoType			= "AP"

ENT.SoundName			= "shootSound"
ENT.ShootSound			= ""

ENT.TurretHeight		= 1
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0
ENT.BaseModel			= ""
ENT.Model				= ""
ENT.EmplacementType     = "MG"
ENT.Scatter				= 1
ENT.MaxUseDistance		= 60
ENT.Seatable			= false
ENT.SecondModel			= ""

ENT.BasePos				= Vector(0,0,0)
ENT.BaseAng				= Angle(0,0,0)
ENT.OffsetPos			= Vector(0,0,0)
ENT.OffsetAng			= Angle(0,0,0)
ENT.Shooter				= nil
ENT.ShooterLast			= nil
ENT.SeatShooting		= false

local ExploSnds = {}
ExploSnds[1]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
ExploSnds[2]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
ExploSnds[3]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
ExploSnds[4]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

local PLAYER = not game.IsDedicated() or CLIENT
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

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() and !IsValid(ply) then return end
	if SERVER then
		if self.AmmoType == "AP" then
			self.AmmoType = "HE"
		
		elseif self.AmmoType == "HE" then
			self.AmmoType = "Smoke"
		
		elseif self.AmmoType == "Smoke" then
			self.AmmoType = "AP"
		end
		if PLAYER then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." shells selected") end
	end
	self.NextSwitch = CurTime()+0.2
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

function ENT:DoShot()
	if self.LastShot+self.ShotInterval<CurTime() then
		if self.EmplacementType == "Mortar" then
			
			local aimpos = self:GetAttachment(self:LookupAttachment("muzzle"))
			local tr = util.QuickTrace(aimpos.Pos,aimpos.Pos + reachSky,{self,self,self.turretBase,self.shootpos} )
			
			if !tr.HitSky or (!tr.HitWorld and !tr.HitSky and !tr.Hit) then
				canShoot = false
				if SERVER then if PLAYER then self:GetShooter():ChatPrint("["..self.NameToPrint.."] Nothing must block the mortar's muzzle! ") end end
				noHitSky = true
			else
				noHitSky = false
			end
			if !canShoot then
				if !noHitSky and SERVER then if PLAYER then self:GetShooter():ChatPrint("["..self.NameToPrint.."] You can't shoot there!") end end
				self.LastShot=CurTime()-self.ShotInterval/1.2
			return end
			
			local pos = self:GetPos()
			util.ScreenShake(pos,5,5,0.5,200)
			ParticleEffect("gred_mortar_explosion_smoke_ground", pos-Vector(0,0,30),Angle(90,0,0))
		end
		for m = 1,self.MuzzleCount do
		
			self.MuzzleAttachmentsClient = {}
			self.MuzzleAttachmentsClient[1] = self:LookupAttachment("muzzle")
			for v=1,self.MuzzleCount do
				if v>1 then
					self.MuzzleAttachmentsClient[v] = self:LookupAttachment("muzzle"..v.."")
				end
			end
			ParticleEffect(self.MuzzleEffect,self:GetAttachment(self.MuzzleAttachmentsClient[m]).Pos,
			self:GetAttachment(self.MuzzleAttachmentsClient[m]).Ang,nil)
			
			if IsValid(self.shootPos) then
				b=ents.Create(self.BulletType)
				if self.EmplacementType == "MG" then
					b = ents.Create("gred_base_bullet")
					
					if self.BulletType == "wac_base_7mm" then
						ang = self:GetAttachment(self.MuzzleAttachments[m]).Ang + Angle(math.Rand(-0.5,0.5), math.Rand(-0.5,0.5), math.Rand(-0.5,0.5))
					elseif self.BulletType == "wac_base_12mm" then
						ang = self:GetAttachment(self.MuzzleAttachments[m]).Ang + Angle(math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1))
					end
					b:SetPos(self:GetAttachment(self.MuzzleAttachments[m]).Pos)
					b:SetAngles(ang)
					b.Speed=1000
					b.Size=0
					b.Width=0
					b.Damage=20
					b.Radius=70
					b.sequential=1
					b.gunRPM=3600
					b.Caliber=self.BulletType
					b:Spawn()
					b:Activate()
					constraint.NoCollide(b,self,0,0,true)
					b.Owner=self.Shooter
					
					self.tracer = self.tracer + 1
					if self.tracer >= GetConVarNumber("gred_tracers") then
						util.SpriteTrail(b, 0, bcolor, false, num1, num1, num2, num3, "trails/laser.vmt")
						if self.Color == "Red" then
							util.SpriteTrail(b, 0, red, false, num4, num5, num6, num7, "trails/smoke.vmt")
						elseif self.Color == "Green" then
							util.SpriteTrail(b, 0, green, false, num4, num5, num6, num7, "trails/smoke.vmt")
						end
						self.tracer = 0
					end
					
				elseif self.EmplacementType == "AT" then
					ang = self:GetAttachment(self.MuzzleAttachments[m]).Ang + Angle(math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter))
					local shootpos = self:GetAttachment(self.MuzzleAttachments[m]).Pos
					b:SetPos(shootpos)
					b:SetAngles(ang)
					if self.AmmoType == "HE" then
						if self.BulletType == "gb_rocket_75mm" then b.Model = "models/gredwitch/75mm_he.mdl" end
						b.ExplosionRadius = self.HERadius
						b.ExplosionDamage = self.HEDamage
						b.Effect		  = self.EffectHE
						b.EffectAir		  = self.EffectHE
					elseif self.AmmoType == "Smoke" then
						if self.BulletType == "gb_rocket_75mm" then b.Model = "models/gredwitch/75mm_he.mdl" end
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
						b.ExplosionSound				   = table.Random(ExploSnds)
						b.WaterExplosionSound			   = table.Random(ExploSnds)
						b.Smoke = true
					end
					b.GBOWNER=self:GetShooter()
					b:Spawn()
					b:Activate()
					b:Launch()
					b:SetVelocity(shootpos-self:GetAngles():Forward()*1000000)
					b.Owner=self.Shooter
					
				elseif self.EmplacementType == "Mortar" then
					local shootPos=util.TraceLine(util.GetPlayerTrace(self.Shooter)).HitPos
					timer.Simple(4,function()
						if not IsValid(self) then return end
						
						local b=ents.Create(self.BulletType)
						b:SetPos(shootPos + Vector(math.random(-self.Scatter,self.Scatter),math.random(-self.Scatter,self.Scatter),1000))
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
							b.ExplosionSound				   = table.Random(ExploSnds)
							b.WaterExplosionSound			   = table.Random(ExploSnds)
							b.Smoke = true
						elseif self.AmmoType == "WP" then
						end
						b.GBOWNER=self:GetShooter()
						b:Spawn()
						b:Activate()
						b:EmitSound("artillery/flyby/artillery_strike_incoming_0"..(math.random(1,4))..".wav", 140, 100, 1)
						b:Arm()
						b.Owner=self.Shooter
					end)
				end
				if self.EmplacementType == "MG" then
					self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*50000)
				elseif self.EmplacementType == "AT" then
					self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*9999999999999)
				end
			end
		end
	self.LastShot=CurTime()
	self:EmitSound(self.SoundName)
	end
end

function ENT:Think()
	
	if SERVER and (!IsValid(self.turretBase) or (self.Seatable and !IsValid(self.shield))) then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			if SERVER then
				self.turretBase:SetSkin(self:GetSkin())
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
				if self.Seatable then
					self.shield:SetSkin(self:GetSkin())
					self.shield:SetPos(self.turretBase:GetPos())
					self.shield:SetAngles(Angle(self.turretBase:GetAngles().p,self:GetAngles().y,self.turretBase:GetAngles().r))
				end
			end
			if self:ShooterStillValid() then
				if SERVER then
					if self.Seatable and !self:GetShooter():InVehicle() then
						self:SetShooter(nil)
						self:FinishShooting()
						if !self:ShooterStillValid() then return end
					end
					
					local offsetAng=(self:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
					local offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
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
					
					--[[local GetTurretHeight=self:GetAngles().r - self.turretBase:GetAngles().r
					if GetTurretHeight <1 and self.Seatable then
						self:SetAngles(Angle(self:GetAngles().p,self:GetAngles().y,1))
						print(self:GetAngles())
					-- end]]
				end
				local pressKey  = IN_BULLRUSH
				local switchKey = IN_ATTACK2
				if CLIENT and game.SinglePlayer() then
					pressKey  = IN_ATTACK
					switchKey = IN_ATTACK2
				end
				self.Secondary = self:GetShooter():KeyDown(switchKey)
				self.Firing		= self:GetShooter():KeyDown(pressKey)
			else
				self.Firing=false
				if SERVER then
					self.OffsetAng=self.turretBase:GetAngles()
					
					self:SetShooter(nil)
					self:FinishShooting()
				end
			end
			if self.Firing then
				self:DoShot()
			end
			if !self.Firing and self.EmplacementType == "MG" then
				self:StopSound(self.SoundName)
			end
			if self.Secondary then
				if self.EmplacementType != "MG" then 
					self:SwitchAmmoType(self:GetShooter()) 
				end
			end
			self:NextThink(CurTime())
			return true
		end
	end
end	
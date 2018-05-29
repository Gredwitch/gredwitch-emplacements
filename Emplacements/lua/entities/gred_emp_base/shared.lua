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

ENT.BasePos=Vector(0,0,0)
ENT.BaseAng=Angle(0,0,0)
ENT.OffsetPos=Vector(0,0,0)
ENT.OffsetAng=Angle(0,0,0)
ENT.Shooter=nil
ENT.ShooterLast=nil

local ExploSnds = {}
ExploSnds[1]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
ExploSnds[2]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
ExploSnds[3]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
ExploSnds[4]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

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
	if self.NextSwitch > CurTime() then return end
	if SERVER then
		if self.AmmoType == "AP" then
			self.AmmoType = "HE"
		
		elseif self.AmmoType == "HE" then
			self.AmmoType = "Smoke"
		
		elseif self.AmmoType == "Smoke" then
			self.AmmoType = "AP"
		end
		if not game.IsDedicated() then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." shells selected") end
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
	
	return IsValid(shooter) and shooter:Alive() and ((self:GetPos()+self.TurretModelOffset):Distance(shooter:GetShootPos())<=60)
end
function ENT:DoShot()
	if self.LastShot+self.ShotInterval<CurTime() then
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
				local b=ents.Create(self.BulletType)
				
				if self.EmplacementType == "MG" then
					if self.BulletType == "wac_base_7mm" then
						ang = self:GetAttachment(self.MuzzleAttachments[m]).Ang + Angle(math.Rand(-0.5,0.5), math.Rand(-0.5,0.5), math.Rand(-0.5,0.5))
					elseif self.BulletType == "wac_base_12mm" then
						ang = self:GetAttachment(self.MuzzleAttachments[m]).Ang + Angle(math.Rand(-0.5,0.5), math.Rand(-0.5,0.5), math.Rand(-0.5,0.5))
					end
					b:SetPos(self:GetAttachment(self.MuzzleAttachments[m]).Pos)
					b:SetAngles(ang)
					b.Speed=1000
					b.Size=0
					b.Width=0
					b.Damage=40
					b.Radius=70
					b.sequential=1
					b.gunRPM=3600
					b:Spawn()
					b:Activate()
					constraint.NoCollide(b,self,0,0,true)
					
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
					ang = self:GetAttachment(self.MuzzleAttachments[m]).Ang + Angle(math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1))
					b:SetPos(self:GetAttachment(self.MuzzleAttachments[m]).Pos)
					b:SetAngles(ang)
					if self.AmmoType == "HE" then
						if self.BulletType == "gb_rocket_75mm" then b.Model = "models/gredwitch/75mm_he.mdl" end
						b.ExplosionRadius = self.HERadius
						b.ExplosionDamage = self.HEDamage
						b.Effect		  = self.EffectHE
						b.EffectAir		  = self.EffectHE
					elseif self.AmmoType == "Smoke" then
						if self.BulletType == "gb_rocket_75mm" then b.Model = "models/gredwitch/75mm_he.mdl" end
						b.Effect 		  				   = "doi_smoke_artillery"
						b.EffectAir 	  				   = "doi_smoke_artillery"
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
					b.GBOWNER=self.Shooter
					b:Spawn()
					b:Activate()
					b:Launch()
				end
				b.Owner=self.Shooter
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
	
	if not IsValid(self.turretBase) and SERVER then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			if SERVER then
				self.turretBase:SetSkin(self:GetSkin())
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
			end
			if self:ShooterStillValid() then
				if SERVER then
					local offsetAng=(self:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
					local offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
					local HookupPos=self:GetAttachment(self.HookupAttachment).Pos
					if offsetDot>=self.TurretTurnMax then
						local offsetAngNew=offsetAng:Angle()
						offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
						
						self.OffsetAng=offsetAngNew
					end
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
				if self.EmplacementType == "AT" then self:SwitchAmmoType(self:GetShooter()) end
			end
			self:NextThink(CurTime())
			return true
		end
	end
end	
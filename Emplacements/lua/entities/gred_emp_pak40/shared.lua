ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]PaK 40"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.8

ENT.LastShot			= 0
ENT.ShotInterval		= 4.8
ENT.NextSwitch			= 0
ENT.AmmoType			= "AP"
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

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	
	if	   self.AmmoType == "AP" then
		self.AmmoType = "HE"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[PaK 40] HE Shells selected") end
	
	elseif self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[PaK 40] Smoke Shells selected") end
	
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "AP"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[PaK 40] AP Shells selected") end
	end
	
	self.NextSwitch = CurTime()+0.2
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
		self:EmitSound("shootPaK40")
		
		ParticleEffect("gred_mortar_explosion_smoke_ground", self:GetPos()+Vector(0,0,50),Angle(0,0,0))
		local shoot1Pos=self:GetAttachment(self.MuzzleAttachment).Pos
		local shoot1Ang=self:GetAttachment(self.MuzzleAttachment).Ang
		ParticleEffect("muzzleflash_bar_3p",shoot1Pos,shoot1Ang,nil)
		if IsValid(self.shootPos) and SERVER then
			
			local shoot1Pos=self:GetAttachment(self.MuzzleAttachment).Pos
			local shoot1Ang=self:GetAttachment(self.MuzzleAttachment).Ang
			
			local b=ents.Create("gb_rocket_75mm")
			ang = shoot1Ang + Angle(math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1))
			b:SetPos(shoot1Pos)
			b:SetAngles(ang)
			b:SetOwner(self.Shooter)
			if self.AmmoType == "HE" then
				b.Model			  = "models/gredwitch/75mm_ap.mdl"
				b.ExplosionRadius = 300
				b.ExplosionDamage = 75
				b.Effect		  = "ins_c4_explosion"
				b.EffectAir		  = "ins_c4_explosion"
			elseif self.AmmoType == "Smoke" then
				b.Model			  				   = "models/gredwitch/75mm_ap.mdl"
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
			
			self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*9999999999999)
		end
		self.LastShot=CurTime()
	end
end

function ENT:Think()
	
	if not IsValid(self.turretBase) and SERVER then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			if SERVER then
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
			end
			if self:ShooterStillValid() then
				if SERVER then
					local offsetAng=(self:GetAttachment(self.MuzzleAttachment).Pos-self:GetDesiredShootPos()):GetNormal()
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
				self.SwitchAmmo = self:GetShooter():KeyDown(switchKey)
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
			if self.SwitchAmmo then
				self:SwitchAmmoType(self:GetShooter())
			end
			self:NextThink(CurTime())
			return true
		end
	end
end	
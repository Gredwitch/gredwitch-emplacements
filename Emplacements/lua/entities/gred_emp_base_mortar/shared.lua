ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Base Mortar"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0.8

ENT.LastShot			= 0
ENT.ShotInterval		= 3
ENT.NextSwitch			= 0
ENT.AmmoType			= "HE"
ENT.Scatter				= 400
ENT.BasePos				= Vector(0,0,0)
ENT.BaseAng				= Angle(0,0,0)

ENT.OffsetPos			= Vector(0,0,0)
ENT.OffsetAng			= Angle(0,0,0)

ENT.Shooter				= nil
ENT.ShooterLast			= nil
ENT.Model 				= "models/gredwitch/m1_mortar/m1_mortar.mdl"
ENT.SoundName 			= "81mmMortar"
ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"
ENT.ShellType			= "gb_rocket_81mm"

local ExploSnds 		= {}
ExploSnds[1]			=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
ExploSnds[2]			=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
ExploSnds[3]			=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
ExploSnds[4]			=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

function ENT:SwitchAmmoType(plr)
	if self.NextSwitch > CurTime() then return end
	
	if self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[Mortar] Smoke Shells selected") end
	
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "HE"
		if CLIENT or game.IsDedicated() then plr:ChatPrint("[Mortar] HE Shells selected") end
	end
	
	self.NextSwitch = CurTime()+0.2
end

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

function ENT:ShooterStillValid()
	local shooter=nil
	if SERVER then
		shooter=self.Shooter
	elseif CLIENT then
		shooter=self:GetDTEntity(0)
	end
	
	return IsValid(shooter) and shooter:Alive() and ((self:GetPos()+self.TurretModelOffset):Distance(shooter:GetShootPos())<=80)
end

function ENT:DoShot()
	if self.LastShot+self.ShotInterval<CurTime() then
		self:EmitSound(self.SoundName)
		
		ParticleEffect("gred_mortar_explosion_smoke_ground", self:GetPos(),Angle(90,0,0))
		local shoot1Pos=self:GetAttachment(self.MuzzleAttachment).Pos
		local shoot1Ang=self:GetAttachment(self.MuzzleAttachment).Ang
		ParticleEffect("muzzleflash_bar_3p",shoot1Pos,shoot1Ang,nil)
		util.ScreenShake(shoot1Pos,5,5,0.5,200)
		if SERVER then
			local shootPos=util.TraceLine(util.GetPlayerTrace(self.Shooter)).HitPos
			timer.Simple(4,function()
				if not IsValid(self) then return end
				
				local b=ents.Create(self.ShellType)
				b:SetPos(shootPos + Vector(math.random(-self.Scatter,self.Scatter),math.random(-self.Scatter,self.Scatter),1000))
				-- (shootPos):Distance(shooter:GetShootPos())<=80) )
				b:SetAngles(Angle(90,0,0))
				b:SetOwner(self.Shooter)
				if self.AmmoType == "Smoke" then
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
				elseif self.AmmoType == "WP" then
				end
				b.GBOWNER=self:GetShooter()
				b:Spawn()
				b:Activate()
				b:EmitSound("artillery/flyby/artillery_strike_incoming_0"..(math.random(1,4))..".wav", 140, 100, 1)
				b:Arm()
			end)
		end
		self.LastShot=CurTime()
	end
end

function ENT:Think()
	if IsValid(self) then
		if self:ShooterStillValid() then
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
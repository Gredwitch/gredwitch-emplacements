ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Base"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.tracer 				= 0
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= 0
ENT.BulletType			= "wac_base_7mm"
ENT.LastShot			= 0
ENT.ShotInterval		= 0
ENT.ShootSound			= ""
ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.MuzzleCount			= 1
ENT.BaseModel			= "models/gredwitch/mg81z/mg81z_tripod.mdl"
ENT.Model				= "models/gredwitch/mg81z/mg81z_gun.mdl"
ENT.Color				= "Green"
ENT.SoundName			= "shootSound"

ENT.BasePos=Vector(0,0,0)
ENT.BaseAng=Angle(0,0,0)
ENT.OffsetPos=Vector(0,0,0)
ENT.OffsetAng=Angle(0,0,0)
ENT.Shooter=nil
ENT.ShooterLast=nil

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
	
	return IsValid(shooter) and shooter:Alive() and ((self:GetPos()+self.TurretModelOffset):Distance(shooter:GetShootPos())<=60)
end
function ENT:DoShot()
	if self.LastShot+self.ShotInterval<CurTime() then
		self:EmitSound(self.SoundName)
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
			
			if IsValid(self.shootPos) and SERVER then
				local tracerConvar = GetConVarNumber("gred_tracers")
				
				local b=ents.Create(self.BulletType)
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
				b.Owner= self.Shooter
				b:Spawn()
				
				self.tracer = self.tracer + 1
				if self.tracer >= tracerConvar then
					util.SpriteTrail(b, 0, bcolor, false, num1, num1, num2, num3, "trails/laser.vmt")
					if self.Color == "Red" then
						util.SpriteTrail(b, 0, red, false, num4, num5, num6, num7, "trails/smoke.vmt")
					elseif self.Color == "Green" then
						util.SpriteTrail(b, 0, green, false, num4, num5, num6, num7, "trails/smoke.vmt")
					end 
					self.tracer = 0
				end
			end
		end
	if IsValid(self.shootPos) and SERVER then self:GetPhysicsObject():ApplyForceCenter( self:GetRight()*50000 ) end
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
					local offsetAng=(self:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
					local offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
					local HookupPos=self:GetAttachment(self.HookupAttachment).Pos
					if offsetDot>=self.TurretTurnMax then
						local offsetAngNew=offsetAng:Angle()
						offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
						
						self.OffsetAng=offsetAngNew
					end
				end
				local pressKey=IN_BULLRUSH
				if CLIENT and game.SinglePlayer() then
					pressKey=IN_ATTACK
				end
				self.Firing=self:GetShooter():KeyDown(pressKey)
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
			if !self.Firing then
				self:StopSound(self.SoundName)
			end
			self:NextThink(CurTime())
			return true
		end
	end
end	
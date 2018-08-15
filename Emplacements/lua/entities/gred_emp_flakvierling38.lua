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
-- ENT.Seatable			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
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
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] Time-Fuze rounds selected") end
	elseif self.AmmoType == "Time-Fuze" then
		self.AmmoType = "Direct Hit"
		if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] Direct hit rounds selected") end
	end
	self.NextSwitch = CurTime()+0.2
end

function ENT:DoShot(plr)
	if SERVER then
		if m == nil or m > self.MuzzleCount then m = 1 end
	    attPos = self:GetAttachment(self.MuzzleAttachments[m]).Pos
		attAng = self:GetAttachment(self.MuzzleAttachments[m]).Ang
		
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
			self.tracer = 0
		else
			b.noTracer = true
		end
		self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*700000)
		if GetConVar("gred_sv_limitedammo"):GetInt() == 1 then self.CurAmmo = self.CurAmmo - 1 end
		m = m + 1
	end
end
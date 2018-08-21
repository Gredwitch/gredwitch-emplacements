ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Base"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Base"

ENT.MuzzleEffect		= ""
ENT.ShotInterval		= 0
ENT.BulletType			= ""
ENT.MuzzleCount			= 1
ENT.NextSwitch			= 0.5
ENT.tracer 				= 0
ENT.Color				= "Green"
ENT.EmplacementType     = "MG"
ENT.NoRecoil			= false

ENT.LastShot			= 0

ENT.AnimPlaying			= false
ENT.AmmoType			= "AP"
ENT.FuzeTime			= 0
ENT.CanSwitchAmmoTypes	= false
ENT.AnimRestartTime		= 0
ENT.NextAnim			= 0
ENT.HasReloadAnim		= false
ENT.AnimPlayTime		= 0.5
ENT.ShellEjectTime		= 0.2
ENT.Ammo        		= 1
ENT.IsReloading			= false

ENT.num					= 0

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
ENT.NextAmmoSwitch		= 0
ENT.CanPlayStopSnd		= false
ENT.MagProp				= ""
ENT.empty				= "EmptySound"
ENT.EmptySND			= "gred_emp/common/empty.wav"
ENT.Sequential			= false

ENT.Recoil				= 50000
ENT.HasShellEject		= true
ENT.CanLookArround		= false
ENT.TurretForward		= 0

ENT.HasNoAmmo			= true
ENT.CurAmmo				= ENT.Ammo
ENT.CanUseShield		= true
ENT.CustomRecoil		= false

ENT.AutomaticFrameAdvance = true -- FUCKING ANIMS NOT WORKING CUZ THIS IS NOT SET TO TRUE

local SmokeSnds = {}
for i=1,4 do
SmokeSnds[i]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_0".. i..".wav"
end

local noHitSky = false
local reachSky = Vector(0,0,9999999999)
local nextplay = 0.5
if SERVER then util.AddNetworkString("gred_net_emp_muzzle_fx")  end
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
		if CLIENT then self.AmmoType = "HE" end
		if SERVER then self.AmmoType = "HE" end
	
	elseif self.AmmoType == "HE" then
		if CLIENT then self.AmmoType = "Smoke" end
		if SERVER then self.AmmoType = "Smoke" end
			
	elseif self.AmmoType == "Smoke" then
		if CLIENT then self.AmmoType = "AP" end
		if SERVER then self.AmmoType = "AP" end
	end
	if CLIENT then plr:ChatPrint("["..self.NameToPrint.."] "..self.AmmoType.." shells selected") end
	self.NextSwitch = CurTime()+0.2
end

function ENT:PlayerSetSecondary(ply)
	if self.Secondary then
		if self.EmplacementType != "MG" or (self.CanSwitchAmmoTypes and self.EmplacementType == "MG") then 
			self:SwitchAmmoType(ply) 
		end
	end
	if self.CanSwitchAmmoTypes and self.AmmoType == "Time-Fuze" and self.NextAmmoSwitch < CurTime() then
		if self.SwitchedFuzeKey then
			self:SetTimeFuze(ply)
		end
		if self.ResetFuzeKey then
			self:LowerTimeFuze(ply)
		end
	end
	if self.ReloadKey then
	    if self.CurAmmo >= self.Ammo or self.IsReloading then return end
		self:ReloadMG(ply)
	end
end  

function ENT:LowerTimeFuze(ply)
	if self.FuzeTime <= 0.01 then
		if CLIENT then self.FuzeTime = 0.5 end
		if SERVER then self.FuzeTime = 0.5 end
	else
		self.FuzeTime = self.FuzeTime - 0.01 
	end
	if CLIENT then
		ply:ChatPrint("["..self.NameToPrint.."] Time fuze set to "..self.FuzeTime.." seconds")
	end
	self.NextAmmoSwitch = CurTime()+0.1
end

function ENT:SetTimeFuze(ply)
	if self.FuzeTime >= 0.5 then 
		if SERVER then self.FuzeTime = 0.01 end
		if CLIENT then self.FuzeTime = 0.01 end
	else 
		if CLIENT then self.FuzeTime = self.FuzeTime + 0.01 end
		if SERVER then self.FuzeTime = self.FuzeTime + 0.01 end
	end
	if CLIENT then
		ply:ChatPrint("["..self.NameToPrint.."] Time fuze set to "..self.FuzeTime.." seconds")
	end
	self.NextAmmoSwitch = CurTime()+0.1
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

function ENT:AddSounds()
	self.sounds = {}
	sound.Add( {
		name = self.empty,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 60,
		pitch = {100},
		sound = self.EmptySND
	} )
	sound.Add( {
		name = self.SoundName,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 100,
		pitch = {100},
		sound = self.ShootSound
	} )
	if self.HasStopSound then
		
		sound.Add( {
			name = self.StopSoundName,
			channel = CHAN_AUTO,
			volume = 1.0,
			level = 100,
			pitch = {100},
			sound = self.StopSound
		} )
		
		self.sounds["stop"] = CreateSound(self,self.StopSoundName)
		self.sounds["stop"]:SetSoundLevel(100)
	end
	if self.EmplacementType == "MG" then
		self.sounds["shoot"] = CreateSound(self,self.SoundName)
		self.sounds["empty"] = CreateSound(self,self.empty)
		self.sounds["shoot"] = CreateSound(self,self.ShootSound)
		self.sounds["empty"] = CreateSound(self,self.EmptySND)
		self.sounds["shoot"]:SetSoundLevel(100)
		self.sounds["empty"]:SetSoundLevel(60)
	end
end

function ENT:DoShot(plr)
		if self.EmplacementType == "Mortar" or self.EmplacementType == "AT" then
			local pos = self:GetPos()
			util.ScreenShake(pos,5,5,0.5,200)
			ParticleEffect("gred_mortar_explosion_smoke_ground", pos-Vector(0,0,30),Angle(90,0,0))
		end
		for m = 1,self.MuzzleCount do
			    attPos = self:GetAttachment(self.MuzzleAttachments[m]).Pos
				attAng = self:GetAttachment(self.MuzzleAttachments[m]).Ang
				
				if self.EmplacementType == "MG" then
					local b = ents.Create("gred_base_bullet")
					
					if self.num > 0 then
						num = self.num
					else
						if self.BulletType == "wac_base_7mm" then
							num = 0.3
						elseif self.BulletType == "wac_base_12mm" then
							num = 0.5
						elseif self.BulletType == "wac_base_20mm" then
							num = 1.4
						elseif self.BulletType == "wac_base_30mm" then
							num = 1.6
						elseif self.BulletType == "wac_base_40mm" then
							num = 2
						end
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
						if self.Color == "Red" then
							b:SetSkin(1)
						elseif self.Color == "Green" then
							b:SetSkin(3)
						elseif self.Color == "Yellow" then
							b:SetSkin(0)
						end
						b:SetModelScale(7)
						if self.CurAmmo <= 20 then 
							self.tracer = GetConVar("gred_sv_tracers"):GetInt() - 2
						else
							self.tracer = 0
						end
					else 
						b.noTracer = true
					end
					
				elseif self.EmplacementType == "AT" then
					local b=ents.Create(self.BulletType)
					ang = attAng + Angle(math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter))
					local shootpos = attPos
					b:SetPos(shootpos)
					b:SetAngles(attAng)
					b.GBOWNER=plr
					b.IsOnPlane = true
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
					b.Owner=plr
					if self.HasShellEject then
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
					end
				elseif self.EmplacementType == "Mortar" then
					local shootPos=util.TraceLine(util.GetPlayerTrace(self.Shooter)).HitPos
					local bul = self.BulletType
					local ammo = self.AmmoType
					timer.Simple(4,function()
						if not IsValid(self) then return end
						local b=ents.Create(bul)
						local spawnAtt = GetConVar("gred_sv_mortar_shellspawnaltitude"):GetInt()
						if spawnAtt == nil then spawnAtt = 1000 end
						b:SetPos(shootPos + Vector(math.random(-self.Scatter,self.Scatter),math.random(-self.Scatter,self.Scatter),spawnAtt))
						b:SetAngles(Angle(90,0,0))
						b:SetOwner(self.Shooter)
						b.IsOnPlane = true
						if ammo == "Smoke" then
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
				if !self.NoRecoil then
					if self.EmplacementType == "MG" then
						self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*self.Recoil)
					elseif self.EmplacementType == "AT" then
						if self.CustomRecoil then
							self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*self.Recoil)
						else
							self:GetPhysicsObject():ApplyForceCenter(self:GetRight()*7000000)
						end
					end
				end
				if GetConVar("gred_sv_limitedammo"):GetInt() == 1 and !self.HasNoAmmo then self.CurAmmo = self.CurAmmo - 1 end
		end
		if self.EmplacementType != "MG" then self:EmitSound(self.SoundName) end
		if self.HasShootAnim then self:ResetSequence(self:LookupSequence("shoot")) end
		if self.EmplacementType == "AT" then self:PlayAnim() end
end

function ENT:PlayAnim()
	if SERVER then
		if self.HasRotatingBarrel then
			if self.NextAnim < CurTime() then
				self:ResetSequence(self:LookupSequence("spin"))
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
				self:ResetSequence(self:LookupSequence("reload_start"))
				self.AnimPlaying = true
			end)
			timer.Simple(self.AnimRestartTime,function() 
				if !IsValid(self) then return end
				self:ResetSequence(self:LookupSequence("reload_finish")) 
				self.AnimPlaying = false
			end)
		end
	end
end

function ENT:SetShootAngles(ply)
	if SERVER then
		ply:DrawViewModel(false)
		net.Start("TurretBlockAttackToggle")
		net.WriteBit(true)
		net.Send(ply)
		if self.Seatable and !ply:InVehicle() then
			self:SetShooter(nil)
			self:FinishShooting()
		end
		if !self:ShooterStillValid() then return end
		offsetAng=(self:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
		offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
		if offsetDot>=self.TurretTurnMax or self.CanLookArround then
			local offsetAngNew=offsetAng:Angle()
			offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
			
			self.OffsetAng=offsetAngNew
			if self.EmplacementType == "Mortar" then canShoot = true end
		else
			if self.EmplacementType == "Mortar" then canShoot = false end
		end
	end
end

function ENT:ReloadMG(ply)
end

function ENT:SetPlayerKeys(ply)
	local pressKey  = IN_BULLRUSH
	local switchKey = IN_ATTACK2
	local fuzekey   = IN_WALK
	local reload    = IN_RELOAD
	local fuzereset = IN_SPEED
	local camera	= IN_DUCK
	if CLIENT and game.SinglePlayer() then
		pressKey  = IN_ATTACK
		switchKey = IN_ATTACK2
		fuzekey	  = IN_WALK
		fuzereset = IN_SPEED
		camera	  = IN_DUCK
	    reload    = IN_RELOAD
	end
	self.Secondary			= ply:KeyDown(switchKey)
	self.Firing				= ply:KeyDown(pressKey)
	self.SwitchedFuzeKey	= ply:KeyDown(fuzekey)
	self.ResetFuzeKey		= ply:KeyDown(fuzereset)
	self.SwitchCamKey		= ply:KeyDown(camera)
	self.ReloadKey          = ply:KeyDown(reload)
end

function ENT:ShieldThink()
	if SERVER then
		self.shield:SetSkin(self:GetSkin())
		self.shield:SetPos(self.BasePos)
		self.shield:SetAngles(Angle(self.turretBase:GetAngles().p,self:GetAngles().y,self.turretBase:GetAngles().r))
		if self.CanUseShield then
			hook.Add("PlayerUse","gred_emp_use_shield",function(ply,ent)
				self:Use(ply,ent,3,1)
			end)
		end
	end
end

function ENT:FindNPCs()
    for _,n in pairs (ents.FindInSphere(self:GetPos(),self.MaxUseDistance)) do
        if n:IsNPC() then
            self:Use(n,n,3,1)
        end
    end
end

function ENT:fire(player)
	if SERVER then
		if self.EmplacementType == "Mortar" then
			local aimpos = self:GetAttachment(self:LookupAttachment("muzzle"))
			local tr = util.QuickTrace(aimpos.Pos,aimpos.Pos + reachSky,{self,self,self.turretBase,self.shootpos} )
			
			if !tr.HitSky or (!tr.HitWorld and !tr.HitSky and !tr.Hit) then
				canShoot = false
				noHitSky = true
				player:ChatPrint("["..self.NameToPrint.."] Nothing must block the mortar's muzzle!")
			else
				noHitSky = false
				if not canShoot then
					player:ChatPrint("["..self.NameToPrint.."] You can't shoot there!")
				return end
			end
		end
	end
	if canShoot or self.EmplacementType != "Mortar" and SERVER then
		self:DoShot(player)
		net.Start("gred_net_emp_muzzle_fx")
			net.WriteEntity(self)
		net.Broadcast()
	end
	if self.EmplacementType == "MG" then 
		self.CanPlayStopSnd = true
		if SERVER then
			self.sounds.shoot:Play()
			if self.HasStopSound then
				self.sounds.stop:Stop()
			end
			self.sounds.empty:Stop()
		end
		self:PlayAnim() 
	end
end

function ENT:stop()
	if SERVER then
		self.sounds.shoot:Stop()
		if self.HasStopSound then
			self.sounds.stop:Play()
		end
		if self.CurAmmo <= 0 then
			self.sounds.empty:Play()
		end
	end
	self.CanPlayStopSnd = false
end

function ENT:Think()
	if CLIENT then if not self.m_initialized then self:Initialize() end end
	if SERVER then if not self.m_initialized then self:Initialize() end end
	if SERVER and (!IsValid(self.turretBase) or (self.Seatable and !IsValid(self.shield))) then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			self:AddOnThink()
			-- self:FindNPCs()
			local player = self:GetShooter()
			if SERVER then
				self.turretBase:SetSkin(self:GetSkin())
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
			end
			if self.SecondModel != "" then
				self:ShieldThink()
			end
			if self:ShooterStillValid() then
				self:SetShootAngles(player)
				self:SetPlayerKeys(player)
				self:PlayerSetSecondary(player)
				if self.Firing and not self.IsReloading and self.LastShot+self.ShotInterval<=CurTime() and self.CurAmmo >= 1 then
					self:fire(player)
					self.LastShot = CurTime()
				else
				end
				if self.LastShot+self.ShotInterval<=CurTime() and self.CanPlayStopSnd and self.EmplacementType == "MG" then
					self:stop()
				end
			else
				if self.Firing and self.EmplacementType == "MG" then
					self:stop()
				end
				self.Firing=false
				if SERVER then
					self.OffsetAng=self.turretBase:GetAngles()
					
					self:SetShooter(nil)
					self:FinishShooting()
				end
			end
			if not self.Firing and self.EmplacementType == "MG" then
				self:stop()
				if SERVER then  end
				if CLIENT then  end
			end
			self:NextThink(CurTime())
			return true
		end
	end
end
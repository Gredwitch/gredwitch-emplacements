ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]Base"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Base"

ENT.Armor				= 10
ENT.ExplodeHeight		= 0
ENT.Destructible		= true

ENT.MagIn				= true
ENT.MuzzleEffect		= ""
ENT.ShotInterval		= 0
ENT.BulletType			= ""
ENT.MuzzleCount			= 1
ENT.NextSwitch			= 0.5
ENT.tracer 				= 0
ENT.Color				= "Green"
ENT.EmplacementType     = "MG"
ENT.NoRecoil			= false
ENT.EjectAngle			= Angle(0,-90,0)
ENT.LastShot			= 0
ENT.CalcMouse			= 1
ENT.Life				= 100
ENT.CurLife				= ENT.Life

ENT.ClassAlt			= ""
ENT.AnimStopRate		= 1

ENT.AnimPlaying			= false
ENT.AmmoType			= "AP"
ENT.FuzeTime			= 0
ENT.CanSwitchAmmoTypes	= false
ENT.AnimRestartTime		= 0
ENT.ShellSoundTime		= 3
ENT.NextAnim			= 0
ENT.HasReloadAnim		= false
ENT.AnimPlayTime		= 0.5
ENT.ShellEjectTime		= 0.2
ENT.Ammo        		= 1
ENT.IsReloading			= false

ENT.num					= 0
ENT.Spawner				= nil

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
ENT.TurretHorrizontal	= 0
ENT.ShieldForward		= 0

ENT.HasNoAmmo			= true
ENT.MultpipleShellEject	= true
ENT.CurAmmo				= ENT.Ammo
ENT.CanUseShield		= true
ENT.CustomRecoil		= false
ENT.GunRPM 				= ENT.ShotInterval*60

ENT.AmmoEnt				= ""
ENT.AnimPauseTime		= 0
ENT.ShieldUp			= 0
ENT.UseSingAnim			= false
ENT.NoWP				= false
ENT.ReloadTime			= 4.1
ENT.CycleRate			= 0.4
ENT.EndReloadSnd		= ""
ENT.ATReloadSound		= "medium"
ENT.AddShootAngle		= 1.5

ENT.Attaker				= nil
ENT.CurViewPos			= 0
ENT.AutomaticFrameAdvance = true -- FUCKING ANIMS NOT WORKING CUZ THIS IS NOT SET TO TRUE

ENT.Wheels				= ""
ENT.WheelsPos			= Vector(0,0,0)

local SmokeSnds			 = {}
for i=1,4 do
	SmokeSnds[i]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_0".. i..".wav"
end
local noHitSky = false
local reachSky = Vector(0,0,9999999999)
local nextplay = 0.5
ENT.serv	   = CLIENT --or game.IsDedicated() or !game.IsDedicated()

function ENT:SetupDataTables()
	self:DTVar("Entity",0,"Shooter")
	self:DTVar("Entity",1,"ShootPos")
	self:DTVar("Entity",2,"Seat")
end

function ENT:SetShooter(ply)
	self.Shooter=ply
	self:SetDTEntity(0,ply)
end

function ENT:GetShooter(ply)
	if SERVER then
		return self.Shooter
	elseif CLIENT then
		return self:GetDTEntity(0)
	end
end

function ENT:AddOnThink()
end

function ENT:SwitchAmmoType(ply)
	if self.NextSwitch > CurTime() then return end
	if self.AmmoType == "AP" then
		self.AmmoType = "HE"
	elseif self.AmmoType == "HE" then
		self.AmmoType = "Smoke"
	elseif self.AmmoType == "Smoke" then
		self.AmmoType = "AP"
	end
	net.Start("gred_net_message_ply")
		net.WriteEntity(ply)
		net.WriteString("["..self.NameToPrint.."] "..self.AmmoType.." shells selected")
	net.Send(ply)
	self.NextSwitch = CurTime()+0.2
end

function ENT:PlayerSetSecondary(ply)
	if SERVER then
		if self.Secondary then
			if (self.EmplacementType != "MG" and GetConVar("gred_sv_manual_reload"):GetInt() == 0) or (self.CanSwitchAmmoTypes and self.EmplacementType == "MG") then 
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
end

function ENT:LowerTimeFuze(ply)
	if self.FuzeTime <= 0.01 then
		self.FuzeTime = 0.5
	else
		self.FuzeTime = self.FuzeTime - 0.01 
	end
	net.Start("gred_net_message_ply")
		net.WriteEntity(ply)
		net.WriteString("["..self.NameToPrint.."] Time fuze set to "..self.FuzeTime.." seconds")
	net.Send(ply)
	self.NextAmmoSwitch = CurTime()+0.1
end

function ENT:SetTimeFuze(ply)
	if self.FuzeTime >= 0.5 then 
		self.FuzeTime = 0.01
	else 
		self.FuzeTime = self.FuzeTime + 0.01
	end
	net.Start("gred_net_message_ply")
		net.WriteEntity(ply)
		net.WriteString("["..self.NameToPrint.."] Time fuze set to "..self.FuzeTime.." seconds")
	net.Send(ply)
	self.NextAmmoSwitch = CurTime()+0.1
end

function ENT:Use(ply)
	if not self:ShooterStillValid() then
		self:SetShooter(ply)
		self:StartShooting()
		self.ShooterLast=ply
	else
		if ply==self.Shooter then
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
	-- sound.Add( {
		-- name = self.empty,
		-- channel = CHAN_STATIC,
		-- volume = 1.0,
		-- level = 60,
		-- pitch = {100},
		-- sound = self.EmptySND
	-- },
	-- {
		-- name = self.SoundName,
		-- channel = CHAN_STATIC,
		-- volume = 1.0,
		-- level = 100,
		-- pitch = {100},
		-- sound = self.ShootSound
	-- } )
	self.sounds["shoot"] = CreateSound(self,self.ShootSound)
	self.sounds.shoot:SetSoundLevel(100)
	self.sounds.shoot:ChangeVolume(1)
	self.sounds["empty"] = CreateSound(self,self.EmptySND)
	self.sounds.empty:SetSoundLevel(60)
	self.sounds.empty:ChangeVolume(1)
	if self.HasStopSound then
		-- sound.Add( {
			-- name = self.StopSoundName,
			-- channel = CHAN_STATIC,
			-- volume = 1.0,
			-- level = 100,
			-- pitch = {100},
			-- sound = self.StopSound
		-- } )
		self.sounds["stop"] = CreateSound(self,self.StopSoundName)
		self.sounds.stop:SetSoundLevel(100)
		self.sounds.stop:ChangeVolume(1)
	end
	if self.EmplacementType == "AT" then
		-- sound.Add( {
			-- name = "self.ReloadAT_"..self.ATReloadSound.."_1",
			-- channel = CHAN_STATIC,
			-- volume = 1.0,
			-- level = 80,
			-- pitch = {100},
			-- sound = "gred_emp/common/reload"..self.ATReloadSound.."_1.wav"
		-- },
		-- {
			-- name = "self.ReloadAT_"..self.ATReloadSound.."_2",
			-- channel = CHAN_STATIC,
			-- volume = 1.0,
			-- level = 80,
			-- pitch = {100},
			-- sound = 
		-- } )
		self.sounds["reload_start"] = CreateSound(self,"gred_emp/common/reload"..self.ATReloadSound.."_1.wav")
		self.sounds.reload_start:SetSoundLevel(80)
		self.sounds.reload_start:ChangeVolume(1)
		self.sounds["reload_finish"] = CreateSound(self,"gred_emp/common/reload"..self.ATReloadSound.."_2.wav")
		self.sounds.reload_finish:SetSoundLevel(80)
		self.sounds.reload_finish:ChangeVolume(1)
		self.sounds["reload_shell"] = CreateSound(self,"gred_emp/common/reload"..self.ATReloadSound.."_shell.wav")
		self.sounds.reload_shell:SetSoundLevel(80)
		self.sounds.reload_shell:ChangeVolume(1)
	end
	-- PrintTable(self.sounds)
end

function ENT:DoShot(ply,shootPos)
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
					-- local b = ents.Create("gred_base_bullet_testPHY")
					
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
					attAng:Add(Angle(math.Rand(num,-num), math.Rand(num,-num), math.Rand(num,-num)))
					b:SetPos(attPos)
					b:SetAngles(attAng)
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
					b.Owner=ply
					if self.SecondModel then
						b.Filter = {self,self.turretBase,self.shield}
					else
						b.Filter = {self,self.turretBase}
					end
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
					attAng:Sub(Angle(self.AddShootAngle,0,0)) -- + Angle(math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter))
					b:SetPos(attPos)
					b:SetAngles(attAng)
					b:Spawn()
					b:SetBodygroup(0,1)
					b:SetBodygroup	  (1,1)
					if self.AmmoType == "AP" then
						b.AP = true
					elseif self.AmmoType == "Smoke" then
						b.Smoke = true
					end
					b:SetOwner(ply)
					b:Activate()
					for k,v in pairs(self.Entities) do
						constraint.NoCollide(v,b,0,0)
					end
					b.IsOnPlane = true
					b:Launch()
					if self.HasShellEject then
						local mdlscale = b.ModelSize
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
							shell:SetModelScale(mdlscale)
						end)
					end
				elseif self.EmplacementType == "Mortar" then
					-------------------
					local trace = {}				
					trace.start = shootPos
					trace.endpos = shootPos + Vector(0,0,1000) -- This calculates the spawn altitude
					trace.Mask = MASK_SOLID_BRUSHONLY
					local tr = util.TraceLine(trace)
					
					local BPos = tr.HitPos + 
					Vector(math.random(-self.Scatter,self.Scatter),
					math.random(-self.Scatter,self.Scatter),-1) -- Creates our spawn position
					while !util.IsInWorld(BPos) do
						BPos = tr.HitPos + 
						Vector(math.random(-self.Scatter,self.Scatter),
						math.random(-self.Scatter,self.Scatter),-1) -- re-ceates our spawn position
					end
					local HitBPos = Vector(0,0,
					util.QuickTrace(BPos,BPos - reachSky,{self,self.turretBase,self.shootpos} ).HitPos.z) -- Defines the ground's pos
					local zpos = Vector(0,0,BPos.z) -- The exact spawn altitude
					local dist = HitBPos:Distance(zpos) -- Calculates the distance between our spawn altitude and the ground
					
					----------------------
					
					local snd = "artillery/flyby/artillery_strike_incoming_0"..(math.random(1,4))..".wav"
					local sndDuration = SoundDuration(snd)
					
					local bul = self.BulletType
					local ammo = self.AmmoType
					timer.Simple(GetConVar("gred_sv_shell_arrival_time"):GetFloat(),function()
						if not IsValid(self) then return end
						local b=ents.Create(bul)
						local time = (dist/-1000)+(sndDuration-0.2) -- Calculates when to play the whistle sound
						if time < 0 then
							b:SetPos(BPos)
							b:SetAngles(Angle(90,0,0))
							b:SetOwner(self.Shooter)
							b.IsOnPlane = true
							if ammo == "Smoke" then
								b.Smoke = true
							end
							b.GBOWNER=ply
							b.Owner=ply
							b:Spawn()
							b:Activate()
							b:Arm()
							b.PhysicsUpdate = function(data,phys)
								phys:SetVelocityInstantaneous(Vector(0,0,-1000))
							end
							timer.Simple(-time,function()
								if !IsValid(b) then return end
								b:EmitSound(snd, 140, 100, 1)
							end)
						else
							local p = ents.Create("prop_dynamic")
							p:SetModel("models/hunter/blocks/cube025x025x025.mdl")
							p:SetPos(BPos)
							p:Spawn()
							p:SetRenderMode(RENDERMODE_TRANSALPHA)
							p:SetColor(255,255,255,0)
							p:EmitSound(snd,140,100,1)
							p:Remove()
							timer.Simple(time,function()
								if !IsValid(self) then return end
								b:SetPos(BPos)
								b:SetAngles(Angle(90,0,0))
								b:SetOwner(self.Shooter)
								b.IsOnPlane = true
								if ammo == "Smoke" then
									b.Smoke = true
								end
								b.GBOWNER=ply
								b:Spawn()
								b:Activate()
								b:Arm()
								b.PhysicsUpdate = function(data,phys)
									phys:SetVelocityInstantaneous(Vector(0,0,-1000))
								end
								b.Owner=ply
							end)
						end
					end)
				end
				if !self.NoRecoil then
					local phy = self:GetPhysicsObject()
					if !IsValid(phy) then return end
					if self.EmplacementType == "MG" then
						phy:ApplyForceCenter(self:GetRight()*self.Recoil)
					elseif self.EmplacementType == "AT" then
						if self.CustomRecoil then
							phy:ApplyForceCenter(self:GetRight()*self.Recoil)
						else
							phy:ApplyForceCenter(self:GetRight()*7000000)
						end
					end
				end
				if self.EmplacementType == "MG" then
					if GetConVar("gred_sv_limitedammo"):GetInt() == 1 and !self.HasNoAmmo then self.CurAmmo = self.CurAmmo - 1 end
				else
					if GetConVar("gred_sv_manual_reload"):GetInt() == 1 then self.CurAmmo = self.CurAmmo - 1 end
				end
		end
		-- if self.EmplacementType != "MG" then self:EmitSound(self.SoundName) end
		
		if self.EmplacementType == "AT" then self:PlayAnim() else if self.HasShootAnim then self:ResetSequence("shoot") end end
end

function ENT:PlayAnim()
	if SERVER then
		if self.HasRotatingBarrel then
			if self.NextAnim < CurTime() then
				self:ResetSequence("spin")
				self.NextAnim = CurTime() + self.AnimRestartTime
			end
		end
		if self.HasShootAnim then
			self:ResetSequence("shoot")
		end
		if self.HasReloadAnim then
			if self.AnimPlaying then return end
			self.sounds.reload_finish:Stop()
			self.sounds.reload_start:Stop()
			self.sounds.reload_shell:Stop()
			if self.UseSingAnim then
				timer.Simple(self.AnimPlayTime,function()
					if !IsValid(self) then return end
					self:ResetSequence("reload")
					self.sounds.reload_start:Play()
					self.AnimPlaying = true
					if GetConVar("gred_sv_manual_reload"):GetInt() == 1 then
						timer.Simple(self.AnimPauseTime,function() 
							self:SetCycle(.5)
							self:SetPlaybackRate(0) 
						end)
					else
						timer.Simple(self.ShellSoundTime,function()
							if !IsValid(self) then return end
							self.sounds.reload_shell:Play()
						end)
						timer.Simple(self:SequenceDuration(),function() 
							if !IsValid(self) then return end
							self.sounds.reload_finish:Play()
							timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function()
								self.AnimPlaying = false
							end)
						end)
					end
				end)
			else
				timer.Simple(self.AnimPlayTime,function()
					if !IsValid(self) then return end
					self:ResetSequence("reload_start")
					self.sounds.reload_start:Play()
					self.AnimPlaying = true
				end)
				if self.CurAmmo <= 0 then return end
				timer.Simple(self.ShellSoundTime,function()
					if !IsValid(self) then return end
					self.sounds.reload_shell:Play()
				end)
				timer.Simple(self.AnimRestartTime,function() 
					if !IsValid(self) then return end
					self:ResetSequence("reload_finish")
					self.sounds.reload_finish:Play()
					timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function()
						self.AnimPlaying = false
					end)
				end)
			end
		end
	end
end

function ENT:SetShootAngles(ply)
	if SERVER then
		if !self.Seatable then
			ply:DrawViewModel(false)
			net.Start("TurretBlockAttackToggle")
				net.WriteBit(true)
			net.Send(ply)
		end
		if self.Seatable and !ply:InVehicle() then
			self:SetShooter(nil)
			self:FinishShooting()
		end
		if !self:ShooterStillValid() then return end
		self.NORESET = true
		-- if self.Seatable then
			-- self.NORESET = true
			-- local plyang = ply:GetAimVector():Angle()
			-- local turang = self.turretBase:GetAngles()
			-- local entang = self:GetAngles()
			-- local offsetAngNew=Angle(0,0,0)
			-- if entang != offsetAngNew then
				-- self:SetAngles(offsetAngNew)
			-- end
			-- local oof = math.ApproachAngle(
							-- self:GetAngles(),
							-- Angle(-plyang.p,plyang.y,-turang.r),
							-- 20)
			-- local offsetAngNew=oof
			-- offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
			
			-- self.OffsetAng=offsetAngNew
			-- self.OldOffsetAng=offsetAngNew
		-- else
			offsetAng=(self:GetAttachment(self.MuzzleAttachments[1]).Pos-self:GetDesiredShootPos()):GetNormal()
			offsetDot=self.turretBase:GetAngles():Right():Dot(offsetAng)
			if (offsetDot>=self.TurretTurnMax or self.CanLookArround) then
				offsetAngNew=offsetAng:Angle()
				offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
				
				self.OffsetAng=offsetAngNew
				self.OldOffsetAng=offsetAng:Angle()
				if self.EmplacementType == "Mortar" then canShoot = true end
			else
				if self.EmplacementType == "Mortar" then canShoot = false end
			end
		-- end
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
	if (CLIENT and game.SinglePlayer()) or (self.Seatable) then
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
		self.shield:SetPos(self.BasePos + self.shield:GetRight()*-self.ShieldForward + self.shield:GetUp()*self.ShieldUp)
		local ta = self.turretBase:GetAngles()
		self.shield:SetAngles(Angle(ta.p,self:GetAngles().y,ta.r))
		
		if self.Seatable and self:ShooterStillValid() then
			self:GetShooter():CrosshairEnable()
		end
	end
end

function ENT:FindNPCs()
    for _,n in pairs (ents.FindInSphere(self:GetPos(),self.MaxUseDistance)) do
        if n:IsNPC() and !n.IsUsingGredEmp then
            self:Use(n,n,3,1)
			n.IsUsingGredEmp = true
        end
    end
end

function ENT:fire(ply,ct)
	local eyetrace
	if self.EmplacementType == "Mortar" then
		local aimpos = self:GetAttachment(self:LookupAttachment("muzzle"))
		local tr = util.QuickTrace(aimpos.Pos,aimpos.Pos + reachSky,{self,self.turretBase,self.shootpos} )
		
		if tr.Hit and !tr.HitSky then
			canShoot = false
			noHitSky = true
			net.Start("gred_net_message_ply")
				net.WriteEntity(ply)
				net.WriteString("["..self.NameToPrint.."] Nothing must block the mortar's muzzle!")
			net.Send(ply)
			self.LastShot = ct - self.ShotInterval+0.5
		else
			noHitSky = false
			if !canShoot then
				net.Start("gred_net_message_ply")
					net.WriteEntity(ply)
					net.WriteString("["..self.NameToPrint.."] You can't shoot there!")
				net.Send(ply)
				self.LastShot = ct - self.ShotInterval+0.5
			else
				eyetrace = util.TraceLine(util.GetPlayerTrace(ply)).HitPos
				local tr = util.QuickTrace(eyetrace,eyetrace + reachSky,{self,self.turretBase,self.shootpos} )
				if tr.Hit and !tr.HitSky then
					canShoot = false
					net.Start("gred_net_message_ply")
						net.WriteEntity(ply)
						net.WriteString("["..self.NameToPrint.."] You can't shoot in interiors!")
					net.Send(ply)
					self.LastShot = ct - self.ShotInterval+0.5
				end
			end
		end
	end
	if canShoot or self.EmplacementType != "Mortar" then
		self:DoShot(ply,eyetrace)
		self.CanPlayStopSnd = true
		if !self.sounds.shoot:IsPlaying() then
			self.sounds.shoot:Play()
		else
			if self.EmplacementType != "MG" then
				self.sounds.shoot:Stop()
				self.sounds.shoot:Play()
			end
		end
		if self.HasStopSound then
			self.sounds.stop:Stop()
		end
		self.sounds.empty:Stop()
		
		self:PlayAnim() 
		net.Start("gred_net_emp_muzzle_fx")
			net.WriteEntity(self)
		net.Broadcast()
		self.LastShot = ct
	end
end

function ENT:PhysicsCollide(data,phy)
	timer.Simple(0,function()
		if self.CurAmmo && self.CurAmmo <= 0 and self.EmplacementType && self.EmplacementType != "MG" then
			if GetConVar("gred_sv_manual_reload"):GetInt() == 0 then return end
			local class = data.HitEntity:GetClass()
			if string.StartWith(class,self.OldBulletType) then
				local isWP = string.EndsWith(class,"wp")
				if self.NoWP and isWP then return end
				self.AnimPlaying = true
				self.BulletType = class
				self.CurAmmo = 1
				if isWP then
					self.AmmoType = "WP"
				else
					if data.HitEntity.AP and !data.HitEntity.Smoke then
						self.AmmoType = "AP"
					elseif !data.HitEntity.AP and data.HitEntity.Smoke then
						self.AmmoType = "Smoke"
					elseif !data.HitEntity.AP and !data.HitEntity.Smoke then
						self.AmmoType = "HE"
					end
				end
				data.HitEntity:Remove()
				if self.EmplacementType == "AT" then
					self.sounds.reload_shell:Stop()
					self.sounds.reload_shell:Play()
					timer.Simple(1.3,function()
						if !IsValid(self) then return end
						self.sounds.reload_start:Stop()
						self.sounds.reload_finish:Play()
						if self.UseSingAnim then
							self:SetCycle(.8)
							self:SetPlaybackRate(1)
							timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function() self.AnimPlaying = false end)
						else
							self:ResetSequence("reload_finish")
							timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function() self.AnimPlaying = false end)
						end
					end)
				end
			end
		elseif self.EmplacementType == "MG" and self.CurAmmo < self.Ammo and self.IsReloading then
			if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then return end
			if data.HitEntity.gredGunEntity == self:GetClass() or data.HitEntity.gredGunEntity ==  self.ClassAlt then
				data.HitEntity:Remove()
				self:SetPlaybackRate(1)
				self:SetCycle(self.CycleRate)
				self:EmitSound(self.EndReloadSnd)
				self.MagIn = true
				timer.Simple(self.ReloadTime, function()
					self.CurAmmo = self.Ammo
					self.AnimPlaying = false
					self.IsReloading = false
				end)
			end
		end
	end)
end

function ENT:stop()
	if SERVER then
		if self.sounds.shoot:IsPlaying() then
			self.sounds.shoot:Stop()
			if self.HasStopSound then
				self.sounds.stop:Play()
			end
		end
		if self.CurAmmo <= 0 then
			self.sounds.empty:Play()
		end
	end
	self.CanPlayStopSnd = false
end

function ENT:Explode()
	if self.Exploded then return end
	
	local b = self:BoundingRadius()
	local p = self:GetPos()
	local tp = self.turretBase:GetPos()
	local tf = self.turretBase:GetForward()
	local tu = self.turretBase:GetUp()
	local tr = self.turretBase:GetRight()
	local u = self:GetUp()
	local r = self:GetRight()
	local f = self:GetForward()
	self.ExploPos = {}
	self.ExploPos[1] = p
	self.ExploPos[2] = tp
	if b >= 150 then
		b = b / 1.5
		p = p + Vector(0,0,self.ExplodeHeight)
		self.ExploPos[3] = p+r*b
		self.ExploPos[4] = p+r*-b
		self.ExploPos[5] = p+f*b
		self.ExploPos[6] = p+f*-b
		self.ExploPos[7] = p+u*b
		self.ExploPos[8] = p+u*-b
	else
		if self.EmplacementType == "AT" then
			self.ExploPos[3] = tp+tr*-(b*0.7)
			self.ExploPos[4] = tp+tr*(b/2)
		end
	end
	for k,v in pairs (self.ExploPos) do
		local effectdata = EffectData()
		effectdata:SetOrigin(v)
		util.Effect("Explosion",effectdata)
		if !IsValid(self.Attaker) then self.Attaker = self end
		util.BlastDamage(self.Attaker,self.Attaker,v,100,100)
	end
	self.Exploded = true
	self:Remove()
end

function ENT:OnTakeDamage(dmg)
	if self.Destructible and not dmg:IsFallDamage() and GetConVar("gred_sv_enable_explosions"):GetInt() >= 1 then
		if (self.EmplacementType == "AT" or self.Seatable) and dmg:GetDamage() < 50 then return end
		local n = dmg:GetDamage() - self.Armor / math.Rand(5,6)
		if n < 0 then n = -n end
		self.CurLife = self.CurLife - (dmg:GetDamage() - self.Armor / math.Rand(2,3))
		self.Attaker = dmg:GetAttacker()
	end
end

-- ResetAnlges = GetConVar("gred_sv_reset_angles"):GetInt()

function ENT:Think()
	if SERVER and (!IsValid(self.turretBase) or (self.SecondModel != "" and !IsValid(self.shield))) then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			local ct = CurTime()
			self:AddOnThink()
			-- self:FindNPCs()
			if SERVER then
				for k,v in pairs(self.Entities) do
					if v != self then
						v:SetSkin(self:GetSkin())
					end
				end
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
				if self.Destructible then
					if self.CurLife <= 0 then self:Explode() end
				end
			end
			if self.SecondModel != "" then
				self:ShieldThink()
			end
			if self:ShooterStillValid() then
				local ply = self:GetShooter()
				self:SetShootAngles(ply)
				self:SetPlayerKeys(ply)
				self:PlayerSetSecondary(ply)
				if self.Firing and not self.IsReloading and self.LastShot+self.ShotInterval<=ct
				and self.CurAmmo >= 1 then
					if (self.EmplacementType == "AT" and self.AnimPlaying) or not SERVER then return end
					self:fire(ply,ct)
				end
				if self.LastShot+self.ShotInterval<=ct and self.CanPlayStopSnd and self.EmplacementType == "MG" then
					self:stop()
				end
			else
				if self.Firing and self.EmplacementType == "MG" then
					self:stop()
				end
				self.Firing=false
				if SERVER then
					-- if ResetAnlges == 1 then
						local ang 
						self.OffsetAng=self.turretBase:GetAngles()
						-- self.NORESET = true
					-- else
						-- local ang
						-- local ta = self.turretBase:GetAngles()
						-- local p = ta.r-self.OldOffsetAng.r
						-- local y = ta.yself.OldOffsetAng.y
						-- local r = ta.p-self.OldOffsetAng.p
						-- self.OffsetAng=Angle(p,y,-r)
						-- self.OffsetAng.y
						-- self.NORESET = false
					-- end
					self:SetShooter(nil)
					self:FinishShooting()
				end
			end
			if not self.Firing and self.EmplacementType == "MG" then
				self:stop()
			end
			self:NextThink(ct)
			return true
		end
	end
end

function ENT:GetCalcView()
	if not self.Seatable then return nil end
end
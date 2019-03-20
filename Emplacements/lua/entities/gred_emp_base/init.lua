
include		('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local IsValid = IsValid

function ENT:Initialize()
	self:SetModel(self.TurretModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:AddEntity(self)
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	self:InitAttachments()
	self:InitHull(pos,ang)
	self:InitYaw(pos,ang)
	self:InitWheels(ang)
	
	self:ReloadSounds()
	self:ResetSequence("reload")
	self:SetCycle(1)
	
	self:OnInit()
	
	if self.AmmunitionTypes then
		local IsAAA = false
		for k,v in pairs(self.AmmunitionTypes) do
			if v[1] == "Time-fuzed" then 
				IsAAA = true
				self.TimeFuze = k
			end
		end
		self.IsAAA = IsAAA
	end
	for k,v in pairs(self.Entities) do
		self.HP = (self.HP+75+(v:BoundingRadius()/table.Count(self.Entities)))
		-- self:SetHP(self.HP)
	end
	if self.EmplacementType != "MG" then
		if GetConVar("gred_sv_manual_reload"):GetInt() == 1 then
			if self.EmplacementType == "Mortar" then
				self:SetAmmo(0)
			else
				self:PlayAnim()
			end
		end
		if self.EmplacementType == "Cannon" then
			self:GetStoredShellProperties()
		end
	end
	if self.Seatable then
		self.Seatable = GetConVar("gred_sv_enable_seats"):GetInt() == 1
	end
	self.IsRocketLauncher = string.StartWith(self.AmmunitionType or self.AmmunitionTypes[1][2],"gb_rocket")
	self.Initialized = true
end

function ENT:ReloadSounds()
	self.sounds = self.sounds or {}
	if self.ReloadSound then
		self.sounds["reload"] = CreateSound(self,self.ReloadSound)
		self.sounds.reload:SetSoundLevel(60)
		self.sounds.reload:ChangeVolume(1)
		
		self.sounds["reloadend"] = CreateSound(self,self.ReloadEndSound)
		self.sounds.reloadend:SetSoundLevel(60)
		self.sounds.reloadend:ChangeVolume(1)
		
		self.sounds["empty"] = CreateSound(self,"gred_emp/common/empty.wav")
		self.sounds.empty:SetSoundLevel(60)
		self.sounds.empty:ChangeVolume(1)
	end
	if self.EmplacementType == "Cannon" then
		if not self.ATReloadSound then self.ATReloadSound = "medium" end
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
end

function ENT:OnInit()

end

function ENT:InitAttachments()
	local attachments = self:GetAttachments()
	local tableinsert = table.insert
	local startsWith = string.StartWith
	local t
	for k,v in pairs(attachments) do
		if startsWith(v.name,"muzzle") then
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretMuzzles,t)
			
		elseif startsWith(v.name,"shelleject") then
		
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretEjects,t)
		end
	end
end

function ENT:InitHull(pos,ang)
	local hull = ents.Create("gred_prop_emp")
	hull.GredEMPBaseENT = self
	hull:SetModel(self.HullModel)
	hull:SetAngles(ang)
	hull:SetPos(pos)
	hull:Spawn()
	hull:Activate()
	hull.canPickUp = self.EmplacementType == "MG" and GetConVar("gred_sv_cantakemgbase"):GetInt() == 1 and not self.YawModel
	
	if self.EmplacementType == "Mortar" then hull:SetMoveType(MOVETYPE_FLY) end
	local phy = hull:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.HullMass)
	end
	
	self:SetHull(hull)
	self:AddEntity(hull)
	
	local newPos = pos + self.TurretPos
	self:SetPos(newPos)
	if not self.YawModel then
		self:SetParent(hull)
	end
	if self.EmplacementType == "Cannon" then
		if GetConVar("gred_sv_carriage_collision"):GetInt() == 0 then
			hull:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		end
	end
	-- constraint.Axis(self,hull,0,0,self.TurretPos,Vector(0,0,0),0,0,0,1,Vector(0,0,0),false)
end

function ENT:InitYaw(pos,ang)
	if self.YawModel then
		local yaw = ents.Create("gred_prop_emp")
		yaw.GredEMPBaseENT = self
		yaw:SetModel(self.YawModel)
		yaw:SetAngles(ang)
		yaw:SetPos(pos+self.YawPos)
		yaw.Use = function(self,ply,act,use,val)
			if IsValid(self.GredEMPBaseENT) then
				self.GredEMPBaseENT:Use(ply,ply,3,0)
			end
		end
		yaw:Spawn()
		yaw:Activate()
		local phy = yaw:GetPhysicsObject()
		if IsValid(phy) then
			phy:SetMass(self.YawMass)
		end
		self:SetYaw(yaw)
		self:AddEntity(yaw)
		
		local newPos = pos + self.TurretPos + self.YawPos
		self:SetPos(newPos)
		yaw:SetParent(self:GetHull())
		self:SetParent(yaw)
		
		-- constraint.Axis(self,hull,0,0,self.TurretPos,Vector(0,0,0),0,0,0,1,Vector(0,0,0),false)
	end
end

function ENT:InitWheels(ang)
	if not self.WheelsModel then return end
	local wheels = ents.Create("gred_prop_emp")
	wheels.GredEMPBaseENT = self
	wheels:SetModel(self.WheelsModel)
	wheels:SetAngles(ang)
	wheels:SetPos(self:LocalToWorld(self.WheelsPos))
	wheels.BaseEntity = self
	wheels:Spawn()
	wheels:Activate()
	local phy = wheels:GetPhysicsObject()
	if IsValid(phy) then
		phy:SetMass(self.WheelsMass)
	end
	
	self:SetWheels(wheels)
	self:AddEntity(wheels)
	constraint.Axis(wheels,self:GetHull(),0,0,Vector(0,0,0),self:WorldToLocal(wheels:LocalToWorld(Vector(0,1,0))),0,0,10,1,Vector(90,0,0))
end

function ENT:ShouldUse(ct)
	return self:GetUseDelay() <= ct
end

function ENT:Use(ply,caller,use,val)
	local ct = CurTime()
	if !self:ShouldUse(ct) then return end
	local shooter = self:GetShooter()
	if ply:IsPlayer() and self:GetBotMode() then
		self:SetBotMode(false)
		self:LeaveTurret(self)
		self:GrabTurret(ply)
	else
		if shooter == ply then
			self:LeaveTurret(ply)
		else
			if not IsValid(shooter) then
				self:GrabTurret(ply)
			end
		end
	end
	self:SetUseDelay(ct + 0.2)
end

---------------------

function ENT:OnTick(ct,ply,botmode)
	
end

local reachSky = Vector(0,0,9999999999)
function ENT:CalcMortarCanShoot(ply,ct)
	local tr = util.QuickTrace(self:LocalToWorld(self.TurretMuzzles[1].Pos),reachSky,self.Entities)
	local canShoot = true
	local botmode = self:GetBotMode()
	self.Time_Mortar = self.Time_Mortar or 0
	if tr.Hit and !tr.HitSky then
		canShoot = false
		noHitSky = true
		if !botmode and self.Time_Mortar <= ct then
			net.Start("gred_net_message_ply")
				net.WriteEntity(ply)
				net.WriteString("["..self.NameToPrint.."] Nothing must block the mortar's muzzle!")
			net.Send(ply)
			self.Time_Mortar = ct + 1
		end
	else
		noHitSky = false
		local ang = self:GetAngles() - self:GetHull():GetAngles()
		ang:Normalize()
		canShoot = not (ang.y >= self.MaxRotation.y or ang.y-0.1 <= -self.MaxRotation.y)
		-- canShoot = not (ang.y > self.MaxRotation.y or ang.y < -self.MaxRotation.y)
		
		if !canShoot then
			if !botmode and self.Time_Mortar <= ct then
				net.Start("gred_net_message_ply")
					net.WriteEntity(ply)
					net.WriteString("["..self.NameToPrint.."] You can't shoot there!")
				net.Send(ply)
				self.Time_Mortar = ct + 1
			end
		else
			if botmode then
				if self:GetTargetValid() then
					shootPos = self:GetTarget():GetPos()
				end
			else
				shootPos = util.TraceLine(util.GetPlayerTrace(ply)).HitPos
			end
			local tr = util.QuickTrace(shootPos,shootPos + reachSky,self.Entities)
			if tr.Hit and !tr.HitSky and !tr.Entity == self:GetTarget() then
				canShoot = false
				if !botmode and self.Time_Mortar <= ct then
					net.Start("gred_net_message_ply")
						net.WriteEntity(ply)
						net.WriteString("["..self.NameToPrint.."] You can't shoot in interiors!")
					net.Send(ply)
					self.Time_Mortar = ct + 1
				end
			end
		end
	end
	return canShoot
end

function ENT:FireMortar(ply,ammo,muzzle)
	
	local pos = self:GetPos()
	util.ScreenShake(pos,5,5,0.5,200)
	local effectdata = EffectData()
	effectdata:SetOrigin(pos-Vector(0,0,10))
	effectdata:SetAngles(Angle(90,0,0))
	effectdata:SetFlags(table.KeyFromValue(gred.Particles,"gred_mortar_explosion_smoke_ground"))
	util.Effect("gred_particle_simple",effectdata)
	
	local dir = ply:EyeAngles():Forward()*100000
	
	local trace = {}				
	trace.start = shootPos
	trace.endpos = shootPos + Vector(0,0,1000) -- This calculates the spawn altitude
	trace.Mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine(trace)
	
	local BPos = tr.HitPos + 
	Vector(math.random(-self.Spread,self.Spread),math.random(-self.Spread,self.Spread),-1) -- Creates our spawn position
	while !util.IsInWorld(BPos) do
		BPos = tr.HitPos + Vector(math.random(-self.Spread,self.Spread),math.random(-self.Spread,self.Spread),-1) -- re-ceates our spawn position
	end
	local HitBPos = Vector(0,0,
	util.QuickTrace(BPos,BPos - reachSky,{self,self.turretBase,self.shootpos} ).HitPos.z) -- Defines the ground's pos
	local zpos = Vector(0,0,BPos.z) -- The exact spawn altitude
	local dist = HitBPos:Distance(zpos) -- Calculates the distance between our spawn altitude and the ground
	
	----------------------
	
	local snd = "artillery/flyby/artillery_strike_incoming_0"..(math.random(1,4))..".wav"
	local sndDuration = SoundDuration(snd)
	local ShellTable = self.AmmunitionTypes[self:GetAmmoType()] 
	local ammo = ShellTable[1]
	local bul = ShellTable[2]
	timer.Simple(GetConVar("gred_sv_shell_arrival_time"):GetFloat(),function()
		if not IsValid(self) then return end
		local  b =ents.Create(bul)
		local time = (dist/-1000)+(sndDuration-0.2) -- Calculates when to play the whistle sound
		if time < 0 then
			b:SetPos(BPos)
			b:SetAngles(Angle(90,0,0))
			b:SetOwner(ply)
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
				b:SetOwner(ply)
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

function ENT:FireMG(ply,ammo,muzzle)
	local pos = self:LocalToWorld(muzzle.Pos)
	local ang = self:LocalToWorldAngles(muzzle.Ang) + self.ShootAngleOffset
	
	local b = ents.Create("gred_base_bullet")
	local ammotype = self.AmmunitionType or self.AmmunitionTypes[1][2]
	local num
	if self.Spread > 0 then
		num = self.Spread
	else
		if ammotype == "wac_base_7mm" then
			num = 0.3
		elseif ammotype == "wac_base_12mm" then
			num = 0.5
		elseif ammotype == "wac_base_20mm" then
			num = 1.4
		elseif ammotype == "wac_base_30mm" then
			num = 1.6
		elseif ammotype == "wac_base_40mm" then
			num = 2
		end
	end
	b:SetPos(pos)
	b:SetAngles(ang + Angle((Angle(math.Rand(num,-num) - 0, math.Rand(num,-num)+90, math.Rand(num,-num)))))
	b.Speed=1000
	b.Damage=20
	b.Radius=70
	if self.AmmunitionTypes and self.AmmunitionTypes[self:GetAmmoType()][1] == "Time-fuzed" or false then 
		b.FuzeTime = self:GetFuzeTime()
	end
	if self.Sequential then
		b.sequential=1
	else
		b.sequential=0
	end
	b.gunRPM=self:GetRoundsPerMinute()
	b.Caliber=ammotype
	b.col = self.TracerColor
	b.Owner=ply
	b.Filter = self.Entities
	b:Spawn()
	b:Activate()
	
	self:UpdateTracers(b)
	
end

function ENT:FireCannon(ply,ammo,muzzle)
	
	local pos = self:GetPos()
	util.ScreenShake(pos,5,5,0.5,200)
	local effectdata = EffectData()
	effectdata:SetOrigin(pos-Vector(0,0,10))
	effectdata:SetAngles(Angle(90,0,0))
	effectdata:SetFlags(table.KeyFromValue(gred.Particles,"gred_mortar_explosion_smoke_ground"))
	util.Effect("gred_particle_simple",effectdata)
	
	util.ScreenShake(pos,5,5,0.5,200)
	pos = self:LocalToWorld(muzzle.Pos)
	local ang = self:LocalToWorldAngles(muzzle.Ang) + self.ShootAngleOffset
	
	local curShell = self:GetAmmoType()
	local ammotype = self.AmmunitionTypes[curShell][1]
	local b = ents.Create(self.AmmunitionType or self.AmmunitionTypes[curShell][2])
	ang:Sub(Angle(self:GetBotMode() and (self.AddShootAngle or 2) + 2 or (self.AddShootAngle or 2),-90,0)) -- + Angle(math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter), math.Rand(-self.Scatter,self.Scatter))
	b:SetPos(pos)
	b:SetAngles(ang)
	b:Spawn()
	b:SetBodygroup(0,1)
	b.IsOnPlane = true
	b:SetBodygroup(1,1)
	b.Parent = self
	b.AddOnThink = function(self)
		-- print(self:GetAngles().p,self.Parent.AddShootAngle or 2)
			-- print("DIST = ",self:GetPos():Distance(self.Parent:GetPos()))
			-- print("VEL = ",self:GetVelocity():Length())
			-- print("VAL = ",self.Val)
	end
	if self.IsRocketLauncher then
		b.FuelBurnoutTime = self:GetMaxRange()
	end
	if ammotype == "AP" then
		b.AP = true
	elseif ammotype == "Smoke" then
		b.Smoke = true
		if self.IsRocketLauncher then
			b.Effect = "doi_smoke_artillery"
			b.EffectAir = "doi_smoke_artillery"
			b.ExplosionRadius = 0
			b.ExplosionDamage = 0
			b.SpecialRadius = 0
			b.PhysForce = 0
			b.RSound = 1
			b.DEFAULT_PHYSFORCE                = 0
			b.DEFAULT_PHYSFORCE_PLYAIR         = 0
			b.DEFAULT_PHYSFORCE_PLYGROUND      = 0
			b.ExplosionSound = table.Random(self.SmokeExploSNDs)
			b.WaterExplosionSound = table.Random(self.SmokeExploSNDs)
		end
	end
	b:SetOwner(ply)
	b:Activate()
	for k,v in pairs(self.Entities) do
		constraint.NoCollide(v,b,0,0)
	end
	b:Launch()
	if self.TurretEjects[1] then
		local mdlscale = b.ModelSize
		timer.Simple(self.AnimPlayTime + (self.TimeToEjectShell or 0.2),function()
			if !IsValid(self) then return end
			shellEject = self.TurretEjects[1]
			local shell = ents.Create("gred_prop_casing")
			shell.Model = "models/gredwitch/bombs/75mm_shell.mdl"
			shell:SetPos(self:LocalToWorld(shellEject.Pos))
			shell:SetAngles(self:LocalToWorldAngles(shellEject.Ang))
			shell.BodyGroupA = 1
			shell.BodyGroupB = 2
			shell:Spawn()
			shell:Activate()
			shell:SetModelScale(mdlscale)
		end)
	end
end

function ENT:UpdateTracers(ent)
	self:SetCurrentTracer(self:GetCurrentTracer() + 1)
	local tracerConvar = GetConVar("gred_sv_tracers"):GetInt()
	if self:GetCurrentTracer() >= tracerConvar then
		if self.TracerColor == "Red" then
			ent:SetSkin(1)
		elseif self.TracerColor == "Green" then
			ent:SetSkin(3)
		elseif self.TracerColor == "Yellow" then
			ent:SetSkin(0)
		end
		ent:SetModelScale(7)
		self:SetCurrentTracer(0)
	else 
		ent.noTracer = true
	end
end

function ENT:Reload()

end

function ENT:CreateSeat(ply)
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	local yaw = self:GetYaw()
	local a = yaw:LookupAttachment("seat")
	local att = yaw:GetAttachment(a)
	
	-- local ang = Angle(att.Ang + self.SeatAngle)
	-- ang:Normalize()
	-- seat:SetAngles(ang)
	
	-- seat:SetAngles(yaw:LocalToWorldAngles(att.Ang))
	seat:SetPos(att.Pos-Vector(0,0,5))
	seat:SetModel("models/nova/airboat_seat.mdl")
	seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview","0")
	seat:Spawn()
	seat:Activate()
	seat:PhysicsInit	  (SOLID_NONE)
	seat:SetRenderMode	  (RENDERMODE_NONE)
	seat:SetSolid		  (SOLID_NONE)
	seat:SetCollisionGroup(COLLISION_GROUP_WORLD)
	seat:SetParent(yaw,a)
	self:SetSeat(seat)
	ply:EnterVehicle(seat)
	ply:CrosshairEnable()
end

function ENT:PlayAnim()
	if self:GetIsReloading() then print("NOT ANIMPLAYING") return end
	self.sounds.reload_finish:Stop()
	self.sounds.reload_start:Stop()
	self.sounds.reload_shell:Stop()
	
	local manualReload = GetConVar("gred_sv_manual_reload"):GetInt() == 1
	self:SetIsReloading(false)
	self:SetAmmo(0)
	timer.Simple(self.AnimPlayTime,function()
		if !IsValid(self) then return end
		self:ResetSequence("reload")
		self.sounds.reload_start:Play()
		self:SetIsReloading(true)
		if manualReload then
			timer.Simple(self.AnimPauseTime,function() 
				self:SetCycle(.5)
				self:SetPlaybackRate(0) 
			end)
		else
			timer.Simple(self.ShellLoadTime or self.AnimRestartTime/2,function()
				if !IsValid(self) then return end
				self.sounds.reload_shell:Play()
			end)
			timer.Simple(self:SequenceDuration()-0.6,function() 
				if !IsValid(self) then return end
				self.sounds.reload_finish:Play()
				timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function()
					self:SetIsReloading(false)
				end)
			end)
		end
	end)
end

function ENT:CheckHasWP()
	for k,v in pairs(self.AmmunitionTypes) do
		if v[1] == "WP" then
			return true
		end
	end
end

---------------------

function ENT:GetStoredShellProperties(ammotype)
	if not ammotype then ammotype = self.AmmunitionType or self.AmmunitionTypes[self:GetAmmoType()][2] end
	if not self.ShellProps then
		local getBase = scripted_ents.Get(ammotype)
		self.ShellProps = {
			getBase.EnginePower*GetConVar("gred_sv_shellspeed_multiplier"):GetFloat(),
			getBase.FuelBurnoutTime,
			getBase.Mass
		}
	end
	return self.ShellProps
end

function ENT:ManualReload(ammo)
	if ammo == 0 and self.EmplacementType != "MG" then
		if GetConVar("gred_sv_manual_reload"):GetInt() == 1 then
		
			local pos = self:GetPos()
			local bboxMin,bboxMax = self:GetModelBounds()
			local ent
			local class
			local IsWP
			local IsRightShell
			for k,v in pairs (ents.FindInBox(bboxMin+pos,bboxMax+pos)) do
				class = v:GetClass()
				if scripted_ents.IsBasedOn(class,"base_shell") then
					IsWP = (string.lower(class) == tostring(self.AmmunitionTypes[1][2].."wp"))
					IsRightShell = (self.AmmunitionTypes[1][2] == class or (IsWP and self:CheckHasWP())) and not v.Fired
					if IsRightShell then
						ent = v
						break
					else
						if IsValid(v.PlyPickup) then
							v.PlyPickup:PrintMessage(4,"["..self.NameToPrint.."] Wrong caliber / shell type !")
						end
					end
				end
			end
			-- debugoverlay.Box(self:GetPos(),bboxMin,bboxMax,FrameTime()+0.05,Color(255,255,255,0))
			if ent != nil then
				if IsRightShell then
					if self.EmplacementType == "Cannon" then
						self.AnimPlaying = true
					end
					for k,v in pairs(self.AmmunitionTypes) do
						if ent.AP and !ent.Smoke and v[1] == "AP" then -- AP
							self:SetAmmoType(k)
							break
						elseif !ent.AP and !ent.Smoke and v[1] == "HE" and not IsWP then -- HE
							self:SetAmmoType(k)
							break
						elseif !ent.AP and ent.Smoke and v[1] == "Smoke" then -- Smoke
							self:SetAmmoType(k)
							break
						elseif string.lower(v[2]) == class and v[1] == "WP" and IsWP then -- WP
							self:SetAmmoType(k)
							break
						end
					end
					if IsValid(ent.PlyPickup) then
						ent.PlyPickup:ChatPrint("["..self.NameToPrint.."] "..self.AmmunitionTypes[self:GetAmmoType()][1].." shell loaded!")
					end
					ent:Remove()
					if self.EmplacementType == "Cannon" then
						self.sounds.reload_shell:Stop()
						self.sounds.reload_shell:Play()
						timer.Simple(1.3,function()
							if !IsValid(self) then return end
							self.sounds.reload_start:Stop()
							self.sounds.reload_finish:Play()
							if self.UseSingAnim then
								self:SetCycle(.8)
								self:SetPlaybackRate(1)
								timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function() 
									self.AnimPlaying = false
									self:SetAmmo(1)
								end)
							else
								self:ResetSequence("reload_finish")
								timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function() 
									self.AnimPlaying = false
									self:SetAmmo(1)
								end)
							end
						end)
					else
						self:SetAmmo(1)
					end
				end
			end
		end
	elseif self.EmplacementType == "MG" and (ammo >= 0 and ammo < self.Ammo) and self:GetIsReloading() then
		if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 1 then
			local bboxMin,bboxMax = self:GetModelBounds()
			local pos = self:GetPos()
			local ent
			for k,v in pairs (ents.FindInBox(bboxMin+pos,bboxMax+pos)) do
				if v.gredGunEntity then
					if v.gredGunEntity == self:GetClass() or v.gredGunEntity == self.AltClassName then
						ent = v
						break
					end
				end
			end
			self.MagIn = false
			-- debugoverlay.Box(pos,bboxMin,bboxMax,FrameTime()+0.05,Color(255,255,255,0))
			if ent != nil then
				ent:Remove()
				self:SetPlaybackRate(1)
				if self.CycleRate then self:SetCycle(self.CycleRate) end
				self.sounds.reloadend:Stop()
				self.sounds.reloadend:Play()
				self.MagIn = true
				timer.Simple(self.ReloadTime, function()
					self:SetAmmo(self.Ammo)
					self:SetIsReloading(false)
				end)
			end
		end
	end
end

function ENT:Explode(ply)
	if self.Exploded then return end
	if GetConVar("gred_sv_enable_explosions"):GetInt() == 0 then return end
	self.Exploded = true
	
	local b = self:BoundingRadius()
	local p = self:GetPos()
	local hull = self:GetHull()
	local tp = hull:GetPos()
	local tr = hull:GetRight()
	local u = self:GetUp()
	local r = self:GetRight()
	local f = self:GetForward()
	self.ExploPos = {}
	self.ExploPos[1] = p
	self.ExploPos[2] = tp
	if b >= 150 then
		b = b / 1.5
		p.z = p.z + (self.ExplodeHeight or 0)
		self.ExploPos[3] = p+r*b
		self.ExploPos[4] = p+r*-b
		self.ExploPos[5] = p+f*b
		self.ExploPos[6] = p+f*-b
		self.ExploPos[7] = p+u*b
		self.ExploPos[8] = p+u*-b
	else
		if self.EmplacementType == "Cannon" then
			self.ExploPos[3] = tp+tr*-(b*0.7)
			self.ExploPos[4] = tp+tr*(b/2)
		end
	end
	for k,v in pairs (self.ExploPos) do
		local effectdata = EffectData()
		effectdata:SetOrigin(v)
		util.Effect("Explosion",effectdata)
		ply = ply or self
		util.BlastDamage(ply,ply,v,100,100)
	end
	self:Remove()
end

function ENT:OnTakeDamage(dmg)
	if dmg:IsFallDamage() or self:GetHP() <= 0 or (dmg:IsBulletDamage() and dmg:GetDamage() < 7) then return end
	self:SetHP(self:GetHP()-dmg:GetDamage())
	
	if self:GetHP() <= 0 then self:Explode(dmg:GetAttacker()) end
end

function ENT:OnRemove()
	for k,v in pairs(self.Entities) do
		if IsValid(v) then
			v:Remove()
		end
	end
	self:LeaveTurret(self:GetShooter())
end

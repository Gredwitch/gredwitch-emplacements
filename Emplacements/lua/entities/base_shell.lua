AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

local MetMat = {
	canister				=	1,
	chain					=	1,
	chainlink				=	1,
	combine_metal			=	1,
	crowbar					=	1,
	floating_metal_barrel	=	1,
	grenade					=	1,
	metal					=	1,
	metal_barrel			=	1,
	metal_bouncy			=	1,
	Metal_Box				=	1,
	metal_seafloorcar		=	1,
	metalgrate				=	1,
	metalpanel				=	1,
	metalvent				=	1,
	metalvehicle			=	1,
	paintcan				=	1,
	roller					=	1,
	slipperymetal			=	1,
	solidmetal				=	1,
	strider					=	1,
	weapon					=	1,
}

sound.Add({
	name = "shellSound",
	channel = CHAN_STATIC,
	soundlevel = 90,
	sound = "gred_emp/common/shellwhiz.wav"
})
local damagesound                    =  "weapons/rpg/shotdown.wav"

local SmokeSnds = {}
SmokeSnds[1]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
SmokeSnds[2]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
SmokeSnds[3]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
SmokeSnds[4]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

local APSounds = {}
APSounds[1]							 =  "impactsounds/ap_impact.wav"
local APSoundsDist = {}
APSoundsDist[1]							 =  "impactsounds/ap_impact_dist_01.wav"
APSoundsDist[2]							 =  "impactsounds/ap_impact_dist_02.wav"
APSoundsDist[3]							 =  "impactsounds/ap_impact_dist_03.wav"

local APMetalSounds = {}
APMetalSounds[1]							 =  "impactsounds/ap_impact_metal_01.wav"
APMetalSounds[2]							 =  "impactsounds/ap_impact_metal_02.wav"
APMetalSounds[3]							 =  "impactsounds/ap_impact_metal_03.wav"

ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "Gredwitch's Shell base"
ENT.Author			                 =  "Gredwitch"
ENT.Contact			                 =  "qhamitouche@gmail.com"
ENT.Category                         =  "Gredwitch's Stuff"

ENT.TOBEPRINTED						 =	0

ENT.Model                            =  ""
ENT.Effect                           =  ""
ENT.EffectAir                        =  ""
ENT.EffectWater                      =  ""
ENT.RocketTrail						 =	"grenadetrail"
     
ENT.ExplosionSound                   =  ENT.ExplosionSound
ENT.FarExplosionSound				 =  ENT.ExplosionSound
ENT.DistExplosionSound				 =  ENT.ExplosionSound
ENT.AngEffect						 =	false

ENT.WaterExplosionSound				 =	nil
ENT.WaterFarExplosionSound			 =  nil
    
ENT.StartSound                       =  ""
ENT.ArmSound                         =  ""
ENT.ActivationSound                  =  ""
ENT.EngineSound                      =  ""--"Missile.Ignite"
ENT.NBCEntity                        =  ""

ENT.ShouldUnweld                     =  false
ENT.ShouldIgnite                     =  false
ENT.UseRandomSounds                  =  false
ENT.SmartLaunch                      =  true
ENT.Timed                            =  false
ENT.IsNBC                            =  false

ENT.AP								 =  false
ENT.ExplosionDamage                  =  0
ENT.ExplosionRadius                  =  0
ENT.PhysForce                        =  ENT.ExplosionRadius / ENT.ExplosionDamage
ENT.SpecialRadius                    =  ENT.ExplosionDamage / ENT.ExplosionRadius
ENT.Life                             =  20
ENT.TraceLength                      =  25
ENT.ImpactSpeed                      =  50
ENT.Mass                             =  0
ENT.EnginePower                      =  99999999999999999999999999999999999
ENT.FuelBurnoutTime                  =  0.7
ENT.IgnitionDelay                    =  0
ENT.RotationalForce                  =  0
ENT.ArmDelay                         =  0
ENT.ForceOrientation                 =  "NORMAL"
ENT.Timer                            =  0
ENT.Smoke							 =  false

ENT.RSound   						 =  1


ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

function ENT:Initialize()
	 if (SERVER) then
		 self:SetModel(self.Model)  
		 self:PhysicsInit( SOLID_VPHYSICS )
		 self:SetSolid( SOLID_VPHYSICS )
		 self:SetMoveType(MOVETYPE_VPHYSICS)
		 self:SetUseType( ONOFF_USE ) -- doesen't fucking work
		 local phys = self:GetPhysicsObject()
		 local skincount = self:SkinCount()
		 if (phys:IsValid()) then
			 phys:SetMass(self.Mass)
			 phys:Wake()
		 end
		 if (skincount > 0) then
			 self:SetSkin(math.random(0,skincount))
		 end
		 self.Armed    = false
		 self.Exploded = false
		 self.Fired    = false
		 self.Burnt    = false
		 self.Ignition = false
		 self.Arming   = false
			
		if self.GBOWNER == nil then self.GBOWNER = self.Owner else self.Owner = self.GBOWNER end
		if !(WireAddon == nil) then self.Inputs = Wire_CreateInputs(self, { "Arm", "Detonate", "Launch" }) end
	end
end

function ENT:TriggerInput(iname, value)
     if (!self:IsValid()) then return end
	 if (iname == "Detonate") then
         if (value >= 1) then
		     if (!self.Exploded and self.Armed) then
				if !self:IsValid() then return end
	            self.Exploded = true
			    self:Explode()
		     end
		 end
	 end
	 if (iname == "Arm") then
         if (value >= 1) then
             if (!self.Exploded and !self.Armed and !self.Arming) then
			     self:EmitSound(self.ActivationSound)
                 self:Arm()
             end 
         end
     end		 
	 if (iname == "Launch") then 
	     if (value >= 1) then
		     if (!self.Exploded and !self.Burnt and !self.Ignition and !self.Fired) then
			     self:Launch()
		     end
	     end
     end
end          

function ENT:AddOnExplode()
end

function ENT:Explode()
    if not self.Exploded then return end
	local pos = self:LocalToWorld(self:OBBCenter())
	self:AddOnExplode()
	if self.Smoke then
		self.ExplosionSound = table.Random(SmokeSnds)
		self.FarExplosionSound = self.ExplosionSound
		self.DistExplosionSound = ""
		self.RSound = 0
		self.Effect = self.SmokeEffect
		self.EffectAir = self.SmokeEffect
	elseif self.AP then
		if game.SinglePlayer() then
			self.ExplosionSound = table.Random(APSoundsDist)
			self.FarExplosionSound = table.Random(APSoundsDist)
		else
			self.ExplosionSound = table.Random(APSounds)
			self.FarExplosionSound = table.Random(APSounds)
		end
		self.DistExplosionSound = table.Random(APSoundsDist)
		self.Effect = "gred_ap_impact"
		self.EffectAir = "gred_ap_impact"
		self.ExplosionRadius = 100
		self.ExplosionDamage = self.APDamage
		self.PhysForce = 10
	end
	if not self.Smoke then
		local ent = ents.Create("shockwave_ent")
		ent:SetPos( pos ) 
		ent:Spawn()
		ent:Activate()
		ent:SetVar("DEFAULT_PHYSFORCE", self.DEFAULT_PHYSFORCE)
		ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", self.DEFAULT_PHYSFORCE_PLYAIR)
		ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", self.DEFAULT_PHYSFORCE_PLYGROUND)
		ent:SetVar("GBOWNER", self.GBOWNER)
		ent:SetVar("MAX_RANGE",self.ExplosionRadius)
		ent:SetVar("SHOCKWAVEDAMAGE",self.ExplosionDamage)
		ent:SetVar("SHOCKWAVE_INCREMENT",100)
		ent:SetVar("DELAY",0.01)
		ent.trace=self.TraceLength
		ent.decal=self.Decal
		for k, v in pairs(ents.FindInSphere(pos,self.SpecialRadius)) do
			if v:IsValid() then
				local i = 0
				while i < v:GetPhysicsObjectCount() do
				phys = v:GetPhysicsObjectNum(i)	  
				if (phys:IsValid()) then		
					local mass = phys:GetMass()
					local F_ang = self.PhysForce
					local dist = (pos - v:GetPos()):Length()
					local relation = math.Clamp((self.SpecialRadius - dist) / self.SpecialRadius, 0, 1)
					local F_dir = (v:GetPos() - pos):GetNormal() * self.PhysForce
					   
					phys:AddAngleVelocity(Vector(F_ang, F_ang, F_ang) * relation)
					phys:AddVelocity(F_dir)
				end
				i = i + 1
				end
			end
		end
	end
	 
	if(self:WaterLevel() >= 1) then
		local trdata   = {}
		local trlength = Vector(0,0,9000)

		trdata.start   = pos
		trdata.endpos  = trdata.start + trlength
		trdata.filter  = self
		local tr = util.TraceLine(trdata) 

		local trdat2   = {}
		trdat2.start   = tr.HitPos
		trdat2.endpos  = trdata.start - trlength
		trdat2.filter  = self
		trdat2.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
			 
		local tr2 = util.TraceLine(trdat2)
		
		if tr2.Hit then
			if self.EffectWater == "ins_water_explosion" then
				ParticleEffect(self.EffectWater, tr2.HitPos, Angle(-90,0,0), nil)
			else
				ParticleEffect(self.EffectWater, tr2.HitPos, Angle(0,0,0), nil)
			end
		end
		if !self.Smoke then
			if self.WaterExplosionSound == nil then else 
				self.ExplosionSound = self.WaterExplosionSound 
			end
			if self.WaterFarExplosionSound == nil then else  
				self.FarExplosionSound = self.WaterFarExplosionSound 
			end
		end
     else
		local tracedata    = {}
	    tracedata.start    = pos
		tracedata.endpos   = tracedata.start - Vector(0, 0, self.TraceLength)
		tracedata.filter   = self.Entity
				
		local trace = util.TraceLine(tracedata)
	     
		if self.AP then
			self.EffectAir = "AP_impact_wall"
			local trdt  = {}
			trdt.start  = pos
			trdt.endpos = pos + pos-self:GetAngles():Forward()*1000
			trdt.filter = self.Entity
			local tr = util.TraceLine(trdt)
			local hitmat = util.GetSurfacePropName(tr.SurfaceProps)
			if MetMat[hitmat] == 1 then
				self.Effect = "AP_impact_wall"
				if game.SinglePlayer() then
					self:EmitSound(table.Random(APMetalSounds),120,100,1,CHAN_AUTO)
					self.ExplosionSound = table.Random(APSoundsDist)
					self.FarExplosionSound = table.Random(APSoundsDist)
				else
					self.ExplosionSound = table.Random(APMetalSounds)
					self.FarExplosionSound = table.Random(APMetalSounds)
				end
				self.DistExplosionSound = table.Random(APSoundsDist)
			else
				self:EmitSound(table.Random(APSounds),120,100,1,CHAN_AUTO)
			end
		end
		if trace.HitWorld then
			if self.AngEffect then
				ParticleEffect(self.Effect,pos,Angle(-90,0,0),nil)
				ParticleEffect("doi_ceilingDust_large",pos-Vector(0,0,100),Angle(0,0,0),nil) 
			else
				ParticleEffect(self.Effect,pos,Angle(0,0,0),nil)
			end
		else 
			if self.AngEffect then
				ParticleEffect(self.EffectAir,pos,Angle(-90,0,0),nil) 
			else
				ParticleEffect(self.EffectAir,pos,Angle(0,0,0),nil)
			end
		end
    end
	
	local ent = ents.Create("shockwave_sound_lowsh")
	ent:SetPos( pos ) 
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER", self.GBOWNER)
	ent:SetVar("MAX_RANGE",self.ExplosionDamage*self.ExplosionRadius)
	if self.RSound == nil then ent:SetVar("NOFARSOUND",1) else
		ent:SetVar("NOFARSOUND",self.RSound) 
	end
	ent:SetVar("SHOCKWAVE_INCREMENT",200)
	
	ent:SetVar("DELAY",0.01)
	ent:SetVar("SOUNDCLOSE", self.ExplosionSound)
	ent:SetVar("SOUND", self.FarExplosionSound)
	ent:SetVar("SOUNDFAR", self.DistExplosionSound)
	ent:SetVar("Shocktime", 0)
	
	 if self.IsNBC then
	     local nbc = ents.Create(self.NBCEntity)
		 nbc:SetVar("GBOWNER",self.GBOWNER)
		 nbc:SetPos(self:GetPos())
		 nbc:Spawn()
		 nbc:Activate()
	 end
	self:StopSound(self.EngineSound)
	self:StopSound(self.StartSound)
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
     if !self:IsValid() then return end
     if self.Exploded then return end
	 exploDamage = dmginfo:IsDamageType(64)
	 if exploDamage == true then return end
	 if (self.Life <= 0) then return end
	 self:TakePhysicsDamage(dmginfo)
     if(GetConVar("gred_sv_fragility"):GetInt() >= 1) then  
	     if(!self.Fired and !self.Burnt and !self.Arming and !self.Armed) then
	         if(math.random(0,9) == 1) then
		         self:Launch()
		     else
			     self:Arm()
			 end
	     end
	 end
	 if(self.Fired and !self.Burnt and self.Armed) then
	     if (dmginfo:GetDamage() >= 2) then
		     local phys = self:GetPhysicsObject()
		     self:EmitSound(damagesound)
	         phys:AddAngleVelocity(dmginfo:GetDamageForce()*0.1)
	     end
	 end
	 if(!self.Armed) then return end
	 self.Life = self.Life - dmginfo:GetDamage()
     if (self.Life <= 0) then
	    if !self:IsValid() then return end 
		self.Exploded = true
		self:Explode()
	end
end

function ENT:PhysicsCollide( data, physobj )
	 timer.Simple(0,function()
     if(self.Exploded) then return end
     if(!self:IsValid()) then return end
	 if(self.Life <= 0) then return end
		 if(GetConVar("gred_sv_fragility"):GetInt() >= 1) then
			 if(!self.Fired and !self.Burnt and !self.Arming and !self.Armed ) and (data.Speed > self.ImpactSpeed * 5) then --and !self.Arming and !self.Armed
				 if(math.random(0,9) == 1) then
					 self:Launch()
					 self:EmitSound(damagesound)
				 else
					 self:Arm()
					 self:EmitSound(damagesound)
				 end
			 end
		 end

		 if(!self.Armed) then return end
			
		 if (data.Speed > self.ImpactSpeed )then
			 self.Exploded = true
			 self:Explode()
		 end
	end)
end

function ENT:Launch()
    if(self.Exploded) then return end
	if(self.Burned) then return end
	if(self.Fired) then return end
	 
	local phys = self:GetPhysicsObject()
	if !phys:IsValid() then return end
	 
	self.Fired = true
	if(self.SmartLaunch) then
		constraint.RemoveAll(self)
	end
	timer.Simple(0.05,function()
	    if not self:IsValid() then return end
	    if(phys:IsValid()) then
            phys:Wake()
		    phys:EnableMotion(true)
	    end
	end)
	
	if not self:IsValid() then return end
	local phys = self:GetPhysicsObject()
	self.Ignition = true
	self:Arm()
	local pos = self:GetPos()
	
	if self.RocketTrail != "" then ParticleEffectAttach(self.RocketTrail,PATTACH_ABSORIGIN_FOLLOW,self,1) end
	if(self.FuelBurnoutTime != 0) then 
		timer.Simple(self.FuelBurnoutTime,function()
			if not self:IsValid() then return end
			self.Burnt = true
		end)
	end
end

function ENT:Think()
    if(self.Burnt) then return end
    if(!self.Ignition) then return end -- if there wasn't ignition, we won't fly
	if(self.Exploded) then return end -- if we exploded then what the fuck are we doing here
	if(!self:IsValid()) then return end -- if we aren't good then something fucked up
	local phys = self:GetPhysicsObject()
	local thrustpos = self:GetPos()
	-- phys:AddVelocity(self:GetForward() * -self.EnginePower)
	phys:AddVelocity(self:GetForward() * self.EnginePower)
	if (self.Armed) then
        phys:AddAngleVelocity(Vector(self.RotationalForce,0,0)) -- Rotational force
	end
	if CLIENT then
		if not self.Fired then return end
		local ply = LocalPlayer()
		local e=ply:GetViewEntity()
		if !IsValid(e) then e=ply end
		
		local frt=CurTime()-self.LastThink
		local pos=e:GetPos()
		local spos=self:GetPos()
		local doppler=(pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200*1
		local engineVal = math.Clamp(1*100+1*1*3+doppler, 0, 200)
		local val = math.Clamp(1*100 + doppler, 0, 200)
		self.sounds.Blades = CreateSound(self,"shellSound")
		self.sounds.Blades:ChangePitch(math.Clamp(val, 50, 150),0.1)
		self.sounds.Blades:ChangeVolume(1*math.Clamp(val*val/5000, 0, 5),0.1)
	end
	self:NextThink(CurTime() + 0.01)
	return true
end

function ENT:Arm()
     if(!self:IsValid()) then return end
	 if(self.Armed) then return end
	 self.Arming = true
	 
	 timer.Simple(self.ArmDelay, function()
	     if not self:IsValid() then return end 
	     self.Armed = true
		 self.Arming = false
		 self:EmitSound(self.ArmSound)
		 if(self.Timed) then
	         timer.Simple(self.Timer, function()
	             if !self:IsValid() then return end 
			     self.Exploded = true
			     self:Explode()
				 self.EmitLight = true
	         end)
		 end
	 end)
end	 

function ENT:Use( activator, caller )
     if(self.Exploded) then return end
	 if(self.Dumb) then return end
	 if(GetConVar("gred_sv_easyuse"):GetInt() >= 1) then
         if(self:IsValid()) then
             if (!self.Exploded) and (!self.Burnt) and (!self.Fired) then
	             if (activator:IsPlayer()) then
                     self:EmitSound(self.ActivationSound)
                     self:Launch()
		         end
	         end
         end
	 end
end

function ENT:OnRemove()
     self:StopSound(self.EngineSound)
	 self:StopParticles()
end

if ( CLIENT ) then
     function ENT:Draw()
         self:DrawModel()
		 if !(WireAddon == nil) then Wire_Render(self.Entity) end
     end
end

function ENT:OnRestore()
     Wire_Restored(self.Entity)
end

function ENT:BuildDupeInfo()
     return WireLib.BuildDupeInfo(self.Entity)
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
     WireLib.ApplyDupeInfo( ply, ent, info, GetEntByID )
end

function ENT:PrentityCopy()
     local DupeInfo = self:BuildDupeInfo()
     if(DupeInfo) then
         duplicator.StorentityModifier(self.Entity,"WireDupeInfo",DupeInfo)
     end
end

function ENT:PostEntityPaste(Player,Ent,CreatedEntities)
     if(Ent.EntityMods and Ent.EntityMods.WireDupeInfo) then
         Ent:ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
     end
end
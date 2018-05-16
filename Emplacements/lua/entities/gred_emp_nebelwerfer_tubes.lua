AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

local ExploSnds = {}
ExploSnds[1]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
ExploSnds[2]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
ExploSnds[3]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
ExploSnds[4]                         =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[EMP]Nebelwerfer 41 (tubes only)"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Ammo							=	66
ENT.TubesMdl                        =	"models/gredwitch/nebelwerfer/nebelwerfer_tubes.mdl"
ENT.Mass							=	0.001
ENT.ReloadTime						=	GetConVarNumber("gred_emp_nebel_reloadtime")
ENT.Dump							=	false
ENT.Smoke							=	false
ENT.FireRate						=	1.67

if (SERVER) then
	function ENT:SpawnFunction( ply, tr, ClassName )
			if (  !tr.Hit ) then return end
			local SpawnPos = tr.HitPos + tr.HitNormal * 16
			local ent = ents.Create(ClassName)
			ent:SetPos(SpawnPos)
			ent:Spawn()
			ent:Activate()
			return ent
	end

	function ENT:Initialize()
		self:SetModel(self.TubesMdl)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		phys = self.Entity:GetPhysicsObject()
		
		if (IsValid(phys)) then
			phys:SetMass(self.Mass)
			phys:Wake()
			-- phys:EnableDrag(false)
		end
		self.nextUse=0
	end
	function ENT:Shoot()
		if self.nextUse>CurTime() or self.Ammo == 0 then return end
		self.nextUse = CurTime()+self.FireRate
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local ent = ents.Create("gb_rocket_nebel")
		local rocket = self:GetAttachment(self:LookupAttachment("rocket"..self.Ammo))
		ent:SetPos(rocket.Pos)
		ent:SetOwner(caller)
		if self.Smoke then
			ent.Effect = "doi_smoke_artillery"
			ent.EffectAir = "doi_smoke_artillery"
			ent.ExplosionRadius = 0
			ent.ExplosionDamage = 0
			ent.SpecialRadius = 0
			ent.PhysForce = 0
			ent.RSound = 1
			ent.DEFAULT_PHYSFORCE                = 0
			ent.DEFAULT_PHYSFORCE_PLYAIR         = 0
			ent.DEFAULT_PHYSFORCE_PLYGROUND      = 0
			ent.ExplosionSound = table.Random(ExploSnds)
		else end
		ent.FuelBurnoutTime = math.random(1.7,1.85)
		ent:Activate()
		ent:Spawn()
		ent:Launch()
		ent:SetAngles(rocket.Ang+Angle(0,math.random(5,-5),0))
		self.Ammo = self.Ammo - 1
		util.ScreenShake(pos, 30, 4, math.Rand(0.5, 0.8), 320)
		ParticleEffect("ins_weapon_at4_frontblast", rocket.Pos, rocket.Ang)
		ParticleEffect("ins_weapon_rpg_dust", rocket.Pos,Angle(0,0,0))
	end

	function ENT:Use(activator, caller)
		self.Dump = true
	end

	function ENT:Reload()
		self.nextUse = CurTime()+self.ReloadTime
		timer.Simple(self.ReloadTime, function() 
			self.Ammo = 6
			self.Dump = false
		end)
	end

	function ENT:Think()
			if self.Ammo < 0 then self.Ammo = 0 end
			if self.Ammo > 6 then self.Ammo = 6 end
			
			if self.Dump and self.Ammo>0 then
				self:Shoot()
				if self.Ammo==0 then self:Reload() end
			end
			self:NextThink(CurTime())
			return true
		end
elseif (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
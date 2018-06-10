AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/doi_wp_01.wav"
ExploSnds[2]                         =  "explosions/doi_wp_02.wav"
ExploSnds[3]                         =  "explosions/doi_wp_03.wav"
ExploSnds[4]                         =  "explosions/doi_wp_04.wav"

ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "[ROCKETS]81mm WP Mortar Shell"
ENT.Author			                 =  ""
ENT.Contact			                 =  ""
ENT.Category                         =  "Gredwitch's Stuff"

ENT.Model                            =  "models/gredwitch/bombs/artillery_shell.mdl"
ENT.RocketTrail                      =  ""
ENT.RocketBurnoutTrail               =  ""
ENT.Effect                           =  "doi_wparty_explosion"
ENT.EffectAir                        =  "doi_wparty_explosion"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.AngEffect						 =	true

ENT.ExplosionSound                   =  table.Random(ExploSnds)
ENT.RSound							 =	1

ENT.StartSound                       =  ""
ENT.ArmSound                         =  ""
ENT.ActivationSound                  =  ""
ENT.EngineSound                      =  ""

ENT.ShouldUnweld                     =  true          
ENT.ShouldIgnite                     =  false         
ENT.UseRandomSounds                  =  true                  
ENT.SmartLaunch                      =  true  
ENT.Timed                            =  false 

ENT.ExplosionDamage                  =  10
ENT.ExplosionRadius                  =  350
ENT.PhysForce                        =  350
ENT.SpecialRadius                    =  350
ENT.MaxIgnitionTime                  =  0
ENT.Life                             =  1
ENT.MaxDelay                         =  0
ENT.TraceLength                      =  500
ENT.ImpactSpeed                      =  100
ENT.Mass                             =  30
ENT.EnginePower                      =  9999
ENT.FuelBurnoutTime                  =  0.7
ENT.IgnitionDelay                    =  0       
ENT.ArmDelay                         =  0
ENT.RotationalForce                  =  1000
ENT.ForceOrientation                 =  "NORMAL"       
ENT.Timer                            =  0


ENT.DEFAULT_PHYSFORCE                = 155
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000     
ENT.Shocktime                        = 2

ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
	self.GBOWNER = ply
    local ent = ents.Create( self.ClassName )
	ent:SetPhysicsAttacker(ply)
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
	
	ent.ExplosionSound = table.Random(ExploSnds)

    return ent
end

function ENT:AddOnExplode()
	local ent = ents.Create("base_napalm")
	local pos = self:GetPos()
	ent:SetPos(pos)
	ent.Radius	 = 500
	ent.Rate  	 = 1
	ent.Lifetime = 15
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER",self.GBOWNER)
end
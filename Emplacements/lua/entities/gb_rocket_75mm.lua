AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/doi_generic_01.wav"
ExploSnds[2]                         =  "explosions/doi_generic_02.wav"
ExploSnds[3]                         =  "explosions/doi_generic_03.wav"
ExploSnds[4]                         =  "explosions/doi_generic_04.wav"

local CloseExploSnds = {}
CloseExploSnds[1]                         =  "explosions/doi_generic_01_close.wav"
CloseExploSnds[2]                         =  "explosions/doi_generic_02_close.wav"
CloseExploSnds[3]                         =  "explosions/doi_generic_03_close.wav"
CloseExploSnds[4]                         =  "explosions/doi_generic_04_close.wav"

local DistExploSnds = {}
DistExploSnds[1]                         =  "explosions/doi_generic_01_dist.wav"
DistExploSnds[2]                         =  "explosions/doi_generic_02_dist.wav"
DistExploSnds[3]                         =  "explosions/doi_generic_03_dist.wav"
DistExploSnds[4]                         =  "explosions/doi_generic_04_dist.wav"

local WaterExploSnds = {}
WaterExploSnds[1]                         =  "explosions/doi_generic_01_water.wav"
WaterExploSnds[2]                         =  "explosions/doi_generic_02_water.wav"
WaterExploSnds[3]                         =  "explosions/doi_generic_03_water.wav"
WaterExploSnds[4]                         =  "explosions/doi_generic_04_water.wav"

local CloseWaterExploSnds = {}
CloseWaterExploSnds[1]                         =  "explosions/doi_generic_02_closewater.wav"
CloseWaterExploSnds[2]                         =  "explosions/doi_generic_02_closewater.wav"
CloseWaterExploSnds[3]                         =  "explosions/doi_generic_03_closewater.wav"
CloseWaterExploSnds[4]                         =  "explosions/doi_generic_04_closewater.wav"

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "[ROCKETS]75mm Artillery Shell"
ENT.Author			                 =  ""
ENT.Contact			                 =  ""
ENT.Category                         =  "Gredwitch's Stuff"

ENT.Model                            =  "models/gredwitch/75mm_ap.mdl"
ENT.RocketTrail                      =  ""
ENT.RocketBurnoutTrail               =  ""
ENT.Effect                           =  "gred_ap_impact"
ENT.EffectAir                        =  "gred_ap_impact"
ENT.EffectWater                      =  "ins_water_explosion"

ENT.ExplosionSound                   =  table.Random(CloseExploSnds)
ENT.FarExplosionSound				 =  table.Random(ExploSnds)
ENT.DistExplosionSound				 =  table.Random(DistExploSnds)
ENT.WaterExplosionSound				 =  table.Random(CloseWaterExploSnds)
ENT.WaterFarExplosionSound			 =  table.Random(WaterExploSnds)
ENT.RSound							 =	0

ENT.StartSound                       =  ""
ENT.ArmSound                         =  ""
ENT.ActivationSound                  =  ""
ENT.EngineSound                      =  ""

ENT.ShouldUnweld                     =  true          
ENT.ShouldIgnite                     =  false         
ENT.UseRandomSounds                  =  true                  
ENT.SmartLaunch                      =  true  
ENT.Timed                            =  false 

ENT.ExplosionDamage                  =  750
ENT.ExplosionRadius                  =  50
ENT.PhysForce                        =  100
ENT.SpecialRadius                    =  10
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


ENT.DEFAULT_PHYSFORCE                = 50
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
	
	ent.ExplosionSound	= table.Random(CloseExploSnds)
	ent.FarExplosionSound	= table.Random(ExploSnds)
	ent.DistExplosionSound	= table.Random(DistExploSnds)
	ent.WaterExplosionSound	= table.Random(CloseWaterExploSnds)
	ent.WaterFarExplosionSound	= table.Random(WaterExploSnds)

    return ent
end
AddCSLuaFile()
if CLIENT or not game.IsDedicated() then
	game.AddParticles( "particles/doi_explosions_smoke.pcf" )
	game.AddParticles( "particles/explosion_fx_ins_b.pcf" )
	game.AddParticles( "particles/ins_smokegrenade.pcf" )
	PrecacheParticleSystem("muzzleflash_bar_3p")
	PrecacheParticleSystem("muzzleflash_garand_3p")
	PrecacheParticleSystem("muzzleflash_mg42_3p")
	PrecacheParticleSystem("ins_weapon_at4_frontblast")
	PrecacheParticleSystem("ins_weapon_rpg_dust")
end
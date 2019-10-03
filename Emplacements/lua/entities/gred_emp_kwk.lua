AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]50mm KwK"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "KwK"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast"
ENT.ShotInterval		= 4.8
ENT.AmmunitionTypes		= {
	{
		Caliber = 50,
		ShellType = "HE",
		MuzzleVelocity = 685,
		Mass = 2.07,
		TracerColor = "white",
	},
	{
		Caliber = 50,
		ShellType = "AP",
		MuzzleVelocity = 685,
		Mass = 2.07,
		TracerColor = "white",
	},
	{
		Caliber = 50,
		ShellType = "Smoke",
		MuzzleVelocity = 685,
		Mass = 2.07,
		TracerColor = "white",
	},
}
ENT.PitchRate			= 50
ENT.YawRate				= 50
ENT.ShootAnim			= "shoot"

ENT.ShellLoadTime		= 1.3
ENT.AnimPlayTime		= 1.3
ENT.AnimPauseTime		= 0.3

ENT.ShootSound			= "^gred_emp/common/50mm.wav"

ENT.TurretPos			= Vector(0,0,49.8)
ENT.HullModel			= "models/gredwitch/kwk/kwk_base.mdl"
ENT.YawModel			= "models/gredwitch/kwk/kwk_shield.mdl"
ENT.TurretModel			= "models/gredwitch/kwk/kwk_gun.mdl"
ENT.EmplacementType     = "Cannon"
-- ENT.Seatable			= true
ENT.Ammo				= -1
ENT.MaxRotation			= Angle(-20)
ENT.ATReloadSound		= "small"
ENT.SightPos			= Vector(0,10,5)
ENT.ViewPos				= Vector(-1.5,-6,30)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
	return ent
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	-- seat = self:GetSeat()
	-- local seatValid = IsValid(seat)
	-- if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
	angles = ply:EyeAngles()
	if --[[(seatValid and seat:GetThirdPersonMode()) or]] self:GetViewMode() == 1 then
		local view = {}
		
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 50
		view.drawviewer = true

		return view
	-- else
		-- if seatValid then
			-- local view = {}
			-- view.origin = seat:LocalToWorld(self.ViewPos)
			-- view.angles = angles
			-- view.fov = fov
			-- view.drawviewer = false

			-- return view
		-- end
	end
end
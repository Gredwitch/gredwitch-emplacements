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
ENT.BulletType			= "gb_shell_50mm"
ENT.MuzzleCount			= 1

ENT.ShellSoundTime		= 1.7
ENT.HasReloadAnim		= true
ENT.AnimPlayTime		= 1.3
ENT.AnimPauseTime		= 0.3

ENT.SoundName			= "shootPaK"
ENT.ShootSound			= "gred_emp/common/50mm.wav"

ENT.TurretHeight		= 49.8
ENT.TurretFloatHeight	= 0
ENT.TurretModelOffset	= Vector(0,0,0)
ENT.TurretTurnMax		= -1
ENT.BaseModel			= "models/gredwitch/kwk/kwk_base.mdl"
ENT.SecondModel			= "models/gredwitch/kwk/kwk_shield.mdl"
ENT.Model				= "models/gredwitch/kwk/kwk_gun.mdl"
ENT.EmplacementType     = "AT"
ENT.MaxUseDistance		= 60
ENT.CanLookArround		= true
ENT.CanUseShield		= false
ENT.CustomRecoil		= true
ENT.Recoil				= 700000
ENT.Seatable			= true
ENT.ATReloadSound		= "small"
ENT.UseSingAnim			= true

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ent:GetAngles()+Angle(0,90,0))
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetSkin(math.random(0,1))
	return ent
end

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_kwk" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			seat = ent:GetDTEntity(2)
			if ent:ShooterStillValid() and IsValid(seat) then
				local a = ent:GetAngles()
				local ang = Angle(-a.r,a.y+90,a.p)
				if seat:GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*-26 + ent:GetRight()*-40 + ent:GetUp()*10
					view.angles = ang
					view.fov = fov
					view.drawviewer = true

					return view
				else
					local view = {}
					view.origin = pos
					view.angles = ang
					view.fov = fov
					view.drawviewer = false

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_kwk_view", CalcView)
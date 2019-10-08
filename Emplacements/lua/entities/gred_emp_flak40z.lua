AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]128mm Flakzwilling 40/2"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Flakzwilling 40/2"

ENT.MuzzleEffect		= "gred_arti_muzzle_blast_alt"
ENT.ShotInterval		= 2.25
ENT.AmmunitionTypes		= {
	{
		Caliber = 128,
		ShellType = "HE",
		MuzzleVelocity = 880,
		Mass = 26,
		TracerColor = "white",
	},
	{
		Caliber = 128,
		ShellType = "AP",
		MuzzleVelocity = 880,
		Mass = 26,
		TracerColor = "white",
	},
	{
		Caliber = 128,
		ShellType = "Smoke",
		MuzzleVelocity = 880,
		Mass = 26,
		TracerColor = "white",
	},
}

ENT.PitchRate			= 10
ENT.YawRate				= 15
ENT.ShellLoadTime		= 0.3
ENT.AnimPlayTime		= 0.6
ENT.AnimPauseTime		= 0.3
ENT.TimeToEjectShell	= -0.8
ENT.ATReloadSound		= "big"
ENT.ShootAnim			= "shoot"
ENT.ShootSound			= "^gred_emp/common/88mm.wav"
ENT.MaxUseDistance		= 150

ENT.TurretPos			= Vector(0,-44,81)
ENT.YawPos				= Vector(0,0,0)

ENT.Sequential			= true
ENT.IsAAA				= true
ENT.HullModel			= "models/gredwitch/flak40z/flak40z_hull.mdl"
ENT.YawModel			= "models/gredwitch/flak40z/flak40z_yaw.mdl"
ENT.TurretModel			= "models/gredwitch/flak40z/flak40z_cannon.mdl"
ENT.EmplacementType     = "Cannon"
ENT.Spread				= 0.1
ENT.MaxRotation			= Angle(-20)
ENT.Seatable			= true
ENT.SightPos			= Vector(0,30,0)
ENT.AddShootAngle		= 0
ENT.ViewPos				= Vector(0,0,60)
ENT.MaxViewModes		= 1
ENT.Ammo				= 2
ENT.SightTexture		= "gredwitch/overlay_german_canonsight_01"
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent.Spawner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	ent:GetHull():SetBodygroup(1,math.random(0,1))
	local yaw = ent:GetYaw()
	yaw:SetBodygroup(1,math.random(0,3))
	yaw:SetBodygroup(2,math.random(0,1))
	yaw:SetBodygroup(3,math.random(0,1))
	yaw:SetBodygroup(4,math.random(0,1))
	return ent
end

function ENT:CustomShootAnim(m)
	if m == 1 then
		self:ResetSequence("shoot_l")
	else
		self:ResetSequence("shoot_r")
	end
end

function ENT:OnInit()
	timer.Simple(0.1,function() if GetConVar("gred_sv_manual_reload"):GetInt() == 1 then self:SetAmmo(1) end end)
end

function ENT:PlayAnim()
	if self:GetIsReloading() then print("NOT ANIMPLAYING") return end
	self.sounds.reload_finish:Stop()
	self.sounds.reload_start:Stop()
	self.sounds.reload_shell:Stop()
	
	local manualReload = GetConVar("gred_sv_manual_reload"):GetInt() == 1
	self:SetIsReloading(false)
	local muzzle = self:GetCurrentMuzzle()-1
	self.sounds.reload_start:Play()
	if not manualReload then self:SetAmmo(self.Ammo) end
	timer.Simple(self.AnimPlayTime,function()
		if !IsValid(self) then return end
		if muzzle == 1 then
			self:ResetSequence("reload_l")
		else
			self:ResetSequence("reload_r")
		end
		self:SetCycle(.1)
		self:SetPlaybackRate(0)
		self:SetIsReloading(true)
		
		if not manualReload then
			timer.Simple(self.ShellLoadTime or self.AnimRestartTime/2,function()
				if !IsValid(self) then return end
				self.sounds.reload_shell:Play()
				timer.Simple(1,function() 
					if !IsValid(self) then return end
					self.sounds.reload_finish:Play()
					self:SetPlaybackRate(1) 
					timer.Simple(SoundDuration("gred_emp/common/reload"..self.ATReloadSound.."_2.wav"),function()
						if !IsValid(self) then return end
						self:SetIsReloading(false)
					end)
				end)
			end)
		end
	end)
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	seat = self:GetSeat()
	local seatValid = IsValid(seat)
	if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end 
	angles = ply:EyeAngles()
	if self:GetViewMode() == 1 then
		local view = {}
		local ang = self:GetAngles()
		angles.p = -ang.r - 1
		angles.y = ang.y + 90
		angles.r = -ang.p
		
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 20
		view.drawviewer = true

		return view
	else
		if seatValid then
			local view = {}
			view.origin = seat:LocalToWorld(self.ViewPos)
			view.angles = angles
			view.fov = fov
			view.drawviewer = false
	 
			return view
		end
	end
end

function ENT:HUDPaint(ply,viewmode)
	if viewmode == 1 then
		local ScrW,ScrH = ScrW(),ScrH()
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(surface.GetTextureID(self.SightTexture))
		surface.DrawTexturedRect(0,-(ScrW-ScrH)*0.5,ScrW,ScrW)
		return ScrW,ScrH
	end
end
AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]81mm Granatfwerfer 34"
ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "Granatfwerfer 34"

ENT.MuzzleEffect		= "muzzleflash_mg42_3p"
ENT.ShotInterval		= 2.4
ENT.Spread				= 400

ENT.ShootSound			= "gred_emp/common/mortar_fire.wav"

ENT.MaxRotation			= Angle(35,45)
ENT.HullModel			= "models/gredwitch/granatwerfer/granatwerfer_base.mdl"
ENT.TurretModel			= "models/gredwitch/granatwerfer/granatwerfer_tube.mdl"
ENT.DefaultPitch		= 50
ENT.EmplacementType     = "Mortar"
ENT.Ammo				= -1

ENT.AmmunitionTypes		= {
						{"HE","gb_shell_81mm"},
						{"Smoke","gb_shell_81mm"}
}

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:SetSkin(math.random(0,2))
	ent:Spawn()
	ent:Activate()
	return ent
end

----------------- LOL EVERYTHING DOWN THERE IS FOR THE GMODSTORE LOLOLOLOLOL

ENT.DelayToNetwork = 0
local bigNum = 99999999999

function ENT:OnTick(ct,ply,botmode)
	if self.FireMissions then
		self.MaxViewModes = table.Count(self.FireMissions)
	end
end

function ENT:OnThinkCL(ct,ply)
	if self.CustomEyeTrace and IsValid(ply) and (ply:KeyDown(IN_ATTACK) or not self.FirstNetwork) and self.DelayToNetwork < ct then
		net.Start("gred_net_sendeyetrace")
			net.WriteEntity(self)
			-- net.WriteString(util.Compress(util.TableToJSON(self.CustomEyeTrace)))
			net.WriteString(util.TableToJSON(self.CustomEyeTrace))
		net.SendToServer()
		self.FirstNetwork = true
		self.DelayToNetwork = ct + 0.1
	end
	if self.FireMissions then
		self.MaxViewModes = table.Count(self.FireMissions)
	end
end

function ENT:HUDPaint(ply)
	if self:GetShooter() != ply then return end
	local viewmode = self:GetViewMode()
	if viewmode != 0 and (self.FireMissions and self.FireMissions[viewmode]) then
		LANGUAGE = GetConVar("gred_cl_lang"):GetString() or "en"
		if not LANGUAGE then return end
		local tab = self.FireMissions[viewmode]
		surface.SetFont("GFont_arti")
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(ScrW()*0.01,ScrH()*0.01)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_missionid..tab[3])
		surface.SetTextPos(ScrW()*0.01,ScrH()*0.07)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_caller..tab[1]:GetName())
		surface.SetTextPos(ScrW()*0.01,ScrH()*0.14)
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementBinoculars.emplacement_timeleft..math.Round((tab[4] + 60) - CurTime()).."s")
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then self.CustomEyeTrace = nil return end
	local viewmode = self:GetViewMode()
	if viewmode != 0 and (self.FireMissions and self.FireMissions[viewmode]) then
		local tab = self.FireMissions[viewmode]
		local tr = util.QuickTrace(tab[2],tab[2] + Vector(0,0,500))
		local view = {}
		view.origin = tab[2] + Vector(0,0,2000)
		angles.p = math.Clamp(angles.p,40,90)
		view.angles = angles
		local ang = Angle(-angles.p,angles.y+180,angles.r)
		ang:Normalize()
		self.CustomEyeTrace = util.QuickTrace(view.origin,view.origin + ang:Forward()*-bigNum)
		view.drawviewer = true

		return view
	else
		self.CustomEyeTrace = nil
	end
end
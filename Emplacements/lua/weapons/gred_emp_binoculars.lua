AddCSLuaFile()

SWEP.Base 						= "weapon_base"

SWEP.Spawnable					= true
SWEP.AdminSpawnable				= true

SWEP.Category					= "Gredwitch's SWEPs"
SWEP.Author						= "Gredwitch"
SWEP.Contact					= ""
SWEP.Purpose					= ""
SWEP.Instructions				= "Mark targets with the fire button."
SWEP.PrintName					= "Emplacement Binoculars"


SWEP.WorldModel					= "models/weapons/gredwitch/w_binoculars.mdl"
SWEP.ViewModel 					= "models/weapons/gredwitch/v_binoculars.mdl"

SWEP.Primary					= {
								Ammo 		= "None",
								ClipSize 	= -1,
								DefaultClip = -1,
								Automatic 	= false,
								
								---------------------
								
								NextShot	= 0,
								FireRate	= 0.3
}
SWEP.Secondary					= SWEP.Primary
SWEP.NextReload					= 0
SWEP.DrawAmmo					= false

SWEP.Zoom						= {}
SWEP.Zoom["FOV"]				= 60
SWEP.Zoom["Val"]				= 0

SWEP.FireMissionID				= 0
SWEP.UseHands					= true
SWEP.PairedEmplacements			= {}

-- Micro optimizations
local pairs						= pairs
local IsValid					= IsValid
local CLIENT					= CLIENT
local SERVER					= SERVER
local LANGUAGE

function SWEP:SetupDataTables()
	-- self:NetworkVar("Bool",0,"IsZooming")
	
	-- self:SetIsZooming(false)
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	
	return true
end

function SWEP:Initialize()
	self:SetHoldType("camera")
	
	if CLIENT then
		timer.Simple(0,function()
			if !IsValid(self) then return end
			if self.Owner != LocalPlayer() then return end
			
			LANGUAGE = self.Owner:GetInfo("gred_cl_lang") or "en"
		end)
	end
end

function SWEP:Holster(wep)
	return true
end

function SWEP:OnRemove()
end

function SWEP:DrawHUD()
	surface.SetDrawColor(0,0,0,self.Zoom.Val*255)
	surface.SetTexture(surface.GetTextureID("gredwitch/overlay_binoculars"))
	local X = ScrW()
	local Y = ScrH()
	surface.DrawTexturedRect(0,-(X-Y)/2,X,X)
end

function SWEP:CalcViewModelView(ViewModel,OldEyePos)
	if self.Zoom.Val > 0.8 then
		return Vector(0,0,0)
	else
		return OldEyePos - Vector(0,0,1.3)
	end
end

function SWEP:Think()
	local keydown = self.Owner:KeyDown(IN_ATTACK2)
	self.Zoom.Val = math.Clamp(self.Zoom.Val + (keydown and 0.1 or -0.1),0,1)
	
	if keydown and not self.IsZooming then
		self.IsZooming = true
		self.IsUnZooming = false
		self.Weapon:SendWeaponAnim(ACT_VM_DEPLOY)
	elseif !keydown and not self.IsUnZooming and self.IsZooming then
		self.IsZooming = false
		self.IsUnZooming = true
		self.Weapon:SendWeaponAnim(ACT_VM_UNDEPLOY)
	end
end

function SWEP:CalcView(ply,pos,ang,fov)
	fov = fov - (self.Zoom.Val*self.Zoom.FOV)
	return pos,ang,fov
end

function SWEP:AdjustMouseSensitivity()
	return self.Owner:KeyDown(IN_ATTACK2) and 0.1 or 1
end


function SWEP:CanPrimaryAttack(ct)
	return self.Primary.NextShot <= ct
end

function SWEP:PrimaryAttack()
	if SERVER then
		local ct = CurTime()
		
		if not self:CanPrimaryAttack(ct) then return end
		self.Primary.NextShot = ct + self.Primary.FireRate
		
		local eyetrace = self.Owner:GetEyeTrace()
		LANGUAGE = LANGUAGE or (self.Owner:GetInfo("gred_cl_lang") or "en")
		if self.Owner:KeyDown(IN_RELOAD) then
			local ent = self:GetEmplacement(eyetrace.Entity)
			if !IsValid(ent) then return end
			
			self:PairEmplacement(ent)
		else
			self:MarkTarget(eyetrace,ct)
		end
	end
end


function SWEP:CanSecondaryAttack(ct)
	return self.Secondary.NextShot <= ct
end

function SWEP:SecondaryAttack()
	local ct = CurTime()
	
	if not self:CanSecondaryAttack(ct) then return end
	self.Secondary.NextShot = ct + self.Secondary.FireRate
	
end


function SWEP:CanReload(ct)
	return self.NextReload <= ct
end

function SWEP:Reload()
	local ct = CurTime()
	
	if not self:CanReload(ct) then return end
	self.NextReload = ct + 0.3

end


function SWEP:GetEmplacement(ent)
	return ent.GredEMPBaseENT and ((ent.GredEMPBaseENT.IsHowitzer or ent.GredEMPBaseENT.EmplacementType == "Mortar" or (ent.GredEMPBaseENT.EmplacementType == "Cannon" and gred.CVars.gred_sv_enable_cannon_artillery:GetBool())) and ent.GredEMPBaseENT or nil) or ((ent.IsHowitzer or ent.EmplacementType == "Mortar" or (ent.EmplacementType == "Cannon" and gred.CVars.gred_sv_enable_cannon_artillery:GetBool())) and ent or nil)
end

function SWEP:PairEmplacement(ent)
	if table.HasValue(self.PairedEmplacements,ent) then
		self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementBinoculars.info_emplacement_unpaired..string.gsub(ent.PrintName,"%[EMP]",""))
		if not ent.Unpair then
			ent.Unpair = function(self,swep)
				table.RemoveByValue(self.PairedWeapons,swep)
			end
		end
		table.RemoveByValue(self.PairedEmplacements,ent)
		ent:Unpair(self)
	else
		self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementBinoculars.info_emplacement_paired..string.gsub(ent.PrintName,"%[EMP]",""))
		if not ent.Pair then
			ent.Pair = function(self,swep)
				self.PairedWeapons = {}
				table.insert(self.PairedWeapons,swep)
			end
		end
		
		table.insert(self.PairedEmplacements,ent)
		ent:Pair(self)
	end
end

local sky = Vector(0,0,999999999999999999)

function SWEP:MarkTarget(trace,ct)
	local tr = util.QuickTrace(trace.HitPos,trace.HitPos + sky,trace.Entity)
	
	if tr.HitSky or !tr.Hit and util.IsInWorld(trace.HitPos) then
		if table.Count(self.PairedEmplacements) <= 0 then
			self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementBinoculars.info_nopairedemplacements)
		else
			gred.EmplacementBinoculars.FireMissionID = gred.EmplacementBinoculars.FireMissionID + 1
			self.FireMissionID = gred.EmplacementBinoculars.FireMissionID
			self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementBinoculars.info_firemission.."#"..self.FireMissionID)
			for k,v in pairs(self.PairedEmplacements) do
				if !IsValid(v) then
					self.PairedEmplacements[k] = nil
				else
					v.FireMissions = v.FireMissions or {}
					table.insert(v.FireMissions,{self.Owner,trace.HitPos,self.FireMissionID,ct})
					local id = #v.FireMissions
					
					net.Start("gred_net_emp_firemission")
						net.WriteEntity(v)
						net.WriteInt(id,14)
						net.WriteTable(v.FireMissions[id])
					net.Broadcast()
					
					timer.Simple(gred.CVars.gred_sv_emplacement_artillery_time:GetFloat(),function()
						if IsValid(v) then
							v.FireMissions[id] = nil
						end
					end)
				end
			end
		end
	else
		self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementBinoculars.info_invalidpos)
	end
end
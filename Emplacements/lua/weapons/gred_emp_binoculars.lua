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
local COLOR_WHITE_HOVERED 		= Color(200,200,200,150)
local COLOR_WHITE		 		= color_white
local COLOR_BLACK 				= color_black
local posX = {
	0.29,
	0.5,
	0.71,
	0.71,
	0.71,
	0.5,
	0.29,
	0.29,
}
local posY = {
	0.29,
	0.29,
	0.29,
	0.5,
	0.71,
	0.71,
	0.71,
	0.5,
}
local LANGUAGE

if CLIENT then
	gred.Lang = gred.Lang or {}
	gred.Lang.fr = gred.Lang.fr or {}
	gred.Lang.en = gred.Lang.en or {}
	gred.Lang.fr.EmplacementTool = {
		["control_init_base"] = "[Recharger] + [Intéragir] pour alterner entre les modes.",
		["control_mode_construct"] = "Clique droit pour faire apparaître le menu, clique droit + [Utiliser] pour supprimer la selection, clique gauche pour spawn l'emplacement, recharger pour changer l'angle de l'emplacement.",
		["info_emplacement_motion_1"] = "L'emplacement '",
		["info_emplacement_motion_2"] = "' a été ",
		["info_emplacement_freeze"] = "freeze",
		["info_emplacement_unfreeze"] = "unfreeze",
		["control_mode_edit"] = "Clique droit pour ouvrir le menu d'édition en visant un emplacement.",
		["info_emplacement_destroyed_1"] = "L'emplacement '",
		["info_emplacement_destroyed_2"] = "' a été détruit!",
		["hud_curmode"] = "Mode:",
		["hud_constructmode"] = "Construction",
		["hud_editmode"] = "Edition",
		["menu_copy_to_clipboard"] = "Copier vers le presse-papier",
		["cant_edit_emplacement"] = "Vous ne pouvez pas modifier cet emplacement!",
		["info_singleplayer"] = "ATTENTION! Ce SWEP ne fonctionne pas en mode solo! Pour l'utiliser, démarrez une partie en mode local ou Peer To Peer (comme ça: https://i.imgur.com/X3bCUcj.png).",
		["menu_emplacement_selection"] = "Sélection de l'emplacement",
		["menu_edit"] = "Menu d'édition",
		["menu_move"] = "Déplacer",
		["menu_destroy"] = "Détruire",
		["menu_properties"] = "Propriétés",
	}
	gred.Lang.fr.EmplacementBinoculars = {
		["control_init_base"] = "Appuyez sur RECHARGER + CLIQUE GAUCHE sur un emplacement pour le synchroniser.\nAppuyez sur CLIQUE GAUCHE pour lancer une demande d'artillerie.\nDemandez à quelqu'un d'aller dans l'emplacement que vous avez synchronisé et d'appuyez sur SUIT ZOOM jusqu'à ce qu'il voie votre demande d'artillerie.",
		["info_emplacement_paired"] = "Vous avez synchronisé l'emplacement ",
		["info_emplacement_unpaired"] = "Vous avez dé-synchronisé l'emplacement ",
		["info_firemission"] = "Fire mission ID: ",
		["info_invalidpos"] = "Coordonées invalides! Rien ne doit obstruer la cible!",
		["emplacement_missionid"] = "DEMANDE N°: #",
		["emplacement_caller"] = "SOUS L'ORDRE DE: ",
		["emplacement_timeleft"] = "TEMPS RESTANT: ",
		["info_nopairedemplacements"] = "Aucun emplacement synchronisé!",
		["emplacement_requesttype"] = "TYPE DE FRAPPE: ",
		["emplacement_requesttype_8"] = "fumée",
		["emplacement_requesttype_2"] = "explosive",
		["emplacement_requesttype_4"] = "phosphore blanc",
		["emp_player_requested"] = " a demandé une frappe de type ",
		
	}
	gred.Lang.en.EmplacementTool = {
		["control_init_base"] = "[Reload] + [Use] to toggle modes.",
		["control_mode_construct"] = "Right click to show the menu, right click + [Use] to remove the selection, left click to spawn the emplacement and reload to change the emplacement's angle.",
		["info_emplacement_motion_1"] = "The emplacement '",
		["info_emplacement_motion_2"] = "' has been ",
		["info_emplacement_freeze"] = "frozen",
		["info_emplacement_unfreeze"] = "unfrozen",
		["control_mode_edit"] = "Right click to open the edit menu while aiming at an emplacement.",
		["info_emplacement_destroyed_1"] = "The emplacement '",
		["info_emplacement_destroyed_2"] = "' has been destroyed!",
		["hud_curmode"] = "Current mode:",
		["hud_constructmode"] = "Construct mode",
		["hud_editmode"] = "Edit mode",
		["menu_copy_to_clipboard"] = "Copy to clipboard",
		["cant_edit_emplacement"] = "You cannot edit this emplacement!",
		["info_singleplayer"] = "WARNING! This SWEP doesn't work in single player mode! If you want to use it, you must start a local game or a Peer To Peer game (like this : https://i.imgur.com/X3bCUcj.png).",
		["menu_emplacement_selection"] = "Emplacement selection",
		["menu_edit"] = "Edit menu",
		["menu_move"] = "Move",
		["menu_destroy"] = "Destroy",
		["menu_properties"] = "Properties",
	}
	gred.Lang.en.EmplacementBinoculars = {
		["control_init_base"] = "Press RELOAD + LEFT CLICK on an emplacement to pair it.\nPress LEFT CLICK to request a fire mission.\nAsk someone to get in the emplacement(s) you have paired and to press the SUIT ZOOM key until he has your fire mission on his screen.",
		["info_emplacement_paired"] = "You have paired ",
		["info_emplacement_unpaired"] = "You have unpaired ",
		["info_firemission"] = "Fire mission ID: ",
		["info_invalidpos"] = "Invalid coordinates! Make sure nothing is obstructing your target!",
		["emplacement_missionid"] = "FIRE MISSION ID: #",
		["emplacement_caller"] = "CALLER: ",
		["emplacement_timeleft"] = "TIME LEFT: ",
		["info_nopairedemplacements"] = "No paired emplacements!",
		["emplacement_requesttype"] = "STRIKE TYPE: ",
		["emplacement_requesttype_8"] = "smoke strike",
		["emplacement_requesttype_2"] = "HE strike",
		["emplacement_requesttype_4"] = "WP strike",
		["emp_player_requested"] = " requested a ",
	}

	net.Receive("gred_net_binoculars_menu",function()
		local self = net.ReadEntity()
		if !IsValid(self) then return end
		self:CreateMenu()
	end)
else
	util.AddNetworkString("gred_net_binoculars_menu")
	util.AddNetworkString("gred_net_emp_striketype")
	
	net.Receive("gred_net_emp_striketype",function()
		local self = net.ReadEntity()
		local int = net.ReadInt(5)
		if !IsValid(self) then return end
		
		self:MarkTarget(int)
	end)
end

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
		self:InitChoices()
		
		timer.Simple(0,function()
			if !IsValid(self) then return end
			if self.Owner != LocalPlayer() then return end
			
			LANGUAGE = gred.CVars["gred_cl_lang"]:GetString() or "en"
			self.Owner:ChatPrint(gred.Lang[LANGUAGE].EmplacementBinoculars.control_init_base) 
		end)
	end
end

function SWEP:InitChoices()
	self.Choices = {
		{
			name = "",
			Decor = true
		},
		{
			name = "Request high explosive artillery",
			-- Decor = true
		},
		{
			name = "",
			Decor = true
		},
		{
			name = "Request white phosphorus artillery",
			-- Decor = true
		},
		{
			name = "",
			Decor = true
		},
		{
			name = "",
			Decor = true
		},
		{
			name = "",
			Decor = true
		},
		{
			name = "Request smoke artillery",
			-- Decor = true
		},
	}
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
			net.Start("gred_net_binoculars_menu")
				net.WriteEntity(self)
			net.Send(self.Owner)
			self.PlyTrace = eyetrace
			-- self:MarkTarget(eyetrace,ct)
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


function SWEP:CreateMenu()
	if IsValid(self.Menu) then self.Menu:Close() end
	local X = ScrW()*0.45
	local Y = ScrH()*0.75
	local DFrame = vgui.Create("DFrame")
	DFrame:SetSize(X,Y)
	DFrame:Center()
	DFrame:MakePopup()
	DFrame:SetAlpha(0)
	DFrame:AlphaTo(255,0.3)
	DFrame:ShowCloseButton(false)
	DFrame:SetTitle("")
	DFrame.Close = function(DFrame)
		if DFrame.IsClosing then return end
		DFrame.IsClosing = true
		DFrame:AlphaTo(0,0.1,0,function(tab,DFrame)
			DFrame:Remove()
		end)
	end
	DFrame.Paint = function(DFrame,x,y)
		surface.SetDrawColor(COLOR_BLACK)
		surface.DrawRect(0,Y*0.391,x,y*0.01)
		surface.DrawRect(0,Y*0.6,x,y*0.01)
		surface.DrawRect(x*0.391,0,x*0.01,y)
		surface.DrawRect(x*0.6,0,x*0.01,y)
		
		surface.SetDrawColor(COLOR_WHITE)
		surface.DrawRect(0,Y*0.393,x,y*0.006)
		surface.DrawRect(0,Y*0.603,x,y*0.006)
		surface.DrawRect(x*0.393,0,x*0.006,y)
		surface.DrawRect(x*0.602,0,x*0.006,y)
	end
	self.Menu = DFrame
	
	local DButton = vgui.Create("DButton",DFrame)
	local X_m,Y_m = X*posX[2],Y*posY[2]
	local x,y = X*0.2,Y*0.2
	DButton:SetPos(X_m-x*0.5,Y_m-y*0.5)
	DButton:SetSize(x,y)
	-- local X_m,Y_m = X*0.5,Y*0.5
	-- local x,y = X*0.2,Y*0.2
	-- DButton:SetPos(X_m-x*0.5,Y_m-y*0.5)
	-- DButton:SetSize(x,y)
	DButton:SetText("Close")
	DButton:SetTextColor(COLOR_BLACK)
	DButton.Paint = function(DButton,x,y)
		if DButton:IsHovered() then
			surface.SetDrawColor(COLOR_WHITE_HOVERED)
			surface.DrawRect(0,0,x,y)
		end
	end
	DButton.DoClick = function(DButton)
		DFrame:Close()
	end
	
	local buttons = {}
	local function AddButtons(tab,DFrame,X,Y,X_m,Y_m,x,y,INDEX)
		for k,v in pairs(tab) do
			local DButton = vgui.Create("DButton",DFrame)
			if k == 2 then
				X_m,Y_m = X*0.5,Y*0.5
				x,y = X*0.2,Y*0.2
			else
				X_m,Y_m = X*posX[k],Y*posY[k]
				x,y = X*0.2,Y*0.2
			end
			DButton:SetPos(X_m-x*0.5,Y_m-y*0.5)
			DButton:SetSize(x,y)
			DButton:SetText(v.name)
			DButton:SetTextColor(COLOR_BLACK)
			DButton:SetAlpha(0)
			DButton:AlphaTo(255,0.2)
			DButton:SetToolTip(v.name)
			DButton.Paint = function(DButton,x,y)
				if DButton:IsHovered() then
					surface.SetDrawColor(COLOR_WHITE_HOVERED)
					surface.DrawRect(0,0,x,y)
				end
			end
			if v.choices or v.less then
				DButton.DoClick = function(DButton)
					for _,b in pairs(buttons) do
						if IsValid(b) then 
							b:AlphaTo(0,0.2,0,function()
								b:Remove()
							end)
						end
					end
					buttons = {}
					if v.less then
						table.remove(INDEX,#INDEX)
						table.remove(INDEX,#INDEX)
						tab = self.Choices
						for k,v in pairs(INDEX) do
							tab = tab[v]
						end
						AddButtons(tab,DFrame,X,Y,X_m,Y_m,x,y,INDEX)
					else
						table.insert(INDEX,k)
						table.insert(INDEX,"choices")
						AddButtons(v.choices,DFrame,X,Y,X_m,Y_m,x,y,INDEX)
					end
				end
			else
				DButton.DoClick = function(DButton)
					if !v.Decor then
						DFrame:Close()
						table.insert(INDEX,k)
						net.Start("gred_net_emp_striketype")
							net.WriteEntity(self)
							net.WriteInt(k,5)
						net.SendToServer()
					end
				end
			end
			buttons[k] = DButton
		end
	end
	AddButtons(self.Choices,DFrame,X,Y,X_m,Y_m,x,y,{})
end

function SWEP:MarkTarget(StrikeType)
	local FireMission = {
		self.Owner,
		self.PlyTrace.HitPos,
		self.FireMissionID,
		CurTime(),
		StrikeType
	}
	local tr = util.QuickTrace(self.PlyTrace.HitPos,self.PlyTrace.HitPos + sky,self.PlyTrace.Entity)
	
	if tr.HitSky or !tr.Hit and util.IsInWorld(self.PlyTrace.HitPos) then
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
					table.insert(v.FireMissions,FireMission)
					local id = #v.FireMissions
					-- v.MaxViewModes = table.Count(v.FireMissions) + v.OldMaxViewModes
					
					net.Start("gred_net_emp_firemission")
						net.WriteEntity(v)
						net.WriteInt(id,14)
						net.WriteTable(v.FireMissions[id])
					net.Broadcast()
					
					v:EmitSound("buttons/blip1.wav")
					if !IsValid(v:GetShooter()) then
						timer.Create("gred_timer_firemission_bip_"..id,1,3,function()
							if IsValid(v) then
								v:EmitSound("buttons/blip1.wav")
							else
								timer.Remove("gred_timer_firemission_bip_"..id)
							end
						end)
					end
					
					timer.Simple(gred.CVars.gred_sv_emplacement_artillery_time:GetFloat(),function()
						if IsValid(v) then
							v.FireMissions[id] = nil
							-- v.MaxViewModes = table.Count(v.FireMissions) + v.OldMaxViewModes
						end
					end)
				end
			end
		end
	else
		self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementBinoculars.info_invalidpos)
	end
end

-- THIS ENTIRE ADDON NEEDS TO BE REWORKED, LOOKIN AT IT NOW THIS CODE IS PURE SHIT

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
local CreateConVar = CreateConVar


gred = gred or {}
gred.CVars = gred.CVars or {}
gred.CVars["gred_sv_carriage_collision"] 			= CreateConVar("gred_sv_carriage_collision"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_remove_time"] 			= CreateConVar("gred_sv_shell_remove_time"			,  "10" , GRED_SVAR)
gred.CVars["gred_sv_limitedammo"] 					= CreateConVar("gred_sv_limitedammo"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_cantakemgbase"] 				= CreateConVar("gred_sv_cantakemgbase"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_enable_seats"] 					= CreateConVar("gred_sv_enable_seats"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_enable_explosions"] 			= CreateConVar("gred_sv_enable_explosions"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_manual_reload"] 				= CreateConVar("gred_sv_manual_reload"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_manual_reload_mgs"] 			= CreateConVar("gred_sv_manual_reload_mgs"			,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_shell_arrival_time"] 			= CreateConVar("gred_sv_shell_arrival_time"			,  "3"  , GRED_SVAR)
gred.CVars["gred_sv_canusemultipleemplacements"] 	= CreateConVar("gred_sv_canusemultipleemplacements"	,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_enable_recoil"] 				= CreateConVar("gred_sv_enable_recoil"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_progressiveturn"] 				= CreateConVar("gred_sv_progressiveturn"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_progressiveturn_mg"] 			= CreateConVar("gred_sv_progressiveturn_mg"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_progressiveturn_cannon"] 		= CreateConVar("gred_sv_progressiveturn_cannon"		,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_enable_cannon_artillery"] 		= CreateConVar("gred_sv_enable_cannon_artillery"	,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_emplacement_artillery_time"]	= CreateConVar("gred_sv_emplacement_artillery_time"	, "60"  , GRED_SVAR)
gred.CVars["gred_sv_firemissiontype"]				= CreateConVar("gred_sv_firemissiontype"			,  "0"  , GRED_SVAR)


gred.EmplacementBinoculars = gred.EmplacementBinoculars or {}
gred.EmplacementBinoculars.FireMissionID = gred.EmplacementBinoculars.FireMissionID or 124



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
	["emplacement_requesttype"] = "TYPE DE FRAPPE DEMANDEE: ",
	["emplacement_requesttype_1"] = "fumée",
	["emplacement_requesttype_2"] = "explosive",
	["emplacement_requesttype_3"] = "phosphore blanc",
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
	["emplacement_requesttype"] = "REQUESTED STRIKE TYPE: ",
	["emplacement_requesttype_8"] = "smoke strike",
	["emplacement_requesttype_2"] = "HE strike",
	["emplacement_requesttype_4"] = "WP strike",
	["emp_player_requested"] = " requested a ",
}


local tableinsert = table.insert
gred.AddonList = gred.AddonList or {}
tableinsert(gred.AddonList,1391460275) -- Emplacements
tableinsert(gred.AddonList,1131455085) -- Base addon


if SERVER then
	util.AddNetworkString("gred_net_emp_reloadsounds")
	util.AddNetworkString("gred_net_emp_viewmode")
	util.AddNetworkString("gred_net_emp_onshoot")
	util.AddNetworkString("gred_net_emp_firemission")
	util.AddNetworkString("gred_net_sendeyetrace")
	util.AddNetworkString("gred_net_removeeyetrace")
	
	util.AddNetworkString("gred_net_mortar_cantshoot_00")
	util.AddNetworkString("gred_net_mortar_cantshoot_01")
	util.AddNetworkString("gred_net_mortar_cantshoot_02")

	
	net.Receive("gred_net_sendeyetrace",function()
		local self = net.ReadEntity()
		local vec = net.ReadVector()
		if !IsValid(self) then return end
		
		self.CustomEyeTrace = true
		self.CustomEyeTraceHitPos = vec
	end)
	
	net.Receive("gred_net_removeeyetrace",function()
		local self = net.ReadEntity()
		if !IsValid(self) then return end
		
		self.CustomEyeTrace = nil
		self.CustomEyeTraceHitPos = nil
	end)
	
	net.Receive("gred_net_emp_viewmode",function(len,ply)
		local self = ply.Gred_Emp_Ent
		local int = net.ReadUInt(7)
		
		if !IsValid(self) then return end
		
		local oldint = self:GetViewMode()
		self:SetViewMode(int)
		
		if int > self.OldMaxViewModes and gred.CVars.gred_sv_firemissiontype:GetInt() == 0 then
			ply:SetEyeAngles(Angle(90))
		elseif oldint > self.OldMaxViewModes and int == 0 then
			ply:SetEyeAngles(self:GetAngles())
		end
	end)
	

else
	
	local CreateClientConVar = CreateClientConVar
	gred.CVars.gred_cl_shelleject = CreateClientConVar("gred_cl_shelleject","1", true,false)
	gred.CVars.gred_cl_emp_mouse_sensitivity = CreateClientConVar("gred_cl_emp_mouse_sensitivity","0.6", true,false)
	gred.CVars.gred_cl_emp_mouse_invert_x = CreateClientConVar("gred_cl_emp_mouse_invert_x","0", true,false)
	gred.CVars.gred_cl_emp_mouse_invert_y = CreateClientConVar("gred_cl_emp_mouse_invert_y","0", true,false)
	gred.CVars.gred_cl_lang = CreateConVar("gred_cl_lang",system.GetCountry() == "FR" and "fr" or "en",FCVAR_USERINFO,"'fr' or 'en'")
	-- CreateClientConVar("gred_cl_emp_volume","1", true,false)
	
	
	surface.CreateFont( "GFont", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = (ScrW()/100 + ScrH()/100)*3,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
	} )
	
	surface.CreateFont( "GFont_arti", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = (ScrW()*0.01 + ScrH()*0.01)*1.5,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
	} )
	
	net.Receive("gred_net_emp_reloadsounds",function()
		net.ReadEntity().ShotInterval = net.ReadFloat()
	end)
	
	net.Receive("gred_net_emp_onshoot",function()
		local self = net.ReadEntity()
		if !IsValid(self) or !self.OnShoot then return end
		self:OnShoot()
	end)
	
	net.Receive("gred_net_emp_firemission",function()
		local ent = net.ReadEntity()
		
		local tab = {
			net.ReadEntity(),
		    net.ReadVector(),
		    net.ReadUInt(8),
		    net.ReadFloat(),
		    net.ReadUInt(2),
		}
		
		-- if !IsValid(ent) or !IsValid(tab[1]) then return end
		
		if !IsValid(ent) then return end
		
		-- local wep = tab[1]:GetWeapon("gred_emp_binoculars")
		
		-- if !IsValid(wep) then return end
		
		gred = gred or {}
		gred.EmplacementBinoculars = gred.EmplacementBinoculars or {}
		gred.EmplacementBinoculars.FireMissionID =  tab[3]
		
		ent.FireMissions = ent.FireMissions or {}
		local id = table.insert(ent.FireMissions,tab)
		ent.MaxViewModes = #ent.FireMissions + ent.OldMaxViewModes
		
		local shooter = ent:GetShooter()
		
		if LocalPlayer() == shooter then
			local LANGUAGE = gred.CVars.gred_cl_lang:GetString()
			LANGUAGE = gred.Lang[LANGUAGE] and LANGUAGE or "en"
			
			shooter:PrintMessage(HUD_PRINTCENTER,tab[1]:GetName()..gred.Lang[LANGUAGE].EmplacementBinoculars.emp_player_requested..gred.Lang[LANGUAGE].EmplacementBinoculars["emplacement_requesttype_"..tab[5]].."!")
		end
		
		timer.Simple(gred.CVars.gred_sv_emplacement_artillery_time:GetFloat(),function()
			if !IsValid(ent) then return end
			
			ent.FireMissions[id] = nil
			ent.MaxViewModes = #ent.FireMissions + ent.OldMaxViewModes
		end)
	end)
	
	net.Receive("gred_net_mortar_cantshoot_00",function()
		local ply = LocalPlayer()
		local self = ply.Gred_Emp_Ent
		
		if !IsValid(self) then return end
		
		ply:PrintMessage(HUD_PRINTCENTER,"Nothing must block the mortar's muzzle!")
	end)
	
	net.Receive("gred_net_mortar_cantshoot_01",function()
		local ply = LocalPlayer()
		local self = ply.Gred_Emp_Ent
		
		if !IsValid(self) then return end
		
		ply:PrintMessage(HUD_PRINTCENTER,"Maximum traverse reached!")
	end)
	
	net.Receive("gred_net_mortar_cantshoot_02",function()
		local ply = LocalPlayer()
		local self = ply.Gred_Emp_Ent
		
		if !IsValid(self) then return end
		
		ply:PrintMessage(HUD_PRINTCENTER,"There is a roof blocking the way!")
	end)
	
	

	local EmplacementMaterial = Material("gredwitch/emplacementicon.png")
	
	hook.Add("GredOptionsAddLateralMenuOption","AddEmplacement",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
		local CreateOptions				= gred.Menu.CreateOptions
		local CreateCheckBoxPanel   	= gred.Menu.CreateCheckBoxPanel
		local CreateSliderPanel     	= gred.Menu.CreateSliderPanel
		local DrawEmptyRect         	= gred.Menu.DrawEmptyRect
		local CreateBindPanel       	= gred.Menu.CreateBindPanel
		local COL_WHITE					= gred.Menu.COL_WHITE					
		local COL_GREY					= gred.Menu.COL_GREY					
		local COL_LIGHT_GREY			= gred.Menu.COL_LIGHT_GREY			
		local COL_LIGHT_GREY1			= gred.Menu.COL_LIGHT_GREY1			
		local COL_RED					= gred.Menu.COL_RED					
		local COL_GREEN					= gred.Menu.COL_GREEN					
		local COL_DARK_GREY 			= gred.Menu.COL_DARK_GREY 			
		local COL_DARK_GREY1 			= gred.Menu.COL_DARK_GREY1 			
		local COL_BLUE_HIGHLIGHT		= gred.Menu.COL_BLUE_HIGHLIGHT		
		local COL_DARK_BLUE_HIGHLIGHT	= gred.Menu.COL_DARK_BLUE_HIGHLIGHT
		local COL_TRANSPARENT_GREY 		= gred.Menu.COL_TRANSPARENT_GREY
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("")
		DButton:Dock(TOP)
		DButton:DockMargin(0,0,0,10)
		DButton:SetSize(X_DPanel,y_DPanel*0.15)
		DButton.Paint = function(DButton,w,h)
			local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			DrawEmptyRect(0,0,w,h,2,2,0)
			surface.SetMaterial(EmplacementMaterial)
			local H = h - 24
			surface.DrawTexturedRect((w - H)*0.5,0,H,H)
			
			draw.DrawText("EMPLACEMENT OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
		end
		DButton.DoClick = function()
			DFrame:SelectLateralMenuOption("EMPLACEMENT OPTIONS")
			DPanel.ToggleButton:DoClick(true)
		end
		
		DFrame.LateralOptionList["EMPLACEMENT OPTIONS"] = function(DFrame,DPanel,X,Y)
			CreateOptions(DFrame,DPanel,X,Y,{
				["CLIENT"] = {
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_shelleject","Shell ejection on machineguns","",false)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_emp_mouse_invert_x","Invert the X axis in sight mode","",false)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_emp_mouse_invert_y","Invert the Y axis in sight mode","",false)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_emp_mouse_sensitivity","Mouse sensitivity in sight mode","",0.01,1,2,false)
					end,
				},
				["SERVER"] = {
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_carriage_collision","Cannons' carriage collide with players","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_limitedammo","Infinite machinegun ammo","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_cantakemgbase","Allow players to take the MG's tripod","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_enable_seats","Enable seats","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_enable_explosions","Destructible emplacements","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_manual_reload","Manual reload wtih cannons","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_manual_reload_mgs","Manual reload wtih MGs","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_canusemultipleemplacements","Allow usage of several emplacements at a time","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_canusemultipleemplacements","Allow usage of several emplacements at a time","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_enable_recoil","Recoil with MGs","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_progressiveturn","Progressive turning (master)","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_firemissiontype","Alternative fire mission view","Disables the bird's eye view",true)
					end,
					
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_progressiveturn_cannon","Progressive turn rate with cannons","",0.1,10,1,true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_progressiveturn_mg","Progressive trun rate with MGs","",0.1,10,1,true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_arrival_time","Shell arrival time with mortars / in fire missions","",1,10,0,true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_emplacement_artillery_time","Fire mission duration","",30,600,0,true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_remove_time","Cannon shell casing removal time","",0,60,1,true)
					end,
				}
			})
		end
	end)
end
AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_nebel_reloadtime"				,  "10" , GRED_SVAR)
CreateConVar("gred_sv_nebel_range_divider"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_carriage_collision"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_mortar_shellspawnaltitude"	, "1000", GRED_SVAR)
CreateConVar("gred_sv_shell_remove_time"			,  "10" , GRED_SVAR)
CreateConVar("gred_sv_limitedammo"					,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_cantakemgbase"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_enable_seats"					,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_manual_reload"				,  "0"  , GRED_SVAR)
CreateConVar("gred_sv_manual_reload_mgs"			,  "0"  , GRED_SVAR)

CreateClientConVar("gred_cl_devemp_warnings","1", true,false)
CreateClientConVar("gred_cl_shelleject","1", true,false)
CreateClientConVar("gred_cl_emp_mouse_sensitivity","0.2", true,false)


-- Adding the spawnmenu options
local function gredEMPsettings(Panel)
	Panel:ClearControls()
	
	Created = true;
	
	Panel:AddControl( "CheckBox", { Label = "Should the howitzers' carriage collide?", Command = "gred_sv_carriage_collision" } );
	
	Panel:AddControl( "CheckBox", { Label = "Should the MGs have limited ammo?", Command = "gred_sv_limitedammo" } );
	
	Panel:AddControl( "CheckBox", { Label = "Should the players be able to take the MGs' pods?", Command = "gred_sv_cantakemgbase" } );
	
	Panel:AddControl( "CheckBox", { Label = "Enable seats?", Command = "gred_sv_enable_seats" } );
	
	Panel:AddControl( "CheckBox", { Label = "Enable development warnings?", Command = "gred_cl_devemp_warnings" } );
	
	Panel:AddControl( "CheckBox", { Label = "Should you be able to see the MGs' shells?", Command = "gred_cl_shelleject" } );
	
	Panel:AddControl( "CheckBox", { Label = "Use a manual shell reload system?", Command = "gred_sv_manual_reload_mgs" } );
	
	Panel:AddControl( "CheckBox", { Label = "Use a manual reload system for the MGs?", Command = "gred_sv_manual_reload_mgs" } );
	
	Panel:NumSlider( "Mortar shells spawn altitude", "gred_sv_mortar_shellspawnaltitude", 1, 1000, 0 );
	
	Panel:NumSlider( "Nebelwerfer reload time", "gred_sv_nebel_reloadtime", 0, 60, 0 );
	
	Panel:NumSlider( "Nebelwerfer range divider", "gred_sv_nebel_range_divider", 0, 10, 2 );
	
	Panel:NumSlider( "Shell remove time", "gred_sv_shell_remove_time", 0, 120, 0 );
	
	Panel:NumSlider( "Shell speed multiplier", "gred_sv_shellspeed_multiplier", 0, 4, 2 );
	
	Panel:NumSlider( "Mouse sensitivity on emplacements with seats", "gred_cl_emp_mouse_sensitivity", 0, 0.99, 2 );
	
end

hook.Add( "PopulateToolMenu", "gred_emp_menu", function()
	spawnmenu.AddToolMenuOption( "Options", "Gredwitch's EMP Pack", "GredwitchEMPSettings", "Settings", "", "", gredEMPsettings )
end );
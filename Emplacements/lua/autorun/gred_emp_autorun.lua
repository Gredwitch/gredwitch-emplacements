AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
local CreateConVar = CreateConVar

gred = gred or {}

CreateConVar("gred_sv_carriage_collision"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_shell_remove_time"			,  "10" , GRED_SVAR)
CreateConVar("gred_sv_limitedammo"					,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_cantakemgbase"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_enable_seats"					,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_enable_explosions"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_manual_reload"				,  "0"  , GRED_SVAR)
CreateConVar("gred_sv_manual_reload_mgs"			,  "0"  , GRED_SVAR)
CreateConVar("gred_sv_shell_arrival_time"			,  "3"  , GRED_SVAR)

if SERVER then
	util.AddNetworkString("gred_net_emp_reloadsounds")
end

local tableinsert = table.insert
gred.AddonList = gred.AddonList or {}
tableinsert(gred.AddonList,1554003672) -- Emplacements materials 2
tableinsert(gred.AddonList,1484100983) -- Emplacements materials
tableinsert(gred.AddonList,1391460275) -- Emplacements
tableinsert(gred.AddonList,1131455085) -- Base addon

if CLIENT then
	
	local CreateClientConVar = CreateClientConVar
	CreateClientConVar("gred_cl_shelleject","1", true,false)
	CreateClientConVar("gred_cl_emp_mouse_sensitivity","1", true,false)
	CreateClientConVar("gred_cl_emp_mouse_invert_x","0", true,false)
	CreateClientConVar("gred_cl_emp_mouse_invert_y","0", true,false)
	-- CreateClientConVar("gred_cl_emp_volume","1", true,false)
	
	
	net.Receive("gred_net_emp_reloadsounds",function()
		local self = net.ReadEntity()
		self.ShotInterval = net.ReadFloat()
	end)
	
	hook.Add("AdjustMouseSensitivity", "gred_emp_mouse", function(s)
		local ply = LocalPlayer()
		local ent = ply.Gred_Emp_Ent
		if not IsValid(ent) then ply.Gred_Emp_Ent = nil return end
		if string.StartWith(ent.ClassName,"gred_emp") then
			if IsValid(ent:GetSeat()) and ply == ent:GetShooter() then
				return GetConVar("gred_cl_emp_mouse_sensitivity"):GetFloat()
			end
		end
	end)

	hook.Add("InputMouseApply", "gred_emp_move",function(cmd,x,y,angle)
		local ply = LocalPlayer()
		local ent = ply.Gred_Emp_Ent
		if not IsValid(ent) then ply.Gred_Emp_Ent = nil return end
		if string.StartWith(ent.ClassName,"gred_emp") then
			if IsValid(ent:GetSeat()) or ent:GetViewMode() != 0 then
				if ply == ent:GetShooter() then
					local InvertX = GetConVar("gred_cl_emp_mouse_invert_x"):GetInt() == 1
					local InvertY = GetConVar("gred_cl_emp_mouse_invert_Y"):GetInt() == 1
					if InvertX then
						angle.yaw = angle.yaw + x / 50
					else
						angle.yaw = angle.yaw - x / 50
					end
					if InvertY then
						angle.pitch = math.Clamp( angle.pitch - y / 50, -89, 89 )
					else
						angle.pitch = math.Clamp( angle.pitch + y / 50, -89, 89 )
					end
					cmd:SetViewAngles( angle )
                   
					return true
				end
			end
		end
	end)
	
	local function gred_settings_emplacements(Panel)
		Panel:ClearControls()
		
		Created = true;
		local ded = game.IsDedicated()
		if !ded then
		
		Panel:AddControl( "CheckBox", { Label = "Should the cannons' carriage collide?", Command = "gred_sv_carriage_collision" } );
		
		Panel:AddControl( "CheckBox", { Label = "Should the MGs have limited ammo?", Command = "gred_sv_limitedammo" } );
		
		Panel:AddControl( "CheckBox", { Label = "Should the players be able to take the MGs' tripods?", Command = "gred_sv_cantakemgbase" } );
		
		Panel:AddControl( "CheckBox", { Label = "Enable seats?", Command = "gred_sv_enable_seats" } );
		
		-- Panel:AddControl( "CheckBox", { Label = "Reset the emplacement's angle after leaving it?", Command = "gred_sv_reset_angles" } );
		
		end
		
		Panel:AddControl( "CheckBox", { Label = "Should you be able to see the MGs' shells?", Command = "gred_cl_shelleject" } );
		
		if !ded then
		
		Panel:AddControl( "CheckBox", { Label = "Use a manual shell reload system?", Command = "gred_sv_manual_reload" } );
		
		Panel:AddControl( "CheckBox", { Label = "Use a manual reload system for the MGs?", Command = "gred_sv_manual_reload_mgs" } );
		
		Panel:AddControl( "CheckBox", { Label = "Should the emplacements explode?", Command = "gred_sv_enable_explosions" } );
		
		Panel:NumSlider( "Shell arrival time (for mortars)", "gred_sv_shell_arrival_time", 0, 10, 2 );
		
		Panel:NumSlider( "Shell casing remove time", "gred_sv_shell_remove_time", 0, 120, 0 );
		
		Panel:NumSlider( "Shell speed multiplier", "gred_sv_shellspeed_multiplier", 0, 4, 2 );
		
		end
		
		Panel:NumSlider( "Mouse sensitivity on emplacements with seats", "gred_cl_emp_mouse_sensitivity", 0, 0.99, 2 );
		
		-- Panel:NumSlider( "Shoot sound volume", "gred_cl_emp_volume", 0, 1, 2 );
		
		Panel:AddControl( "CheckBox", { Label = "Invert X axis in seats?", Command = "gred_cl_emp_mouse_invert_x" } );
		
		Panel:AddControl( "CheckBox", { Label = "Invert Y axis in seats?", Command = "gred_cl_emp_mouse_invert_y" } );
		
	end
	
	hook.Add( "PopulateToolMenu", "gred_menu_emplacements", function()
		spawnmenu.AddToolMenuOption("Options",						-- Tab
									"Gredwitch's Stuff",			-- Sub-tab
									"gred_settings_emplacements",	-- Identifier
									"Emplacement Pack",			-- Name of the sub-sub-tab
									"",								-- Command
									"",								-- Config (deprecated)
									gred_settings_emplacements		-- Function
		)
	end)
end
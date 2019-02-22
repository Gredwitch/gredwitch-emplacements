AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
local CreateConVar = CreateConVar

gred = gred or {}

CreateConVar("gred_sv_nebel_reloadtime"				,  "10" , GRED_SVAR)
CreateConVar("gred_sv_nebel_range_divider"			,  "1"  , GRED_SVAR)
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
	util.AddNetworkString("TurretBlockAttackToggle")
	util.AddNetworkString("gred_net_emp_getplayer")
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
	

	local shouldBlockAttack=false
	net.Receive("TurretBlockAttackToggle",function()
		local blockBit=net.ReadBit()
		if blockBit==1 then
			shouldBlockAttack=true
		elseif blockBit==0 then
			shouldBlockAttack=false
		end
	end)
	
	net.Receive("gred_net_emp_getplayer",function()
		local ply = net.ReadEntity()
		local self = net.ReadEntity()
		local class = self:GetClass()
		if class == "worldspawn" then
			ply.Gred_Emp_Ent = nil
			ply.Gred_Emp_Class = nil
		else
			ply.Gred_Emp_Ent = self
			ply.Gred_Emp_Class = class
		end
	end)
	
	hook.Add("CreateMove","gred_turretblock",function(cmd)
		local lp = LocalPlayer()
		if shouldBlockAttack and IsValid(lp) and bit.band(cmd:GetButtons(), IN_ATTACK) > 0 then
			cmd:SetButtons(bit.bor(cmd:GetButtons() - IN_ATTACK, IN_BULLRUSH))
		end
	end)
	
	hook.Add("AdjustMouseSensitivity", "gred_emp_mouse", function(s)
		local ply = LocalPlayer()
		if not ply.Gred_Emp_Class then return end
		if string.StartWith(ply.Gred_Emp_Class,"gred_emp") then
			local ent = ply.Gred_Emp_Ent
			if IsValid(ent) then
				if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) and ply == ent:GetShooter() then
					return GetConVar("gred_cl_emp_mouse_sensitivity"):GetFloat() -- 0.2
				end
			end
		end
	end)

	hook.Add("InputMouseApply", "gred_emp_move",function(cmd,x,y,angle)
		local ply = LocalPlayer()
		if not ply.Gred_Emp_Class then return end
		if string.StartWith(ply.Gred_Emp_Class,"gred_emp") then
			local ent = ply.Gred_Emp_Ent
			if IsValid(ent) then
				if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) and ply == ent:GetShooter() then
					local InvertX = GetConVar("gred_cl_emp_mouse_invert_x"):GetInt() == 1
					local InvertY = GetConVar("gred_cl_emp_mouse_invert_Y"):GetInt() == 1
					if InvertX then
						angle.yaw = angle.yaw - x / 5
					else
						angle.yaw = angle.yaw + x / 50
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
		
		Panel:AddControl( "CheckBox", { Label = "Should the howitzers' carriage collide?", Command = "gred_sv_carriage_collision" } );
		
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
		
		Panel:NumSlider( "Nebelwerfer reload time", "gred_sv_nebel_reloadtime", 0, 60, 0 );
		
		Panel:NumSlider( "Nebelwerfer range divider", "gred_sv_nebel_range_divider", 0, 10, 2 );
		
		Panel:NumSlider( "Shell arrival time (for mortars)", "gred_sv_shell_arrival_time", 0, 10, 2 );
		
		Panel:NumSlider( "Shell remove time", "gred_sv_shell_remove_time", 0, 120, 0 );
		
		Panel:NumSlider( "Shell speed multiplier", "gred_sv_shellspeed_multiplier", 0, 4, 2 );
		
		end
		
		Panel:NumSlider( "Mouse sensitivity on emplacements with seats", "gred_cl_emp_mouse_sensitivity", 0, 0.99, 2 );
		
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


hook.Add("SetupMove", "gred_emp_calcmouse", function(ply,mv,cmd)
	if not ply.Gred_Emp_Class then return end
	if string.StartWith(ply.Gred_Emp_Class,"gred_emp") then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) and ply == ent:GetShooter() then
				ent.CalcMouse = cmd:GetMouseY() + cmd:GetMouseX()
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "gred_emp_takedmg", function(target,dmginfo)
	if target.GredEMPBaseENT != nil then
		target.GredEMPBaseENT:TakeDamageInfo(dmginfo)
	end
end)

AddCSLuaFile()

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

if SERVER then
	util.AddNetworkString("gred_net_emp_reloadsounds")
	util.AddNetworkString("gred_net_emp_prop")
	util.AddNetworkString("gred_net_emp_viewmode")
	util.AddNetworkString("gred_net_emp_onshoot")
	
	net.Receive("gred_net_emp_viewmode",function()
		self = net.ReadEntity()
		self:SetViewMode(net.ReadInt(8))
	end)
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
		net.ReadEntity().ShotInterval = net.ReadFloat()
	end)
	
	net.Receive("gred_net_emp_prop",function()
		net.ReadEntity().GredEMPBaseENT = net.ReadEntity()
	end)
	
	net.Receive("gred_net_emp_onshoot",function()
		net.ReadEntity():OnShoot()
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
	
	hook.Add("CalcView","gred_emp_calcview",function(ply, pos, angles, fov)
		if ply:GetViewEntity() != ply then return end
		if ply.Gred_Emp_Ent and ply:Alive() then
			local ent = ply.Gred_Emp_Ent
			if IsValid(ent) then
				return ent:ViewCalc(ply,pos,angles,fov)
			end
		end
	end)
	
	hook.Add("HUDPaint","gred_emp_hudpaint",function()
		local ply = LocalPlayer()
		if not ply.Gred_Emp_Ent then return end
		
		local ent = ply.Gred_Emp_Ent
		if !IsValid(ent) then return end
		if ent.EmplacementType != "Mortar" then return end
		-- if not ent.HUDPaint then return end
		
		return ent:HUDPaint(ply)
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
		
		local this = Panel:CheckBox("Should the cannons' carriage collide?","gred_sv_carriage_collision");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_carriage_collision",val)
		end
		
		local this = Panel:CheckBox("Should the players be able to use multiple emplacements at once?","gred_sv_canusemultipleemplacements");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_canusemultipleemplacements",val)
		end
		
		local this = Panel:CheckBox("Should the MGs have limited ammo?","gred_sv_limitedammo");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_limitedammo",val)
		end
		
		local this = Panel:CheckBox("Should the players be able to take the MGs' tripods?","gred_sv_cantakemgbase");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_cantakemgbase",val)
		end
		
		local this = Panel:CheckBox("Enable seats?","gred_sv_enable_seats");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_enable_seats",val)
		end
		
		
		local this = Panel:CheckBox("Should you be able to see the MGs' shells?","gred_cl_shelleject");
		
		-- if !ded then
		
		local this = Panel:CheckBox("Use a manual shell reload system?","gred_sv_manual_reload");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_manual_reload",val)
		end
		
		local this = Panel:CheckBox("Use a manual reload system for the MGs?","gred_sv_manual_reload_mgs");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_manual_reload_mgs",val)
		end
		
		local this = Panel:CheckBox("Should the emplacements explode?","gred_sv_enable_explosions");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_enable_explosions",val)
		end
		
		local this = Panel:CheckBox("Enable recoil?","gred_sv_enable_recoil");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_enable_recoil",val)
		end
		
		local this = Panel:CheckBox("Enable progressive rotation?","gred_sv_progressiveturn");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_progressiveturn",val)
		end
		
		local this = Panel:NumSlider( "Progressive rotation multiplier (MGs)", "gred_sv_progressiveturn_mg", 0, 10, 2 );
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand("gred_sv_progressiveturn_mg",val)
		end
		
		local this = Panel:NumSlider( "Progressive rotation multiplier (Cannons)", "gred_sv_progressiveturn_cannon", 0, 10, 2 );
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand("gred_sv_progressiveturn_cannon",val)
		end
		
		local this = Panel:NumSlider( "Shell arrival time (for mortars)", "gred_sv_shell_arrival_time", 0, 10, 2 );
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand("gred_sv_shell_arrival_time",val)
		end
		
		local this = Panel:NumSlider( "Shell casing remove time", "gred_sv_shell_remove_time", 0, 120, 0 );
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand("gred_sv_shell_remove_time",val)
		end
		
		-- end
		
		local this = Panel:NumSlider( "Mouse sensitivity", "gred_cl_emp_mouse_sensitivity", 0, 0.99, 2 );
		
		-- local this = Panel:NumSlider( "Shoot sound volume", "gred_cl_emp_volume", 0, 1, 2 );
		
		local this = Panel:CheckBox("Invert X axis in seats?","gred_cl_emp_mouse_invert_x");
		
		local this = Panel:CheckBox("Invert Y axis in seats?","gred_cl_emp_mouse_invert_y");
		
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
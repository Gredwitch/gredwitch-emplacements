
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
gred.EmplacementTool = {}
gred.EmplacementTool.BlackList = {"gred_emp_nebelwerfer_tubes","gred_emp_m61","gred_emp_base",
								-- "gred_emp_[whatyouwant]",  -- These emplacements won't show up in the menu
}
gred.EmplacementBinoculars = gred.EmplacementBinoculars or {}
gred.EmplacementBinoculars.FireMissionID = gred.EmplacementBinoculars.FireMissionID or 124



local tableinsert = table.insert
gred.AddonList = gred.AddonList or {}
tableinsert(gred.AddonList,1391460275) -- Emplacements
tableinsert(gred.AddonList,1131455085) -- Base addon

timer.Simple(0.1,function()
	local tablehasvalue = table.HasValue
	local startsWith = string.StartWith
	
	gred.EntsList = {}
	for k,v in pairs (scripted_ents.GetList()) do
		if (startsWith(k,"gred_emp") or k == "gred_prop_ammobox") and not tablehasvalue(gred.EmplacementTool.BlackList,k) then
			gred.EntsList[k] = v
		end
	end
	-- table.sort(gred.EntsList,function(a,b) return a.t.ClassName > b.t.ClassName end)
end)


if SERVER then
	util.AddNetworkString("gred_net_emp_reloadsounds")
	util.AddNetworkString("gred_net_emp_prop")
	util.AddNetworkString("gred_net_emp_viewmode")
	util.AddNetworkString("gred_net_emp_onshoot")
	util.AddNetworkString("gred_net_emp_firemission")
	util.AddNetworkString("gred_net_sendeyetrace")
	util.AddNetworkString("gred_net_removeeyetrace")
	
	util.AddNetworkString("gred_net_send_emplacement_type")
	util.AddNetworkString("gred_net_send_emplacement_zoffset")
	util.AddNetworkString("gred_net_emplacement_builtpercent")
	util.AddNetworkString("gred_net_modifyemplacement")
	util.AddNetworkString("gred_net_freeze_unfreeze")
	util.AddNetworkString("gred_net_getmotion")
	util.AddNetworkString("gred_net_setmotion")
	util.AddNetworkString("gred_net_move")
	util.AddNetworkString("gred_net_remove")
	
	timer.Simple(0,function()
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
	end)
	net.Receive("gred_net_emp_viewmode",function()
		local self = net.ReadEntity()
		local int = net.ReadInt(8)
		if !IsValid(self) then return end
		
		self:SetViewMode(int)
		if int > self.OldMaxViewModes then
			self:GetShooter():SetEyeAngles(Angle(90))
		end
	end)
	
	net.Receive("gred_net_send_emplacement_type",function()
		local self = net.ReadEntity()
		self:SendWeaponAnim(ACT_VM_DEPLOY)
		self:SetSelectedEmplacement(net.ReadString())
	end)
	
	net.Receive("gred_net_send_emplacement_zoffset",function()
		net.ReadEntity().Emplacement.ZOffset = net.ReadVector()
	end)
	
	net.Receive("gred_net_getmotion",function()
		local self = net.ReadEntity()
		local ent = net.ReadEntity()
		local p = ent:GetPhysicsObject()
		if IsValid(p) then
			net.Start("gred_net_setmotion")
				net.WriteEntity(self)
				net.WriteBool(p:IsMotionEnabled())
			net.Broadcast()
		end
	end)
	
	net.Receive("gred_net_remove",function()
		net.ReadEntity():Remove()
	end)
	
	net.Receive("gred_net_move",function()
		local self = net.ReadEntity()
		local ent = net.ReadEntity()
		
		self:SendWeaponAnim(ACT_VM_DEPLOY)
		self.Emplacement.ZOffset = nil
		self:SetSelectedEmplacement(ent.ClassName)
		self:SetIsMoving(true)
		self:SetPrevBuiltPercent(ent.BuiltPercent or 999)
		
		-- self:SetGredEMPBaseENT(nil)
		self:SetEditMode(false)
		
		ent:Remove()
	end)
	
	net.Receive("gred_net_freeze_unfreeze",function()
		local ent = net.ReadEntity()
		local bool = net.ReadBool()
		if ent.Entities then
			for k,v in pairs(ent.Entities) do
				local p = v:GetPhysicsObject()
				if IsValid(p) then
					p:EnableMotion(bool)
				end
			end
		else
			local p = ent:GetPhysicsObject()
			if IsValid(p) then
				p:EnableMotion(bool)
			end
		end
	end)

else
	
	local CreateClientConVar = CreateClientConVar
	gred.CVars.gred_cl_shelleject = CreateClientConVar("gred_cl_shelleject","1", true,false)
	gred.CVars.gred_cl_emp_mouse_sensitivity = CreateClientConVar("gred_cl_emp_mouse_sensitivity","1", true,false)
	gred.CVars.gred_cl_emp_mouse_invert_x = CreateClientConVar("gred_cl_emp_mouse_invert_x","0", true,false)
	gred.CVars.gred_cl_emp_mouse_invert_y = CreateClientConVar("gred_cl_emp_mouse_invert_y","0", true,false)
	gred.CVars.gred_cl_lang = CreateConVar("gred_cl_lang",system.GetCountry() == "FR" and "fr" or "en",FCVAR_USERINFO,"'fr' or 'en'")
	-- CreateClientConVar("gred_cl_emp_volume","1", true,false)
	
	
	local function DrawCircle( X, Y, radius )
		local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
		
		for a = 0, 360 - segmentdist, segmentdist do
			surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		end
	end
	
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
		
		local this = Panel:CheckBox("Should every cannons be able to be used as artillery?","gred_sv_enable_cannon_artillery");
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_enable_cannon_artillery",val)
		end
		
		local this = Panel:NumSlider( "Fire mission time", "gred_sv_emplacement_artillery_time", 1, 900, 0 );
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand("gred_sv_emplacement_artillery_time",val)
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
		
		local this = Panel:NumSlider( "Mouse sensitivity", "gred_cl_emp_mouse_sensitivity", 0.01, 0.99, 2 );
		
		-- local this = Panel:NumSlider( "Shoot sound volume", "gred_cl_emp_volume", 0, 1, 2 );
		
		local this = Panel:CheckBox("Invert X axis in seats?","gred_cl_emp_mouse_invert_x");
		
		local this = Panel:CheckBox("Invert Y axis in seats?","gred_cl_emp_mouse_invert_y");
		
	end
	
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
	
	net.Receive("gred_net_emplacement_builtpercent",function()
		local ent = net.ReadEntity()
		ent.BuiltPercent = net.ReadFloat()
		ent.HP = net.ReadFloat()
	end)
	
	net.Receive("gred_net_setmotion",function()
		local self = net.ReadEntity()
		self.EmplacementMotion = net.ReadBool()
	end)
	
	net.Receive("gred_net_modifyemplacement",function()
		
		local emplacement = net.ReadEntity()
		if !IsValid(emplacement) then return end
		emplacement.BuiltPercent = emplacement.BuiltPercent or 0
		
		emplacement.Draw = function(self)
			self:DrawModel()
			
			if self.ClassName == "gred_prop_ammobox" then
				if self.BuiltPercent < 300 then
					local ang = LocalPlayer():EyeAngles()
					ang.p = 0
					ang.y = ang.y - 90
					ang.r = 90
					local pos = self:GetPos()
					pos.z = pos.z + 30
					local mins,maxs = self:GetModelBounds()
					
					cam.Start3D2D(pos,ang,0.25)
						surface.SetFont("Default")
						surface.SetTextColor(0,0,0)
						surface.SetTextPos(0,-maxs.x/2)
						draw.DrawText(math.Round((self.BuiltPercent/300 * 100),1).."%","DermaDefault",0,offset,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT )
					cam.End3D2D()
				end
			else
				if self.BuiltPercent < self.HP then
					local ang = LocalPlayer():EyeAngles()
					ang.p = 0
					ang.y = ang.y - 90
					ang.r = 90
					local pos = self:GetPos()
					local mins,maxs = self:GetModelBounds()
					local c = self:GetClass()
					if c == "gred_emp_flak38" or c == "gred_emp_flakvierling38" or c == "gred_emp_bofors" or c == "gred_emp_artemis30" or c == "gred_emp_nebelwerfer" or c == "gred_emp_m60" or c == "gred_emp_mg42" or c == "gred_emp_mg81z" or c == "gred_emp_m2"  or c == "gred_emp_m2_low" or c == "gred_emp_vickers" then
						pos.z = pos.z + 30
					elseif c == "gred_emp_breda35" or c == "gred_emp_zsu23" or c == "gred_emp_kwk" or c == "gred_emp_zpu4_1949" or c == "gred_emp_bar" or c == "gred_emp_mg3" or c == "gred_emp_rpk" then
						pos.z = pos.z + maxs.z*4
					else
						pos.z = pos.z + maxs.z*1.5
					end
					cam.Start3D2D(pos,ang,0.25)
						surface.SetFont("Default")
						surface.SetTextColor(0,0,0)
						surface.SetTextPos(0,-maxs.x/2)
						draw.DrawText(math.Round((self.BuiltPercent/self.HP * 100),1).."%","DermaDefault",0,offset,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT )
					cam.End3D2D()
				end
			end
		end
	end)
	
	net.Receive("gred_net_emp_reloadsounds",function()
		net.ReadEntity().ShotInterval = net.ReadFloat()
	end)
	
	net.Receive("gred_net_emp_prop",function()
		net.ReadEntity().GredEMPBaseENT = net.ReadEntity()
	end)
	
	net.Receive("gred_net_emp_onshoot",function()
		local self = net.ReadEntity()
		if !IsValid(self) or !self.OnShoot then return end
		self:OnShoot()
	end)
	
	net.Receive("gred_net_emp_firemission",function()
		local ent = net.ReadEntity()
		local id = net.ReadInt(14)
		local tab = net.ReadTable()
		
		if !IsValid(ent) then return end
		
		gred = gred or {}
		gred.EmplacementBinoculars = gred.EmplacementBinoculars or {}
		gred.EmplacementBinoculars.FireMissionID = id
		ent.FireMissions = ent.FireMissions or {}
		ent.FireMissions[id] = tab
		ent.MaxViewModes = table.Count(ent.FireMissions) + ent.OldMaxViewModes
		
		local shooter = ent:GetShooter()
		if LocalPlayer() == shooter then
			LANGUAGE = gred.CVars.gred_cl_lang:GetString() or "en"
			if not LANGUAGE then return end
			shooter:ChatPrint(tab[1]:GetName()..gred.Lang[LANGUAGE].EmplacementBinoculars.emp_player_requested..gred.Lang[LANGUAGE].EmplacementBinoculars["emplacement_requesttype_"..tab[5]].."!")
		end
		
		timer.Simple(gred.CVars.gred_sv_emplacement_artillery_time:GetFloat(),function()
			if !IsValid(ent) then return end
			ent.FireMissions[id] = nil
			ent.MaxViewModes = table.Count(ent.FireMissions) + ent.OldMaxViewModes
		end)
	end)
	
	
	hook.Add("AdjustMouseSensitivity", "gred_emp_mouse", function(s)
		local ply = LocalPlayer()
		local ent = ply.Gred_Emp_Ent
		if not IsValid(ent) then ply.Gred_Emp_Ent = nil return end
		if string.StartWith(ent.ClassName,"gred_emp") then
			if IsValid(ent:GetSeat()) and ply == ent:GetShooter() then
				return gred.CVars.gred_cl_emp_mouse_sensitivity:GetFloat()
			end
		end
	end)
	
	hook.Add("CalcView","gred_emp_calcview",function(ply, pos, angles, fov)
		if ply:GetViewEntity() != ply then return end
		if !ply:Alive() then return end
		if !ply.Gred_Emp_Ent then return end
		if !IsValid(ply.Gred_Emp_Ent) then return end
		
		return ply.Gred_Emp_Ent:View(ply,pos,angles,fov)
	end)
	
	hook.Add("HUDPaint","gred_emp_hudpaint",function()
		local ply = LocalPlayer()
		if not ply.Gred_Emp_Ent then return end
		
		local ent = ply.Gred_Emp_Ent
		if !IsValid(ent) then return end
		if ent:GetShooter() != ply then return end
		
		local ScrW,ScrH = ent:PaintHUD(ply,ent:GetViewMode())
		if ScrW and ScrH then
			local startpos = ent:LocalToWorld(ent.SightPos)
			local scr = util.TraceLine({
				start = startpos,
				endpos = (startpos + ply:EyeAngles():Forward() * 1000),
				filter = ent.Entities
			}).HitPos:ToScreen()
			scr.x = scr.x > ScrW and ScrW or (scr.x < 0 and 0 or scr.x)
			scr.y = scr.y > ScrH and ScrH or (scr.y < 0 and 0 or scr.y)
			
			
			surface.SetDrawColor(255,255,255)
			DrawCircle(scr.x,scr.y,19)
			surface.SetDrawColor(0,0,0)
			DrawCircle(scr.x,scr.y,20)
		end
	end)
	
	hook.Add("InputMouseApply", "gred_emp_move",function(cmd,x,y,angle)
		local ply = LocalPlayer()
		local ent = ply.Gred_Emp_Ent
		if not IsValid(ent) then ply.Gred_Emp_Ent = nil return end
		if string.StartWith(ent.ClassName,"gred_emp") then
			if IsValid(ent:GetSeat()) or ent:GetViewMode() != 0 then
				if ply == ent:GetShooter() then
					local InvertX = gred.CVars.gred_cl_emp_mouse_invert_x:GetInt() == 1
					local InvertY = gred.CVars.gred_cl_emp_mouse_invert_y:GetInt() == 1
					local sensitivity = gred.CVars.gred_cl_emp_mouse_sensitivity:GetFloat()
					
					x = x * sensitivity
					y = y * sensitivity
					
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
	
	gred = gred or {}
	gred.TakeScreenShot = function()
		local t = os.clock()
		print("Capturing...")
		render.CapturePixels()
		
		local ScrW,ScrH = ScrW(),ScrH()
		local tab = {}
		local r,g,b
		print("Running...")
		for x = 0,ScrW do
			-- local y = 500
			for y = 0,ScrH do
				r,g,b = render.ReadPixel(x,y)
				print(r,g,b)
				-- tab[x.." "..y] = {r = r,g = g,b = b}
			end
		end
		print("Writing...")
		-- file.Write("screenshot.json",util.TableToJSON(tab))
		PrintTable(tab)
		print("Done in "..(os.clock() - t).."s!")
	end
end
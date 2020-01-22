AddCSLuaFile()

SWEP.Base 						= "weapon_base"

SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false

SWEP.Category					= "Gredwitch's SWEPs"
SWEP.Author						= "Gredwitch"
SWEP.Contact					= ""
SWEP.Purpose					= ""
SWEP.Instructions				= "[Reload] + [Use] for help."
SWEP.PrintName					= "Emplacement Tool"


SWEP.WorldModel					= "models/weapons/c_arms.mdl"
SWEP.ViewModel 					= "models/weapons/gredwitch/v_hammer.mdl"
SWEP.UseHands					= true

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
SWEP.DrawAmmo					= false

SWEP.Emplacement				= {}
SWEP.Emplacement["Hull"]		= nil
SWEP.Emplacement["Yaw"]			= nil
SWEP.Emplacement["Turret"]		= nil
SWEP.Emplacement["Wheels"]		= nil
SWEP.Emplacement["ZOffset"]		= nil

SWEP.CustomOffset				= {
	["gred_emp_flak37"] = Vector(0,0,38),
	["gred_emp_pak40"] = Vector(0,0,17),
	["gred_emp_pm41"] = Vector(0,0,30),
	["gred_emp_3inchmortar"] = Vector(0,0,30),
	["gred_emp_m1mortar"] = Vector(0,0,35),
	["gred_emp_grw34"] = Vector(0,0,30),
	["gred_emp_m134"] = Vector(0,0,50),
	["gred_emp_m1919"] = Vector(0,0,10),
	["gred_emp_m2_low"] = Vector(0,0,30),
	["gred_emp_gau19"] = Vector(0,0,50),
	["gred_emp_bofors"] = Vector(0,0,88),
}

SWEP.AddAngle					= Angle(0,0,0)
SWEP.NextReload					= 0

SWEP.WeaponWhiteList			= {
	"weapon_crowbar",
	"What you want - weapon classname goes here",
}

SWEP.MaxSpawnDistance			= 600 -- How far the player can set his emplacement / modify other emplacements

-- Micro optimizations
local pairs						= pairs
local tablehasvalue				= table.HasValue
local IsValid					= IsValid
local CLIENT					= CLIENT
local SERVER					= SERVER
local PrintMessage				= PrintMessage

function SWEP:SetupDataTables()
	self:NetworkVar("String",0,"SelectedEmplacement")
	self:NetworkVar("Bool",0,"EditMode")
	self:NetworkVar("Bool",1,"IsMoving")
	-- self:NetworkVar("Bool",2,"IsMotionEnabled")
	self:NetworkVar("Float",0,"PrevBuiltPercent")
	-- self:NetworkVar("Entity",0,"GredEMPBaseENT")
	self:NetworkVar("Entity",0,"HoveredEmplacement")
end

function SWEP:Initialize()
	if CLIENT then
		timer.Simple(0,function()
			if !IsValid(self) then return end
			if self.Owner != LocalPlayer() then return end
			
			LANGUAGE = GetConVar("gred_cl_lang"):GetString() or "en"
			
			if game.SinglePlayer() then
				self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.info_singleplayer)
			else
				self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.control_init_base) 
				self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.control_mode_construct)
			end
		end)
	end
end

function SWEP:Holster(wep)
	if self:GetSelectedEmplacement() != "" then 
		return false 
	else
		self:SetSelectedEmplacement("")
		for k,v in pairs(self.Emplacement) do
			if IsValid(v) then
				v:Remove()
			end
		end
		return true
	end
end

function SWEP:OnRemove()
	for k,v in pairs(self.Emplacement) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

function SWEP:DrawHUD()
	if not LANGUAGE then return end
	if not gred then return end
	if not gred.Lang then return end
	if not gred.Lang[LANGUAGE] then return end
	if not gred.Lang[LANGUAGE].EmplacementTool then return end
	surface.SetFont("GFont")
	surface.SetTextColor(255,255,255)
	surface.SetTextPos(ScrW()*0.01,ScrH()*0.01)
	-- PrintTable(gred.Lang[LANGUAGE].EmplacementTool)
	surface.DrawText(gred.Lang[LANGUAGE].EmplacementTool.hud_curmode and gred.Lang[LANGUAGE].EmplacementTool.hud_curmode or "")
	surface.SetTextPos(ScrW()*0.01,ScrH()*0.07)
	if self:GetEditMode() then
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementTool.hud_editmode and gred.Lang[LANGUAGE].EmplacementTool.hud_editmode or "")
	else
		surface.DrawText(gred.Lang[LANGUAGE].EmplacementTool.hud_constructmode and gred.Lang[LANGUAGE].EmplacementTool.hud_constructmode or "")
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	
	return true
end

function SWEP:GetZOffset(emplacement)
	if CLIENT then
		if emplacement == "gred_prop_ammobox" then
			self.Emplacement.ZOffset = Vector(0,0,16)
		else
			if self.CustomOffset[emplacement] then
				self.Emplacement.ZOffset = self.CustomOffset[emplacement]
			else
				if not IsValid(self.Emplacement.Hull) then
					self.Emplacement.Hull = ents.CreateClientProp()
					self.Emplacement.Hull:SetModel(gred.EntsList[emplacement].t.HullModel)
					self.Emplacement.Hull:Spawn()
					self.Emplacement.Hull:Activate()
				end
				local mins,maxs = self.Emplacement.Hull:GetModelBounds()
				self.Emplacement.Hull:Remove()
				self.Emplacement.ZOffset = Vector(0,0,math.abs(mins.z))
			end
		end
		
		net.Start("gred_net_send_emplacement_zoffset")
			net.WriteEntity(self)
			net.WriteVector(self.Emplacement.ZOffset)
		net.SendToServer()
	end
end

function SWEP:Think()
	if CLIENT then
		
		if LocalPlayer() != self.Owner then return end -- yea
		
		local emplacement = self:GetSelectedEmplacement()
		
		if emplacement != "" then
			local eyeTrace = self.Owner:GetEyeTrace()
			if emplacement == "gred_prop_ammobox" then
			
				if not IsValid(self.Emplacement.Hull) then
					self.Emplacement.Hull = ents.CreateClientProp()
					self.Emplacement.Hull:SetModel(gred.EntsList[emplacement].t.Model)
					self.Emplacement.Hull:Spawn()
					self.Emplacement.Hull:Activate()
				end
				if not self.Emplacement.ZOffset then
					self:GetZOffset(emplacement)
				end
				self.Emplacement.Hull:SetAngles(Angle(0,self.Owner:EyeAngles().y + self.AddAngle.y))
				self.Emplacement.Hull:SetPos(eyeTrace.HitPos + Vector(0,0,eyeTrace.HitNormal:Angle():Up().z*10 + self.Emplacement.ZOffset.z))
				local color = self:SpawnPosValid(eyeTrace) and Color(0,255,0) or Color(255,0,0)
				
				halo.Add(self.Emplacement,color)
				for k,v in pairs(self.Emplacement) do
					if IsValid(v) then
						v:SetRenderMode(RENDERMODE_TRANSCOLOR)
					end
				end
				
			else
				if not IsValid(self.Emplacement.Hull) then
					self.Emplacement.Hull = ents.CreateClientProp()
					self.Emplacement.Hull:SetModel(gred.EntsList[emplacement].t.HullModel)
					self.Emplacement.Hull:Spawn()
					self.Emplacement.Hull:Activate()
				end
				
				if not self.Emplacement.ZOffset then
					self:GetZOffset(emplacement)
				end
				
				if gred.EntsList[emplacement].t.YawModel and not IsValid(self.Emplacement.Yaw) then
					self.Emplacement.Yaw = ents.CreateClientProp()
					self.Emplacement.Yaw:SetModel(gred.EntsList[emplacement].t.YawModel)
					self.Emplacement.Yaw:Spawn()
				end
				
				if gred.EntsList[emplacement].t.WheelsModel and not IsValid(self.Emplacement.Wheels) then
					self.Emplacement.Wheels = ents.CreateClientProp()
					self.Emplacement.Wheels:SetModel(gred.EntsList[emplacement].t.WheelsModel)
					self.Emplacement.Wheels:Spawn()
				end
				
				if not IsValid(self.Emplacement.Turret) then
					self.Emplacement.Turret = ents.CreateClientProp()
					self.Emplacement.Turret:SetModel(gred.EntsList[emplacement].t.TurretModel)
					self.Emplacement.Turret:Spawn()
				end
				
				
				 
				local ang = Angle(0,self.Owner:EyeAngles().y + self.AddAngle.y)
				
				self.Emplacement.Hull:SetAngles(ang)
				self.Emplacement.Hull:SetPos(eyeTrace.HitPos + self.Emplacement.ZOffset + Vector(0,0,eyeTrace.HitNormal:Angle():Up().z*10))
				
				if gred.EntsList[emplacement].t.YawModel then 
					self.Emplacement.Yaw:SetAngles(ang) 
					self.Emplacement.Yaw:SetPos(self.Emplacement.Hull:LocalToWorld(gred.EntsList[emplacement].t.YawPos or Vector(0,0,0)))
				end
				self.Emplacement.Turret:SetAngles(ang)
				self.Emplacement.Turret:SetPos(IsValid(self.Emplacement.Yaw) and self.Emplacement.Yaw:LocalToWorld(gred.EntsList[emplacement].t.TurretPos or Vector(0,0,0)) or self.Emplacement.Hull:LocalToWorld(gred.EntsList[emplacement].t.TurretPos or Vector(0,0,0)))
				
				if gred.EntsList[emplacement].t.WheelsModel then 
					self.Emplacement.Wheels:SetAngles(ang)
					self.Emplacement.Wheels:SetPos(IsValid(self.Emplacement.Yaw) and self.Emplacement.Yaw:LocalToWorld(gred.EntsList[emplacement].t.WheelsPos or Vector(0,0,0)) or self.Emplacement.Turret:LocalToWorld(gred.EntsList[emplacement].t.WheelsPos or Vector(0,0,0)))
				end
				
				local color = self:SpawnPosValid(eyeTrace) and Color(0,255,0) or Color(255,0,0)
				
				halo.Add(self.Emplacement,color)
				for k,v in pairs(self.Emplacement) do
					if IsValid(v) then
						v:SetRenderMode(RENDERMODE_TRANSCOLOR)
					end
				end
			end
		else
			for k,v in pairs(self.Emplacement) do
				if IsValid(v) then
					v:Remove()
				end
			end
			if self:GetEditMode() then
				local eyeTrace = self.Owner:GetEyeTrace()
				local ent = eyeTrace.Entity.GredEMPBaseENT and eyeTrace.Entity.GredEMPBaseENT or (eyeTrace.Entity.Base == "gred_emp_base" and eyeTrace.Entity or (eyeTrace.Entity.ClassName == "gred_prop_ammobox" and eyeTrace.Entity or nil))
				if IsValid(ent) then
					if self:SpawnPosValid(eyeTrace) then
						local color = Color(0,255,0)
						if tablehasvalue(gred.EmplacementTool.BlackList,ent.ClassName) then
							color = Color(255,0,0)
							-- if CLIENT then
								-- net.Start("gred_net_playsound") net.WriteString("buttons/button11.wav") net.Send(self.Owner)
								-- surface.PlaySound("buttons/button11.wav")
								-- self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.cant_edit_emplacement)
							-- end
							-- return
							self:SetHoveredEmplacement(nil)
						else
							self:SetHoveredEmplacement(ent)
						end
						halo.Add(ent.ClassName == "gred_prop_ammobox" and {ent} or ent.Entities,color)
					end
				end
			end
		end
	end
end



function SWEP:CanPrimaryAttack(ct,eyeTrace,editmode)
	local spValid = self:SpawnPosValid(eyeTrace)
	return self.Primary.NextShot <= ct and (!editmode and spValid and self:GetSelectedEmplacement() != "") or (editmode and spValid and (eyeTrace.Entity.GredEMPBaseENT and eyeTrace.Entity.GredEMPBaseENT.Base == "gred_emp_base" or (eyeTrace.Entity.Base == "gred_emp_base" or eyeTrace.Entity.ClassName == "gred_prop_ammobox")))
end

function SWEP:PrimaryAttack()
	local ct = CurTime()
	local eyeTrace = self.Owner:GetEyeTrace()
	local editmode = self:GetEditMode()
	
	if !IsValid(self) then return end
	if editmode and !IsValid(eyeTrace.Entity) then return end
	
	if not self:CanPrimaryAttack(ct,eyeTrace,editmode) then return end
	self.Primary.NextShot = ct + self.Primary.FireRate
	
	if not editmode then
		local selectedEmplacement = self:GetSelectedEmplacement()
		self:SendWeaponAnim(ACT_VM_UNDEPLOY)
		if selectedEmplacement == "gred_prop_ammobox" then
			self:CreateAmmoBox(eyeTrace,selectedEmplacement)
		else
			self:CreateEmplacement(eyeTrace,selectedEmplacement)
		end
		if CLIENT then surface.PlaySound("phx/epicmetal_hard"..math.random(1,7)..".wav") end
		self:SetSelectedEmplacement("")
		self.Emplacement.ZOffset = nil
	end
	
end


function SWEP:CanSecondaryAttack(ct)
	return self.Secondary.NextShot <= ct
end

function SWEP:SecondaryAttack()
	local ct = CurTime()
	
	if not self:CanSecondaryAttack(ct) then return end
	self.Secondary.NextShot = ct + self.Secondary.FireRate
	
	if self:GetEditMode() then
		if CLIENT then
			local ent = self:GetHoveredEmplacement()
			if IsValid(ent) then
				surface.PlaySound("garrysmod/ui_return.wav")
				
				local MainWindow = vgui.Create("DFrame")
				MainWindow:SetSize(ScrW()/10,ScrH()/(7.5))
				MainWindow:SetTitle(gred.Lang[LANGUAGE].EmplacementTool.menu_edit)
				MainWindow:SetDraggable(true)
				MainWindow.Paint = function(self,w,h)
					draw.RoundedBox(14,0,0,w,h,Color(10,10,10,240))
				end
				MainWindow:Center()
				MainWindow:MakePopup()
				
				local DScrollPanel = vgui.Create("DScrollPanel",MainWindow)
				DScrollPanel:Dock(FILL)
				
				net.Start("gred_net_getmotion")
					net.WriteEntity(self)
					net.WriteEntity(ent)
				net.SendToServer()
				
				timer.Simple(0,function()
					local DButton = DScrollPanel:Add("DButton")
					DButton:SetText(self.EmplacementMotion and "Freeze" or "Unfreeze")
					DButton:Dock(TOP)
					DButton:DockMargin(0,0,0,5)
					DButton.DoClick = function()
						net.Start("gred_net_freeze_unfreeze")
							net.WriteEntity(ent)
							net.WriteBool(!self.EmplacementMotion)
						net.SendToServer()
						
						surface.PlaySound("garrysmod/content_downloaded.wav")
						local u = !self.EmplacementMotion and gred.Lang[LANGUAGE].EmplacementTool.info_emplacement_unfreeze or gred.Lang[LANGUAGE].EmplacementTool.info_emplacement_freeze
						local s = ent.ClassName == "gred_prop_ammobox" and string.gsub(ent.PrintName,"%[OTHERS]","") or string.gsub(ent.PrintName,"%[EMP]","")
						self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.info_emplacement_motion_1..s..gred.Lang[LANGUAGE].EmplacementTool.info_emplacement_motion_2..u.."!")
						
						self.EmplacementMotion = nil
						MainWindow:Close()
					end
				end)
				
				local DButton = DScrollPanel:Add("DButton")
				DButton:SetText(gred.Lang[LANGUAGE].EmplacementTool.menu_move)
				DButton:Dock(TOP)
				DButton:DockMargin(0,0,0,5)
				DButton.DoClick = function()
					net.Start("gred_net_move")
						net.WriteEntity(self)
						net.WriteEntity(ent)
					net.SendToServer()
					timer.Simple(0,function()
						self.Emplacement.ZOffset = nil
						self:GetZOffset(ent.ClassName)
						self:SetSelectedEmplacement(ent.ClassName)
						self:SetIsMoving(true)
						self:SetPrevBuiltPercent(ent.BuiltPercent or 999)
						
						-- self:SetGredEMPBaseENT(nil)
						self:SetEditMode(false)
					end)
					
					surface.PlaySound("garrysmod/ui_return.wav")
					self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.control_mode_construct)
					
					
					MainWindow:Close()
				end
				
				local DButton = DScrollPanel:Add("DButton")
				DButton:SetText(gred.Lang[LANGUAGE].EmplacementTool.menu_destroy)
				DButton:Dock(TOP)
				DButton:DockMargin(0,0,0,5)
				DButton.DoClick = function()
					net.Start("gred_net_remove")
						net.WriteEntity(ent)
					net.SendToServer()
					local e = ent.ClassName == "gred_prop_ammobox" and string.gsub(ent.PrintName,"%[OTHERS]","") or string.gsub(ent.PrintName,"%[EMP]","")
					self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.info_emplacement_destroyed_1..e..gred.Lang[LANGUAGE].EmplacementTool.info_emplacement_destroyed_2)
					surface.PlaySound("garrysmod/balloon_pop_cute.wav")
					MainWindow:Close()
				end
				
				local DButton = DScrollPanel:Add("DButton")
				DButton:SetText(gred.Lang[LANGUAGE].EmplacementTool.menu_properties)
				DButton:Dock(TOP)
				DButton:DockMargin(0,0,0,5)
				DButton.DoClick = function()
					MainWindow:Close()
					local window = vgui.Create("DFrame")
					window:SetSize( 320, 400 )
					local e = ent.ClassName == "gred_prop_ammobox" and string.gsub(ent.PrintName,"%[OTHERS]","") or string.gsub(ent.PrintName,"%[EMP]","")
					window:SetTitle(e.." - "..gred.Lang[LANGUAGE].EmplacementTool.menu_properties)
					window:Center()
					window:MakePopup()
					window:SetSizable(true)
					
					local control = window:Add("DEntityProperties")
					control:SetEntity(ent)
					control:Dock(FILL)

					control.OnEntityLost = function()
						window:Remove()
					end
				end
				
			end
		end
	else
		if self.Owner:KeyDown(IN_USE) then
			if self:GetSelectedEmplacement() != "" and not self:GetIsMoving() then
				self:SendWeaponAnim(ACT_VM_UNDEPLOY)
				if CLIENT then
					surface.PlaySound("buttons/button3.wav")
				end
				self.Emplacement.ZOffset = nil
				self:SetSelectedEmplacement("")
			end
		else
			if CLIENT then
				surface.PlaySound("garrysmod/ui_return.wav")
				
				local count = table.Count(gred.EntsList)
				local maxW = ScrW()/(2-(count/100))
				 
				local MainWindow = vgui.Create("DFrame")
				MainWindow:SetSize(maxW,ScrH()/(2-(count/100)))
				MainWindow:SetTitle(gred.Lang[LANGUAGE].EmplacementTool.menu_emplacement_selection)
				MainWindow:SetDraggable(true)
				MainWindow.Paint = function(self,w,h)
					draw.RoundedBox(14,0,0,w,h,Color(10,10,10,240))
				end
				MainWindow:Center()
				MainWindow:MakePopup()
				
				local DScrollPanel = vgui.Create("DScrollPanel",MainWindow)
				DScrollPanel:Dock(FILL)
				
				local c = maxW/40
				local x = c
				local y = 10
				
				for k,v in pairs(gred.EntsList) do
					if v.t.PrintName then
						
						if x > maxW - c*3 then
							x = c
							y = y + 130
						end
						
						local ContentIcon = vgui.Create("ContentIcon",DScrollPanel)
						ContentIcon:SetPos(x,y)
						ContentIcon:SetMaterial("vgui/entities/"..k)
						ContentIcon:SetName(v.t.ClassName == "gred_prop_ammobox" and string.gsub(v.t.PrintName,"%[OTHERS]","") or string.gsub(v.t.PrintName,"%[EMP]",""))
						ContentIcon.LANGUAGE = LANGUAGE
						ContentIcon.OpenMenu = function()
							local menu = DermaMenu()
							menu:AddOption(gred.Lang[LANGUAGE].EmplacementTool.menu_copy_to_clipboard,function() SetClipboardText(k) end)
							menu:Open()
						end
						ContentIcon.DoClick = function()
							for k,v in pairs(self.Emplacement) do
								if IsValid(v) then
									v:Remove()
								end
							end
							-- self:SendWeaponAnim(ACT_VM_DEPLOY)
							self:SetSelectedEmplacement(k)
							self.Emplacement.ZOffset = nil
							net.Start("gred_net_send_emplacement_type")
								net.WriteEntity(self)
								net.WriteString(k)
							net.SendToServer()
							
							surface.PlaySound("garrysmod/ui_click.wav")
							MainWindow:Close()
						end
						
						x = x + 128
					end
				end
			end
		end
	end
end


function SWEP:CanReload(ct)
	return self.NextReload <= ct
end

function SWEP:Reload()
	local ct = CurTime()
	
	if not self:CanReload(ct) then return end
	self.NextReload = ct + 0.3
	
	if self.Owner:KeyDown(IN_USE) and not self:GetIsMoving() then
		local editmode = self:GetEditMode()
		if CLIENT then
			if !editmode then
				self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.control_mode_edit)
			else
				self.Owner:PrintMessage(HUD_PRINTTALK,gred.Lang[LANGUAGE].EmplacementTool.control_mode_construct)
			end
		end
		if !editmode then
			if self:GetSelectedEmplacement() != "" then
				self:SendWeaponAnim(ACT_VM_UNDEPLOY)
			end
			self:SetSelectedEmplacement("")
		end
		self:SetEditMode(!editmode)
	else
		if not self:GetEditMode() then
			self.AddAngle.y = self.AddAngle.y + 90
		end
	end
end



function SWEP:CreateAmmoBox(eyeTrace,selectedEmplacement)
	if SERVER then
		local box = ents.Create(selectedEmplacement)
		box:SetPos(eyeTrace.HitPos - self.Emplacement.ZOffset*2)
		box:SetAngles(Angle(0,self.Owner:EyeAngles().y + self.AddAngle.y))
		box.Owner = self.Owner
		box.BuiltPercent = self:GetIsMoving() and self:GetPrevBuiltPercent() or 0
		box.WeaponWhiteList = self.WeaponWhiteList
		local baseclass = baseclass.Get(selectedEmplacement)
		
		box.Use = function(self,ply,caller,use,val)
			if self.BuiltPercent < (300 and 300 or 300) then return end
			return baseclass.Use(self,ply,caller,use,val)
		end
		
		box.Think = function(self)
		
			if self.BuiltPercent > 300 then self.BuiltPercent = 300 end
			
			local val = (self.BuiltPercent/300)*255
			
			-- if val < 30 then 
				-- val = 30 
			-- end
			
			self:SetRenderMode(RENDERMODE_TRANSCOLOR)
			self:SetColor(Color(255,val,val,255))
					
			return baseclass.Think(self)
		end
		
		box.OnTakeDamage = function(self,dmg)
			
			if self.BuiltPercent < 300 then
				local attacker = dmg:GetAttacker()
				if attacker then
					if attacker.GetActiveWeapon then
						if table.HasValue(self.WeaponWhiteList,attacker:GetActiveWeapon():GetClass()) then -- Tu remplaces avec ce que tu veux
							self.BuiltPercent = self.BuiltPercent + math.random(10.3,20.4)
							
							net.Start("gred_net_emplacement_builtpercent")
								net.WriteEntity(self)
								net.WriteFloat(self.BuiltPercent)
								net.WriteFloat(300)
							net.Broadcast()
						end
					end
					return
				end
				
			else
				return baseclass.OnTakeDamage(self,dmg)
			end
			
		end
		
		box:Spawn()
		box:Activate()
		local p = box:GetPhysicsObject()
		if IsValid(p) then
			p:EnableMotion(false)
		end
		self:SetIsMoving(false)
		
		timer.Simple(self.Owner:Ping()/100,function() -- Not dividing by 1000 cuz yea
			if !IsValid(box) then return end
			net.Start("gred_net_modifyemplacement")
				net.WriteEntity(box)
			net.Broadcast()
		end)
	end
end

function SWEP:CreateEmplacement(eyeTrace,selectedEmplacement)
	if SERVER then
		local emplacement = ents.Create(selectedEmplacement)
		emplacement:SetPos(eyeTrace.HitPos+self.Emplacement.ZOffset + Vector(0,0,eyeTrace.HitNormal:Angle():Up().z*10))
		emplacement:SetAngles(Angle(0,self.Owner:EyeAngles().y + self.AddAngle.y))
		emplacement.Owner = self.Owner
		emplacement.Spawner = self.Owner
		emplacement.WeaponWhiteList = self.WeaponWhiteList
		emplacement.BuiltPercent = self:GetIsMoving() and self:GetPrevBuiltPercent() or 0
		if emplacement.ClassName == "gred_emp_m777" then
			emplacement.TurretPos.z = 0
		end
		
		-------------------------------------
		
		emplacement.InitHull = function(self,pos,ang)
			local hull = ents.Create("gred_prop_emp")
			hull.GredEMPBaseENT = self
			hull:SetModel(self.HullModel)
			hull:SetAngles(ang)
			hull:SetPos(pos)
			hull:Spawn()
			hull:Activate()
			hull.canPickUp = self.EmplacementType == "MG" and GetConVar("gred_sv_cantakemgbase"):GetInt() == 1 and not self.YawModel
			
			if self.EmplacementType == "Mortar" then hull:SetMoveType(MOVETYPE_FLY) end
			local phy = hull:GetPhysicsObject()
			if IsValid(phy) then
				phy:SetMass(self.HullMass)
			end
			
			self:SetHull(hull)
			self:AddEntity(hull)
			
			local newPos = hull:LocalToWorld(self.TurretPos)
			self:SetPos(newPos)
			if not self.YawModel then
				self:SetParent(hull)
			end
			if self.EmplacementType == "Cannon" then
				if GetConVar("gred_sv_carriage_collision"):GetInt() == 0 then
					hull:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
				end
			end
		end
		
		emplacement.InitYaw = function(self,pos,ang)
			if self.YawModel then
				local yaw = ents.Create("gred_prop_emp")
				yaw.GredEMPBaseENT = self
				yaw:SetModel(self.YawModel)
				yaw:SetAngles(ang)
				yaw:SetPos(pos+self.YawPos)
				yaw.Use = function(self,ply,act,use,val)
					if IsValid(self.GredEMPBaseENT) then
						self.GredEMPBaseENT:Use(ply,ply,3,0)
					end
				end
				yaw:Spawn()
				yaw:Activate()
				local phy = yaw:GetPhysicsObject()
				if IsValid(phy) then
					phy:SetMass(self.YawMass)
				end
				self:SetYaw(yaw)
				self:AddEntity(yaw)
				
				local newPos = yaw:LocalToWorld(self.TurretPos + self.YawPos)
				self:SetPos(newPos)
				yaw:SetParent(self:GetHull())
				self:SetParent(yaw)
			end
		end
		
		local baseclass = baseclass.Get("gred_emp_base")
		
		emplacement.Initialize = function(self)
			baseclass.Initialize(self)
			for k,v in pairs(self.Entities) do
				local p = v:GetPhysicsObject()
				if IsValid(p) then
					p:EnableMotion(false)
				end
			end
			timer.Simple(self.Owner:Ping()/100,function() -- Not dividing by 1000 cuz yea
				if !IsValid(self) then return end
				net.Start("gred_net_emplacement_builtpercent")
					net.WriteEntity(self)
					net.WriteFloat(self.BuiltPercent)
					net.WriteFloat(self.HP)
				net.Broadcast()
			end)
		end
		
		emplacement.Use = function(self,ply,caller,use,val)
			if self.BuiltPercent < self.HP then return end
			return baseclass.Use(self,ply,caller,use,val)
		end
		
		emplacement.Think = function(self)
		
			if self.BuiltPercent > self.HP then self.BuiltPercent = self.HP end
			
			local val = (self.BuiltPercent/self.HP)*255
			
			-- if val < 30 then 
				-- val = 30 
			-- end
			
			for k,v in pairs(self.Entities) do
				if IsValid(v) then
					v:SetRenderMode(RENDERMODE_TRANSCOLOR)
					v:SetColor(Color(255,val,val,255))
				end
			end
			
			return baseclass.Think(self)
		end
		
		emplacement.OnTakeDamage = function(self,dmg)
			
			if self.BuiltPercent < self.HP then
				local attacker = dmg:GetAttacker()
				if attacker then
					if attacker.GetActiveWeapon then
						if table.HasValue(self.WeaponWhiteList,attacker:GetActiveWeapon():GetClass()) then -- Tu remplaces avec ce que tu veux
							self.BuiltPercent = self.BuiltPercent + math.random(10.3,20.4)
							
							net.Start("gred_net_emplacement_builtpercent")
								net.WriteEntity(self)
								net.WriteFloat(self.BuiltPercent)
								net.WriteFloat(self.HP)
							net.Broadcast()
						end
					end
					return
				end
				
			else
				return baseclass.OnTakeDamage(self,dmg)
			end
			
		end
		
		-------------------------------------
		
		emplacement:Spawn()
		emplacement:Activate()
		self:SetIsMoving(false)
		
		
		timer.Simple(self.Owner:Ping()/100,function() -- Not dividing by 1000 cuz yea
			if !IsValid(emplacement) then return end
			net.Start("gred_net_modifyemplacement")
				net.WriteEntity(emplacement)
			net.Broadcast()
		end)
	end
end

function SWEP:SpawnPosValid(eyeTrace)
	return !(eyeTrace.HitSky or !eyeTrace.Hit) and self.MaxSpawnDistance >= self.Owner:GetPos():Distance(eyeTrace.HitPos)
end

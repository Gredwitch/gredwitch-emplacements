include('shared.lua')
function ENT:Draw()
	self:DrawModel()
end

net.Receive("gred_net_ammobox_cl_gui",function()
	local ply = net.ReadEntity()
	if LocalPlayer() == ply then
		local function AddShellMenu(shell,self,ply,frame)
			local d = DermaMenu()
			d:AddOption("AP",function() 
				shell = shell
				ap = true
				smoke = false
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
		
			d:AddOption("HE",function() 
				shell = shell
				ap = false
				smoke = false
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("Smoke",function() 
				shell = shell
				ap = false
				smoke = true
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		local function Add30CalMenu(self,ply,frame)
			local d = DermaMenu()
			d:AddOption("30. cal M1919 Belt",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/m1919/m1919_belt.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_m1919")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
		
			d:AddOption("7.62mm M240B Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/fnmag/m240b_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_m240b")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
		
			d:AddOption("7.62mm FN MAG Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/fnmag/fnmag_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_fnmag")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("7.62mm M60 Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/m60/m60_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_m60")
					net.WriteInt(1,1)
					net.WriteInt(1,1)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("7.62mm Bar Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/bar/bar_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_bar")
					net.WriteInt(1,1)
					net.WriteInt(1,1)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		local function Add7mmMenu(self,ply,frame)
			local d = DermaMenu()
			d:AddOption("7.92mm MG34 Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/mg34/mg34_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_mg34")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("7.92mm MG15 Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/mg15/mg15_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_mg15")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("7.92mm MG42 Belt",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/mg42/mg42_belt.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_mg42")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		local function Add303Menu(self,ply,frame)
			local d = DermaMenu()
			d:AddOption(".303 Vickers Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/vickers/vickers_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_vickers")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption(".303 Bren Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/bren/bren_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_bren")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		local function Add50calMenu(self,ply,frame)
			local d = DermaMenu()
			d:AddOption("12.7mm M2 Browning Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/m2browning/m2_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_m2")
					net.WriteInt(1,1)
					net.WriteInt(1,1)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("12.7mm DShK Mag",function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString("models/gredwitch/dhsk/dhsk_mag.mdl")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteString("gred_emp_dshk")
					net.WriteInt(0,1)
					net.WriteInt(0,1)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		local function AddMortarShellMenu(shell,self,ply,frame)
			local d = DermaMenu()
			d:AddOption("HE",function() 
				shell = shell
				ap = false
				smoke = false
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("Smoke",function() 
				shell = shell
				ap = false
				smoke = true
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		local function AddWPShellMenu(shell,self,ply,frame)
			local d = DermaMenu()
			d:AddOption("WP",function() 
				shell = shell.."WP"
				ap = false
				smoke = false
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("HE",function() 
				shell = shell
				ap = false
				smoke = false
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:AddOption("Smoke",function() 
				shell = shell
				ap = false
				smoke = true
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteString(shell)
					net.WriteBool(ap)
					net.WriteBool(smoke)
					net.WriteEntity(self)
					net.WriteEntity(ply)
				net.SendToServer()
				frame:Close()
			end)
			d:Open()
		end
		
		local self = net.ReadEntity()
		local shell = nil
		local smoke = nil
		local ap = nil
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 360)
		frame:Center()
		frame:MakePopup()
		frame.ent = self
		frame.ply = ply
		frame:SetTitle("Ammo box - Shell selection")
		function frame:Think()
			if !IsValid(frame.ply) or !frame.ply:Alive() then frame:Close() end
		end
		function frame:OnClose()
			net.Start("gred_net_ammobox_sv_close")
				net.WriteEntity(frame.ent)
			net.SendToServer()
		end
		local DScrollPanel = vgui.Create("DScrollPanel",frame)
		DScrollPanel:Dock(FILL)
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("50mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu("gb_shell_50mm",self,ply,frame)
		end
		
		--[[local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("56mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu("gb_shell_56mm",self,ply,frame)
		end]]
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("57mm / 6 pounders shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu("gb_shell_57mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("75mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu("gb_shell_75mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("76mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu("gb_shell_76mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("81mm mortar shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddWPShellMenu("gb_shell_81mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("82mm mortar shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddMortarShellMenu("gb_shell_82mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("88mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu("gb_shell_88mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("105mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddWPShellMenu("gb_shell_105mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("152mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddMortarShellMenu("gb_shell_152mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("155mm shell")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddMortarShellMenu("gb_shell_155mm",self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("7.62mm / 30. cal")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			Add30CalMenu(self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("7.92mm")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			Add7mmMenu(self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("7.7mm / .303 British")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			Add303Menu(self,ply,frame)
		end
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("12.7mm / .50 cal")
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			Add50calMenu(self,ply,frame)
		end
	end
end)
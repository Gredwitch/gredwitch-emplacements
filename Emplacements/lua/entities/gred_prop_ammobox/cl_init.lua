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
		frame:SetSize(300, 300)
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
	end
end)
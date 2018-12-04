if SERVER then AddCSLuaFile() end

timer.Simple(5,function()
		GredwitchBase=steamworks.ShouldMountAddon(1131455085) and steamworks.IsSubscribed(1131455085)
		Emplacements_mats1=steamworks.ShouldMountAddon(1484100983) and steamworks.IsSubscribed(1484100983)
		Emplacements_mats2=steamworks.ShouldMountAddon(1554003672) and steamworks.IsSubscribed(1554003672)
	end
	if !GredwitchBase then
		if CLIENT then
			GredFrame=vgui.Create('DFrame')
			GredFrame:SetTitle("Grediwtch's Base is not installed / enabled")
			GredFrame:SetSize(ScrW()*0.95, ScrH()*0.95)
			GredFrame:SetPos((ScrW() - GredFrame:GetWide()) / 2, (ScrH() - GredFrame:GetTall()) / 2)
			GredFrame:MakePopup()
			
			local h=vgui.Create('DHTML')
			h:SetParent(GredFrame)
			h:SetPos(GredFrame:GetWide()*0.005, GredFrame:GetTall()*0.03)
			local x,y = GredFrame:GetSize()
			h:SetSize(x*0.99,y*0.96)
			h:SetAllowLua(true)
			h:OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1131455085.html')
		end
	end
	if !Emplacements_mats1 then
		if CLIENT then
			GredEMPFrame=vgui.Create('DFrame')
			GredEMPFrame:SetTitle("Grediwtch's Emplacement Pack materials (part 1) addon is not installed / enabled")
			GredEMPFrame:SetSize(ScrW()*0.95, ScrH()*0.95)
			GredEMPFrame:SetPos((ScrW() - GredEMPFrame:GetWide()) / 2, (ScrH() - GredEMPFrame:GetTall()) / 2)
			GredEMPFrame:MakePopup()
			
			local h=vgui.Create('DHTML')
			h:SetParent(GredEMPFrame)
			h:SetPos(GredEMPFrame:GetWide()*0.005, GredEMPFrame:GetTall()*0.03)
			local x,y = GredEMPFrame:GetSize()
			h:SetSize(x*0.99,y*0.96)
			h:SetAllowLua(true)
			h:OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1484100983.html')
		end
	end
	if !Emplacements_mats2 then
		if CLIENT then
			GredEMPFrame2=vgui.Create('DFrame')
			GredEMPFrame2:SetTitle("Grediwtch's Emplacement Pack materials (part 2) addon is not installed / enabled")
			GredEMPFrame2:SetSize(ScrW()*0.95, ScrH()*0.95)
			GredEMPFrame2:SetPos((ScrW() - GredEMPFrame2:GetWide()) / 2, (ScrH() - GredEMPFrame2:GetTall()) / 2)
			GredEMPFrame2:MakePopup()
			
			local h=vgui.Create('DHTML')
			h:SetParent(GredEMPFrame2)
			h:SetPos(GredEMPFrame2:GetWide()*0.005, GredEMPFrame2:GetTall()*0.03)
			local x,y = GredEMPFrame2:GetSize()
			h:SetSize(x*0.99,y*0.96)
			h:SetAllowLua(true)
			h:OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1554003672.html')
		end
	end
end)
if SERVER then AddCSLuaFile() end

local found=false
local f=file.Find('autorun/client/*.lua', "LUA")
for k,v in pairs(f) do
	if v == "gredwitch_addon_verify.lua" then
		include('autorun/client/gredwitch_addon_verify.lua')
		found=true
	end
end

local foundE=false
local fE=file.Find('autorun/*.lua', "LUA")
for k,v in pairs(fE) do
	if v=="gred_emplacements_verify.lua" then
		include('autorun/gred_emplacements_verify.lua')
		foundE=true
	end
end

timer.Simple(5,function()
	if not found and not GredFrame then
		if CLIENT then
			GredFrame=vgui.Create('DFrame')
			GredFrame:SetTitle("Grediwtch's Base is not installed")
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
	if not foundE and not GredEMPFrame then
		if CLIENT then
			GredEMPFrame=vgui.Create('DFrame')
			GredEMPFrame:SetTitle("Grediwtch's Emplacement Pack materials addon is not installed")
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
end)
if not found or not foundE then return end
if SERVER then
	AddCSLuaFile()
end

local foundG=false
local fG=file.Find('autorun/client/gredwitch_addon_verify.lua', "LUA")
for k,v in pairs(f) do
	include('autorun/client/gredwitch_addon_verify.lua')
	foundG=true
end

timer.Simple(5,function()
	if not foundG then
		if CLIENT then
			WACFrame=vgui.Create('DFrame')
			WACFrame:SetTitle("Grediwtch's Base addon is not installed")
			WACFrame:SetSize(ScrW()*0.95, ScrH()*0.95)
			WACFrame:SetPos((ScrW() - WACFrame:GetWide()) / 2, (ScrH() - WACFrame:GetTall()) / 2)
			WACFrame:MakePopup()
			
			local h=vgui.Create('DHTML')
			h:SetParent(WACFrame)
			h:SetPos(WACFrame:GetWide()*0.005, WACFrame:GetTall()*0.03)
			local x,y = WACFrame:GetSize()
			h:SetSize(x*0.99,y*0.96)
			h:SetAllowLua(true)
			h:OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1131455085.html')
		elseif SERVER then
			timer.Create("GredWAC-NotInstalled", 10, 0, function() print("Grediwtch's Base addon is not installed") end)
		end
	end
end)
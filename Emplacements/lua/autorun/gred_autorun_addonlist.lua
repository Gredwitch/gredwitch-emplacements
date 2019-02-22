	
AddCSLuaFile()

gred = gred or {}
gred.AddonList = gred.AddonList or {}
gred.RequiredAddons = {}

-- hook.Add( "PostGamemodeLoaded", "gred_warning_about_fucking_missing_addons", function()
timer.Simple(5,function()
	if #gred.AddonList == 0 then return end
	local pairs = pairs
	local tableinsert = table.insert
	local addons = {}
	
	for k,requiredAddonID in pairs (gred.AddonList) do
		addons[k] = requiredAddonID
	end
	table.sort(addons,function(a,b) return a > b end)
	for k,v in pairs(addons) do
		if (v != addons[k+1] and not table.HasValue(gred.RequiredAddons,v)) then
			tableinsert(gred.RequiredAddons,v)
		end
	end
	
	if CLIENT then
		if GetConVar("gred_cl_enable_popups"):GetInt() != 1 then return end
		
		-- DFrame code from the ULX addon cuz I'm too lazy to make one myself
		
		if #gred.RequiredAddons == 0 then return end
		gred.ClientRequiredAddons = {}
		local IsMounted = steamworks.ShouldMountAddon
		local GetWorkshopFileInfo = steamworks.FileInfo
		
		for k,v in pairs(addons) do
			if !IsMounted(v) and v != addons[k+1] then
				tableinsert(gred.ClientRequiredAddons,v)
			end
		end
		
		if #gred.ClientRequiredAddons == 0 then return end
		
		local window = vgui.Create( "DFrame" )
		if ScrW() > 640 then -- Make it larger if we can.
			window:SetSize( ScrW()*0.9, ScrH()*0.9 )
		else
			window:SetSize( 640, 480 )
		end
		window:Center()
		window:SetTitle( "Gredwitch's Stuff - You need these addons installed AND enabled, or else the ones you have subscribed to will not work correctly!" )
		window:SetVisible( true )
		window:MakePopup()


		local Wwide = window:GetWide()
		local Wtall = window:GetTall()
		
		local button = vgui.Create( "DButton", window )
		button:SetText( "Close" )
		button.DoClick = function() window:Close() end
		button:SetSize( 100, 40 )
		button:SetPos( (Wwide - button:GetWide()) / 2, Wtall - button:GetTall() - 10 )
		
		local x = 110
		local y = 70
		
		for k,id in pairs(gred.ClientRequiredAddons) do
			GetWorkshopFileInfo(id,function(r)
				if x > Wwide - 110 then 
					x = 110
					y = y + 70
				end
				local b = vgui.Create( "DButton", window )
				b:SetText(r.title)
				b.DoClick = function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id="..id) end
				b:SetSize( 100, 40 )
				b:SetPos(x,y)
				x = x + 110
			end)
		end
	end
end)

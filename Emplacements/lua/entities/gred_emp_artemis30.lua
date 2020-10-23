AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]30mm Artemis 30"
ENT.Author				= "Gredwitch"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.NameToPrint			= "Artemis 30"

ENT.Sequential			= true
ENT.MuzzleEffect		= "muzzleflash_bar_3p"
ENT.ShotInterval		= 0.0375

ENT.AmmunitionTypes		= {
						{"Direct Hit","wac_base_30mm"},
						{"Time-fused","wac_base_30mm"},
}

ENT.OnlyShootSound		= true
ENT.ShootSound			= "gred_emp/common/20mm_01.wav"

ENT.PitchRate			= 40
ENT.YawRate				= 40
ENT.TurretPos			= Vector(0,0,64)
ENT.Ammo				= -1
ENT.HullModel			= "models/gredwitch/artemis30/artemis30_base_open.mdl"
ENT.AimsightModel		= "models/gredwitch/artemis30/artemis30_aimsight.mdl"
ENT.YawModel			= "models/gredwitch/artemis30/artemis30_shield.mdl"
ENT.TurretModel			= "models/gredwitch/artemis30/artemis30_gun.mdl"
ENT.WheelsModel			= "models/gredwitch/artemis30/artemis30_wheels.mdl"
ENT.AimSightPos			= Vector(-30,-11,80)
ENT.EmplacementType     = "MG"
ENT.TracerColor			= "Yellow"
ENT.Seatable			= true
ENT.SightPos			= Vector(70,0,-5)
ENT.IsAAA				= true
ENT.CanSwitchTimeFuse	= true
ENT.MaxViewModes		= 1
ENT.ViewPos				= Vector(0,0,37)
ENT.DisplayAimSightPos	= Vector(20,12,3)
ENT.DisplayPos			= Vector(11,14.8,3.8)
ENT.WheelsPos			= Vector(-80.8887,0,15.9966)
ENT.MaxRotation			= Angle(85,180)
ENT.MinRotation			= Angle(-5,-180)
ENT.ToggleableCarriage	= true


function ENT:AddDataTables()
	self:NetworkVar("Entity",10,"AimSight")
end

if CLIENT then
	local ply = LocalPlayer()
	local ang = Angle(0,-90,90)
	local w,h = 810,385
	local x,y = w*0.5,h*0.5
	local mat = CreateMaterial("artemis_screen","UnlitGeneric",{
		["$color"] = "[0.5 0.5 0.5]",
		
	})
	local RenderTab = {
		x = 0,
		y = 0,
		w = 1920,
		h = 1080,
		fov = 10,
		drawpostprocess = false,
		drawhud = false,
		drawmonitors = false,
		drawviewmodel = false,
		dopostprocess = false,
		bloomtone = false,
	}
	
	hook.Add("RenderScene","gred_emp_artemis_rendersceen",function(pos,ang,fov)
		ply = IsValid(ply) and ply or LocalPlayer()
		if !IsValid(ply.GredActiveEMP) then return end
		ply.GredActiveEMP:RenderScreen(pos,ang,fov)
	end)
	
	hook.Add("PostDrawTranslucentRenderables","gred_emp_artemis_PostDrawTranslucentRenderables",function()
		ply = IsValid(ply) and ply or LocalPlayer()
		if !IsValid(ply.GredActiveEMP) then return end
		ply.GredActiveEMP:Do3D2D()
	end)
	function ENT:Draw()
		self:DrawModel()
		ply = IsValid(ply) and ply or LocalPlayer()
		if ply == self:GetShooter() and self:GetViewMode() < self.MaxViewModes then
			ply.GredActiveEMP = self
			self:Do3D2D()
		else
			ply.GredActiveEMP = nil
		end
		
	end
	
	function ENT:Do3D2D()
		if self.Rt then
			local aimsight = self:GetAimSight()
			cam.Start3D2D(aimsight:LocalToWorld(self.DisplayPos),aimsight:LocalToWorldAngles(ang),0.01)
				mat:SetTexture("$basetexture",self.Rt)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(255,255,255,150)
				surface.DrawRect(x-100,y-2,90,4)
				surface.DrawRect(x+5.5,y-2,95,4)
							
				surface.DrawRect(x-5,y+5,4,90)
				surface.DrawRect(x-5,y-100,4,95)
				
				
				-- surface.DrawRect(x-15.5,y+100,30,4)
				-- surface.DrawRect(x-15.5,y-104,30,4)
				
				-- surface.DrawRect(x+100,y-15,4,30)
				-- surface.DrawRect(x-104,y-15,4,30)
			cam.End3D2D()
		end
	end
	
	function ENT:RenderScreen(pos,Ang,fov)
		self.Rt = GetRenderTarget("gred_emp_artemis30"..self.ENT_INDEX,1920,1080,false)
		local oldRT = render.GetRenderTarget()
		
		render.SetRenderTarget(self.Rt)
			render.Clear(0,0,0,255)
			surface.SetDrawColor(255,255,255,255)
			
			RenderTab.origin = self:GetAimSight():LocalToWorld(self.DisplayAimSightPos)
			RenderTab.angles = self:GetAngles()
			
			render.RenderView(RenderTab)
		render.SetRenderTarget(oldRT)
	end
	
	function ENT:ViewCalc(ply, pos, angles, fov)
		-- debugoverlay.Sphere(self:GetAimSight():LocalToWorld(self.DisplayAimSightPos),2,0.1,Color(255,255,255))
		local seat = self:GetSeat()
		local seatValid = IsValid(seat)
		if (!seatValid and GetConVar("gred_sv_enable_seats"):GetInt() == 1) then return end
		
		if self:GetViewMode() == self.MaxViewModes then
			local view = {}
			view.origin = self:LocalToWorld(self.SightPos)
			view.angles = self:GetAngles()
			view.fov = 40
			view.drawviewer = false

			return view
		else
			if seatValid then
				local view = {}
				view.origin = seat:LocalToWorld(self.ViewPos)
				view.angles = ply:EyeAngles()
				view.angles.r = self:GetAngles().r
				view.fov = fov
				view.drawviewer = false
		 
				return view
			end
		end
	end

	function ENT:HUDPaint(ply,viewmode)
		if viewmode == self.MaxViewModes then
			local ScrW,ScrH = ScrW(),ScrH()
			-- surface.SetDrawColor(255,255,255,255)
			-- surface.SetTexture(surface.GetTextureID(self.SightTexture))
			-- surface.DrawTexturedRect((-(ScrW*1.25-ScrW)*0.5),(-(ScrW*1.25-ScrH)*0.5),ScrW*1.25,ScrW*1.25)
			return ScrW,ScrH
		end
	end
else
	-- function ENT:CustomShootAnim(val)
		-- self:ResetSequence("shoot_"..(val > 1 and "r" or "l"))
	-- end
	
	function ENT:SpawnFunction( ply, tr, ClassName )
		if (  !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 16
		local ent = ents.Create(ClassName)
		ent:SetPos(SpawnPos)
		ent.Owner = ply
		ent.Spawner = ply
		ent:Spawn()
		ent:Activate()
		return ent
	end
	
	function ENT:OnTick(ct,ply,botmode)
		local aimsight = self:GetAimSight()
		local ang = aimsight:GetAngles()
		ang.p = self:GetAngles().p
		aimsight:SetAngles(ang)
	end

	function ENT:AddOnPartsInit(pos,ang,hull,yaw)
		local aimsight = ents.Create("gred_prop_emp")
		aimsight.GredEMPBaseENT = self
		aimsight:SetModel(self.AimsightModel)
		aimsight:SetAngles(yaw:GetAngles())
		aimsight:SetPos(yaw:LocalToWorld(self.AimSightPos))
		aimsight:Spawn()
		aimsight:Activate()
		aimsight:SetParent(yaw)
		
		self:SetAimSight(aimsight)
		-- aimsight:SetNoDraw(true)
		self:AddEntity(aimsight)
	end
end
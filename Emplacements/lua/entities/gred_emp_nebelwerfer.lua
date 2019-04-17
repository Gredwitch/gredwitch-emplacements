AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Gredwitch's Stuff"
ENT.PrintName 			= "[EMP]150mm Nebelwerfer 41"

ENT.Author				= "Gredwitch"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.NameToPrint			= "Nebelwerfer"
ENT.MuzzleEffect		= "ins_weapon_at4_frontblast"
ENT.AmmunitionTypes		= {
						{"HE","gb_rocket_nebel"},
						{"Smoke","gb_rocket_nebel"}
}
ENT.ShotInterval		= 1

ENT.ShootSound			= "gred_emp/common/empty.wav"

ENT.HullModel			= "models/gredwitch/nebelwerfer/nebelwerfer_base.mdl"
ENT.TurretModel			= "models/gredwitch/nebelwerfer/nebelwerfer_tubes.mdl"
ENT.Sequential			= true

ENT.EmplacementType		= "Cannon"
ENT.Ammo				= 6
ENT.TurretPos			= Vector(0,0,43.8)
ENT.SightPos			= Vector(0,30,22)
ENT.MaxViewModes		= 1
ENT.OffsetAngle			= Angle(-1,180)
ENT.MaxRotation			= Angle(27,45)

ENT.SmokeExploSNDs		= {}
ENT.SmokeExploSNDs[1]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav"
ENT.SmokeExploSNDs[2]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav"
ENT.SmokeExploSNDs[3]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav"
ENT.SmokeExploSNDs[4]		=  "gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav"

function ENT:AddDataTables()
	self:NetworkVar("Float",11,"MaxRange", { KeyName = "MaxRange", Edit = { type = "Float", order = 0,min = 0, max = 5, category = "Ammo"} } )
	self:NetworkVar("Float",12,"ReloadTime", { KeyName = "ReloadTime", Edit = { type = "Float", order = 0,min = 0, max = 300, category = "Ammo"} } )
	self:NetworkVar("Bool",10,"AutoFire", { KeyName = "AutoFire", Edit = {type = "Boolean", order = 0, category = "Ammo"} } )
	self:SetMaxRange(2)
	self:SetReloadTime(10)
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
 	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:OnTick(ct,ply,botmode,IsShooting,canShoot,ammo,IsReloading,shouldSetAngles)
	if canShoot or !shouldSetAngles then
		if self:GetAutoFire() then
			self.AutoFire = true
		end
	end
	if !IsShooting and self.AutoFire then
		if self:CanShoot(ammo,ct,ply,IsReloading) then
			self:fire(ammo,ct,ply,IsReloading)
		end
		if self:GetAmmo() <= 0 then self.AutoFire = false end
	end
end

function ENT:PlayAnim()
	self:SetIsReloading(true)
	timer.Simple(self:GetReloadTime(),function()
		if not IsValid(self) then return end
		self:SetAmmo(self.Ammo)
		self:SetIsReloading(false)
	end)
end

function ENT:InitAttachments()
	local attachments = self:GetAttachments()
	local tableinsert = table.insert
	local startsWith = string.StartWith
	local t
	for k,v in pairs(attachments) do
		if startsWith(v.name,"rocket") then
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretMuzzles,t)
			
		elseif startsWith(v.name,"shelleject") then
		
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretEjects,t)
		end
	end
end

function ENT:InitAttachmentsCL()
	local tableinsert = table.insert
	local startsWith = string.StartWith
	local t
	for k,v in pairs(self:GetAttachments()) do
		if startsWith(v.name,"rocket") then
		
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretMuzzles,t)
			
		elseif startsWith(v.name,"shelleject") then
		
			t = self:GetAttachment(self:LookupAttachment(v.name))
			t.Pos = self:WorldToLocal(t.Pos)
			t.Ang = self:WorldToLocalAngles(t.Ang)
			tableinsert(self.TurretEjects,t)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		local ang = self:GetAngles()
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = Angle(ang.r,ang.y+270,ang.p)
		view.fov = 35
		view.drawviewer = false

		return view
	end
end
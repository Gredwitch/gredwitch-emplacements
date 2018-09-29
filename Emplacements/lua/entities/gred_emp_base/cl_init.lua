include("shared.lua")
function ENT:Initialize()
	self.MuzzleAttachments = {}
	self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
	self.HookupAttachment=self:LookupAttachment("hookup")
	for v=1,self.MuzzleCount do
		if v>1 then
			self.MuzzleAttachments[v] = self:LookupAttachment("muzzle"..v.."")
		end
	end
	self.shootPos=self:GetDTEntity(1)
	
end

local function MouseSensitivity(s)
	local ply = LocalPlayer()
	if not ply.Gred_Emp_Class then return end
	if string.StartWith(ply.Gred_Emp_Class,"gred_emp") then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) and ply == ent:GetShooter() then
				return GetConVar("gred_cl_emp_mouse_sensitivity"):GetFloat() -- 0.2
			end
		end
	end
end
hook.Add("AdjustMouseSensitivity", "gred_emp_mouse", MouseSensitivity)

function ENT:Draw()
	self:DrawModel()
end

net.Receive("gred_net_emp_getplayer",function()
	local ply = net.ReadEntity()
	local self = net.ReadEntity()
	
	ply.Gred_Emp_Ent = self
	ply.Gred_Emp_Class = self:GetClass()
end)

net.Receive("gred_net_emp_muzzle_fx",function()
	local self = net.ReadEntity()
	if !IsValid(self) then return end
	canEjectShell = self.EmplacementType == "MG" and GetConVar("gred_cl_shelleject"):GetInt() == 1 and self.HasShellEject
	if canEjectShell then
		self.ShellEject = {}
		self.ShellEject[1] = self:LookupAttachment("shelleject")
	end
	self.MuzzleAttachments = {}
	self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
	for v=1,self.MuzzleCount do
		if v>1 then
			self.MuzzleAttachments[v] = self:LookupAttachment("muzzle"..v.."")
			if canEjectShell and self.MultpipleShellEject then self.ShellEject[v] = self:LookupAttachment("shelleject"..v.."") end
		end
	end
	if self.Sequential then
		if m == nil or m > self.MuzzleCount then m = 1 end
		attPos = self:GetAttachment(self.MuzzleAttachments[m]).Pos
		attAng = self:GetAttachment(self.MuzzleAttachments[m]).Ang
		
		if GetConVar("gred_cl_altmuzzleeffect"):GetInt() == 1 or 
		(self.EmplacementType != "MG" and self.EmplacementType != "Mortar") then
			ParticleEffect(self.MuzzleEffect,attPos,attAng,nil)
		else
			local effectdata=EffectData()
			effectdata:SetOrigin(attPos)
			effectdata:SetAngles(attAng)
			effectdata:SetEntity(self)
			effectdata:SetScale(1)
			util.Effect("MuzzleEffect", effectdata)
	    end
		if canEjectShell then
			local effectdata = EffectData()
			local eject = self:GetAttachment(self.ShellEject[m])
			effectdata:SetOrigin(eject.Pos)
			effectdata:SetAngles(eject.Ang + self.EjectAngle)
			if self.BulletType == "wac_base_7mm" then
				util.Effect("ShellEject",effectdata)
			else
				util.Effect("RifleShellEject",effectdata)
			end
		end
		m = m + 1
	else
		for m = 1,self.MuzzleCount do
			att = self:GetAttachment(self.MuzzleAttachments[m])
			attPos = att.Pos
			attAng = att.Ang
			if GetConVar("gred_cl_altmuzzleeffect"):GetInt() == 1 or 
			(self.EmplacementType != "MG" and self.EmplacementType != "Mortar") then
			
				ParticleEffect(self.MuzzleEffect,attPos,attAng,nil)
			else
				local effectdata=EffectData()
				effectdata:SetOrigin(attPos)
				effectdata:SetAngles(attAng)
				effectdata:SetEntity(self)
				effectdata:SetScale(1)
				util.Effect("MuzzleEffect", effectdata)
			end
			if canEjectShell then
				local effectdata = EffectData()
				local eject = nil
				if self.MultpipleShellEject then
					eject = self:GetAttachment(self.ShellEject[m])
				else
					eject = self:GetAttachment(self.ShellEject[1])
				end
				effectdata:SetOrigin(eject.Pos)
				effectdata:SetAngles(eject.Ang + self.EjectAngle)
				effectdata:SetEntity(self)
				if self.BulletType == "wac_base_7mm" then
					util.Effect("ShellEject",effectdata)
				else
					util.Effect("RifleShellEject",effectdata)
				end
			end
			self:StopParticlesWithNameAndAttachment("weapon_muzzle_smoke",self.MuzzleAttachments[m])
			ParticleEffectAttach("weapon_muzzle_smoke",4,self,self.MuzzleAttachments[m])
		end
	end
end)
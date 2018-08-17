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
	
	if self.IsInDev then
		if GetConVar("gred_cl_devemp_warnings"):GetInt() == 1 then
			-- local o = self:GetOwner()
			chat.AddText(Color(255,0,0),"This emplacement is currently in development, so some features are missing on it.")
			chat.AddText(Color(255,0,0),"CURRENT FEATURES NEEDED : ")
			chat.AddText(Color(255,0,0)," - The ability to seat on the emplacement")
			chat.AddText(Color(255,0,0)," - A third person aiming system")
			chat.AddText(Color(255,0,0),"To remove this warning message, simply set gred_cl_devemp_warnings to 0 in the developer console.")
		end
		self.IsInDev = false
	end
end

function ENT:Draw()
	self:DrawModel()
end

net.Receive("gred_net_emp_muzzle_fx",function()
	local self = net.ReadEntity()
	self.MuzzleAttachments = {}
	self.MuzzleAttachments[1] = self:LookupAttachment("muzzle")
	self.HookupAttachment=self:LookupAttachment("hookup")
	for v=1,self.MuzzleCount do
		if v>1 then
			self.MuzzleAttachments[v] = self:LookupAttachment("muzzle"..v.."")
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
		m = m + 1
	else
		for m = 1,self.MuzzleCount do
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
		end
	end
end)
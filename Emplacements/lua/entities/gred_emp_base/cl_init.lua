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


function ENT:Draw()
	self:DrawModel()
end
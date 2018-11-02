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
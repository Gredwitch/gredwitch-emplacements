if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("TurretBlockAttackToggle")
	
elseif CLIENT then
	local shouldBlockAttack=false
	net.Receive("TurretBlockAttackToggle",function()
		local blockBit=net.ReadBit()
		if blockBit==1 then
			shouldBlockAttack=true
		elseif blockBit==0 then
			shouldBlockAttack=false
		end
	end)
	
	hook.Add("CreateMove","gred_turretblock",function(cmd)
		local lp = LocalPlayer()
		if shouldBlockAttack and IsValid(lp) and bit.band(cmd:GetButtons(), IN_ATTACK) > 0 then
			cmd:SetButtons(bit.bor(cmd:GetButtons() - IN_ATTACK, IN_BULLRUSH))
		end
	end)
end

hook.Add("SetupMove", "gred_emp_calcmouse", function(ply,mv,cmd)
	if not ply.Gred_Emp_Class then return end
	if string.StartWith(ply.Gred_Emp_Class,"gred_emp") then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) and ply == ent:GetShooter() then
				ent.CalcMouse = cmd:GetMouseY() + cmd:GetMouseX()
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "gred_emp_takedmg", function(target,dmginfo)
	if target.GredEMPBaseENT != nil then
		target.GredEMPBaseENT:TakeDamageInfo(dmginfo)
	end
end)

local function CalcView(ply, pos, angles, fov)
	if ply.Gred_Emp_Class == "gred_emp_artemis30" then
		local ent = ply.Gred_Emp_Ent
		if IsValid(ent) then
			if ent:ShooterStillValid() and IsValid(ent:GetDTEntity(2)) and ent:GetShooter() == ply then
				if ent:GetDTEntity(2):GetThirdPersonMode() then
					local view = {}

					view.origin = pos + ent:GetForward()*ent.ViewForward + ent:GetRight()*ent.ViewRight + ent:GetUp()*ent.ViewUp
					view.angles = angles
					view.fov = fov
					view.drawviewer = true

					return view
				end
			end
		end
	end
end
hook.Add("CalcView", "gred_emp_calcview", CalcView)

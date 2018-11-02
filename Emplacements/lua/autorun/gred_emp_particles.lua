AddCSLuaFile()

PrecacheParticleSystem("muzzleflash_bar_3p")
PrecacheParticleSystem("muzzleflash_garand_3p")
PrecacheParticleSystem("muzzleflash_mg42_3p")
PrecacheParticleSystem("ins_weapon_at4_frontblast")
PrecacheParticleSystem("ins_weapon_rpg_dust")
PrecacheParticleSystem("gred_arti_muzzle_blast")
PrecacheParticleSystem("gred_mortar_explosion_smoke_ground")
PrecacheParticleSystem("weapon_muzzle_smoke")
PrecacheParticleSystem("ins_ammo_explosionOLD")
PrecacheParticleSystem("gred_ap_impact")
PrecacheParticleSystem("AP_impact_wall")

if SERVER then
	util.AddNetworkString("TurretBlockAttackToggle")
	util.AddNetworkString("gred_net_emp_muzzle_fx")
	util.AddNetworkString("gred_net_emp_getplayer")
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
	
	net.Receive("gred_net_emp_getplayer",function()
		local ply = net.ReadEntity()
		local self = net.ReadEntity()
		local class = self:GetClass()
		if class == "worldspawn" then
			ply.Gred_Emp_Ent = nil
			ply.Gred_Emp_Class = nil
		else
			ply.Gred_Emp_Ent = self
			ply.Gred_Emp_Class = class
		end
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

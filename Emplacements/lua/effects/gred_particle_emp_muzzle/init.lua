function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	canEjectShell = ent.EmplacementType == "MG" and GetConVar("gred_cl_shelleject"):GetInt() == 1 and ent.HasShellEject
	if canEjectShell then
		ent.ShellEject = {}
		ent.ShellEject[1] = ent:LookupAttachment("shelleject")
	end
	ent.MuzzleAttachments = {}
	ent.MuzzleAttachments[1] = ent:LookupAttachment("muzzle")
	for v=1,ent.MuzzleCount do
		if v>1 then
			ent.MuzzleAttachments[v] = ent:LookupAttachment("muzzle"..v.."")
			if canEjectShell and ent.MultpipleShellEject then ent.ShellEject[v] = ent:LookupAttachment("shelleject"..v.."") end
		end
	end
	if ent.Sequential then
		if m == nil or m > ent.MuzzleCount then m = 1 end
		attPos = ent:GetAttachment(ent.MuzzleAttachments[m]).Pos
		attAng = ent:GetAttachment(ent.MuzzleAttachments[m]).Ang
		
		if GetConVar("gred_cl_altmuzzleeffect"):GetInt() == 1 or 
		(ent.EmplacementType != "MG" and ent.EmplacementType != "Mortar") then
			ParticleEffect(ent.MuzzleEffect,attPos,attAng,nil)
		else
			local effectdata=EffectData()
			effectdata:SetOrigin(attPos)
			effectdata:SetAngles(attAng)
			effectdata:SetEntity(ent)
			effectdata:SetScale(1)
			util.Effect("MuzzleEffect", effectdata)
		end
		if canEjectShell then
			local effectdata = EffectData()
			local eject = ent:GetAttachment(ent.ShellEject[m])
			effectdata:SetOrigin(eject.Pos)
			effectdata:SetAngles(eject.Ang + ent.EjectAngle)
			if ent.BulletType == "wac_base_7mm" then
				util.Effect("ShellEject",effectdata)
			else
				util.Effect("RifleShellEject",effectdata)
			end
		end
		m = m + 1
	else
		for m = 1,ent.MuzzleCount do
			att = ent:GetAttachment(ent.MuzzleAttachments[m])
			attPos = att.Pos
			attAng = att.Ang
			if GetConVar("gred_cl_altmuzzleeffect"):GetInt() == 1 or 
			(ent.EmplacementType != "MG" and ent.EmplacementType != "Mortar") then
			
				ParticleEffect(ent.MuzzleEffect,attPos,attAng,nil)
			else
				local effectdata=EffectData()
				effectdata:SetOrigin(attPos)
				effectdata:SetAngles(attAng)
				effectdata:SetEntity(ent)
				effectdata:SetScale(1)
				util.Effect("MuzzleEffect", effectdata)
			end
			if canEjectShell then
				local effectdata = EffectData()
				local eject = nil
				if ent.MultpipleShellEject then
					eject = ent:GetAttachment(ent.ShellEject[m])
				else
					eject = ent:GetAttachment(ent.ShellEject[1])
				end
				effectdata:SetOrigin(eject.Pos)
				effectdata:SetAngles(eject.Ang + ent.EjectAngle)
				effectdata:SetEntity(ent)
				if ent.BulletType == "wac_base_7mm" then
					util.Effect("ShellEject",effectdata)
				else
					util.Effect("RifleShellEject",effectdata)
				end
			end
			ent:StopParticlesWithNameAndAttachment("weapon_muzzle_smoke",ent.MuzzleAttachments[m])
			ParticleEffectAttach("weapon_muzzle_smoke",4,ent,ent.MuzzleAttachments[m])
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end
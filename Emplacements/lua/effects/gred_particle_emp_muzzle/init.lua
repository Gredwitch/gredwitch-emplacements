function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	
	canExtractShell = ent.EmplacementType == "MG" and GetConVar("gred_cl_shelleject"):GetInt() == 1 and table.Count(ent.TurretEjects) > 0
	
	if ent.Sequential then
		ent:CheckMuzzle()
		local v = ent:GetCurrentMuzzle()
		attPos = ent:LocalToWorld(ent.TurretMuzzles[v].Pos)
		attAng = ent:LocalToWorldAngles(ent.TurretMuzzles[v].Ang)
		
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
		if canExtractShell then
			ent:CheckExtractor()
			local effectdata = EffectData()
			local curExtractor = ent:GetCurrentExtractor()
			
			local eject = ent.TurretEjects[ent:GetCurrentExtractor(curExtractor)]
			
			effectdata:SetOrigin(ent:LocalToWorld(eject.Pos))
			effectdata:SetAngles(ent:LocalToWorldAngles(eject.Ang + ent.ExtractAngle))
			
			if ent.AmmunitionType == "wac_base_7mm" then
				util.Effect("ShellEject",effectdata)
			else
				util.Effect("RifleShellEject",effectdata)
			end
			
			ent:SetCurrentExtractor(curExtractor + 1)
		end
	else
		for k,v in pairs(ent.TurretMuzzles) do
			attPos = ent:LocalToWorld(v.Pos)
			attAng = ent:LocalToWorldAngles(v.Ang)
			
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
		end
		if canExtractShell then
			
			for a,b in pairs(ent.TurretEjects) do
				local effectdata = EffectData()
				
				effectdata:SetOrigin(ent:LocalToWorld(b.Pos))
				effectdata:SetAngles(ent:LocalToWorldAngles(b.Ang + ent.ExtractAngle))
				
				if ent.AmmunitionType == "wac_base_7mm" then
					util.Effect("ShellEject",effectdata)
				else
					util.Effect("RifleShellEject",effectdata)
				end
			end
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end
AddCSLuaFile()

if GetConVar("gred_emp_nebel_reloadtime") == nil then
	CreateConVar("gred_emp_nebel_reloadtime", "10", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )
end
if GetConVar("gred_emp_nebel_range_divider") == nil then
	CreateConVar("gred_emp_nebel_range_divider", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )
end
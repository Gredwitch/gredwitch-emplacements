AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED,FCVAR_ARCHIVE, FCVAR_NOTIFY }
CreateConVar("gred_sv_nebel_reloadtime"				,  "10" , GRED_SVAR)
CreateConVar("gred_sv_nebel_range_divider"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_carriage_collision"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_mortar_shellspawnaltitude"	, "1000", GRED_SVAR)
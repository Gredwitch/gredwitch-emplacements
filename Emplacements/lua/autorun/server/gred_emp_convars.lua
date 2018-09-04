AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_nebel_reloadtime"				,  "10" , GRED_SVAR)
CreateConVar("gred_sv_nebel_range_divider"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_carriage_collision"			,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_mortar_shellspawnaltitude"	, "1000", GRED_SVAR)
CreateConVar("gred_sv_shell_remove_time"			,  "10" , GRED_SVAR)
CreateConVar("gred_sv_limitedammo"					,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_cantakemgbase"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_enable_dev_emp"				,  "1"  , GRED_SVAR)

resource.AddWorkshop(1484100983) -- Emplacements materials
resource.AddWorkshop(1391460275) -- Emplacements
resource.AddWorkshop(1131455085) -- Base addon
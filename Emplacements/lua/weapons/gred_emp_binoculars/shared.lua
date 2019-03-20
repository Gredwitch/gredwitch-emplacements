SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false

SWEP.PrintName					= "[EMP]Binoculars"
SWEP.strikedalay				= 0
SWEP.strikeentity     	  		= ""
SWEP.Primary.Ammo				= ""
SWEP.ShellCount					= 0
SWEP.ExactShellCount			= nil
SWEP.Team						= ""
SWEP.StrikeString				= ""
SWEP.Bomber						= false
SWEP.RocketRun					= false

SWEP.Smoke						= false
SWEP.RandomPos					= 0
SWEP.LoopTimerTime1				= 0
SWEP.LoopTimerTime2				= 0
SWEP.FireRate					= 200

SWEP.SndLang					= ""
SWEP.SndAccent                  = 0
SWEP.ModelTimer                 = 0
SWEP.CustomAngle				= 50

SWEP.Category					= "Gredwitch's SWEPs"
SWEP.Author						= "Gredwitch"
SWEP.Contact					= "qhamitouche@gmail.com"
SWEP.Purpose					= "Destroy the enemy"
SWEP.Instructions				= "Right ckick to look through the binoculars, left click to call in a strike."
SWEP.MuzzleAttachment			= "1"
SWEP.ShellEjectAttachment		= "2"
SWEP.Slot						= 4
SWEP.SlotPos					= 35
SWEP.DrawAmmo					= true
SWEP.DrawWeaponInfoBox			= false
SWEP.BounceWeaponIcon   		= false
SWEP.DrawCrosshair				= false
SWEP.Weight						= 50
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= true
SWEP.XHair						= false
SWEP.HoldType 					= "camera"

SWEP.ViewModelFOV				= 70
SWEP.WaitGuns					= 10
SWEP.GunCount					= 1
SWEP.GunOffset					= 50
SWEP.ViewModelFlip				= false
SWEP.ViewModel					= "models/weapons/v_invisib.mdl"
SWEP.WorldModel					= "models/weapons/w_binos.mdl"
SWEP.Base 						= "gred_scoped_base"
SWEP.PreSound 					= nil
SWEP.PreSoundName				= nil
SWEP.PreSndPossibilities		= nil
SWEP.PreSndFormat				= nil

SWEP.Primary.Sound				= Sound("weapons/satellite/targaquired.mp3")
SWEP.Primary.RPM				= 10
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.KickUp				= 1
SWEP.Primary.KickDown			= 1
SWEP.Primary.KickHorizontal		= 1
SWEP.Primary.Automatic			= false

SWEP.Secondary.ScopeZoom		= 6
SWEP.Secondary.UseParabolic		= false
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot		= true		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	
SWEP.GunRun						= false
SWEP.GunSnd						= ""
SWEP.AircraftModel				= "models/mm1/box.mdl"

SWEP.data 						= {}
SWEP.data.ironsights			= 1
SWEP.ScopeScale 				= 1

SWEP.PoorBastard 				= false
SWEP.NextShoot 					= 0

SWEP.RadioCallInSnd				= ""

SWEP.IronSightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.IronSightsAng = Vector(50.353, 17.884, -19.428)
SWEP.SightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.SightsAng = Vector(50.353, 17.884, -19.428)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-21.994, 0, 0)

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-19.507, 0, 0) },
	["r-index-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-71.792, 0, 0) },
	["r-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.483, 1.309, 0) },
	["l-upperarm-movement"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.88), angle = Angle(0, 0, 0) },
	["Da Machete"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.263, -1.826), angle = Angle(0, 0, 0) },
	["r-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.507, 0, 0) },
	["r-pinky-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-47.32, 0, 0) },
	["r-ring-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-54.065, 0, 0) },
	["r-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0) },
	["r-thumb-tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.666, 0, 0) },
	["r-upperarm-movement"] = { scale = Vector(1, 1, 1), pos = Vector(7.394, 2.101, -9.54), angle = Angle(-10.502, -12.632, 68.194) },
	["r-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.526, 0, 0) },
	["r-middle-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-37.065, 0, 0) },
	["r-thumb-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.816, 18.775, -30.143) },
	["l-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0) },
	["r-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.982, 0, 0) }
}

SWEP.VElements = {
	["binos"] = { type = "Model", model = "models/weapons/binos.mdl", bone = "r-thumb-low", rel = "", pos = Vector(3.907, -0.109, -1.125), angle = Angle(-2.829, 27.281, 105.791), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:GetCallInSound()
	if GetConVar("gred_sv_artisweps_spam"):GetInt() <= 0 then
		local ct = CurTime()
		local rand = math.random(1,2)
		if !self.Owner.LastHit then
			suppressed = "unsuppressed/"
		else
			if self.Owner.LastHit + 7 <= ct then
				suppressed = "unsuppressed/"
			else
				suppressed = "suppressed/"
			end
		end
		if self.SndLang == "English" then
			if self.SndAccent == 1 then
				CallSnd = "english/"..suppressed..self.RadioCallInSnd..rand..".wav"
			else
				CallSnd = "american_01/"..suppressed..self.RadioCallInSnd..rand..".wav"
			end
		else
			CallSnd = "german_01/"..suppressed..self.RadioCallInSnd..rand..".wav"
		end
		return CallSnd
	else return 0 end
end

local SubTitles = {
	[1] = { "american_01/unsuppressed/requeststraferun1.wav", "Station this is Squad Lead, can you get air to do a gun run on this position?" },
	[2] = { "american_01/unsuppressed/requeststraferun2.wav", "Station, we're gonna need air to strafe this area, can you let 'em know?" },
	[3] = { "american_01/suppressed/requeststraferun1.wav", "Light it up! Shoot those sons of bitches!" },
	[4] = { "american_01/suppressed/requeststraferun2.wav", "We need air support! Shoot the bastards, gun 'em down!" },
	
	[5] = { "american_01/unsuppressed/requestartillery1.wav", "Station this is Squad Lead, we need artillery on this location, over." },
	[6] = { "american_01/unsuppressed/requestartillery2.wav", "Station this is Squad Leader, can you hit this position with artillery?" },
	[7] = { "american_01/suppressed/requestartillery1.wav", "We need that artillery right now, send it!" },
	[8] = { "american_01/suppressed/requestartillery2.wav", "We need fire support, just freakin' fire your guns already!" },
	
	[9]  = { "american_01/suppressed/requestcarpetbomb1.wav", "Get Air over here quick, we need to drop some bombs on 'em!" },
	[10] = { "american_01/suppressed/requestcarpetbomb2.wav", "Bomb em'! Send Air, blow 'em all to hell!" },
	[11] = { "american_01/unsuppressed/requestcarpetbomb1.wav", "Station, this is Squad Lead. We need a bombing run on this location, you got it?" },
	[12] = { "american_01/unsuppressed/requestcarpetbomb2.wav", "Station, we're gonna need Air to bomb this position. Get them over here quick!" },
	
	[13] = { "american_01/suppressed/requestsmokeartillery1.wav", "We can't do shit unless you give us some smoke cover!" },
	[14] = { "american_01/suppressed/requestsmokeartillery2.wav", "Look, if you're not real busy, smoke cover would be fucking fantastic!" },
	[15] = { "american_01/unsuppressed/requestsmokeartillery1.wav", "Station this is Squad Lead, can you get us some smoke cover right here, over." },
	[16] = { "american_01/unsuppressed/requestsmokeartillery2.wav", "Station this is Squad Leader, can you put smoke right here, we need cover." },
	
	[17] = { "german_01/suppressed/requestartillery1.wav", "Put it right here! Send these bastards to Hell!" },
	[18] = { "german_01/suppressed/requestartillery2.wav", "We need artillery right now, God damn it, over!" },
	[19] = { "german_01/unsuppressed/requestartillery1.wav", "Station, this is Gruppenführer, I need artillery on this position, do you copy?" },
	[20] = { "german_01/unsuppressed/requestartillery2.wav", "Station, this is Gruppenführer, we need a barrage on this position, over." },
	
	[21] = { "german_01/unsuppressed/requestcarpetbomb1.wav", "Station, we need air support to bomb this area, over." },
	[22] = { "german_01/unsuppressed/requestcarpetbomb2.wav", "Station, this is Gruppenführer, send bombers here, over." },
	[23] = { "german_01/suppressed/requestcarpetbomb1.wav", "We need air support! Drop the bombs! Hurry!" },
	[24] = { "german_01/suppressed/requestcarpetbomb2.wav", "Just bomb them, come on! It can't be that hard!" },
	
	[25] = { "german_01/unsuppressed/requestsmokeartillery1.wav", "Station, this is Gruppenführer, we need a smokescreen on this position, do you copy?" },
	[26] = { "german_01/unsuppressed/requestsmokeartillery2.wav", "Station, this is Gruppenführer, can you fire a smoke barrage at this location, over." },
	[27] = { "german_01/suppressed/requestsmokeartillery1.wav", "We need cover, damn it! Send a smokescreen on this position, over!" },
	[28] = { "german_01/suppressed/requestsmokeartillery2.wav", "We're totally exposed! Put a smokescreen on this location!" },
	
	[29] = { "german_01/unsuppressed/requeststukadive1.wav", "Station, this is Gruppenführer, we need a Stuka strike on this position, over." },
	[30] = { "german_01/unsuppressed/requeststukadive2.wav", "Station, this is Gruppenführer, send the Stuka, give it to 'em!" },
	[31] = { "german_01/suppressed/requeststukadive1.wav", "Stuka! Send a Stuka over God damn it!" },
	[32] = { "german_01/suppressed/requeststukadive2.wav", "I've had enough of this! Send the Stuka!" },
	
	[33] = { "english/suppressed/requesttyphoonstrike1.wav", "I need a bloody Typhoon on my target! Obliterate these bastards!" },
	[34] = { "english/suppressed/requesttyphoonstrike2.wav", "Station! I want a shit ton of rockets on this position! Now damn it!" },
	[35] = { "english/unsuppressed/requesttyphoonstrike1.wav", "Station this is Section Commander, requesting immediate rocket run on my target, over." },
	[36] = { "english/unsuppressed/requesttyphoonstrike2.wav", "Station come in, can you sick a Typhoon on this position, over." },
	
	[37] = { "english/suppressed/requestincendiaryartillery1.wav", "Requesting immediate incendiary barrage on my target, burn 'em to a bloody crisp!" },
	[38] = { "english/suppressed/requestincendiaryartillery2.wav", "Bollocks to protocol get me a rain of burny shit down here now! Torch these fuckers!" },
	[39] = { "english/unsuppressed/requestincendiaryartillery1.wav", "Station this is Section Commander, incendiary strike my target, over." },
	[40] = { "english/unsuppressed/requestincendiaryartillery2.wav", "Commander to Station, got a bunch of Krauts that need roasting. Can you assist, over?" },
	
	[41] = { "english/suppressed/requestgasartillery1.wav", "Command! Drop some mustard gas on these handbastards!" },
	[42] = { "english/suppressed/requestgasartillery2.wav", "Damn it, I do not care anymore! Use gas! Suffocate the wankers!" },
	[43] = { "english/unsuppressed/requestgasartillery1.wav", "Command, do you read? We need mustard gas [] of this target, over!" },
	[44] = { "english/unsuppressed/requestgasartillery2.wav", "Command, send the gas. Target is here, over." },
	
	[45] = { "/radio/axis/airsupportnotvalidtarget1.ogg", "Fire mission denied, Gruppenführer. We can't fire there." },
	[46] = { "/radio/axis/airsupportnotvalidtarget2.ogg", "Sorry, we can't fire there." },
	[47] = { "/radio/axis/airsupportnotvalidtarget3.ogg", "Negative, Gruppenführer. Unable to fire there." },
	[48] = { "/radio/axis/airsupportnotvalidtarget4.ogg", "Negative, Gruppenführer. Our guns can't fire there." },
	[49] = { "/radio/axis/airsupportnotvalidtarget5.ogg", "Uh, not sure where you mean. That's not a valid target." },
	
	[50] = { "/radio/axis/artillerybegin1.ogg", "Understood. Artillery is on its way." },
	[51] = { "/radio/axis/artillerybegin2.ogg", "Roger that, Gruppenführer. Here comes the barrage." },
	[52] = { "/radio/axis/artillerybegin3.ogg", "No problem. All you had to do was ask." },
	[53] = { "/radio/axis/artillerybegin4.ogg", "Understood. Keep your heads down, men." },
	[54] = { "/radio/axis/artillerybegin5.ogg", "Artillery fire is coming in a sec. Hold on to your butts!" },
	
	[55] = { "/radio/axis/artillerybeginsmoke1.ogg", "Understood, Gruppenführer. Smoke on its way." },
	[56] = { "/radio/axis/artillerybeginsmoke2.ogg", "Roger that. Smoke barrage going out. Hang on." },
	[57] = { "/radio/axis/artillerybeginsmoke3.ogg", "Roger that, Gruppenführer. Smoke is on the way." },
	[58] = { "/radio/axis/artillerybeginsmoke4.ogg", "Smoke barrage on its way. Get yourselves ready." },
	[59] = { "/radio/axis/artillerybeginsmoke5.ogg", "Understood. Here comes the smoke." },
	
	[60] = { "/radio/axis/artillerydoesnotcopy1.ogg", "Say again, Gruppenführer. We did not understand your last transmission." },
	[61] = { "/radio/axis/artillerydoesnotcopy2.ogg", "Say again, Gruppenführer? The transmission was cut off." },
	[62] = { "/radio/axis/artillerydoesnotcopy3.ogg", "Gruppenführer, come in. Gruppenführer, we did not understand you." },
	[63] = { "/radio/axis/artillerydoesnotcopy4.ogg", "Please say again. We did not understand your request." },
	[64] = { "/radio/axis/artillerydoesnotcopy5.ogg", "Gruppenführer, are you still there? We didn't get that." },
	
	[65] = { "/radio/axis/artillerynotvalidtarget1.ogg", "Fire mission denied, Gruppenführer. We can't fire there." },
	[66] = { "/radio/axis/artillerynotvalidtarget2.ogg", "Sorry, we can't fire there." },
	[67] = { "/radio/axis/artillerynotvalidtarget3.ogg", "Negative, Gruppenführer. Our guns can't fire there." },
	[68] = { "/radio/axis/artillerynotvalidtarget4.ogg", "Uh, not sure where you mean. That's not a valid target." },
	[69] = { "/radio/axis/artillerynotvalidtarget5.ogg", "Negative, Gruppenführer. Unable to fire there." },
	
	[70] = { "/radio/axis/carpetbombbegin1.ogg", "Alright, roger that. Bombs are on the way." },
	[71] = { "/radio/axis/carpetbombbegin2.ogg", "Plane is coming. Get ready." },
	[72] = { "/radio/axis/carpetbombbegin3.ogg", "Roger that, Gruppenführer. Bombardment will begin shortly." },
	[73] = { "/radio/axis/carpetbombbegin4.ogg", "Get ready for an incoming airstrike." },
	[74] = { "/radio/axis/carpetbombbegin5.ogg", "Copy that, sending a plane now." },
	
	[75] = { "/radio/axis/stukadivebegin1.ogg", "Gruppenführer, confirmed. Stuka on the way." },
	[76] = { "/radio/axis/stukadivebegin2.ogg", "Yeah, we hear you. Stuka on its way." },
	[77] = { "/radio/axis/stukadivebegin3.ogg", "Stand by, Stuka on the way." },
	[78] = { "/radio/axis/stukadivebegin4.ogg", "You said Stuka, yeah? Alright, on the way." },
	[79] = { "/radio/axis/stukadivebegin5.ogg", "Copy that. This ought to make them shit their pants." },
	
	[80] = { "/radio/allied/american/airsupportnotvalidtarget1.ogg", "That's a bad target for air. You need to find another spot." },
	[81] = { "/radio/allied/american/airsupportnotvalidtarget2.ogg", "Negative, Squad Leader, bad target. Find another spot." },
	[82] = { "/radio/allied/american/airsupportnotvalidtarget3.ogg", "We can't send them there, that target is no good." },
	[83] = { "/radio/allied/american/airsupportnotvalidtarget4.ogg", "Negative, no, that's not a good target." },
	[84] = { "/radio/allied/american/airsupportnotvalidtarget5.ogg", "Not trying to be a pain in the rear here but that's a bad target. Find another spot." },
	
	[85] = { "/radio/allied/american/artillerybegin1.ogg", "Understood. Artillery on the way." },
	[86] = { "/radio/allied/american/artillerybegin2.ogg", "Yup I heard you it's gonna get loud down there." },
	[87] = { "/radio/allied/american/artillerybegin3.ogg", "Okay roger that, firing artillery." },
	[88] = { "/radio/allied/american/artillerybegin4.ogg", "It's coming." },
	[89] = { "/radio/allied/american/artillerybegin5.ogg", "Roger, yeah, on the way." },
	[155] = { "/radio/allied/american/artillerybegin6.ogg", "Roger that. Artillery outgoing." },
	
	[90] = { "/radio/allied/american/artillerydoesnotcopy1.ogg", "We did not get that Squad Lead, please say again." },
	[91] = { "/radio/allied/american/artillerydoesnotcopy2.ogg", "Station did not understand your last. Say again." },
	[92] = { "/radio/allied/american/artillerydoesnotcopy3.ogg", "Squad Lead we did not hear your last, over." },
	[93] = { "/radio/allied/american/artillerydoesnotcopy4.ogg", "Squad Lead are you alright? We did not hear your last." },
	[94] = { "/radio/allied/american/artillerydoesnotcopy5.ogg", "Squad Lead, Station did not copy. Say again, over." },
	
	[95] = { "/radio/allied/american/artillerynotvalidtarget1.ogg", "We're not able to target that location, over." },
	[96] = { "/radio/allied/american/artillerynotvalidtarget2.ogg", "Negative, we can't fire on that location." },
	[97] = { "/radio/allied/american/artillerynotvalidtarget3.ogg", "Uh, I'm not seeing that on my map." },
	[98] = { "/radio/allied/american/artillerynotvalidtarget4.ogg", "That's a negative. Can't target that area." },
	[99] = { "/radio/allied/american/artillerynotvalidtarget5.ogg", "I'm uh, where is that? I can't fire there." },
	
	[100] = { "/radio/allied/american/carpetbombbegin1.ogg", "Alright, sending a bomber." },
	[101] = { "/radio/allied/american/carpetbombbegin2.ogg", "Yeah, we copy. They're gonna do a run now." },
	[102] = { "/radio/allied/american/carpetbombbegin3.ogg", "Okay we got it, bombing run coming." },
	[103] = { "/radio/allied/american/carpetbombbegin4.ogg", "Understood, they're on the way." },
	[104] = { "/radio/allied/american/carpetbombbegin5.ogg", "Yup, we got it." },
	
	[105] = { "/radio/allied/american/straferunbegin1.ogg", "Alright yup gun run coming, sit tight." },
	[106] = { "/radio/allied/american/straferunbegin2.ogg", "Understood, it'll be there in a second." },
	[107] = { "/radio/allied/american/straferunbegin3.ogg", "You got it, I'll let them know." },
	[108] = { "/radio/allied/american/straferunbegin4.ogg", "Copy that." },
	[109] = { "/radio/allied/american/straferunbegin5.ogg", "Roger, yeah, I'll have 'em strafe it real good." },
	
	[110] = { "/radio/allied/british/airsupportnotvalidtarget1.ogg", "That's a negative. Deployment is not possible in that area." },
	[111] = { "/radio/allied/british/airsupportnotvalidtarget2.ogg", "Cannot comply. That is an invalid target." },
	[112] = { "/radio/allied/british/airsupportnotvalidtarget3.ogg", "Cannot commence sortie. Target details are invalid." },
	[113] = { "/radio/allied/british/airsupportnotvalidtarget4.ogg", "Unable to deploy aircraft to your current target. Please readjust coordinates." },
	[114] = { "/radio/allied/british/airsupportnotvalidtarget5.ogg", "Negative. Air support cannot deploy to those coordinates." },
	
	[115] = { "/radio/allied/british/typhoonbegin1.ogg", "Roger, Typhoon is inbound." },
	[116] = { "/radio/allied/british/typhoonbegin2.ogg", "Rocket strike is imminent, get clear." },
	[117] = { "/radio/allied/british/typhoonbegin3.ogg", "Confirmed. Rockets on your target." },
	[118] = { "/radio/allied/british/typhoonbegin4.ogg", "Typhoon has your target, commencing attack run." },
	[119] = { "/radio/allied/british/typhoonbegin5.ogg", "That's a copy, Typhoon is on approach." },
	
	[120] = { "/radio/allied/british/artillerydoesnotcopy1.ogg", "We need full target details. Please say again, over." },
	[121] = { "/radio/allied/british/artillerydoesnotcopy2.ogg", "We did not understand your last. Where are we targeting?" },
	[122] = { "/radio/allied/british/artillerydoesnotcopy3.ogg", "Say again? You got cut off." },
	[123] = { "/radio/allied/british/artillerydoesnotcopy4.ogg", "Resend target details. Transmission cut short, over." },
	[124] = { "/radio/allied/british/artillerydoesnotcopy5.ogg", "Station did not receive. Say again?" },
	
	[125] = { "/radio/allied/british/artillerynotvalidtarget1.ogg", "We can't target there. Our shots are blocked." },
	[126] = { "/radio/allied/british/artillerynotvalidtarget2.ogg", "Target coordinates not viable for fire." },
	[127] = { "/radio/allied/british/artillerynotvalidtarget3.ogg", "That's a negative. Station is unable to fire there." },
	[128] = { "/radio/allied/british/artillerynotvalidtarget4.ogg", "Unable to fire. It's out of our current range." },
	[129] = { "/radio/allied/british/artillerynotvalidtarget5.ogg", "Negative, we can't adjust fire to those coordinates." },
	
	[130] = { "/radio/allied/british/gasartillerybegin1.ogg", "Confirming request for gas. Here it comes!" },
	[131] = { "/radio/allied/british/gasartillerybegin2.ogg", "[]" },
	[132] = { "/radio/allied/british/gasartillerybegin3.ogg", "Message is received. Mustard gas incoming." },
	[133] = { "/radio/allied/british/gasartillerybegin4.ogg", "Understood, firing gas rounds." },
	[134] = { "/radio/allied/british/gasartillerybegin5.ogg", "We read you, commencing gas bombardment." },
	
	[135] = { "/radio/allied/british/gasartillerydoesnotcopy1.ogg", "We need full target details. Please say again, over." },
	[136] = { "/radio/allied/british/gasartillerydoesnotcopy2.ogg", "We did not understand your last. Where are we targeting?" },
	[137] = { "/radio/allied/british/gasartillerydoesnotcopy3.ogg", "Say again? You got cut off." },
	[138] = { "/radio/allied/british/gasartillerydoesnotcopy4.ogg", "Resend target details. Transmission cut short, over." },
	[139] = { "/radio/allied/british/gasartillerydoesnotcopy5.ogg", "Station did not receive. Say again?" },
	
	[140] = { "/radio/allied/british/incendiaryartillerybegin1.ogg", "Roger, incendiary shells are on their way." },
	[141] = { "/radio/allied/british/incendiaryartillerybegin2.ogg", "That's a copy. Commencing incendiary strike now." },
	[142] = { "/radio/allied/british/incendiaryartillerybegin3.ogg", "Confirmed, firing incendiary rounds." },
	[143] = { "/radio/allied/british/incendiaryartillerybegin4.ogg", "Message received, firing incendiaries. Clear the area." },
	[144] = { "/radio/allied/british/incendiaryartillerybegin5.ogg", "Affirmative, incendiary barrage outgoing." },
	
	[145] = { "/radio/allied/british/gasartillerynotvalidtarget1.ogg", "We can't target there. Our shots are blocked." },
	[146] = { "/radio/allied/british/gasartillerynotvalidtarget2.ogg", "Target coordinates not viable for fire." },
	[147] = { "/radio/allied/british/gasartillerynotvalidtarget3.ogg", "That's a negative. Station is unable to fire there." },
	[148] = { "/radio/allied/british/gasartillerynotvalidtarget4.ogg", "Unable to fire. It's out of our current range." },
	[149] = { "/radio/allied/british/gasartillerynotvalidtarget5.ogg", "Negative, we can't adjust fire to those coordinates." },

	[150] = { "/radio/allied/american/artillerybeginsmoke1.ogg", "Smoke sounds good, yeah, here it comes." },
	[151] = { "/radio/allied/american/artillerybeginsmoke2.ogg", "Okay we got you firing smoke." },
	[152] = { "/radio/allied/american/artillerybeginsmoke3.ogg", "Smoke artillery on the way, stand by." },
	[153] = { "/radio/allied/american/artillerybeginsmoke4.ogg", "Smoke barrage incoming." },
	[154] = { "/radio/allied/american/artillerybeginsmoke5.ogg", "Roger that smoke is on the way." },
}

function SWEP:CreateSubtitles(snd,ply)
	if tonumber(ply:GetInfo("gred_cl_artisweps_enable_subtitles")) == 1 then
		for k,v in pairs (SubTitles) do
			local Table = SubTitles[k]
			if table.HasValue(Table,snd) then
				ply:PrintMessage(HUD_PRINTCENTER,Table[2])
			end
		end
	end
end

if SERVER then
	function SWEP:PrimaryAttack()
		if !self:CanPrimaryAttack() or (self.IsCallingIn and GetConVar("gred_sv_artisweps_spam"):GetInt() <= 0) then return end
		self.IsCallingIn = true
		local CallSnd = self:GetCallInSound()
		if CallSnd != 0 then
			sound.Add( {
				name = "CallSnd",
				channel = CHAN_AUTO,
				volume = 1.0,
				level = 80,
				pitch = { 100 },
				sound = CallSnd
			} )
			self.Owner:EmitSound("CallSnd")
			-- self.snd = snd
			local dur = SoundDuration(CallSnd)
			if dur == 0 then sndDur = 4.5 else sndDur = dur + math.random(0.5,0.6) end
		else
			sndDur = CallSnd
		end
		
		ply = self.Owner
		self:CreateSubtitles(CallSnd,ply)
		sndl = self.SndLang
		snda = self.SndAccent
		ss = self.StrikeString
		local PlayerPos = self.Owner:GetEyeTrace().HitPos
		local PlyAng = self.Owner:EyeAngles().y
		timer.Simple(sndDur, function()
			if self.Weapon && IsValid( self.Weapon.Owner) then
				local trace = {}
				trace.start = PlayerPos
				trace.endpos = PlayerPos + Vector(0,0,1000)
				trace.filter = {ply}
				tr = util.TraceLine(trace)
				if tr.Hit and !tr.HitSky then
					local trace = {}
					trace.start = tr.HitPos + Vector(0,0,50)
					trace.endpos = tr.HitPos + Vector(0,0,1000)
					trace.filter = {ply}
					tr = util.TraceLine(trace)
				end
				if tr.Hit and !tr.HitSky then
					if self.GunRun or self.RocketRun or self.Bomber or self.StrikeString == "Air" then
						if self.SndLang == "English" then
							if self.SndAccent == 1 then
								snd = "/radio/allied/british/airsupportnotvalidtarget"..math.random(1,5)..".ogg"
							else
								snd = "/radio/allied/american/airsupportnotvalidtarget"..math.random(1,5)..".ogg"
							end
						else
							snd = "/radio/axis/airsupportnotvalidtarget"..math.random(1,5)..".ogg"
						end
					else
						if self.SndLang == "English" then
							if self.SndAccent == 1 then
								if self.StrikeString == "Chemical mortar" then 
									snd = "/radio/allied/british/gasartillerynotvalidtarget"..math.random(1,5)..".ogg"
								else
									snd = "/radio/allied/british/artillerynotvalidtarget"..math.random(1,5)..".ogg"
								end
							else
								snd = "/radio/allied/american/artillerynotvalidtarget"..math.random(1,5)..".ogg"
							end
						else
							snd = "/radio/axis/artillerynotvalidtarget"..math.random(1,5)..".ogg"
						end
					end
					self.Weapon:EmitSound(snd)
					self:CreateSubtitles(snd,ply)
					timer.Simple(SoundDuration(snd) + 1, function() self.IsCallingIn = false end)
					net.Start("gred_net_message_ply")
						net.WriteEntity(ply)
						net.WriteString("[GREDWITCH'S SWEPS]Bad target! Don't aim inside buildings")
					net.Send(ply)
				else
					snd = self.SoundName..(math.random(1,self.SndPossibilities))..self.SndFormat
					self.Weapon:EmitSound(snd)
					self:CreateSubtitles(snd,ply)
					net.Start("gred_net_message_ply")
						net.WriteEntity(ply)
						net.WriteString("[GREDWITCH'S SWEPS]"..self.StrikeString.." strike begins in "..(self.strikedalay).." seconds")
					net.Send(ply)
					self:TakePrimaryAmmo(1)
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					
					local ArtiStrike = ents.Create("gred_arti_ent")
					ArtiStrike:SetPos(tr.HitPos)
					ArtiStrike:SetAngles(ArtiStrike:GetAngles() + Angle(0,PlyAng,0))
					
					ArtiStrike.PlyPos				= PlayerPos
					ArtiStrike.ShellType			= self.strikeentity
					ArtiStrike.Delay	    		= self.strikedalay
					ArtiStrike.ShellCount			= self.ShellCount
					ArtiStrike.Owner				= ply
					ArtiStrike.Team					= self.Team
					ArtiStrike.StrikeString 		= self.StrikeString
					ArtiStrike.WaitGuns				= self.WaitGuns
					ArtiStrike.PreSound				= self.PreSound
					ArtiStrike.PreSoundName			= self.PreSoundName
					ArtiStrike.PreSndFormat			= self.PreSndFormat
					ArtiStrike.PreSndPossibilities	= self.PreSndPossibilities
					ArtiStrike.Bomber				= self.Bomber
					
					ArtiStrike.GunRun				= self.GunRun
					ArtiStrike.RocketRun			= self.RocketRun
					ArtiStrike.FireRate				= self.FireRate
					
					ArtiStrike.Smoke				= self.Smoke
					ArtiStrike.RandomPos			= self.RandomPos
					ArtiStrike.LoopTimerTime1		= self.LoopTimerTime1
					ArtiStrike.LoopTimerTime2		= self.LoopTimerTime2
					
					ArtiStrike.GunCount				= self.GunCount
					ArtiStrike.GunOffset			= self.GunOffset
					ArtiStrike.CustomAngle			= self.CustomAngle
					ArtiStrike.StrikeType			= self.StrikeType
					ArtiStrike.AircraftModel		= self.AircraftModel
					ArtiStrike.ModelTimer			= self.ModelTimer
					ArtiStrike.AnimPlaybackRate		= self.AnimPlaybackRate
					ArtiStrike.RandomBullets		= self.RandomBullets
					ArtiStrike:Spawn()
					ArtiStrike:Activate()
					timer.Simple(SoundDuration(snd) + 1, function() self.IsCallingIn = false end)
				end
			else
				if sndl == "English" then
					if snda == 1 then
						if ss == "Chemical mortar" then
							snd = "/radio/allied/british/gasartillerydoesnotcopy"..math.random(1,5)..".ogg"
						else
							snd = "/radio/allied/british/artillerydoesnotcopy"..math.random(1,5)..".ogg"
						end
					else
						snd = "/radio/allied/american/artillerydoesnotcopy"..math.random(1,5)..".ogg"
					end
				else
					snd = "/radio/axis/artillerydoesnotcopy"..math.random(1,5)..".ogg"
				end
				local ent = ents.Create("prop_dynamic")
				ent:SetPos(ply:GetPos())
				ent:EmitSound(snd)
				ent:Remove()
			end
		end)
	end
end
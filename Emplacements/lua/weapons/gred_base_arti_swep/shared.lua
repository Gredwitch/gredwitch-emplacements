SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false

SWEP.Primary.Ammo				= ""

SWEP.PrintName					= "[EMP]Binoculars"
SWEP.ExactShellCount			= nil
SWEP.Team						= ""

SWEP.Category					= "Gredwitch's SWEPs"
SWEP.Author						= "Gredwitch"
SWEP.Contact					= "qhamitouche@gmail.com"
SWEP.Purpose					= "Destroy the enemy"
SWEP.Instructions				= "Right ckick to look through the binoculars, left click to call in a strike."
SWEP.MuzzleAttachment			= "1"
SWEP.ShellEjectAttachment		= "2"
SWEP.Slot						= 4
SWEP.SlotPos					= 35
SWEP.DrawAmmo					= false
SWEP.DrawWeaponInfoBox			= false
SWEP.BounceWeaponIcon   		= false
SWEP.DrawCrosshair				= false
SWEP.Weight						= 50
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= true
SWEP.XHair						= false
SWEP.HoldType 					= "camera"

SWEP.ViewModelFOV				= 70
SWEP.ViewModelFlip				= false
SWEP.ViewModel					= "models/weapons/v_invisib.mdl"
SWEP.WorldModel					= "models/weapons/w_binos.mdl"
SWEP.Base 						= "gred_m9k_scoped_base"

SWEP.Primary.Sound				= Sound("weapons/satellite/targaquired.mp3")
SWEP.Primary.RPM				= 10
SWEP.Primary.ClipSize			= -1
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

SWEP.data 						= {}
SWEP.data.ironsights			= 1
SWEP.ScopeScale 				= 1

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

SWEP.BoundEmplacements = {}

function SWEP:Reload()
		if not IsValid(self) then return end if not IsValid(self.Owner) then return end
	   
		if self.Owner:IsNPC() then
				self.Weapon:DefaultReload(ACT_VM_RELOAD)
		return end
	   
		if self.Owner:KeyDown(IN_USE) then return end
	   
		if self.Silenced then
				self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
		else
				self.Weapon:DefaultReload(ACT_VM_RELOAD)
		end
	   
		if !self.Owner:IsNPC() then
				if self.Owner:GetViewModel() == nil then self.ResetSights = CurTime() + 3 else
				self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				end
		end
	   
		if SERVER and self.Weapon != nil then
		if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
		-- //When the current clip < full clip and the rest of your ammo > 0, then
				self.Owner:SetFOV( 0, 0.3 )
				-- //Zoom = 0
				self:SetIronsights(false)
				-- //Set the ironsight to false
				self.Weapon:SetNWBool("Reloading", true)
		end
		local waitdammit = 0 --(self.Owner:GetViewModel():SequenceDuration())
		timer.Simple(waitdammit + .1,
				function()
				if self.Weapon == nil then return end
				self.Weapon:SetNWBool("Reloading", false)
				if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then
						if CLIENT then return end
						if self.Scoped == false then
								self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
								self.IronSightsPos = self.SightsPos                                     -- Bring it up
								self.IronSightsAng = self.SightsAng                                     -- Bring it up
								self:SetIronsights(true, self.Owner)
								self.DrawCrosshair = false
						else return end
				elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then
						if self.Weapon:GetNextPrimaryFire() <= (CurTime() + .03) then
								-- self.Weapon:SetNextPrimaryFire(CurTime()+0.3)                   -- Make it so you can't shoot for another quarter second
						end
						self.IronSightsPos = self.RunSightsPos                                  -- Hold it down
						self.IronSightsAng = self.RunSightsAng                                  -- Hold it down
						self:SetIronsights(true, self.Owner)                                    -- Set the ironsight true
						self.Owner:SetFOV( 0, 0.3 )
				else return end
				end)
		end
end
 

function SWEP:CanPrimaryAttack()

	-- if ( self.Weapon:Clip1() <= 0 ) then

		-- self:EmitSound( "Weapon_Pistol.Empty" )
		-- self:SetNextPrimaryFire( CurTime() + 0.2 )
		-- self:Reload()
		-- return false

	-- end

	return true

end

function SWEP:BindEmplacement(ent)
	-- local name = 
	if table.HasValue(self.BoundEmplacements,ent) then
		table.RemoveByValue(self.BoundEmplacements,ent)
	else
		table.insert(self.BoundEmplacements,ent)
	end
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
end
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
if CLIENT then
   SWEP.PrintName			= "357 Magnum"			

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1
end

SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.IsGrenade = false

SWEP.Base				= "weapon_fort_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.HeadshotMultiplier = 3


SWEP.Primary.Ammo       = "357" -- Type of ammo
SWEP.Primary.Recoil 	= 2
SWEP.Primary.Damage 	= 55 // Damage
SWEP.Primary.Delay 		= 0.45 //Delay between shots.
SWEP.Primary.Cone 		= 0.011 // Cone
SWEP.Primary.ClipSize 	= 6 // Clipsize
SWEP.Primary.ClipMax 	= 24 // Max Clip
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false // Automatic?
SWEP.Primary.Bullets = 1 //Number of bullet shot.
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound	= Sound( "Weapon_Deagle.Single" ) // Primary Fire Sound
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Anim = ACT_VM_PRIMARYATTACK // Attack Anim
SWEP.Primary.Force = 15 // Bullet Force


SWEP.CrossHairMinDistance = 4 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 8 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 40 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect


SWEP.MoveKick = 0

SWEP.KickVert = 4 // View punch vert effect.
SWEP.KickHoriz = 4 // View punch horizontal effect.
SWEP.KickMult = 1.1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 3 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.22 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 12


SWEP.KickMove = 0.1 // The times amount for our movement.
SWEP.MaxMoveKick = 15
SWEP.JumpKick = 4 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.6

SWEP.HeadshotMultiplier = 4 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Secondary.Type = 1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.Delay = 0
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.ClipMax = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Tracer = false
SWEP.Secondary.DryFireSound = "Weapon_Pistol.Empty"
SWEP.Secondary.Anim = ACT_VM_PRIMARYATTACK
SWEP.Secondary.Sound = "npc/combine_soldier/gear6.wav"

SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.DeployAnim = ACT_VM_DEPLOY

SWEP.Type = "pistol" // Used to determine if the weapon is a pistol, shotgun, etc.
SWEP.CanSilence = false
SWEP.Silenced = false
SWEP.Silencing = false

SWEP.CanBurst = false
SWEP.BurstCount = 0
SWEP.BurstDelay = 0
SWEP.BurstKick = 1
SWEP.Primary.BurstDelay = 0
SWEP.BurstMode = false

SWEP.QuedBullets = 0
SWEP.QueDelay = 0
SWEP.QueFireDelay = CurTime()

SWEP.ReloadNo = 0
SWEP.ReloadDelay = CurTime()
SWEP.ShouldReload = false

SWEP.SilencedAnims = { ACT_VM_DRAW_SILENCED,ACT_VM_PRIMARYATTACK_SILENCED,ACT_VM_RELOAD_SILENCED, ACT_VM_IDLE_SILENCED}

SWEP.DeploySpeed = 1 // The speed at which the weapon is deployed.

SWEP.IronSights = false // Don't touch this

SWEP.NextWeaponThink = CurTime() // Don't touch this

SWEP.DeployPunch = Angle(10,5,0) // The view punch when you draw your weapon.

SWEP.FOVSet = false


SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 64
SWEP.ViewModel	= "models/weapons/c_357.mdl"
SWEP.WorldModel	= "models/weapons/w_357.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1

local SF_WEAPON_START_CONSTRAINED = 1


SWEP.LastSprintTime = CurTime()


SWEP.NextPrimaryAttack = CurTime()
SWEP.NextSecondaryAttack = CurTime()


if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "pistol"
SWEP.Kind = WEAPON_NONE
SWEP.CanBuy = nil

if CLIENT then
	SWEP.PrintName			= "Desert Eagle"			
	SWEP.Author				= "Fortune"
   
	SWEP.EquipMenuData = nil
   
	SWEP.Icon = "vgui/ttt/icon_nades"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 1

	SWEP.DrawCrosshair   = false
end


SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.IsGrenade = false

SWEP.Base				= "weapon_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false


SWEP.Primary.Ammo       = "357" -- Type of ammo
SWEP.Primary.Recoil 	= 2
SWEP.Primary.Damage 	= 54 // Damage
SWEP.Primary.Delay 		= 0.225 //Delay between shots.
SWEP.Primary.Cone 		= 0.01 // Cone
SWEP.Primary.ClipSize 	= 7 // Clipsize
SWEP.Primary.ClipMax 	= 35 // Max Clip
SWEP.Primary.Automatic = false // Automatic?
SWEP.Primary.Bullets = 1 //Number of bullet shot.
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound	= Sound( "Weapon_Deagle.Single" ) // Primary Fire Sound
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Anim = ACT_VM_PRIMARYATTACK // Attack Anim
SWEP.Primary.Force = 15 // Bullet Force

SWEP.InLoadoutMenu = false

SWEP.CrossHairMinDistance = 5 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 8 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 40 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 1 // View punch vert effect.
SWEP.KickHoriz = 1 // View punch horizontal effect.
SWEP.KickMult = 1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 2 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.04 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 6


SWEP.KickMove = 0.1 // The times amount for our movement.
SWEP.MaxMoveKick = 15
SWEP.JumpKick = 4 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = 0.07

SWEP.HeadShotMult = 4.1 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Secondary.Type = 1
SWEP.Secondary.Ammo = "Buckshot"
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.Delay = 0
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.ClipMax = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Tracer = false
SWEP.Secondary.DryFireSound = Sound("Weapon_Pistol.Empty")
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
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1

local SF_WEAPON_START_CONSTRAINED = 1


SWEP.LastSprintTime = CurTime()

SWEP.IronSightTime = 0.2
SWEP.SprintTime = 0.2

SWEP.FixedIdleAnim = false
SWEP.LastSilencedFire = CurTime()

SWEP.NextPrimaryAttack = CurTime()
SWEP.NextSecondaryAttack = CurTime()

if SERVER then
	util.AddNetworkString( "SyncInSights")
end

function BoolToNumber( bool )
	if bool == true then 
		return 1
	else
		return 0
	end
end

function NumberToBool( num )
	if num == 1 then
		return true
	else
		return false
	end
end

if CLIENT then
	
   	function DrawCrossRect( x, y, w, h )
   		surface.DrawRect( x, y, w, h )

   		surface.SetDrawColor( Color( 0, 0, 0 ) )
   		surface.DrawOutlinedRect( x-1, y-1, w+2, h+2)
   	end

   	local h = 2
   	local len = 15

	function SWEP:DrawHUD()
		if not GAMEMODE.Jericho.AllowCrosshair then return end
		local LShootTime = self:LastShootTime()
		scale = (self.KickMult + self.MoveKick) * (self.IronSights and 0.6 or 1) *self.CrouchMult
		
		
		local gap = math.Clamp( self.CrossHairDeltaDistance * scale, self.CrossHairMinDistance, self.CrossHairMaxDistance )
		local x = ScrW()/2 
		local y = ScrH()/2 
		
		surface.SetDrawColor(Color(255,255,255,255))
		DrawCrossRect( x - gap - len, y - h/2, len, h)

		surface.SetDrawColor(Color(255,255,255,255))
		DrawCrossRect( x + gap , y - h/2, len, h)

		surface.SetDrawColor(Color(255,255,255,255))
		DrawCrossRect( x - h/2, y + gap, h, len)

	end
end

function SWEP:GetDamageFactors()
	return { self.HeadShotMult, self.StomachMult, self.LegMult }
end 

local SF_WEAPON_START_CONSTRAINED = 1

-- Picked up by player. Transfer of stored ammo and such.
function SWEP:Equip(newowner)
   if SERVER then
      if self:IsOnFire() then
         self:Extinguish()
      end

      if self:HasSpawnFlags(SF_WEAPON_START_CONSTRAINED) then
         -- If this weapon started constrained, unset that spawnflag, or the
         -- weapon will be re-constrained and float
         local flags = self:GetSpawnFlags()
         local newflags = bit.band(flags, bit.bnot(SF_WEAPON_START_CONSTRAINED))
         self:SetKeyValue("spawnflags", newflags)
      end
   end
end

function SWEP:SetNextPrimaryAttack( delay )
	self.NextPrimaryAttack = CurTime() + delay
end

function SWEP:SetNextSecondaryAttack( delay )
	self.NextSecondaryAttack = CurTime() + delay
end

function SWEP:SetNext( delay )
	self.NextPrimaryAttack = CurTime() + delay
	self.NextSecondaryAttack = CurTime() + delay
end

function SWEP:DryFire( snd )
	if CLIENT and LocalPlayer() == self.Owner then
		surface.PlaySound( snd )
	end
	
	self:SetNextPrimaryFire( 0.2 )
	self:SetNextSecondaryFire( 0.2 )
	
	self:Reload()
	
end

function SWEP:CanPrimaryAttack()
	if not IsValid(self.Owner) then return end
	if CurTime() < self.NextPrimaryAttack then return false end
	if self.Deploying == true then return false end
	if self.Sprinting  == true then return false end
	
	if self:Clip1() <= 0 then
		self:DryFire( self.Primary.DryFireSound )
		self:SetNext( self.Primary.Delay*2 )
		return false
	end
return true
end


function SWEP:PrimaryAttack()
	if self.BurstMode == true and self:CanPrimaryAttack() == true then
		self:SetNextPrimaryAttack( self.Primary.BurstDelay )
		self:QueBullets( self.BurstCount, self.BurstDelay )
	else
		if self:CanPrimaryAttack() then 
			if self.ReloadNo > 1 then
				self.ReloadNo = 0
				self:FinishReload()
				self:SetNextPrimaryAttack( 0.7 )
			end
			self:ShootBullet( self.Primary.Damage, self.Primary.Cone, self.Primary.Delay, self.Primary.Bullets, self.Primary.Recoil, self.Primary.Force, self.Kick )
			self:TakePrimaryAmmo(1)
		end
	end
end

local reg = debug.getregistry()
local GetVelocity = reg.Entity.GetVelocity
local Length = reg.Vector.Length

function GetUseVelocity( ply )
	return Length(GetVelocity(ply))/10
end


function SWEP:StartReload( num )
	self.ReloadNo = num
	self.ReloadDelay = CurTime()
	self.FirstReload = true
	self.ShouldReload = true
	
	if not IsFirstTimePredicted() then return false end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
	self.ReloadDelay = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
	local ply = self.Owner
   
	if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
		return false
	end

	local wep = self.Weapon
   
	if wep:Clip1() >= self.Primary.ClipSize then 
		return false 
	end
end

function SWEP:PerformReload()
	local ply = self.Owner
	if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
		self.ReloadNo = 0
		self:FinishReload()
		return
	end
  	
	self:SetClip1( self:Clip1() + 1 )
	ply:SetAmmo( ply:GetAmmoCount( self.Primary.Ammo ) - 1, self.Primary.Ammo )
	local vm = ply:GetViewModel()
	
	self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
				
	local delay = vm:SequenceDuration()
				
	self.ReloadDelay = CurTime() + delay
	--self:SetNextPrimaryAttack( delay )
	self.ReloadNo = self.ReloadNo - 1
	
	if self.ReloadNo == 0 then
		timer.Simple( delay, function()
			if IsValid( self ) and IsValid( self.Owner ) then
				self:FinishReload()
			end
		end)
	end
end

function SWEP:FinishReload()
	self.ShouldReload = false
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
end

SWEP.__delay = 1
function SWEP:Think()
	
	if self.ReloadNo > 0 and self.ShouldReload then
		if CurTime() > self.ReloadDelay then
			self:PerformReload()	
		end
	end
	
	
	
	local Vel = GetUseVelocity( self.Owner )
	
	
	self.CrouchMult = (self.Owner:Crouching() and self.CrouchKick) or 1
		
	local KickMod = hook.Call( "HDN_RecoilCallback", GAMEMODE, self.Owner ) or 1
	if CurTime() > self.NextWeaponThink then
		if self.KickMult > 1 then
			self.KickMult = math.Clamp( self.KickMult - ( self.Owner:Crouching() and self.CrouchDecrease or self.KickDecrease), 1, 30 )
		end 
		
		if not self.Owner:IsOnGround() and Vel > 100 then
			self.KickMult = math.Clamp( self.KickMult + self.JumpKick*KickMod, 1, 4 )
		else
			self.MoveKick = math.Clamp( Vel*self.KickMove*KickMod, 0, self.MaxMoveKick*KickMod)
		end
		self.NextWeaponThink = CurTime() + 0.01
	end

end



if CLIENT then
	net.Receive( "SyncBSights", function()
		local tbl = net.ReadTable()
		local ent = net.ReadEntity()
		ent.BSights = tbl[1]
		print( "NET MESSAGE: "..tostring(ent.BSights) )
	end)
end

SWEP.BSights = false
function SWEP:SecondaryAttack()
	return
end


function SWEP:ShootEffects()
	if CLIENT then
	
		local vm = LocalPlayer():GetViewModel()
		local mpos = vm:GetAttachment(1)
		if not mpos then
			mpos = {}
			mpos.Pos = self.Owner:GetShootPos()*5
		end
		
		local effect = EffectData()
		effect:SetOrigin(mpos.Pos )
		effect:SetAngles( self.Owner:GetAimVector():Angle() )
		effect:SetEntity( self )
		effect:SetAttachment( 1 )
		effect:SetScale(1)
		util.Effect("MuzzleEffect", effect, true, true )
		
	end
end

function SWEP:FireAnimationEvent(pos,ang,event)
return (event==5001)
end

function SWEP:ShootBullet( damage, cone, delay, bullets, recoil, force, kick )
	
	self:SetNextPrimaryAttack( delay )
	
	if self.Silenced == true then
		self.LastSilencedFire = CurTime() + self:SequenceDuration() - 0.2
		self.FixedIdleAnimation = false
	end


	if not IsFirstTimePredicted() then return end
	
	self.Weapon:SendWeaponAnim( (self.Silenced == true and self.SilencedAnims[2] ) or self.Primary.Anim)
	

	self:ShootEffects()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:EmitSound( (self.Silenced == true and self.Primary.SilencedSound) or self.Primary.Sound )

	local KickMod = hook.Call( "HDN_RecoilCallback", GAMEMODE, self.Owner ) or 1
	
	local cone = cone or 0.1
	
	   local bullet = {}
	   bullet.Num    = bullets
	   bullet.Src    = self.Owner:GetShootPos()
	   bullet.Dir    = self.Owner:GetAimVector()
	   bullet.Spread = Vector( cone, cone, 0 )*( self.KickMult + self.MoveKick ) * (self.IronSights and 0.6 or 1) * self.CrouchMult * KickMod
	   bullet.Tracer = self.TraceNum
	   bullet.TracerName = self.TraceName
	   bullet.Force  = force
	   bullet.Damage = damage
	   bullet.AmmoType = "Pistol"
	   bullet.Callback = function( att, tr, dmginfo )
			local norm = tr.HitNormal
			local dir = bullet.Dir
			local mat = tr.MatType
			if self:BulletPenetration( dmginfo, dir, mat, tr ) == false then
				self:Ricochet( dmginfo, mat, norm, dir, tr.HitPos )
			end
	   end
	   
	   self.Owner:FireBullets( bullet )
	   
	   self:ApplyRecoil( recoil, kick )
		
end

SWEP._rdelay = CurTime()
function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	if CurTime() < self._rdelay then return end
	
	if self.Type == "shotgun"  then
		if self.ShouldReload == false then
			self:StartReload( (self.Primary.ClipSize - self:Clip1()) )
			self._rdelay = CurTime()+0.8
		else
			self.ReloadNo = 0
			self:FinishReload()
			self._rdelay = CurTime()+0.8
		end
	else
		self:DefaultReload( (self.Silenced == true and self.SilencedAnims[3]) or self.ReloadAnim)
	end
	
end

function SWEP:ApplyRecoil( recoil, kick )

		local ang = Angle(math.min(math.Rand(-self.KickVert,-self.KickVert*1.5),0.5),math.min(math.Rand(-self.KickHoriz,self.KickHoriz),0.5),0)
		self.Owner:ViewPunch(ang)
		
		self.KickMult = math.Clamp( self.KickMult + kick*self.CrouchMult, 1, self.MaxKick )
		
	if ((game.SinglePlayer() and SERVER) or
		((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
		
		local rand = math.random(1,2)
		
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		eyeang.yaw = eyeang.yaw -( (rand == 1 and recoil or -recoil)/3 )
		self.Owner:SetEyeAngles( eyeang )
	  
	end
end

function SWEP:Ammo1()
   return IsValid(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) or false
end

function SWEP:Ammo2()
   return IsValid(self.Owner) and self.Owner:GetAmmoCount(self.Secondary.Ammo) or false
end

function SWEP:DrawWeaponSelection() end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( (self.Silenced == true and self.SilencedAnims[1] ) or self.DeployAnim )
	self:SetNext(0.5)
	self.Owner:ViewPunch( self.DeployPunch )
	hook.Call( "OnWeaponDeployed", GAMEMODE, self, self.Owner )
return true
end

function SWEP:Holster()
	hook.Call( "OnWeaponHolstered", GAMEMODE, self, self.Owner )
return true
end

function SWEP:GetSights()
	return self:GetNWBool("BSights")
end

function SWEP:Initialize()
	
	if self.SetHoldType then
		self:SetHoldType( self.HoldType or "pistol" )
 	end
	util.PrecacheModel( self.WorldModel )
	util.PrecacheModel( self.ViewModel )
	self:SetDeploySpeed( self.DeploySpeed or 1 )
end

local divamount = 1.7
function CalcRicochet( dir, norm )
	local rand = math.random(1,2)
	return dir+norm/divamount + (rand == 1 and VectorRand()*0.05 or -VectorRand()*0.05)
end

local RicochetChances = {}
RicochetChances[MAT_FLESH] = 0
RicochetChances[MAT_CONCRETE] = 100
RicochetChances[MAT_WOOD] = 0
RicochetChances[MAT_METAL] = 70
RicochetChances[MAT_VENT] = 70
RicochetChances[MAT_CLIP] = 70
RicochetChances[MAT_COMPUTER] = 40
RicochetChances[MAT_GRATE] = 40
RicochetChances[48] = 100


function SWEP:Ricochet( dmginfo, mat, norm, dir, pos )
	local rchance = RicochetChances[mat] or 0
	
	local dot = norm:Dot(norm + dir) 
	
	if math.Rand(1,100) <= rchance and dot > 0.5 then
	
		local norm2 = norm
		local ndir = CalcRicochet( dir, norm )
		
		
		if not IsFirstTimePredicted() then return end
		local bullet = {}
		bullet.Num    = 1
		bullet.Src    = pos
		bullet.Dir    = ndir
		bullet.Spread = Vector( 0, 0, 0 )
		bullet.Tracer = 0
		bullet.TracerName = "Tracer"
		bullet.Force  = dmginfo:GetDamageForce()/3
		bullet.Damage = dmginfo:GetDamage()/2
		
		self.Owner:FireBullets( bullet )
		
	end
end

local PenetrationDistances = {}
PenetrationDistances[MAT_FLESH] = 60
PenetrationDistances[MAT_ALIENFLESH] = 60
PenetrationDistances[MAT_BLOODYFLESH] = 60
PenetrationDistances[MAT_CONCRETE] = 20
PenetrationDistances[MAT_WOOD] = 40
PenetrationDistances[MAT_METAL] = 0
PenetrationDistances[MAT_VENT] = 0
PenetrationDistances[MAT_CLIP] = 0
PenetrationDistances[MAT_COMPUTER] = 10
PenetrationDistances[MAT_GRATE] = 30
PenetrationDistances[MAT_GLASS] = 50
PenetrationDistances[48] = 20
PenetrationDistances[67] = 20
PenetrationDistances[68] = 20

function SWEP:BulletPenetration( dmginfo, dir, mat, trace )
	local PenDist = PenetrationDistances[mat] or 60
	
	if not PenetrationDistances[mat] then
		print(mat)
	end
	
	if PenDist > 0 then
		local trd = {}
		trd.start = trace.HitPos
		trd.endpos = trace.HitPos + (dir*PenDist)
		trd.filter = trace.Entity
		trd.mask = MASK_SOLID
		trd.ignoreworld = true
		local tr = util.TraceLine(trd)
		
		if not tr.Hit then
		
			local trd2 = {}
			trd2.start = trd.endpos
			trd2.endpos = trd.endpos - dir*PenDist
			local tr2 = util.TraceLine(trd2)
		
			if not IsFirstTimePredicted() then return end
			local bullet = {}
			bullet.Num    = 1
			bullet.Src    = tr2.HitPos + dir
			bullet.Dir    = dir
			bullet.Spread = Vector( 0, 0, 0 )
			bullet.Tracer = 0
			bullet.TracerName = "Tracer"
			bullet.Force  = dmginfo:GetDamageForce()/3
			bullet.Damage = dmginfo:GetDamage()/2
			
			self.Owner:FireBullets( bullet )
			return true
		else
			print(tr.Entity) 
			return false
		end
	else
		return false
	end
end

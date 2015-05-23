if SERVER then
   AddCSLuaFile()
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Tranquilizer"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 1
end

SWEP.Base				= "weapon_base"

SWEP.Primary.Ammo       = "none" -- Type of ammo
SWEP.Primary.Recoil 	= 2
SWEP.Primary.Damage 	= 8 // Damage
SWEP.Primary.Delay 		= 0.5 //Delay between shots.
SWEP.Primary.Cone 		= 0 // Cone
SWEP.Primary.ClipSize 	= 6
SWEP.Primary.Automatic	= false
SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipMax 	= 6
SWEP.Primary.Tracer = true // Should we have a tracer?
SWEP.Primary.Sound = Sound( "weapons/crossbow/fire1.wav" )
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 10 // Bullet Force


SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1

SWEP.DeployPunch = Angle(4,1,0) // The view punch when you draw your weapon.

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetDeploySpeed( 1 )
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DEPLOY )
	self.Owner:ViewPunch( self.DeployPunch )
	hook.Call( "OnWeaponDeployed", GAMEMODE, self, self.Owner )
return true
end




if CLIENT then
	
   	function DrawCrossRect( x, y, w, h )
   		surface.DrawRect( x, y, w, h )

   		surface.SetDrawColor( Color( 0, 0, 0 ) )
   		surface.DrawOutlinedRect( x-1, y-1, w+2, h+2)
   	end

   	local h = 2
   	local len = 10

	function SWEP:DrawHUD()
		local LShootTime = self:LastShootTime()
		
		
		local gap = 2
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

function SWEP:FireAnimationEvent(pos,ang,event)
	return (event==5001)
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then return false end
	return true 
end

function SWEP:TakePrimaryAmmo( num )
	self:SetClip1( self:Clip1() - 1 )
end

function SWEP:ShootEffects()
	if CLIENT then
	
		local vm = LocalPlayer():GetViewModel()
		local mpos = vm:GetAttachment(1)
		
		local effect = EffectData()
		effect:SetOrigin(mpos.Pos)
		effect:SetAngles( self.Owner:GetAimVector():Angle() )
		effect:SetEntity( self )
		effect:SetAttachment( 1 )
		effect:SetScale(0.1)
		util.Effect("MuzzleEffect", effect, true, true )
		
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then self:EmitSound( self.Primary.DryFireSound ) return end 

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	

	self:ShootEffects()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:EmitSound( self.Primary.Sound, 100, 100, 0.3 )
	
	
	local cone = self.Primary.Cone
	local bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector( cone, cone, cone )
	bullet.Tracer = 1
	bullet.TracerName = "Pistol"
	bullet.Force  = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = "Pistol"
	bullet.Callback = function( att, tr, dmginfo )
		local ent = tr.Entity
		if IsValid( ent ) and ent:IsPlayer() and ent:Team() == TEAM_HIDDEN then
			if SERVER then
				--self.Owner:Blind( 12, 0.96 )
				ent:Blind( GAMEMODE.TranqBlindDuration, GAMEMODE.TranqBlindIntensity )
			end
		end
	end

	self.Owner:FireBullets( bullet )
	self:TakePrimaryAmmo( 1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end


function SWEP:SecondaryAttack()
	return
end
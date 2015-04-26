if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName			= "Pipebomb"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 1
end

SWEP.Base				= "weapon_base"

SWEP.Primary.Ammo       = "none"   -- Type of ammo
SWEP.Primary.Damage 	= 30 // Damage
SWEP.Primary.Automatic	= true
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipMax 	= -1
SWEP.Primary.Sound			= Sound( "weapons/knife/knife_slash2.wav" )
SWEP.Primary.HitForce = 50

SWEP.InLoadoutMenu = false

SWEP.Grenades = 0
SWEP.Throwing = false
SWEP.TimeUntillThrow = 0

SWEP.Range = 90
SWEP.PinPulled = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 90
SWEP.ViewModel			= "models/weapons/pipe/v_pipebomb.mdl" 
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1

if CLIENT then
	local Mat = Material( "sprites/hdn_crosshairs", "noclamp smooth" )

	local cross_sz = 90
	function SWEP:DrawHUD()
		surface.SetDrawColor( Color( 255, 100, 100, 255 ) )
		surface.SetMaterial( Mat )
		surface.DrawTexturedRectUV( ScrW()/2 - cross_sz/2, ScrH()/2 - cross_sz/2, cross_sz, cross_sz, 0.5, 0.5, 0, 1 )
	end	
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	local nades = math.floor( math.Clamp( #player.GetAll()/GAMEMODE.Hidden.GrenadeRatio, GAMEMODE.Hidden.MinimumGrenades, GAMEMODE.Hidden.MaximumGrenades ) )
	self.Grenades = nades
	self:SetDeploySpeed( 1 )
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DEPLOY )
	return true
end

function SWEP:PrimaryAttack()
	--self:SendWeaponAnim( ACT_VM_PULLPIN )
end

function SWEP:SecondaryAttack()
	--self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
end

function SWEP:PullPin()
	self:SendWeaponAnim( ACT_VM_PULLPIN )
	self.PinPulled = true
	self.TimeUntillThrow = CurTime() + 0.5
end

function SWEP:StartThrow( )
	self.ThrowTime = CurTime() + 0.1
	self.Throwing = true
end

function SWEP:CreateGrenade( ply, angle, src, vel )

   local gren = ents.Create("hdn_grenade")

   gren:SetPos(src)
   gren:SetAngles(angle)

   --   gren:SetVelocity(vel)
   gren:SetOwner(ply)

   --gren:SetGravity(0.4)
     gren:SetFriction(8)
     gren:SetElasticity(2)

   gren:Spawn()

   gren:PhysWake()

   local phys = gren:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocity(vel)
      phys:AddAngleVelocity(VectorRand()*150)
   end

end

function SWEP:ThrowGrenade()
	if CLIENT then return end
	local ply = self.Owner
	local ang = ply:EyeAngles()

	-- don't even know what this bit is for, but SDK has it
	-- probably to make it throw upward a bit
	if ang.p < 90 then
	 ang.p = -10 + ang.p * ((90 + 10) / 90)
	else
	 ang.p = 360 - ang.p
	 ang.p = -10 + ang.p * -((90 + 10) / 90)
	end

	local vel = 1000

	local vfw = ang:Forward()
	local vrt = ang:Right()
	--      local vup = ang:Up()

	local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
	src = src + (vfw * 8) + (vrt * 10)

	local thr = vfw * vel + ply:GetVelocity()
	self:CreateGrenade( ply, Angle( 0, 0, 0 ), src, thr )
	self.Grenades = self.Grenades - 1
	if self.Grenades <= 0 then
		self:Remove()
		return
	end
	self:SendWeaponAnim( ACT_VM_IDLE )
	self.PinPulled = false
	self.Throwing = false
end

function SWEP:Think()
	local ply = self.Owner

	if not self.Throwing then
		if ply:KeyDown( IN_ATTACK ) and not self.PinPulled then
			self:PullPin()
		elseif not ply:KeyDown( IN_ATTACK ) and self.PinPulled and CurTime() > self.TimeUntillThrow then
			self:StartThrow()
		end
	end

	if self.ThrowTime and CurTime() > self.ThrowTime and self.PinPulled and self.Throwing then
		self:ThrowGrenade()
	end
end

function SWEP:DrawWorldModel()
	return false
end
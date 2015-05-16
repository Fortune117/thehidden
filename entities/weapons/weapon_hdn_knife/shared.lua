if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "knife"

if CLIENT then
   SWEP.PrintName			= "Knife"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 0
end

SWEP.Base				= "weapon_base"

SWEP.Primary.Ammo       = "none"   -- Type of ammo
SWEP.Primary.Damage 	= 36 // Damage
SWEP.Primary.Automatic	= true
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipMax 	= -1
SWEP.Primary.Sound			= Sound( "weapons/knife/knife_slash2.wav" )
SWEP.Primary.Hit            = Sound( "npc/fast_zombie/claw_strike3.wav" )
SWEP.Primary.HitForce = 50
SWEP.Primary.Delay = 0.1
SWEP.Secondary.Delay = 0.1

SWEP.PigStickDelay = 2.6
SWEP.PigSticks = 0
SWEP.MaxPigSticks = 99999

SWEP.PigSticking = false

SWEP.Range = 90

local PIN_RAG_RANGE = 120
local CARRY_WEIGHT_LIMIT = 45

local prop_force = 60000

SWEP.InLoadoutMenu = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 90
SWEP.ViewModel			= "models/weapons/kabar/v_kabar.mdl" 
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1

SWEP.NextPrimaryAttack = 0
SWEP.NextSecondaryAttack = 0
SWEP.ReloadDelay = 0


local knife_path = "weapons/knife/"

local hitsounds = {
knife_path.."knife_hit2.wav",
knife_path.."knife_hit3.wav",
knife_path.."knife_hit4.wav"
}
 
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
	self:SetHoldType( self.HoldType )
	self.NextIdleAnim = CurTime() + 5
	self:SetDeploySpeed( 1 )
	self.carried_rag = nil
	self.PickUpDelay = CurTime()
	if GAMEMODE.Hidden.PigStickMode == 5 then
		self:SetNWInt( "MaxPigSticks", math.floor( #player.GetAll()*GAMEMODE.Hidden.PigStickChargesRatio ) )
	end
end

function SWEP:SetNext( time )
	self.Weapon:SetNextPrimaryFire( CurTime() + time )
	self.Weapon:SetNextSecondaryFire( CurTime() + time )
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:GetMaxPigSticks()
	return self:GetNWInt( "MaxPigSticks", 9999 )
end

function SWEP:GetPigStickMode()
	return GAMEMODE.Hidden.PigStickMode
end


function SWEP:PrimaryAttack()

	if self:IsCarrying() then
		self:DoAttack( true )
		return 
	end

	self.Owner:LagCompensation( true )
		self:Slash()
	self.Owner:LagCompensation( false )

	self.ResetingSequence = false
	self.NextIdleAnim = CurTime() + 10
	self:SetNext( GAMEMODE.Hidden.AttackDelay )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:SendWeaponAnim( ACT_VM_MISSCENTER )

end

function SWEP:Reload()
	if CurTime() > self.ReloadDelay then
		self.NextIdleAnim = CurTime() - 1
		self.ReloadDelay = CurTime() + 4
	end
end

local pig_stick =
{
	"player/hidden/voice/617-pigstick01.mp3",
	"player/hidden/voice/617-pigstick02.mp3",
	"player/hidden/voice/617-pigstick03.mp3",
	"player/hidden/voice/617-pigstick04.mp3"
}

function SWEP:SecondaryAttack()

	if self:IsCarrying() then
		self:DoAttack( false )
		return 
	end
	if self.PigSticks >= self:GetMaxPigSticks() then return end
	if self:GetPigStickMode() == 4 then return end
	if self:GetPigStickMode() == 2 and self.PigSticks >= GAMEMODE.Hidden.PigStickCharges then
		return
	end
	if self:GetPigStickMode() == 6 and GAMEMODE.Hidden.Strength < GAMEMODE.Hidden.PigStickStrengthCap then
		return
	end

	self.ResetingSequence = false
	self.NextIdleAnim = CurTime() + 10
	self.PigSticks = self.PigSticks + 1
	self:PigStick( 1.4 )

	self.Owner:EmitSound( tostring( table.Random( pig_stick ) ) )
	self:SetNext( self.PigStickDelay )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:SendWeaponAnim( ACT_VM_HITCENTER2 )

end

function SWEP:Slash()
	
	local ply = self.Owner

	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * self.Range

	local line = {}
	line.start = pos
	line.endpos = pos + aim
	line.filter = {self.Owner, self}
	
	local tr = {}
	tr.start = pos + self.Owner:GetAimVector() * -5
	tr.endpos = pos + aim
	tr.filter = {self.Owner, self }
	tr.mask = MASK_SHOT_HULL
	tr.mins = Vector(-20,-20,-20)
	tr.maxs = Vector(20,20,20)

	local linetr = util.TraceLine( line )
	local trace = util.TraceHull( tr )

	local ent = trace.Entity
	local ent2 = linetr.Entity
	
	if not IsValid( ent ) and IsValid( ent2 ) then
	
		ent = ent2
	
	end

	if SERVER then

		if not linetr.Hit then
			self.Owner:EmitSound(  knife_path.."knife_slash"..math.random(1,2)..".wav" )
		end

		if IsValid( ent ) then

			local dmg = DamageInfo()
			dmg:SetDamage( self.Primary.Damage )
			dmg:SetInflictor( self.Weapon )
			dmg:SetAttacker( self.Owner )
			dmg:SetDamageType( DMG_SLASH )
			dmg:SetDamageForce( self.Owner:GetAimVector()*self.Primary.HitForce )
			dmg:SetDamagePosition( linetr.HitPos )

			ent:TakeDamageInfo( dmg )

			if ent:IsPlayer() or ent:GetClass() == "prop_ragdoll" then
				local effect = EffectData()
				effect:SetOrigin(trace.HitPos)
				effect:SetScale(8)
				util.Effect("BloodImpact",effect,true,true)
				ent:EmitSound( knife_path.."knife_stab.wav", 100, math.random(90,110)  )
				if ent:GetClass() == "prop_ragdoll" then
					if ent.Hits and ent.Hits < GAMEMODE.Hidden.MaxBodyHeal then
						if not ent.IsGib then
							if self.Owner:Health() < GAMEMODE.Hidden.Health then
								ent.Hits = ent.Hits+1
								self.Owner:SetHealth( math.min( self.Owner:Health()+GAMEMODE.Hidden.BodyHealAmount, self.Owner:GetMaxHealth() ) )
								if ent.Hits >= GAMEMODE.Hidden.MaxBodyHeal then
									local dmg = DamageInfo()
									dmg:SetDamage( self.Primary.Damage )
									dmg:SetInflictor( self.Weapon )
									dmg:SetAttacker( self.Owner )
									dmg:SetDamageType( DMG_SLASH )
									dmg:SetDamageForce( self.Owner:GetAimVector()*self.Primary.HitForce )
									dmg:SetDamagePosition( linetr.HitPos )
									ent.PigSticked = true
									ent.DirForce = (self.Owner:GetShootPos() - (ent:GetPos()+Vector(0,0,60) )):GetNormal()*-1
									ent:TakeDamageInfo( dmg )
								end
							end
						end
					end
					local phys = ent:GetPhysicsObject()
					if IsValid( phys ) then
						phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * self.Primary.HitForce )
					end
				end
			else
				sound.Play(knife_path.."knife_hitwall1.wav",trace.HitPos,100,100)
			end

			if !ent:IsPlayer() then 
				
				local phys = ent:GetPhysicsObject()
				
				if IsValid( phys ) then
				
					ent:SetPhysicsAttacker( self.Owner )
					phys:Wake()
					phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * self.Primary.HitForce )
					
				end
			elseif ent:GetClass() == "func_breakable_surf" then
					
				ent:Fire( "shatter", "1 1 1", 0 )
			end
		elseif linetr.HitWorld then
			sound.Play(knife_path.."knife_hitwall1.wav",linetr.HitPos,100,100)
		end	
	end

	local Pos1 = linetr.HitPos + linetr.HitNormal
	local Pos2 = linetr.HitPos - linetr.HitNormal
	util.Decal("ManhackCut", Pos1, Pos2)
end

function SWEP:GetDamageForce()
	if self:GetPigStickMode() == 3 then
		return self.Owner:GetAimVector()*GAMEMODE.Hidden.PigStickForce+Vector( 0, 0, 150 ) 
	else
		return self.Owner:GetAimVector()*GAMEMODE.Hidden.PigStickForce
	end
end

function SWEP:GetPigStickDamage()
	if self:GetPigStickMode() == 3 then
		return self.Primary.Damage
	else
		return GAMEMODE.Hidden.PigStickDamage
	end
end

function SWEP:Stick()

	if CLIENT then return end
	local ply = self.Owner

	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * self.Range
	
	local line = {}
	line.start = pos
	line.endpos = pos + aim
	line.filter = {self.Owner, self}
	
	local hull_sz = 10
	local tr = {}
	tr.start = pos + self.Owner:GetAimVector() * -5
	tr.endpos = pos + aim
	tr.filter = {self.Owner, self }
	tr.mask = MASK_SHOT_HULL
	tr.mins = Vector( -hull_sz, -hull_sz, -hull_sz )
	tr.maxs = Vector( hull_sz, hull_sz, hull_sz )

	local linetr = util.TraceLine( line )
	local trace = util.TraceHull( tr )

	local ent = trace.Entity
	local ent2 = linetr.Entity
	
	if not IsValid( ent ) and IsValid( ent2 ) then
	
		ent = ent2
	
	end

	if SERVER then
		if IsValid( ent ) then

			local dmg = DamageInfo()
			dmg:SetDamage( self:GetPigStickDamage() )
			dmg:SetDamageForce( self:GetDamageForce() )
			dmg:SetInflictor( self.Weapon )
			dmg:SetAttacker( self.Owner )
			dmg:SetDamageType( DMG_SLASH )
			dmg:SetDamagePosition( linetr.HitPos )
			ent.PigSticked = true
			ent.DirForce = (self.Owner:GetShootPos() - (ent:GetPos()+Vector(0,0,60) )):GetNormal()*-1
			ent:TakeDamageInfo( dmg )



			if ent:IsPlayer() or ent:GetClass() == "prop_ragdoll" then

				local effect = EffectData()
				effect:SetOrigin(trace.HitPos)
				effect:SetScale(8)
				util.Effect("BloodImpact",effect,true,true)
				ent:EmitSound( knife_path.."knife_stab.wav", 100, math.random(90,110)  )

			else
				sound.Play(knife_path.."knife_hitwall1.wav",trace.HitPos,100,100)
			end

			if !ent:IsPlayer() then 
				
				local phys = ent:GetPhysicsObject()
				
				if IsValid( phys ) then
				
					ent:SetPhysicsAttacker( self.Owner )
					phys:Wake()
					phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * self.Primary.HitForce*50 )
					
				end
			elseif ent:GetClass() == "func_breakable_surf" then
					
				ent:Fire( "shatter", "1 1 1", 0 )
				
			end
			
		end
	end

	self.Owner:EmitSound( self.Primary.Sound, 100, math.random(80,100)  )
	local Pos1 = linetr.HitPos + linetr.HitNormal
	local Pos2 = linetr.HitPos - linetr.HitNormal
	util.Decal("ManhackCut", Pos1, Pos2)
end 

function SWEP:KnifeThink()

	if self:IsPigSticking() then
		if CurTime() > self.FinishStick then
			self:Stick()
			self.PigSticking = false
		end
	end

	if CurTime() > self.NextIdleAnim and not self:CheckValidity() then
		local vm = self.Owner:GetViewModel()
		vm:SetSequence( 0 )
		self.NextIdleAnim = CurTime() + 10
		self.ResetingSequence = true
		self.SeqenceResetDelay = CurTime() + self:SequenceDuration( 0 )
	end

	if self.ResetingSequence then
		if CurTime() > self.SeqenceResetDelay then
			self:SendWeaponAnim( ACT_VM_IDLE )
			self.ResetingSequence = false
		end
	end

	if not self:IsPigSticking() and self.Owner:KeyDown( IN_USE ) and CurTime() > self.PickUpDelay then
		self:DoAttack( true )
		self.PickUpDelay = CurTime() + 0.25
	end
end

function SWEP:IsPigSticking()
	return self.PigSticking
end

function SWEP:PigStick( delay )
	self.PigSticking = true
	self.FinishStick = CurTime() + delay
end

function SWEP:Holster()
	if self:IsPigSticking() then
		return false
	else
		self:Reset()
		return true 
	end
end

function SWEP:DrawWorldModel()
	return false
end

local player = player
local IsValid = IsValid
local CurTime = CurTime


local function SetSubPhysMotionEnabled(ent, enable)
   if not IsValid(ent) then return end

   for i=0, ent:GetPhysicsObjectCount()-1 do
      local subphys = ent:GetPhysicsObjectNum(i)
      if IsValid(subphys) then
         subphys:EnableMotion(enable)
         if enable then
            subphys:Wake()
         end
      end
   end
end

local function KillVelocity(ent)
   ent:SetVelocity(vector_origin)

   -- The only truly effective way to prevent all kinds of velocity and
   -- inertia is motion disabling the entire ragdoll for a tick
   -- for non-ragdolls this will do the same for their single physobj
   SetSubPhysMotionEnabled(ent, false)

   timer.Simple(0, function() SetSubPhysMotionEnabled(ent, true) end)
end

function SWEP:Reset(keep_velocity)
   if IsValid(self.CarryHack) then
      self.CarryHack:Remove()
   end

   if IsValid(self.Constr) then
      self.Constr:Remove()
   end

   if IsValid(self.EntHolding) then
      if not IsValid(self.PrevOwner) then
         self.EntHolding:SetOwner(nil)
      else
         self.EntHolding:SetOwner(self.PrevOwner)
      end

      -- the below ought to be unified with self:Drop()
      local phys = self.EntHolding:GetPhysicsObject()
      if IsValid(phys) then
         phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
         phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
         phys:EnableCollisions(true)
         phys:EnableGravity(true)
         phys:EnableDrag(true)
         phys:EnableMotion(true)
      end

	if (self.EntHolding:GetClass() == "prop_ragdoll") then
		KillVelocity(self.EntHolding)
	end

   end

   self:SetNWBool( "CarryingEnt", false )
   self.Weapon:SendWeaponAnim( ACT_VM_DRAW )

   self.EntHolding = nil
   self.CarryHack = nil
   self.Constr = nil
end
SWEP.reset = SWEP.Reset

function SWEP:CheckValidity()

   if (not IsValid(self.EntHolding)) or (not IsValid(self.CarryHack)) or (not IsValid(self.Constr)) then

      -- if one of them is not valid but another is non-nil...
      if (self.EntHolding or self.CarryHack or self.Constr) then
         self:Reset()
      end

      return false
   else
      return true
   end
end

local function PlayerStandsOn(ent)
   for _, ply in pairs(player.GetAll()) do
      if ply:GetGroundEntity() == ent and ply:Alive() then
         return true
      end
   end

   return false
end

if SERVER then

local ent_diff = vector_origin
local ent_diff_time = CurTime()

local stand_time = 0
function SWEP:Think()
	self:KnifeThink()
   if not self:CheckValidity() then return end

   -- If we are too far from our object, force a drop. To avoid doing this
   -- vector math extremely often (esp. when everyone is carrying something)
   -- even though the occurrence is very rare, limited to once per
   -- second. This should be plenty to catch the rare glitcher.
   if CurTime() > ent_diff_time then
      ent_diff = self:GetPos() - self.EntHolding:GetPos()
      if ent_diff:Dot(ent_diff) > 40000 then
         self:Reset()
         return
      end

      ent_diff_time = CurTime() + 1
   end

   if CurTime() > stand_time then

      if PlayerStandsOn(self.EntHolding) then
         self:Reset()
         return
      end

      stand_time = CurTime() + 0.1
   end

   self.CarryHack:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 70)

   self.CarryHack:SetAngles(self.Owner:GetAngles())

   self.EntHolding:PhysWake()
end

end

function SWEP:MoveObject(phys, pdir, maxforce, is_ragdoll)
   if not IsValid(phys) then return end
   local speed = phys:GetVelocity():Length()

   -- remap speed from 0 -> 125 to force 1 -> 4000
   local force = maxforce + (1 - maxforce) * (speed / 125)

   if is_ragdoll then
      force = force * 2
   end

   pdir = pdir * force

   local mass = phys:GetMass()
   -- scale more for light objects
   if mass < 50 then
      pdir = pdir * (mass + 0.5) * (1 / 50)
   end

   phys:ApplyForceCenter(pdir)
end

function SWEP:GetRange(target)
   if IsValid(target) and target:IsWeapon() and allow_wep:GetBool() then
      return wep_range:GetFloat()
   elseif IsValid(target) and target:GetClass() == "prop_ragdoll" then
      return 75
   else
      return 100
   end
end

function SWEP:AllowPickup(target)
   local phys = target:GetPhysicsObject()
   local ply = self:GetOwner()

   return (IsValid(phys) and IsValid(ply) and
           (not phys:HasGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)) and
           phys:GetMass() < CARRY_WEIGHT_LIMIT and
           (not PlayerStandsOn(target)) and
           (target.CanPickup != false) and
           ((not target:IsWeapon()) or allow_wep:GetBool()))
end

function SWEP:DoAttack(pickup)
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if IsValid(self.EntHolding) then

      if (not pickup) and self.EntHolding:GetClass() == "prop_ragdoll" then
         -- see if we can pin this ragdoll to a wall in front of us
         if not self:PinRagdoll() then
            -- else just drop it as usual
            self:Drop()
         end
      else
         self:Drop()
      end

      self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
      return
   end

   local ply = self.Owner

   local trace = ply:GetEyeTrace(MASK_SHOT)
   if IsValid(trace.Entity) then
      local ent = trace.Entity
      local phys = trace.Entity:GetPhysicsObject()

      if not IsValid(phys) or not phys:IsMoveable() or phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
         return
      end

      -- if we let the client mess with physics, desync ensues
      if CLIENT then return end

      if pickup then
         if (ply:EyePos() - trace.HitPos):Length() < self:GetRange(ent) then

            if self:AllowPickup(ent) then
               self:Pickup()

               -- make the refire slower to avoid immediately dropping
               local delay = (ent:GetClass() == "prop_ragdoll") and 0.8 or 0.5

               self.Weapon:SetNextSecondaryFire(CurTime() + delay)
               return
            else
               local is_ragdoll = trace.Entity:GetClass() == "prop_ragdoll"

               -- pull heavy stuff
               local ent = trace.Entity
               local phys = ent:GetPhysicsObject()
               local pdir = trace.Normal * -1

               if is_ragdoll then

                  phys = ent:GetPhysicsObjectNum(trace.PhysicsBone)

                  -- increase refire to make rags easier to drag
                  --self.Weapon:SetNextSecondaryFire(CurTime() + 0.04)
               end

               if IsValid(phys) then
                  self:MoveObject(phys, pdir, 6000, is_ragdoll)
                  return
               end
            end
         end
      else
         if (ply:EyePos() - trace.HitPos):Length() < 100 then
            local phys = trace.Entity:GetPhysicsObject()
            if IsValid(phys) then
               if IsValid(phys) then
                  local pdir = trace.Normal
                  self:MoveObject(phys, pdir, 6000, (trace.Entity:GetClass() == "prop_ragdoll"))

                  self.Weapon:SetNextPrimaryFire(CurTime() + 0.03)
               end
            end
         end
      end
   end
end

-- Perform a pickup
function SWEP:Pickup()
   if CLIENT or IsValid(self.EntHolding) then return end

   local ply = self.Owner
   local trace = ply:GetEyeTrace(MASK_SHOT)
   local ent = trace.Entity
   self.EntHolding = ent
   local entphys = ent:GetPhysicsObject()


   if IsValid(ent) and IsValid(entphys) then

   		self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
   		self:SetNWBool( "CarryingEnt", true )

      self.CarryHack = ents.Create("prop_physics")
      if IsValid(self.CarryHack) then
         self.CarryHack:SetPos(self.EntHolding:GetPos())

         self.CarryHack:SetModel("models/weapons/w_bugbait.mdl")

         self.CarryHack:SetColor(Color(50, 250, 50, 240))
         self.CarryHack:SetNoDraw(true)
         self.CarryHack:DrawShadow(false)

         self.CarryHack:SetHealth(999)
         self.CarryHack:SetOwner(ply)
         self.CarryHack:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
         self.CarryHack:SetSolid(SOLID_NONE)

         self.CarryHack:Spawn()

         -- if we already are owner before pickup, we will not want to disown
         -- this entity when we drop it
         self.PrevOwner = self.EntHolding:GetOwner()

         self.EntHolding:SetOwner(ply)

         local phys = self.CarryHack:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetMass(200)
            phys:SetDamping(0, 1000)
            phys:EnableGravity(false)
            phys:EnableCollisions(false)
            phys:EnableMotion(false)
            phys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
         end

         entphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
         local bone = math.Clamp(trace.PhysicsBone, 0, 1)
         local max_force = prop_force

         if ent:GetClass() == "prop_ragdoll" then
            self.carried_rag = ent

            bone = trace.PhysicsBone
            max_force = 0
         else
            self.carried_rag = nil
         end

         self.Constr = constraint.Weld(self.CarryHack, self.EntHolding, 0, bone, max_force, true)


      end
   end
end

function SWEP:IsCarrying()
	return self:GetNWBool( "CarryingEnt", false )
end 

local down = Vector(0, 0, -1)
function SWEP:AllowEntityDrop()
   local ply = self.Owner
   local ent = self.CarryHack
   if (not IsValid(ply)) or (not IsValid(ent)) then return false end

   local ground = ply:GetGroundEntity()
   if ground and (ground:IsWorld() or IsValid(ground)) then return true end

   local diff = (ent:GetPos() - ply:GetShootPos()):GetNormalized()

   return down:Dot(diff) <= 0.75
end

function SWEP:Drop()
   if not self:CheckValidity() then return end
   if not self:AllowEntityDrop() then return end
   if SERVER then
      self.Constr:Remove()
      self.CarryHack:Remove()

      local ent = self.EntHolding

      local phys = ent:GetPhysicsObject()
      if IsValid(phys) then
         phys:EnableCollisions(true)
         phys:EnableGravity(true)
         phys:EnableDrag(true)
         phys:EnableMotion(true)
         phys:Wake()
         phys:ApplyForceCenter(self.Owner:GetAimVector() * 500)

         phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
         phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
      end

      -- Try to limit ragdoll slinging
	if ent:GetClass() == "prop_ragdoll" then
		KillVelocity(ent)
	end

      ent:SetPhysicsAttacker(self.Owner)

   end

   self:Reset()
end

local CONSTRAINT_TYPE = "Rope"

local function RagdollPinnedTakeDamage(rag, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return end

   -- drop from pinned position upon dmg
   constraint.RemoveConstraints(rag, CONSTRAINT_TYPE)
   rag:PhysWake()

   rag:SetHealth(0)
   rag.is_pinned = false
end

function SWEP:PinRagdoll()

   local rag = self.EntHolding
   local ply = self.Owner

   local tr = util.TraceLine({start  = ply:EyePos(),
                              endpos = ply:EyePos() + (ply:GetAimVector() * PIN_RAG_RANGE),
                              filter = {ply, self, rag, self.CarryHack},
                              mask   = MASK_SOLID})

   if tr.HitWorld and (not tr.HitSky) then

      -- find bone we're holding the ragdoll by
      local bone = self.Constr.Bone2

      -- only allow one rope per bone
      for _, c in pairs(constraint.FindConstraints(rag, CONSTRAINT_TYPE)) do
         if c.Bone1 == bone then
            c.Constraint:Remove()
         end
      end

      local bonephys = rag:GetPhysicsObjectNum(bone)
      if not IsValid(bonephys) then return end

      local bonepos = bonephys:GetPos()
      local attachpos = tr.HitPos
      local length = (bonepos - attachpos):Length() * 0.1

      -- we need to convert using this particular physobj to get the right
      -- coordinates
      bonepos = bonephys:WorldToLocal(bonepos)

      constraint.Rope(rag, tr.Entity, bone, 0, bonepos, attachpos,
                      length, length * 0.2, 6000,
                      0, "cable/rope", false)

      rag.is_pinned = true
      rag.OnPinnedDamage = RagdollPinnedTakeDamage

      -- lets EntityTakeDamage run for the ragdoll
      rag:SetHealth(999999)

      self:Reset(true)
   end
end

function SWEP:OnRemove()
   self:Reset()
end

function SWEP:Deploy()
	self:Reset()
	timer.Simple( 0.1, function() 
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	end)
	
	return true
end


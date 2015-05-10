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

SWEP.PigStickDelay = 2.6
SWEP.PigSticks = 0
SWEP.MaxPigSticks = 99999

SWEP.PigSticking = false

SWEP.Range = 90

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

function SWEP:Think()

	if self:IsPigSticking() then
		if CurTime() > self.FinishStick then
			self:Stick()
			self.PigSticking = false
		end
	end

	if CurTime() > self.NextIdleAnim then
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
end

function SWEP:IsPigSticking()
	return self.PigSticking
end

function SWEP:PigStick( delay )
	self.PigSticking = true
	self.FinishStick = CurTime() + delay
end

function SWEP:Holster()
	return not self:IsPigSticking()
end

function SWEP:DrawWorldModel()
	return false
end
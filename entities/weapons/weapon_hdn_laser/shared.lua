
AddCSLuaFile()

SWEP.HoldType = "slam"


if CLIENT then
   SWEP.PrintName = "Disintergrator Mine"
   SWEP.Slot = 2
   
end

SWEP.Base				= "weapon_base"


SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"
SWEP.Weight			= 5


SWEP.CanPlace = false
SWEP.DrawAnim = ACT_SLAM_TRIPMINE_DRAW
SWEP.CanPlaceAnim = ACT_SLAM_TRIPMINE_ATTACH
SWEP.IdleAnim = ACT_SLAM_TRIPMINE_IDLE
SWEP.PlaceAnim = ACT_SLAM_TRIPMINE_ATTACH2

SWEP.DrawAnim_Placed = ACT_SLAM_DETONATOR_DRAW
SWEP.Detonate = ACT_SLAM_DETONATOR_DETONATE
SWEP.DetIdle = ACT_SLAM_DETONATOR_IDLE
SWEP.ChangeAnim = ACT_SLAM_TRIPMINE_TO_THROW_ND

SWEP.Primary.Delay				= 1
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= -1
SWEP.Primary.NumShots			= -1
SWEP.Primary.Cone				= -1
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetDeploySpeed( 1.3 )
	self.Targets = {}

	self.Placed = false
	self.Raised = false

	self.CanHolster = true
	self.Detonated = false
end

function SWEP:Deploy()

	if self.Placed == false then
		self:SendWeaponAnim( self.DrawAnim )
	else
		self:SendWeaponAnim( self.DrawAnim_Placed )
	end
	return true 	
end

function SWEP:Think()
	if self.Placed == true then return end
	
	local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*70, {self, self.Owner} )
	
	if IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_ragdoll" and self.Raised == false  then
		self.Raised = true
		self:SendWeaponAnim( self.CanPlaceAnim )
	elseif tr.HitWorld and self.Raised == true or not tr.Hit and self.Raised == true then
		self.Raised = false
		self:SendWeaponAnim(self.IdleAnim)
	end
	
end

function SWEP:PrimaryAttack()	
	if self.Placed == false then
		local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*70, {self, self.Owner})
		
		if tr.Hit and tr.HitNonWorld then
		
			if tr.Entity:GetClass() == "prop_ragdoll" then
			
				if IsFirstTimePredicted() then
					self.Owner:EmitSound("physics/cardboard/cardboard_box_break3.wav")
					self:SendWeaponAnim( self.PlaceAnim )
				end
				
				self.Owner:SetNWEntity("IEDTarget", tr.Entity )
				self.Placed = true
				self.CanHolster = false
				timer.Simple(0.7,function()
					if IsValid(self) and IsValid(self.Owner) then
						self:SendWeaponAnim( self.DrawAnim_Placed )
						self.CanHolster = true
					end
				end)
			end
			
		end
	end
end

function SWEP:Explode( targ, owner )
	
	if IsValid( targ ) then
		local explosioneffect = ents.Create( "prop_combine_ball" )
	    explosioneffect:SetPos(targ:GetPos())
	    explosioneffect:Spawn()
	   	explosioneffect:Fire( "explode", "", 0 )

	    local targname = "dissolveme"..targ:EntIndex()
		targ:SetKeyValue("targetname",targname)

		local targpos = targ:GetPos()
		targ:Gore( VectorRand()*1000 )

		util.BlastDamage( self, self.Owner, targpos, 150, 20 )
		self:Remove()
	end	
end

function SWEP:Reload()

end

function SWEP:SecondaryAttack()
	if self.Placed == false then return end
	if self.Detonated == true then return end
	
	if IsFirstTimePredicted() then
		self:SendWeaponAnim( self.Detonate )
		self:EmitSound("buttons/blip2.wav")
	end
	
	if SERVER then
		self:Explode( self.Owner:GetNWEntity("IEDTarget"), self.Owner )
	end 
	self.Detonated = true
	
end

function SWEP:Holster()
	return self.CanHolster
end

function SWEP:OnDrop()
	self.OldOwner = self.Owner
end
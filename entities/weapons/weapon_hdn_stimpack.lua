if SERVER then
   AddCSLuaFile()
end
   
SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName			= "Medkit"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 2
end

SWEP.Base = "weapon_base"


SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"
SWEP.ViewModelFOV		= 54
SWEP.Primary.DefaultClip = 100
SWEP.Primary.ClipMax 	=  100

SWEP.MaxCharge = 80
SWEP.Charge = 80
SWEP.ChargeTime = 30 -- In Seconds.
SWEP.ChargeDelay = 0
SWEP.UsePerCharge = SWEP.MaxCharge/GAMEMODE.MedpackUses


local HealSound = Sound( "items/smallmedkit1.wav" )
local DenySound = Sound( "items/medshotno1.wav" )

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:IsCharged()
	return self.Charge >= self.UsePerCharge
end

function SWEP:UseCharge()
	self.Charge = self.Charge - self.UsePerCharge
	self.ChargeDelay = CurTime() + 3
end

function SWEP:PrimaryAttack()

	if self:IsCharged() then
		if SERVER then
			self:Heal( false )
		end
	else
		self:EmitSound( DenySound )
	end

end

function SWEP:SecondaryAttack()

	if self:IsCharged() then
		if SERVER then
			self:Heal( true )
		end
	else
		self:EmitSound( DenySound )
	end
end

function SWEP:Heal( is_self )
	if is_self and self.Owner:IsInjured() then
		self.Owner:Heal( GAMEMODE.MedpackHealSelf )
		self.Owner:EmitSound( HealSound )
		self:UseCharge()
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
	else
		self.Owner:LagCompensation( true )
			local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*50, {self,self.Owner})
		self.Owner:LagCompensation( false )

		local ent = tr.Entity
		if tr.Hit and IsValid( tr.Entity ) then
			if tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_HUMAN then
				if SERVER then
					tr.Entity:Heal( GAMEMODE.MedpackHealSelf )
					self.Owner:EmitSound( HealSound )
				end
				self:UseCharge()
				self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			end
		end
	end
end


function SWEP:Think()

	if self.Charge < self.MaxCharge and self.ChargeDelay < CurTime() then
		local charge_ps = self.MaxCharge/self.ChargeTime
		local delay = 1/charge_ps
		self.Charge = self.Charge + 1
		self.ChargeDelay = CurTime() + delay 
	end

end


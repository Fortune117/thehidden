if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName			= "Medkit"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 2

	function DrawSegmentBar( x, y, full_w, w, h, t, l, g)
		local segs = math.Round( full_w/t )
		local loop_no = math.ceil(segs*(w/full_w))
		local r =  1 - (loop_no - w/t)
		for i = 1,loop_no do
			local add = i == loop_no and (full_w/segs)*r or (full_w/segs)
			local s = x + (full_w/segs)*(i-1) + g
			local bar =
			{ 
				{x = s + l, y = y },
				{x = s + add + l - (g*2), y = y },
				{x = s + add - (g*2), y = y + h },
				{x = s, y = y + h}
			}
			surface.DrawPoly( bar )
		end
	end

	function SWEP:DrawHUD()
		local w = ScrW()/5
	   	local h = 10
	   	local x = ScrW()/2 - w/2
	   	local y = 30
		local m_charge = self.MaxCharge
		local c = self:GetCharge()
		local bars = m_charge/self.UsePerCharge
		local bar_p = c/m_charge

		surface.SetDrawColor( Color( 14, 14, 14, 255 ) )
		DrawSegmentBar( x, ScrH() - y, w, w, h, w/bars, 0, 2 )

		local r = 255*( 1 - bar_p )
		local g = 255*( bar_p )
		local b = 120*( bar_p )
		surface.SetDrawColor( Color( r, g, b ,255 ) )
		DrawSegmentBar( x, ScrH() - y, w, w*bar_p, h, w/bars, 0, 2 )
	end 
end

SWEP.Base = "weapon_base"

SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_medkit.mdl" 
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"
SWEP.ViewModelFOV		= 54
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipMax 	= -1

local HealSound = Sound( "items/smallmedkit1.wav" )
local DenySound = Sound( "items/medshotno1.wav" )

function SWEP:SetCharge( num )
	self:SetNWInt( "Charge", math.min( num, self.MaxCharge ) )
end

function SWEP:GetCharge()
	return self:GetNWInt( "Charge", 0 )
end

function SWEP:Initialize()

	self.MaxCharge = 100
	self.UsePerCharge = self.MaxCharge/GAMEMODE.MedpackUses
	self:SetCharge( 100 )
	self.ChargeTime = 20 -- In Seconds.
	self.ChargeDelay = 0

	self:SetHoldType( self.HoldType )

end

function SWEP:IsCharged()
	return self:GetCharge() >= self.UsePerCharge
end

function SWEP:UseCharge()
	self:SetCharge( self:GetCharge() - self.UsePerCharge )
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
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
	else
		self.Owner:LagCompensation( true )
			local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*50, {self,self.Owner})
		self.Owner:LagCompensation( false )

		local ent = tr.Entity
		if tr.Hit and IsValid( tr.Entity ) then
			if tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_HUMAN then
				if SERVER then
					tr.Entity:Heal( GAMEMODE.MedpackHeal )
					self.Owner:EmitSound( HealSound )
				end
				self:UseCharge()
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			end
		end
	end
end


function SWEP:Think()

	if self:GetCharge() < self.MaxCharge and self.ChargeDelay < CurTime() then
		local charge_ps = self.MaxCharge/self.ChargeTime
		local delay = 1/charge_ps
		self:SetCharge( self:GetCharge() + 1 )
		self.ChargeDelay = CurTime() + delay 
	end

end

function SWEP:Holster()
	self.HolsterTime = CurTime()
	return true 
end

function SWEP:Deploy()
	if self.HolsterTime then
		local charge_ps = self.MaxCharge/self.ChargeTime
		local delay = 1/charge_ps
		local time = math.Round( CurTime() - self.HolsterTime )
		self:SetCharge( self:GetCharge() +  time/delay )
	end
	return true 
end 


if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName			= "Ammo Bag"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 2
end

SWEP.Base = "weapon_base"


SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV		= 10
SWEP.Primary.DefaultClip = 3
SWEP.Primary.ClipMax 	= 3
SWEP.Primary.ClipSize = 3
SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.AutoMatic = false 



function SWEP:PrimaryAttack()
	self.Owner:EmitSound( "npc/fast_zombie/claw_miss1.wav" )
	if SERVER then
		local ply = self.Owner 
		local ent = ents.Create( "hdn_ammobox" )
		ent:SetPos( ply:GetShootPos() + ply:GetAimVector()*10 )
		ent:SetAngles( ply:GetAngles()*-1 )
		ent.Owner = ply 
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:Wake()
			phys:ApplyForceCenter( ply:GetAimVector()*1200 )
		end
		self:SetClip1( self:Clip1() - 1 )
		if self:Clip1() <= 0 then
			self:Remove()
		end
	end 
end

function SWEP:SecondaryAttack()
	return true
end
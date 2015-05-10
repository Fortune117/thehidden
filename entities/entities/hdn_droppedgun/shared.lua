
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Dropped Gun"
end

ENT.Type = "anim"
ENT.Model = "models/weapons/w_slam.mdl"


function ENT:Initialize()

	if SERVER then
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetUseType( SIMPLE_USE )
	end
	
end


function ENT:SetWeapon( wep )
	local model = wep.WorldModel
	self:SetModel( model )
	self.WeaponEnt = wep.ClassName
	self.StoredAmmo = wep:Clip1()
	self.AmmoType = wep.Primary.Ammo 
end

function ENT:Use( ply )
	if SERVER then
		if IsValid( ply ) and ply:Alive() and ply:Team() == TEAM_HUMAN then
			local wep = ply:GetPrimary()
			if IsValid( wep ) then
				ply:CreateWeapon()
			end
			local old_ammo = ply:GetAmmoCount( self.AmmoType )
			ply:Give( self.WeaponEnt )
			ply:SetAmmo( old_ammo, self.AmmoType )
			ply:SelectWeapon( self.WeaponEnt )
			local new_wep = ply:GetWeapon( self.WeaponEnt )
			new_wep:SetClip1( self.StoredAmmo )
			self:Remove()
		end
	end
end
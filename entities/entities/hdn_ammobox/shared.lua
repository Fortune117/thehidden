
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Ammo Box"
end

ENT.Type = "anim"
ENT.Model = "models/generic/gen_ammo_bag.mdl"

ENT.UseTable = {}

function ENT:Initialize()

	if SERVER then
		local min,max = self:GetCollisionBounds()
		self:SetModel( self.Model )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end


	self:SetHealth( 5 )
	self.PlaceTime = CurTime() + 3

end

function ENT:PhysicsCollide( data, physobj )

	if data.Speed > 1 and data.DeltaTime > 0.35 then
	
		self.Entity:EmitSound( "physics/cardboard/cardboard_box_impact_soft"..math.random( 1, 7 )..".wav", 125, math.random( 80, 120 ) )
	end
	
end

function ENT:Use( ply )
	if SERVER then
		if CurTime() < self.PlaceTime and ply != self.Owner then return end 
		local wep = ply:GetPrimary()
		ply:GiveAmmo( wep.Primary.ClipSize, wep.Primary.Ammo )
		self:Remove()
	end
end

function ENT:OnTakeDamage( dmginfo )
	local atk = dmginfo:GetAttacker()
	if not atk:IsPlayer() or not atk:IsHidden() then return end 
   	self:TakePhysicsDamage(dmginfo)
   
	if IsValid(self) then
		self:SetHealth(self:Health() - dmginfo:GetDamage() )
		
		if self:Health() <= 0 then
			self:Remove()
		end
	end
end


if SERVER then 
AddCSLuaFile("shared.lua")
end

if CLIENT then
   ENT.PrintName = "Grenade"
end

ENT.Type = "anim"
ENT.Model = "models/weapons/pipe/w_pipebomb_thrown.mdl"

ENT.CanUseKey = false

ENT.On = false

function ENT:Initialize()

	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_BBOX)
   	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	self.ThrowLiveTime = CurTime() + 3
	self.LiveTime = CurTime() + 1.5

end


function ENT:Detonate( mult )

	if mult == nil then mult = 1 end
	
	if IsValid(self) then
		if SERVER then
			if self.Detonated then
				return
			end
			
			self.Detonated = true
			util.BlastDamage( self.Owner, self.Owner, self:GetPos(), GAMEMODE.Hidden.GrenadeBlastRadius, GAMEMODE.Hidden.GrenadeDamage )
			
			local effect = EffectData()
			effect:SetStart(self:GetPos())
			effect:SetOrigin(self:GetPos())
			effect:SetScale( GAMEMODE.Hidden.GrenadeBlastRadius )
			effect:SetRadius( GAMEMODE.Hidden.GrenadeBlastRadius )
			effect:SetMagnitude( GAMEMODE.Hidden.GrenadeBlastRadius )
			effect:SetNormal( self:GetUp() )
			util.Effect("Explosion", effect, true, true)
				
			self:Remove()
		end
	end

end

function ENT:PhysicsCollide( data, physobj )

	self.HasTouchedGround = true
	--We have to at least hit one surface before we explode.
	if CurTime() > self.ThrowLiveTime then

		self:Detonate()
		
	end

	if data.Speed > 1 and data.DeltaTime > 0.35 then
	
		self.Entity:EmitSound( "weapons/hegrenade/he_bounce-1.wav", 125, math.random( 80, 120 ) )

		--Taken from sent_ball by Garry Newman.
		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = physobj:GetVelocity()
		NewVelocity:Normalize()
		
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
		
		local TargetVelocity = data.OurOldVelocity*0.4
		
		physobj:SetVelocity( TargetVelocity )

	elseif CurTime() > self.LiveTime then

		self:Detonate()

	end

	
end

function ENT:Think()
	if CurTime() > self.LiveTime and self.HasTouchedGround then
		self:Detonate()
	end
end
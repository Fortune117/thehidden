AddCSLuaFile()

function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	self.Entity = data:GetEntity() 

	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 6
	self.LiveTime = CurTime() + 1
	local sidevel = 30
	local up_downvel = 25

	local sc = self.Entity:Health()/self.Entity:GetMaxHealth()

	self.emitter = ParticleEmitter( Pos )
	
		for i=1,math.random(7,11) do
		
			local particle = self.emitter:Add( "sprites/aura", Pos + Vector(0,0,math.random(0,60)))
			local sz = math.random(8, 11)

			particle:SetVelocity(Vector(math.random(-sidevel,sidevel),math.random(-sidevel,sidevel), math.random(-up_downvel, up_downvel)))
			particle:SetDieTime(math.Rand( 0.3, 0.6 ))
			particle:SetStartAlpha( 40 )
			particle:SetStartSize( sz )
			particle:SetEndSize( sz )
			particle:SetRoll( math.Rand( 360, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 255 * ( 1 - sc ), 255 * sc, 100 * sc )

		end
end


function EFFECT:Think( )
	return IsValid( self ) and CurTime() < self.LiveTime or false
end

-- Draw the effect
function EFFECT:Render()
	return true-- Do nothing - this effect is only used to spawn the particles in Init	
end






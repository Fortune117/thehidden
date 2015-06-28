

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( math.Rand( 1.3, 1.8 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 5, 10 ) )
	particle:SetEndSize( math.Rand( 75, 100 ) )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	
	local speed = 25
	for i=1, math.random(18,35) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(math.random(-speed,speed),math.random(-speed,speed), 10 ) )
		particle:SetDieTime( 1.5 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 20, 40 ) )
		particle:SetEndSize( math.Rand( 50, 150 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 50, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	

	emitter:Finish()
	
	
end

function EFFECT:Think( )

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end

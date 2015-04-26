-- simple unloack effect :/

--Initializes the effect. The data is a table of data 
--which was passed from the server.

		
local params = {}
params[ "$basetexture" ] = "sprites/aura"
params[ "$vertexcolor" ] = 1
params[ "$vertexalpha" ] = 1
params[ "$angle" ] = 1
params[ "$ignorez" ] = 1
params[ "$additive" ] = 1
params[ "$spriteorigin" ] = "[ 0.25 0.25 ]"
params[ "$spriteorientation" ] = "vp_parallel"

local aura = CreateMaterial( "aura_mat", "UnlitGeneric", params )
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

	local emitter = ParticleEmitter( Pos )
	
		for i=1,math.random(7,11) do
		
			local particle = emitter:Add( "sprites/aura.vmt", Pos + Vector(0,0,math.random(0,60)))
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
	emitter:Finish()
end


function EFFECT:Think( )
	return self.LiveTime > CurTime()	
end

-- Draw the effect
function EFFECT:Render()
	return true-- Do nothing - this effect is only used to spawn the particles in Init	
end

function EFFECT:Draw()
	return true
end




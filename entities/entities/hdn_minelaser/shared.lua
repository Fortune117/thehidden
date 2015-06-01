
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trip Mine"
end

ENT.Type = "anim"
ENT.Model = "models/weapons/w_slam.mdl"

ENT.CanUseKey = false


function ENT:Initialize()
	self.Entity:DrawShadow( false )
	self.Entity:SetTrigger( true )
	self.Entity:SetSolid( SOLID_BBOX )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self.Entity:SetModel( "models/weapons/w_grenade.mdl" )
	self.NextAlarm = CurTime()
end


 
function ClampWorldVector(vec)
	vec.x = math.Clamp( vec.x , -16380, 16380 )
	vec.y = math.Clamp( vec.y , -16380, 16380 )
	vec.z = math.Clamp( vec.z , -16380, 16380 )
	return vec
end


function ENT:SetLaserPositions( start, endpos )
	self:SetNWVector( "EndPos", endpos )
	self:SetNWVector( "StartPos", start )
	self.Entity:SetCollisionBoundsWS( start, endpos, Vector( ) * 0.25 )
end

function ENT:SetLaserColor( is_blue )
	self:SetNWBool("LaserColor", is_blue)
end

function ENT:GetEndPos()
	return self:GetNWVector( "EndPos" )
end

function ENT:GetStartPos()
	return self:GetNWVector( "StartPos" )
end

if SERVER then
	function ENT:Touch( ent )

		local parent = self.Entity:GetParent()
		
		if not IsValid( parent ) then

			self.Entity:Remove()
		
		end

		if CurTime() < self.NextAlarm then return end
		
		if not ent:IsPlayer() then
		
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) and not phys:IsAsleep() then
			
				parent:DoAlarm( false )
			
			end
		
		else
		
			if ent:Team() == TEAM_HIDDEN then
				
				parent:DoAlarm( true )

			elseif ent:Team() == TEAM_HUMAN then
			
				parent:DoAlarm( false )
				
			end
			
		end
		self.NextAlarm = CurTime() + 2
	end

end


if CLIENT then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

	function ENT:Initialize()

		self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )
		
	end

	function ENT:Think()

		self:SetRenderBoundsWS( self:GetEndPos( ), self:GetPos( ) )
		
	end

	ENT.Laser = Material( "sprites/bluelaser1" )
	ENT.Light = Material( "effects/blueflare1" )

	--[[function ENT:Draw()

	end]]

	function ENT:Draw()
		
		if self.Entity:GetEndPos() == Vector(0,0,0) then return end
		
		local offset = CurTime() * 3
		local distance = self.Entity:GetEndPos():Distance( self.Entity:GetPos() )
		local size = math.Rand( 2, 4 )
		local normal = ( self.Entity:GetPos() - self.Entity:GetEndPos() ):GetNormal() * 0.1
		
		local col = self:GetNWBool("LaserColor") and Color( 50, 50, 255, 100 ) or Color( 50, 255, 50, 100 ) 
		render.SetMaterial( self.Laser )
		render.DrawBeam( self.Entity:GetEndPos(), self.Entity:GetStartPos(), 2, offset, offset + distance / 8, col )
		render.DrawBeam( self.Entity:GetEndPos(), self.Entity:GetStartPos(), 1, offset, offset + distance / 8, col )
		
		render.SetMaterial( self.Light )
		render.DrawQuadEasy( self.Entity:GetEndPos() + normal, normal, size, size, col, 0 )
		render.DrawQuadEasy( self.Entity:GetPos(), normal * -1, size, size, col, 0 )
		 
	end
end

if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trip Mine"
end

ENT.Type = "anim"
ENT.Model = "models/weapons/w_slam.mdl"

ENT.CanUseKey = false

ENT.On = false

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetTrigger( true )
		self:DrawShadow(false)
	end


	self:SetHealth( 25 )
	timer.Simple(2,function()
		if IsValid(self) then
			self.On = true
			if IsFirstTimePredicted() then
				sound.Play( "buttons/blip2.wav", self:GetPos() )
			end

			if SERVER then
				local tr = util.QuickTrace( self:GetPos() + self:GetRight()*-1.4 + self:GetForward()*-2.25, self:GetUp()*9000, { self, unpack( player.GetAll() ), unpack( ents.GetAll() ) } )
				self.Laser = ents.Create( "hdn_minelaser" )
				self.Laser:Spawn()
				self.Laser:SetLaserPositions( self:GetPos() + self:GetRight()*-1.4 + self:GetForward()*-2.25, tr.HitPos )
				self.Laser:SetLaserColor( true )
				self.Laser:SetParent( self )
			end
		end
	end)
	
		self:SetBodygroup( 0, 1 )
end


function ENT:Detonate( mult )

	if mult == nil then mult = 1 end
	
	if IsValid(self) then
		if SERVER then
			if self.Detonated then
				return
			end
			
			self.Detonated = true
			util.BlastDamage( self.Owner, self.Owner, self:GetPos(), 200*mult, 50*mult)
			
			local effect = EffectData()
			effect:SetStart(self:GetPos())
			effect:SetOrigin(self:GetPos())
			effect:SetScale(400*mult)
			effect:SetRadius(400*mult)
			effect:SetMagnitude(220*mult)
			effect:SetNormal( self:GetUp() )
			util.Effect("Explosion", effect, true, true)
				
			self:Remove()
		end
	end
end

function ENT:DoAlarm( is_hidden )

	if is_hidden then
		self:Detonate()
	end

end

 
function ClampWorldVector(vec)
	vec.x = math.Clamp( vec.x , -16380, 16380 )
	vec.y = math.Clamp( vec.y , -16380, 16380 )
	vec.z = math.Clamp( vec.z , -16380, 16380 )
	return vec
end 

local GibProbs = { "models/props/cs_office/computer_caseb_p3a.mdl", "models/props/cs_office/projector_p6.mdl" } 
function ENT:BreakRemove()

	local gib = ents.Create( "physics_prop" )
	gib:SetPos( self:GetPos() )
	gib:SetAngles( self:GetAngles() )
	gib:SetModel( self.Model )
	gib:SetBodygroup( 0, 1 )
	gib:Spawn()
	gib:SetCollisionGroup(  COLLISION_GROUP_DEBRIS )
	local phys = gib:GetPhysicsObject()
	if IsValid( phys) then
		phys:Wake()
		phys:ApplyForceCenter( VectorRand()*12 )
	end

	self:Remove()
end


function ENT:OnTakeDamage( dmginfo )
	local atk = dmginfo:GetAttacker()
	if not atk:IsPlayer() or not atk:IsHidden() then return end 
   	self:TakePhysicsDamage(dmginfo)
   
	if IsValid(self) then
		if dmginfo:GetDamageType() == DMG_BLAST or dmginfo:GetDamageType() == DMG_BURN then
			self:Detonate(0.5)
		else
		
			self:SetHealth(self:Health() - dmginfo:GetDamage() )
			
			if self:Health() <= 0 then
				self:BreakRemove()
			end
		end
	end
end

if SERVER then
	function ENT:OnRemove()
		if IsValid( self.Laser ) then
			self.Laser:Remove()
		end
	end 
end

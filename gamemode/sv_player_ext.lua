
local PLY = FindMetaTable( "Player" )

function PLY:SetHiddenDamage( num )
	self:SetNWInt( "HiddenDamage", num )
end

function PLY:GetHiddenDamage( )
	return self:GetNWInt( "HiddenDamage", 0 )
end

function PLY:AddHiddenDamage( num )
	self:SetNWInt( "HiddenDamage", self:GetHiddenDamage() + num )
end

function GM:OnStaminaChange( ply, old, new )
	ply.ChargeDelay = CurTime() + self.Hidden.StaminaDelay
	hook.Call( "HDN_OnStaminaChange", self, ply, old, new )
end

function PLY:Heal( num )
	self:SetHealth( math.min( self:Health() + num, self:GetMaxHealth() ) )
	GAMEMODE:OnPlayerHealed( self, num )
end

function PLY:Blind( duration, intensity )
	net.Start( "Blind" )
		net.WriteTable( {duration, intensity} )
	net.Send( self )
	hook.Call( "HDN_OnBlind", GAMEMODE, self, duration, intensity )
end

function PLY:AddScore( score )
	self:SetNWInt( "Score", self:GetNWInt( "Score", 0 ) + score )
end

function PLY:DoTaunt( tbl )
	if #tbl < 1 then return end

	if not self.TauntDelay then
		self.TauntDelay = CurTime() - 1
	end

	local snd = "player/hidden/voice/"..table.Random( tbl )
	if CurTime() > self.TauntDelay then
		self:EmitSound( snd )
		self.TauntDelay = CurTime() + SoundDuration( snd ) + 0.2
	end
	hook.Call( "HDN_OnTaunt", GAMEMODE, self, tbl )
end



function PLY:HiddenDamageSounds( is_killshot )
	local gm = GAMEMODE
	if not self.NextHiddenDamageSound then
		self.NextHiddenDamageSound = CurTime() - 1
	end

	if self.NextHiddenDamageSound < CurTime() then
		local snd = tostring( is_killshot and table.Random( gm.HiddenDeathSounds ) or table.Random( gm.HiddenPainSounds ) )
		self:EmitSound( snd )
		self.NextHiddenDamageSound = CurTime() + SoundDuration( snd ) + 0.5
	end
end 

function PLY:SetNextJump( time )
	self:SetNWInt( "NextJump", time )
end

function PLY:SetCanJump( bool )
	self:SetNWBool( "CanJump", bool )
end

function PLY:SetNextVoice( vtype, delay, is_reply )
	self.vtype = vtype
	self.NextVoice = CurTime() + delay
	self.IsReply = is_reply
end

function PLY:DoVoice()

	local gm = GAMEMODE
	if not self.vtype then self.vtype = VO_IDLE end

	local snd = self.IsReply and table.Random( gm.Replies[ self.vtype ] ) or table.Random( gm.Chatter[ self.vtype ] )
	local len = SoundDuration( snd ) + 0.5
	self:EmitSound( snd )

	if self.IsReply == false and gm.Replies[ self.vtype ] then
		self:FindReplies( len, self.vtype )
	end

	self:SetNextVoice( VO_IDLE, math.random( 15, 45 ), false )

end

function PLY:FindReplies( len, vtype )

	local rep = 0
	local valid_plys = {}
	for k,v in pairs( player.GetAll() ) do
		if v == self then continue end 

		if not v:IsHidden() and v:GetPos():Distance( self:GetPos() ) then
			valid_plys[ #valid_plys + 1 ] = v
		end

	end

	if #valid_plys > 0 then
		table.Random( valid_plys ):SetNextVoice( vtype, len + math.Rand( 0.2, 1.5 ) , true )
	end

end

function PLY:ApplyHiddenStats( str, agi, endurance )
	local hidden = GAMEMODE.Hidden
	self:SetHealth( hidden.BaseHealth + str*hidden.HealthPerStrength )
	self:SetMaxHealth( hidden.BaseHealth + str*hidden.HealthPerStrength )
	hidden.Health = hidden.BaseHealth + str*hidden.HealthPerStrength
	hidden.DamageMult = str*hidden.DamageMultPerStrength
	self:SetWalkSpeed( hidden.BaseSpeed + agi*hidden.SpeedPerAgility )
	self:SetRunSpeed( hidden.BaseSpeed + agi*hidden.SpeedPerAgility )
	self:SetJumpPower( hidden.BaseJumpPower + agi*hidden.JumpPowerPerAgility )
	hidden.PounceForce = hidden.BasePounceForce + agi*hidden.PounceForcePerAgility
	hidden.Stamina = hidden.BaseStamina + endurance*hidden.StaminaPerEndurance
	self:SetStamina( hidden.BaseStamina + endurance*hidden.StaminaPerEndurance )
	hidden.RegenTime = hidden.BaseRegenTime - endurance*hidden.RegenTimePerEndurance
	hidden.DamageReduction = hidden.BaseDamageReduction + endurance*hidden.DamageReductionPerEndurance
	hidden.PounceCost = hidden.BasePounceCost - hidden.PounceCostPerEndurance*endurance
	hidden.AttackDelay = hidden.BaseAttackDelay + hidden.AttackDelayIncreasePerStrength*str - hidden.AttackDelayDecreasePerAgility*agi

	hidden.Strength = str
	hidden.Agility = agi
	hidden.Endurance = endurance 

	net.Start( "TellHiddenStats" )
		net.WriteTable( { str, agi, endurance } )
	net.Broadcast()

	hook.Call( "HDN_OnApplyStats", GAMEMODE, self, str, agi, endurance )	
end

net.Receive( "ApplyHiddenStats", function( len, ply )
	local stats = net.ReadTable()
	ply:ApplyHiddenStats( stats[ 1 ], stats[ 2 ], stats[ 3 ] )

	if GAMEMODE:GetRoundState() == ROUND_PREPARING then
		GAMEMODE:SetRoundState( ROUND_ACTIVE )
	end
end)


local ENTITY = FindMetaTable( "Entity" )
function ENTITY:Gore( dir )
	local gm = GAMEMODE
	if self:IsPlayer() then
		self.Gibbed = true
		for i = 1,math.Rand( 9, 18 ) do

			local tbl = gm.SmallBodyParts

			if i == 1 then

				local doll = ents.Create( "prop_ragdoll" )
				doll:SetModel( table.Random( gm.LargeBodyParts ) )
				doll:SetPos( self:GetPos() )
				doll:SetAngles( self:GetAngles() )
				doll:Spawn()
				doll:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				doll:SetMaterial( "models/flesh" )
				doll.IsGib = true 

				local phys = doll:GetPhysicsObject()
						
				if IsValid( phys ) then
						
					phys:AddAngleVelocity( VectorRand() * 2000 )
					phys:ApplyForceCenter( dir * math.random( 6000, 9000 ) )

				end	

				continue

			elseif i < 3 then

				tbl = gm.MediumBodyParts

			end

			local gib = ents.Create( "ent_gore" )
			gib:SetPos( self:GetPos() + VectorRand()*20 )
			gib:SetModel( table.Random( tbl ) )
			gib:Spawn()

		end
	elseif self:GetClass() == "prop_ragdoll" then
		for i = 1,math.Rand( 9, 18 ) do

			local tbl = gm.SmallBodyParts

			if i == 1 and not self.IsGib then

				local doll = ents.Create( "prop_ragdoll" )
				doll:SetModel( table.Random( gm.LargeBodyParts ) )
				doll:SetPos( self:GetPos() )
				doll:SetAngles( self:GetAngles() )
				doll:Spawn()
				doll:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				doll:SetMaterial( "models/flesh" )
				doll.IsGib = true 

				local phys = doll:GetPhysicsObject()
						
				if IsValid( phys ) then
						
					phys:AddAngleVelocity( VectorRand() * 2000 )
					phys:ApplyForceCenter( dir * math.random( 3000, 6000 ) )

				end	

				continue

			elseif i < 3 and not self.IsGib then

				tbl = gm.MediumBodyParts

			end

			local gib = ents.Create( "ent_gore" )
			gib:SetPos( self:GetPos() + VectorRand()*20 )
			gib:SetModel( table.Random( tbl ) )
			gib:Spawn()

		end
		self:Remove()
	end
end 

net.Receive( "HiddenTaunt", function( len, ply )
	ply:DoTaunt( net.ReadTable() )
end)

net.Receive( "ToggleHiddenVision", function( len, ply )
	local hidden_vision = ply:GetInt( "HiddenVision", 0 ) == 0 and 1 or 0
	ply:SetInt( "HiddenVision", hidden_vision )
end)
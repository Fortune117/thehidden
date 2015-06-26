  
local PLY = FindMetaTable( "Player" )

function PLY:GetInt( name, default )

	if not self.Data then return 0 end 

	return self.Data[ name ] or ( default or 0 )

end

function PLY:SetInt( name, value, override )

	value = math.Clamp( value, 0, 300 )
	
	self.Data[ name ] = value
	
	if override then return end
	 
	net.Start( "SynchInt" )
			
		net.WriteString( name )	
		net.WriteUInt( value, 8 )
			
	net.Send( self )

end

function PLY:AddInt( name, amt )

	self:SetInt( name, self:GetInt( name ) + amt )

end

function PLY:SetStamina( num )
	local old_stamina = self:GetStamina()
	self:SetInt( "Stamina", num )
	GAMEMODE:OnStaminaChange( self, old_stamina, num )
end

function PLY:AddStamina( num )
	local old_stamina = self:GetStamina()
	local new_stamina = old_stamina + num
	self:SetInt( "Stamina", new_stamina )
	GAMEMODE:OnStaminaChange( self, old_stamina, new_stamina )
end

function PLY:GetPrimary()
	local weps = self:GetWeapons()
	for k,v in pairs( weps ) do
		if v.InLoadoutMenu then
			return v
		end
	end
return false 
end

function PLY:CreateWeapon()
	local wep = self:GetPrimary()
	if not IsValid( wep ) then return end 
	local ent = ents.Create( "hdn_droppedgun" )
	ent:SetPos( self:GetShootPos() )
	ent:SetAngles( self:GetAngles() )
	ent:SetWeapon( wep )
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
		phys:ApplyForceCenter( self:GetAimVector()*math.random( 200, 350 ) + VectorRand()*15 + Vector( 0, 0, 50 ) )
		ent:SetLocalAngularVelocity( AngleRand()*500 )
	end
	wep:Remove()
end


 
TeamSetUp =
{
	[ TEAM_HUMAN ] = function( ply ) 
 
		local plyInfo = ply:IsCaptain() and GAMEMODE.Captain or GAMEMODE.Jericho
		ply:ApplyLoadOut()
		ply:SetMaxHealth( plyInfo.Health )
		ply:SetHealth( plyInfo.Health )
		ply:SetArmor( plyInfo.Armor )
		ply:SetWalkSpeed( plyInfo.Speed )
		ply:SetRunSpeed( plyInfo.Speed )
		ply:SetJumpPower( plyInfo.JumpPower )
		ply:SetModel( table.Random( plyInfo.Models ) )
		ply:AllowFlashlight( GAMEMODE.Jericho.AllowFlashlight )
		ply:SetupHands()
		ply:SetNextVoice( VO_IDLE, math.random( 15, 45 ), false )

		ply:SetRenderMode( RENDERMODE_NORMAL )
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		ply:SetMaterial( "" )
		ply:DrawShadow( true )
		ply:SetAvoidPlayers( true )
		ply:SetPlayerColor( Vector( 1, 1, 1 ) )

		hook.Call( "HDN_OnHumanSpawn", GAMEMODE, ply )

	end,
 
	[ TEAM_HIDDEN ] = function( ply )

		local plyInfo = GAMEMODE.Hidden
		ply:SetMaxHealth( plyInfo.Health )
		ply:SetHealth( plyInfo.Health )
		ply:SetArmor( plyInfo.Armor ) 
		ply:SetWalkSpeed( plyInfo.Speed )
		ply:SetRunSpeed( plyInfo.Speed )
		ply:SetJumpPower( plyInfo.JumpPower )
		ply:SetModel( plyInfo.Model )
		ply:AllowFlashlight( false )
		ply:Give( "weapon_hdn_knife" )

		if math.floor( math.Clamp( #player.GetAll()/GAMEMODE.Hidden.GrenadeRatio, GAMEMODE.Hidden.MinimumGrenades, GAMEMODE.Hidden.MaximumGrenades ) ) > 0 then
			ply:Give( "weapon_hdn_pipe" )
		end
 
		ply:SetInt( "Stamina", plyInfo.Stamina )

		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	 	ply:SetColor( Color( 255, 255, 255, plyInfo.Alpha ) )

		ply:SetMaterial( plyInfo.Material )
		ply:DrawShadow( false )
		ply:SetAvoidPlayers( false )
		hook.Call( "HDN_OnHiddenSpawn", GAMEMODE, ply )

	end,

	[TEAM_SPECTATOR] = function( ply )
		ply:Spectate( OBS_MODE_ROAMING )
		ply:SetMoveType( MOVETYPE_NOCLIP )
	end
}

function PLY:SetUpForRound( team )

	self:StripWeapons()
	self:UnSpectate()
	self:SetMoveType( MOVETYPE_WALK )
	self:SetNoCollideWithTeammates( true )
	self:SetGravity( 1 )

	TeamSetUp[ team ]( self ) 
end 
 
function PLY:Pounce()

	local gm_hdn = GAMEMODE.Hidden
	if self:GetStamina() >= gm_hdn.PounceCost then

		self:EmitSound( "npc/fast_zombie/claw_miss"..math.random(1,2)..".wav", 75, 100, 0.1 )
		self:SetPos( self:GetPos() + Vector(0, 0, 1 ) )
		local dir = self:GetAimVector()
		self:SetVelocity( dir*gm_hdn.PounceForce + Vector( 0, 0, 200 ) )
		self:AddStamina( -gm_hdn.PounceCost ) 

		if not gm_hdn.AllowBhop then
			self:SetCanJump( false )
		end

	end
	hook.Call( "HDN_OnPounce", GAMEMODE, self )
end 

function PLY:CreateDeathRagdoll( ply, atk, dmginfo )
	if self.Gibbed then self.Gibbed = false return end

	if self:IsHidden() then
		self:SetMaterial( "" )
		self:CreateRagdoll()

		self.SpecTime = CurTime() + 3
		return 
	end

	local body = ents.Create( "prop_ragdoll" )
	body:SetModel( self:GetModel() )
	body:SetPos( self:GetPos() )
	body:SetAngles( self:GetAngles() )
	body:SetKeyValue( "sequence", 1 )
	body.Hits = 0
	body:Spawn()
	body:SetVelocity( self:GetVelocity() )
	body:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	self:SetTeam( TEAM_SPECTATOR )
	self:SetMoveType( MOVETYPE_NOCLIP )
	self:Spectate( OBS_MODE_CHASE )
	self:SpectateEntity( body )

	self.SpecTime = CurTime() + 3

	if IsValid( atk ) and atk:IsPlayer() and atk != self then
	
		local dir = ( self:GetPos() - atk:GetPos() ):GetNormal()
		
		for i=1, math.random( 3, 5 ) do
		
			local phys = body:GetPhysicsObjectNum( math.random( 0, body:GetPhysicsObjectCount() ) )
			
			if IsValid( phys ) then
			
				phys:AddAngleVelocity( VectorRand() * 5000 )
				phys:ApplyForceCenter( dir * math.random( 8000, 11000 ) )
			
			end

		end

	end

end 

function PLY:ResetData()
	self.PounceDelay = 0
	self.ChargeDelay = 0
	self.HangingDelay = 0
	self.HiddenVisionDelay = 0
	self:SetInt( "Hanging", 0 )
	self:SetInt( "HiddenVision", 0 )
	self:SetNWBool( "HiddenKiller", false )
	self:SetCanJump( true )
	self:SetHiddenDamage( 0 )
	self:StripAmmo()
	self.PigSticked = false 
end

function PLY:SetCaptain( bool )
	self.Captain = bool
	hook.Call( "HDN_OnBecomeCaptain", GAMEMODE, self )
end 

PlayerThinkFuncs = 
{
	[ TEAM_HIDDEN ] = function( ply )
		local hdn_info = GAMEMODE.Hidden
		if ply.ChargeDelay < CurTime() and ply:GetInt( "Hanging", 0 ) == 0 then 
			if ply:GetStamina() < hdn_info.Stamina then
				ply:SetStamina( math.min( ply:GetStamina() + 1, hdn_info.Stamina ) )
			end
			ply.ChargeDelay = CurTime() + hdn_info.RegenTime/hdn_info.Stamina
		end

		if ply:KeyDown( IN_SPEED ) and ply:GetInt( "Hanging", 0 ) == 0 then 
			local tr = util.QuickTrace( ply:GetShootPos(), ply:GetAimVector()*35, {ply, ply:GetActiveWeapon()} )
			if tr.HitWorld then
				local z = tr.HitNormal.z
				if z < 0.3 and z > -0.3 or z < -0.7 then 
					ply:SetInt( "Hanging", 1 )   
					ply:SetVelocity( -ply:GetVelocity() )
					ply:SetMoveType( MOVETYPE_NONE )
				end
			end
		end

		if ply:GetInt( "Hanging", 0 ) == 1 and hdn_info.HangDrain then
			if ply:GetStamina() <= 0 then
				ply:SetInt( "Hanging", 0 )
				ply:SetMoveType( MOVETYPE_WALK )
			else
				if ply.HangingDelay < CurTime() then
					ply:AddStamina( -hdn_info.HangDrainSpeed )
					ply.HangingDelay = CurTime() + 1
				end
			end
		end

		if ply:HiddenVision() then
			if ply:GetStamina() <= 0 then
				ply:SetInt( "HiddenVision", 0 )
			else
				if ply.HiddenVisionDelay < CurTime() then
					ply:AddStamina( -hdn_info.VisionDrain )
					ply.HiddenVisionDelay = CurTime() + 0.5
				end
			end
		end

		if ply.LastJump then
			if CurTime() - ply.LastJump > 0.05 and ply:IsOnGround() then
				ply.BunnyHopping = false
			end
		end 

	end,
	[ TEAM_HUMAN ] = function( ply )
		local gm = GAMEMODE
		local speed = ( ply:IsCaptain() and gm.Captain.Speed ) or gm.Jericho.Speed 
		local mult = hook.Call( "HDN_MoveSpeed", GAMEMODE, ply ) or 1
		ply:SetRunSpeed( speed*mult )
		ply:SetWalkSpeed( speed*mult )
	end
}

function PLY:Think()

	local _team = self:Team()

	if PlayerThinkFuncs[ _team ] then    
		PlayerThinkFuncs[ self:Team() ]( self )
	end

	if self.NextVoice < CurTime() and self:Team() == TEAM_HUMAN and self:Alive() then
		self:DoVoice()
	end

end



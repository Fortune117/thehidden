
AddCSLuaFile( "shared.lua" ) 
AddCSLuaFile( "tables.lua" )
AddCSLuaFile( "config.lua" )
AddCSLuaFile( "rtv/cl_rtv.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "vgui/cl_endround.lua" )
AddCSLuaFile( "vgui/cl_scoreboard.lua" )
AddCSLuaFile( "vgui/cl_hiddenstats.lua" )
AddCSLuaFile( "vgui/cl_taunt.lua" )
AddCSLuaFile( "vgui/cl_loadout.lua" )
AddCSLuaFile( "vgui/cl_helpmenu.lua" )
AddCSLuaFile( "cl_screenfx.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "sh_loadout.lua" )
AddCSLuaFile( "default_player.lua" )

include( "shared.lua" )
include( "config.lua" )
include( "tables.lua" )
include( "rtv/sv_rtv.lua" )
include( "sv_rounds.lua" )
include( "sv_player.lua" )
include( "sv_player_ext.lua" )
include( "sh_loadout.lua" )
include( "sv_loadout.lua" )
include( "default_player.lua" )


util.AddNetworkString( "SynchInt" )
util.AddNetworkString( "HealNumbers" )
util.AddNetworkString( "Blind" )
util.AddNetworkString( "HiddenStats" )
util.AddNetworkString( "ApplyHiddenStats" )
util.AddNetworkString( "CheckHiddenMenu" )
util.AddNetworkString( "HiddenTaunt" )
util.AddNetworkString( "ToggleHiddenVision" )
util.AddNetworkString( "TellHiddenStats" )
util.AddNetworkString( "DoEndRoundScreen" )
util.AddNetworkString( "TimeSlowSound" )

GM.ShouldChangeHidden = false
GM.InitialHidden = false
GM.HiddenRounds = 0

function GM:PlayerInitialSpawn( ply )

	ply:SetUpLoadout()

	player_manager.SetPlayerClass( ply, "player_combine" )

	if self:GetRoundState() == ROUND_PREPARING then
		ply:SetTeam(TEAM_HUMAN)
		ply:Spawn()
	else
		ply:SetTeam(TEAM_SPECTATOR)
		ply:Spectate(OBS_MODE_ROAMING)
	end
	
	ply.NextVoice = CurTime()

end

function GM:PlayerSpawn( ply )

	if ply:Team() == TEAM_UNASSIGNED then
	
		ply:Spectate( OBS_MODE_ROAMING )
		ply:SetMoveType( MOVETYPE_NOCLIP )
		ply:SetPos( ply:GetPos() + Vector( 0, 0, 50 ) )
		
		return
		
	end

	ply:ResetData()
	ply:SetUpForRound( ply:Team() )

end 

function GM:GetFallDamage( ply, speed )
 	
 	if ply:IsHidden() then return 0 end

	return ( speed / 8 )
 
end

function GM:OnPlayerHitGround( ply, inWater, onFloater, speed )
	if not self.Hidden.AllowBhop then
		ply:SetNextJump( CurTime() + 0.15 )
		ply:SetCanJump( true )
	end
	return self:GetFallDamage( ply, speed )
end

function GM:ApplyDamageFactors( ply, dmginfo )
	local atk = dmginfo:GetAttacker()
	if atk:IsPlayer() then

		if ply:IsHidden() then
			local scale = 1 - self.Hidden.DamageReduction
			if self.Hidden.DamageReductionScaleWithPlayers then
				local reduction = scale - ( #player.GetAll()*self.Hidden.DamageReductionScaleRatio )
				scale = math.Clamp( reduction, ( 1 - self.Hidden.DamageReductionScaleMax ), 1 )
			end
			dmginfo:ScaleDamage( scale )
		elseif atk:IsHidden() then
			if not dmginfo:IsExplosionDamage() then 
				local scale =  1 + self.Hidden.DamageMult 
				if self.Hidden.DamageScaleWithPlayers then
					scale = math.min( scale + self.Hidden.DamageScaleRatio*#player.GetAll(), 1 + self.Hidden.DamageScaleMax )
				end
				dmginfo:ScaleDamage( scale )
			end
		end

		if ply:Team() == atk:Team() then
			if ply:IsHidden() and not self.Hidden.GrenadeCanDamageSelf || not ply:IsHidden() then
				dmginfo:ScaleDamage( 0 )
			end
		end

	end

	local prop_damage_scale = ply:IsHidden() and 0 or not atk:IsPlayer() and 0 or self.Hidden.PropKillDamageScale
	if dmginfo:GetInflictor():GetClass() == "prop_physics" then
		dmginfo:ScaleDamage( prop_damage_scale )
	end

	return dmginfo
end 

function GM:DoHiddenDamageMessages()
	local damage_total = 0
	local ply_table = {}
	for k,ply in pairs( player.GetAll() ) do
		if ply:GetHiddenDamage() > 0 then
			ply_table[ #ply_table+1 ] = { ply, ply:GetHiddenDamage() }
			damage_total = damage_total + ply:GetHiddenDamage()
		end
	end

	if #ply_table > 0 then
		for k,v in pairs( ply_table ) do
			local ply = v[ 1 ]
			local damage = v[ 2 ]
			local print_damage = math.Round( damage, 4 )
			local chance = math.Round(damage/damage_total, 2)*100
			local a = string.sub( tostring( print_damage ), 0, 1 ) == "8" and "an" or "a"
			ply:PrintMessage( HUD_PRINTTALK, "You dealt "..print_damage.." damage to the Hidden and have "..a.." "..chance.."% chance of becoming the Hidden next round." )
		end
	end
end

function GM:OnHiddenDeath( hdn, atk, dmginfo )
	atk:SetNWBool( "HiddenKiller", true )
	self.ShouldChangeHidden = true
	if self.Hidden.SelectMode == 3 then
		self:DoHiddenDamageMessages()
	end 
	hook.Call( "HDN_OnHiddenDeath", self, hdn, atk, dmginfo )
end

function GM:DoPlayerDamageLogic( vic, dmginfo )
	local atk = dmginfo:GetAttacker()
	if vic:IsPlayer() then

		local ply = vic
		dmginfo = self:ApplyDamageFactors( ply, dmginfo )

		local is_killhit = dmginfo:GetDamage() > ply:Health()

		if is_killhit then
			ply:SetDeaths( ply:Deaths() + 1 )
			if atk:IsPlayer() then
				atk:SetFrags( atk:Frags() + 1 )
				atk:AddScore( GetScoreValue( ply, atk ) )
			end 
		end

		if ply:IsHidden() then
			if atk:IsPlayer() then
				if atk:IsHidden() then return end 
				atk:AddHiddenDamage( dmginfo:GetDamage() )
				ply:HiddenDamageSounds( is_killhit )
				if is_killhit then
					atk:SetNextVoice( VO_VICTORY, 1, false )
					self:OnHiddenDeath( ply, atk, dmginfo )
				end
			end
		else
			//Have to hack in the Pigstick damage force.
			if atk:IsPlayer() and atk:IsHidden() then
				if not dmginfo:IsExplosionDamage() then 
					ply:SetVelocity( dmginfo:GetDamageForce() )
				else
					if is_killhit then
						ply:Gore( VectorRand()*10 )
					else
						if self.Hidden.GrenadeBlurVision then
							ply:Blind( self.Hidden.GrenadeBlindDuration, self.Hidden.GrenadeBlindIntensity  )
						end
					end
				end 
			end
			local should_voice = true
			if ply.PigSticked then
				if is_killhit then
					ply:Gore( vic.DirForce )
					should_voice = false
				else
					ply.PigSticked = false 
				end
			end
			ply:SetNextVoice( is_killhit and VO_DEATH or VO_PAIN, 0, false )
			ply:DoVoice()
		end

	end
end

function GM:DoEntityDamageLogic( vic, dmginfo )
	if not vic:IsPlayer() then
		local atk = dmginfo:GetAttacker()
		if vic:GetClass() == "prop_ragdoll" then
			if vic.PigSticked then
				vic:Gore( vic.DirForce )
			elseif dmginfo:IsExplosionDamage() then
				vic:Gore( VectorRand()*10 )
			end
		end
	end
end

function GetScoreValue( vic, killer )
	local hook_val = hook.Call( "HDN_GetScoreValue", GAMEMODE, vic, killer )
	if hook_val then
		return hook_val
	end
	if vic:IsHidden() then
		return 5
	else
		return 1
	end
end

function GM:EntityTakeDamage( vic, dmginfo )

	self:DoPlayerDamageLogic( vic, dmginfo )
	self:DoEntityDamageLogic( vic, dmginfo )

end 

function GM:DoPlayerDeath( ply, atk, dmginfo )

	ply:CreateDeathRagdoll( ply, atk, dmginfo )
	return	

end

function GM:ShowTeam( ply )
	ply:ConCommand( "hdn_loadout" )
end

function GM:ShowHelp( ply )
	--ply:ConCommand( "hdn_helpmenu" )
end

function GM:OnPlayerHealed( ply, amount )
	net.Start( "HealNumbers" )
		net.WriteInt( amount, 16 )
		net.WriteEntity( ply )
	net.Broadcast()
	hook.Call( "HDN_OnPlayerHealed", self, ply, amount )
end

function GM:PlayerDeathThink()

end

function GM:PlayerNoClip( ply )
	return not game.IsDedicated() or false 
end

local hidden_select_funcs = 
{
	[ 1 ] = function( )
		local humans = team.GetPlayers( TEAM_HUMAN )
		local specs = team.GetPlayers( TEAM_SPECTATOR )
		local tbl = {}
		tbl = table.Merge( tbl, humans, specs )
		return table.Random( tbl )
	end,

	[ 2 ] = function( )
		local damage = 0
		local ply_table = {}
		for k,ply in pairs( player.GetAll() ) do
			local hidden_damage = ply:GetHiddenDamage()
			if hidden_damage > damage then
				damage = hidden_damage
				ply_table = { ply }
			elseif hidden_damage == damage then
				table.insert( ply_table, ply )
			end
		end
		if #ply_table <= 0 then
			ply_table = team.GetPlayers( TEAM_HUMAN )
			local specs = team.GetPlayers( TEAM_SPECTATOR )
			table.Merge( ply_table, specs )
		end
		return table.Random( ply_table )
	end,

	[ 3 ] = function()
		local ply_table = {}
		local damage_total = 0
		local previous_damage = 0
		for k,ply in pairs( player.GetAll() ) do
			if ply:GetHiddenDamage() > 0 then
				ply_table[ #ply_table+1 ] = { ply, previous_damage + 1, previous_damage + ply:GetHiddenDamage() }
				damage_total = damage_total + ply:GetHiddenDamage()
				previous_damage = previous_damage + ply:GetHiddenDamage()
			end
		end

		local rand = math.random( 1, damage_total )
		for i = 1,#ply_table do
			if rand >= ply_table[ i ][ 2 ] and rand <= ply_table[ i ][ 3 ] then
				ply_table = { ply_table[ i ][ 1 ] }
				break
			end
		end

		if #ply_table < 1 then
			ply_table = player.GetAll()
		end
		return table.Random( ply_table )
	end,

	[ 4 ] = function()
		local ply_table = player.GetAll()
		for k,ply in pairs( ply_table ) do
			if ply:GetNWBool( "HiddenKiller", false ) == true then
				ply_table = { ply }
				break
			end
		end
		return table.Random( ply_table )
	end,

	[ "debug" ] = function()
		return Entity( 1 )
	end 

}
 
function GM:SelectNewHidden() 
	hidden_select_funcs[ self.Hidden.SelectMode ]():SetTeam( TEAM_HIDDEN )
	self.ShouldChangeHidden = false
	self.HiddenRounds = 0
end

local function AlivePlayers()

	local pool = {}

	for k, v in pairs( player.GetAll() ) do
		if not v:Alive() then continue end
		if not GAMEMODE.Hidden.AllowSpectate and v:IsHidden() then continue end
		pool[#pool+1] = v
	end

	return pool

end

local function NextPlayer( ply )

	local plys = AlivePlayers()

	if #plys < 1 then return nil end
	if not IsValid(ply) then return plys[1] end

	local old, new

	for k, v in pairs( plys ) do

		if old == ply then
			new = v
		end

		old = v

	end

	if not IsValid(new) then
		return plys[1]
	end

	return new

end

local function PrevPlayer( ply )

	local plys = AlivePlayers()

	if #plys < 1 then return nil end
	if not IsValid(ply) then return plys[1] end

	local old

	for k, v in pairs( plys ) do

		if v == ply then
			return old or plys[#plys]
		end

		old = v

	end

	if not IsValid(old) then
		return plys[#plys]
	end

	return old
end

local SpecFuncs = {
	
	[IN_ATTACK] = function( ply )

		local targ = PrevPlayer( ply:GetObserverTarget() )

		if IsValid(targ) then
			ply:Spectate( ply._smode or OBS_MODE_CHASE )
			ply:SpectateEntity( targ )
		end

	end,

	[IN_ATTACK2] = function( ply )

		local targ = NextPlayer( ply:GetObserverTarget() )

		if IsValid(targ) then
			ply:Spectate( ply._smode or OBS_MODE_CHASE )
			ply:SpectateEntity( targ )
		end

	end,

	[IN_RELOAD] = function( ply )

		local targ = ply:GetObserverTarget()
		if not IsValid(targ) or not targ:IsPlayer() then return end

		if not ply._smode or ply._smode == OBS_MODE_CHASE then
			ply._smode = OBS_MODE_IN_EYE
		elseif ply._smode == OBS_MODE_IN_EYE then
			ply._smode = OBS_MODE_CHASE
		end

		ply:Spectate( ply._smode )

	end,

	[IN_JUMP] = function( ply )

		if ply:GetMoveType() != MOVETYPE_NOCLIP then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end

	end,

	[IN_DUCK] = function( ply )

		local pos = ply:GetPos()
		local targ = ply:GetObserverTarget()

		if IsValid(targ) and targ:IsPlayer() then
			pos = targ:EyePos()
		end

		ply:Spectate(OBS_MODE_ROAMING)
		ply:SpectateEntity(nil)

		ply:SetPos(pos)

	end

}

-- beware, unoptimized code

util.AddNetworkString( "_KeyPress" )
util.AddNetworkString( "_KeyRelease" )

local WantKeys = {}
WantKeys[IN_JUMP] = true
WantKeys[IN_MOVELEFT] = true
WantKeys[IN_MOVERIGHT] = true
WantKeys[IN_DUCK] = true
WantKeys[IN_BACK] = true
WantKeys[IN_FORWARD] = true

local function GetSpectating( ply ) 

	local tab = {}

	for k, v in pairs( player.GetAll() ) do
		if v:GetObserverTarget() == ply then
			tab[#tab+1] = v
		end
	end

	return tab

end

function GM:KeyPress( ply, key )

	if ply:Alive() then
		if ply:IsHidden() then
			if key == IN_SPEED then
				if ply:IsOnGround() then
					if ply.PounceDelay < CurTime() then
						ply:Pounce()
						ply.PounceDelay = CurTime() + self.Hidden.PounceDelay
					end
				elseif ply:GetInt("Hanging") == 1 then
					local tr = util.QuickTrace( ply:GetShootPos(), ply:GetAimVector()*50, {ply, ply:GetActiveWeapon()} )
					if not tr.HitWorld then
						if ply.PounceDelay < CurTime() then
							ply:SetInt( "Hanging", 0 )
							ply:SetMoveType( MOVETYPE_WALK )
							ply:Pounce()
							ply.PounceDelay = CurTime() + self.Hidden.PounceDelay
						end
					end
				end
			elseif ply:GetInt( "Hanging" ) == 1 and key == IN_JUMP then
				ply:SetInt( "Hanging", 0 )
				ply:SetMoveType( MOVETYPE_WALK )
			elseif key == IN_JUMP and ply:IsOnGround() and not self.Hidden.AllowBhop then
				ply:SetCanJump( false )
			end
		end
	else
		if SpecFuncs[key] then
			local ob = ply:GetObserverTarget()
			if not ply._unspec_deathrag then
				return SpecFuncs[key](ply)
			end

			if ply._unspec_deathrag >= CurTime() then return end

			ply._unspec_deathrag = nil
			ply:Spectate( OBS_MODE_ROAMING )
			ply:SpectateEntity(nil)
		end
	end

end 

function GM:AllowPlayerPickup( ply, entity )
	if ply:Alive() and ply:IsHidden() then
		return true 
	end
	return false 
end

GM.ThinkTime = 1
GM.ThinkDelay = 1
function GM:Think()

	self:RoundThink()

	for k,v in pairs( player.GetAll() ) do
		v:Think()
	end

	if self.IsSlowed then
		if CurTime() > self.SlowTime then
			game.SetTimeScale( 1 )
			self.IsSlowed = false
		end
	end
	
end	

concommand.Add( "hdn_debug_invis", function( ply ) 
	if ply:IsAdmin() then
		local hdn = GetHidden()
		hdn:SetMaterial( "" )
		hdn:SetColor( Color( 255, 255, 255, 255 ) )
	end
end)

concommand.Add( "hdn_restart_round", function( ply ) 
	if ply:IsAdmin() then
		GAMEMODE:OnWin( TEAM_HIDDEN )
		GAMEMODE:SetRoundState( ROUND_PREPARING )
	end
end)

concommand.Add( "hdn_debug_damage", function( ply ) 
	if ply:IsSuperAdmin() then
		ply:TakeDamage( 9 )
	end
end)


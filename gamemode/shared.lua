
GM.Name 	= "The Hidden"
GM.Author 	= "Fortune"
GM.Email 	= ""
GM.Website 	= ""

TEAM_HUMAN = 1
TEAM_HIDDEN = 2

ROUND_WAITING = 0
ROUND_PREPARING = 1
ROUND_ACTIVE = 2
ROUND_ENDED = 3

VO_DEATH = 1
VO_PAIN = 2
VO_TAUNT = 3
VO_ALERT = 4
VO_IDLE = 5
VO_YES = 6
VO_SPAWN = 7
VO_QUESTION = 8
VO_VICTORY = 9

white_glow = { Color( 255, 255, 255, 255 ),  Color( 255, 255, 255, 200 ),  Color( 255, 255, 255, 125 ) }
white_glow_outline = { Color( 255, 255, 255, 255 ),  Color( 44, 44, 44, 255 ),  Color( 0, 0, 0, 255 ) }
blue_glow = { Color( 255, 255, 255, 255 ),  Color( 55, 55, 255, 255 ),  Color( 55, 55, 250, 255 ) }

function GM:CreateTeams()
	
	team.SetUp( TEAM_HUMAN, "Jericho", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_human", "info_player_counterterrorist", "info_player_combine", "info_player_deathmatch" } )
	
	team.SetUp( TEAM_HIDDEN, "The Hidden", Color( 255, 80, 80 ), false )
	team.SetSpawnPoint( TEAM_HIDDEN, { "info_player_stalker", "info_player_terrorist", "info_player_rebel", "info_player_start" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 80, 255, 150 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_counterterrorist", "info_player_combine", "info_player_human", "info_player_deathmatch" } ) 
	team.SetSpawnPoint( TEAM_UNASSIGNED, { "info_player_counterterrorist", "info_player_combine", "info_player_human", "info_player_deathmatch" } ) 

end

function GM:PlayerSelectSpawn( ply, failed )
	local ply_team = ply:Team()
	local spawns = team.GetSpawnPoints( ply_team )
	local valid_spawns = {}
	if failed then
		return table.Random( spawns )
	end

	for k,spwn in pairs( spawns ) do
		local content = util.PointContents( spwn:GetPos() )
		if content == CONTENTS_EMPTY || content == CONTENTS_PLAYERCLIP then
			valid_spawns[ #valid_spawns+1 ] = spwn
		end
	end
	if #valid_spawns < 1 then
		return table.random( spawns )
	end
	return table.Random( valid_spawns )
end


function GM:PlayerNoClip( ply, on )
	
	if game.SinglePlayer() then return true end
	
	if ply:IsAdmin() or ply:IsSuperAdmin() then return true end
	
	return false
	
end


function GM:OnPlayerChat( ply, text, teamchat, dead )
	
	// chat.AddText( player, Color( 255, 255, 255 ), ": ", strText )
	
	local tab = {}
	
	if dead then
	
		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, "(DEAD) " )
		
	end
	
	if teamchat then 
	
		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, "(TEAM) " )
		
	end
	
	if ( IsValid( ply ) ) then
	
		table.insert( tab, ply )
		
	else
	
		table.insert( tab, Color( 150, 255, 150 ) )
		table.insert( tab, "Console" )
		
	end
	
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": " .. text )
	
	chat.AddText( unpack( tab ) )

	return true
	
end

function GM:GetRoundState()
	return GetGlobalInt( "RoundState", 0)
end

function GM:GetRoundTime()
	return math.Round(math.max( GetGlobalInt( "RoundTime" ) - CurTime(), 0 ))
end

local PLY = FindMetaTable( "Player" )
function PLY:IsCaptain()
	return self.Captain == true
end

function PLY:IsHidden()
	return self:Team() == TEAM_HIDDEN
end

function PLY:IsInjured()
	return self:Health() < self:GetMaxHealth() 
end 

function PLY:HiddenVision()
	return self:GetInt( "HiddenVision", 0 ) == 1
end
 
function PLY:GetNextJump()
	return self:GetNWInt( "NextJump", 0 )
end

function PLY:CanJump()
	return self:GetNWBool( "CanJump", true )
end

function PLY:GetStamina()
	return self:GetInt( "Stamina", 0 )
end

function GetHidden()
	return team.GetPlayers( TEAM_HIDDEN )[ 1 ]
end

function IsHiddenAlive()
	return IsValid( GetHidden() ) and GetHidden():Alive()
end

function GetHiddenKiller()
	for k,v in pairs( player.GetAll() ) do
		if v:GetNWBool( "HiddenKiller", false ) then
			return v
		end
	end
	return nil
end

function util.GetLivingPlayers(class)
   local count = 0
   for k, v in ipairs(team.GetPlayers(class)) do
      if (v:Alive() and v:GetObserverMode() == OBS_MODE_NONE) then
         count = count + 1
      end
   end
   
   return count
end

function GM:PlayerFootstep( ply, pos, foot, snd, vol )
	if ply:IsHidden() then
		sound.Play( snd, pos, 50, 100, 0.25)
		return true
	end
end



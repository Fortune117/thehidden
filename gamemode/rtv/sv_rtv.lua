
util.AddNetworkString( "InitiateRTV" )
util.AddNetworkString( "RTV_Vote" )
util.AddNetworkString( "RTV_Nominate" )
util.AddNetworkString( "RTV_SyncVotes" )
util.AddNetworkString( "RTV_SyncNominate" )

RTV = {}
RTV.Maps = {}
RTV.Prefixes = 
{
	"ts_",
	"thestalker_",
	"stalker_",
	"de_",
	"dm_",
	"cs_"
}
RTV.Enabled = true
RTV.MaxMaps = 8
RTV.Ratio = 0.7
RTV.Votes = 0
RTV.VoteMaps = {}

function table.randomshuffle( tbl ) 
	table.sort(tbl, function(a, b) return math.Rand( 0, 1 ) > 0.5 end)
end

function RTV.GetValidMaps()
	local maps = {}
	files, dirs = file.Find( "maps/*.bsp", "GAME" )

	for k, v in RandomPairs( files ) do
		if string.gsub(v, ".bsp", "") == game.GetMap() then continue end
		if table.HasValue( RTV.Maps, string.gsub(v, ".bsp", "") ) then continue end
		for _, prefix in pairs( RTV.Prefixes ) do
			prefix = string.lower(prefix)
			if string.sub( string.lower(v), 0, #prefix ) == prefix then
				maps[#maps+1] = string.gsub( v, ".bsp", "" )
			end
		end
	end
	return maps
end

function RTV.GetValidNominateMaps()
	local maps = RTV.GetValidMaps()
	local new_maps = {}
	for k,v in pairs( maps ) do
		if table.HasValue( RTV.Maps, v ) then continue end
		new_maps[ #new_maps+1 ] = v
	end
	return new_maps
end

function RTV.GetMapList()
	local maps = RTV.Maps
	local v_maps = RTV.GetValidMaps()
	if #RTV.Maps < RTV.MaxMaps then
		for i = #RTV.Maps + 1, RTV.MaxMaps do
			maps[ i ] = v_maps[ i ]
		end
	end
	return maps
end

function RTV.GetWinningMap()
	local map 
	local votes = 0
	for k,v in pairs( RTV.VoteMaps ) do
		if #v > votes then
			votes = #v
			map = k 
		end
	end
	if map == nil then map = RTV.GetValidMaps()[ 1 ] end
	return map
end

function RTV.GetRequiredVotes()
	return math.Clamp( math.floor( #player.GetAll()*RTV.Ratio ), 2, math.huge )
end

function RTV.Start()
	if RTV.Enabled == false then return end
	RTV.TimeUntilMapChange = CurTime() + 30
	net.Start( "InitiateRTV" )
		net.WriteTable( RTV.GetMapList() )
		net.WriteInt( 30, 8 )
	net.Broadcast()
	--RTV.Enabled = false
end

function RTV.Think()
	if RTV.TimeUntilMapChange then
		if CurTime() > RTV.TimeUntilMapChange then
			local map = RTV.GetWinningMap()

			for k,v in pairs( player.GetAll() ) do
				v:PrintMessage( HUD_PRINTTALK, "Changing the map to "..map.." after the current round." )
			end

			hook.Add( "HDN_OnRoundChange", "RTV - Change Map", function( r )

				if r != ROUND_PREPARING then return end

				RunConsoleCommand( "gamemode", GAMEMODE.FolderName )
				RunConsoleCommand( "changelevel", map )

			end )

			RTV.TimeUntilMapChange = nil
		end
	end
end

hook.Add( "Think", "RTV Think", RTV.Think )

function IsCommand( text )
	local first_char = string.sub( text, 0, 1 )
	print( first_char )
	if  first_char == "!" or first_char == "/" then
		return true
	end
	return false 
end 

RTV.Commands =
{
	[ "rtv" ] = function( ply )
		if RTV.Enabled then
			ply:Vote()
		else
			ply:PrintMessage( HUD_PRINTTALK, "You can't RTV at this time!" )
		end
	end,

	[ "unrtv" ] = function( ply )
		if RTV.Enabled then
			if ply:HasVoted() then
				ply:UnVote()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You haven't voted!" )
			end
		else
			ply:PrintMessage( HUD_PRINTTALK, "You can't un-RTV at this time!" )
		end
	end,

	[ "nominate" ] = function( ply )
		if RTV.Enabled then
			if not ply.Nominated then
				net.Start( "RTV_Nominate" )
					net.WriteTable( RTV.GetValidNominateMaps() )
				net.Send( ply )
			else
				ply:PrintMessage( HUD_PRINTTALK, "You have already nominated a map!" )
			end
		else
			ply:PrintMessage( HUD_PRINTTALK, "You can't nominate a map at this time!" )
		end
	end,

	[ "revote" ] = function( ply )

	end
}

function GM:PlayerSay( ply, text )
	if IsCommand( text ) then
		local cmd = string.sub( text, 2, string.len( text ) )
		if RTV.Commands[ cmd ] then
			RTV.Commands[ cmd ]( ply )
		end
	end
end

local PLY = FindMetaTable( "Player" )

function PLY:HasVoted()
	return self.Voted
end

function PLY:Vote()
	if self:HasVoted() then return end
	self.Voted = true
	RTV.Votes = RTV.Votes + 1

	if RTV.Votes >= RTV.GetRequiredVotes() then
		RTV.Start()
	end

	for k,v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, self:Nick().." has voted to rock the vote!\n".."("..RTV.Votes.."/"..RTV.GetRequiredVotes().." required for a successful RTV.)" )
	end
end

function PLY:UnVote() 
	self.Voted = false
	RTV.Votes = RTV.Votes - 1

	for k,v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, self:Nick().." has retracted their RTV." )
	end
end

net.Receive( "RTV_Vote", function( len, ply )
	local map = net.ReadString()
	local vote_tbl = RTV.VoteMaps

	for k,v in pairs( vote_tbl ) do
		if table.HasValue( vote_tbl[ k ], ply ) then
			local new_tbl = {}
			for i = 1,#vote_tbl[ k] do
				if vote_tbl[ k ][ i ] == ply then continue end 
				new_tbl[ #new_tbl+1 ]= vote_tbl[ k ][ i ]
			end
			PrintTable( new_tbl )
			vote_tbl[ k ] = new_tbl 
		end
	end

	if vote_tbl[ map ] then
		if table.HasValue( vote_tbl[ map ], ply ) then return end
		vote_tbl[ map ][ #vote_tbl[ map ]+ 1 ] = ply
	else
		vote_tbl[ map ] = { ply }
	end
	net.Start( "RTV_SyncVotes" )
		net.WriteTable( vote_tbl )
	net.Broadcast()
end)

net.Receive( "RTV_SyncNominate", function( len, ply ) 
	RTV.Maps[ #RTV.Maps+1 ] = net.ReadString()
	ply.Nominated = true 
end)
concommand.Add(  "hdn_start_rtv", function( ply )
	--if ply:IsSuperAdmin() then
		RTV.Start()
	--end	
end )
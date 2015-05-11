
SetGlobalBool( "InRound", false )
SetGlobalInt( "RoundNumber", 10)
SetGlobalInt( "RoundState", ROUND_WAITING )
SetGlobalInt( "RoundTime", 0 )

function GM:SetRoundTime( time )
	SetGlobalInt( "RoundTime", math.Round( CurTime() + time ) )
end

function GM:QueComplete()
	for k,v in pairs( player.GetAll() ) do
		if not table.HasValue( self.HiddenPlayers, v:SteamID64() ) then
			return false 
		end
	end
	return true 
end

RoundChangeFunctions =
{
	[ROUND_WAITING] = function()
		GAMEMODE:SetRoundTime( 0 )
	end,
	[ROUND_PREPARING] = function( )

		game.CleanUpMap()

		local prep_time =  GAMEMODE.Hidden.CustomMode and GAMEMODE.RoundPrepTimeCustom or GAMEMODE.RoundPrepTime

		GAMEMODE:SetRoundTime( prep_time )

		local plys = player.GetAll()

			for k,v in pairs( team.GetPlayers( TEAM_SPECTATOR ) ) do

				v:SetTeam( TEAM_HUMAN )
				v:SetCaptain( false )

			end

			for k,v in pairs( plys ) do

				v:SetCaptain( false )

			end

		if GAMEMODE.ShouldChangeHidden or GAMEMODE.InitialHidden == false then
			for k,v in pairs( plys ) do

				v:SetTeam( TEAM_HUMAN )
				v:SetCaptain( false )

			end

		-- local randomguy = Entity( 1 )
			GAMEMODE:SelectNewHidden()
			GAMEMODE.InitialHidden = true
		end


		if GAMEMODE.Hidden.CustomMode then
			net.Start( "HiddenStats" )
			net.Send( GetHidden() )
		end

		if GAMEMODE.Captain.Enabled then
			local num_captains = math.max( math.ceil( #team.GetPlayers( TEAM_HUMAN )*GAMEMODE.Captain.Percentage ), 1 )
			local num_selected = 0
			for k,v in RandomPairs( team.GetPlayers( TEAM_HUMAN ) ) do
				if IsValid( v ) and v:Alive() then
					v:SetCaptain( true )
					num_selected = num_selected + 1
				end
				if num_selected >= num_captains then break end
			end
		end

		for k,v in pairs( plys ) do
			v:Spawn()
			v:Freeze( true )
		end

	end,
	[ROUND_ACTIVE] = function()
		GAMEMODE:SetRoundTime( GAMEMODE.RoundTime )
		net.Start( "CheckHiddenMenu" )
		net.Send( GetHidden() )
		SetGlobalBool( "InRound", true )
		for k,v in pairs( player.GetAll() ) do
			v:Freeze( false )
		end
	end,
	[ROUND_ENDED] = function()
		SetGlobalBool( "InRound", false )
		GAMEMODE.RoundLimit = GAMEMODE.RoundLimit - 1
		if GAMEMODE.RoundLimit <= 0 then
			if GAMEMODE.Hidden.SelectMode == 5 and GAMEMODE.Hidden.ChangeMapWhenQueComplete then
				if GAMEMODE:QueComplete() then
					RTV.Start()
					GAMEMODE:SetRoundTime( 35 )
				else
					GAMEMODE:SetRoundTime( GAMEMODE.RoundEndTime )
				end
			else
				RTV.Start()
				GAMEMODE:SetRoundTime( 35 )
			end
		else
			GAMEMODE:SetRoundTime( GAMEMODE.RoundEndTime )
		end
	end
}

function GM:OnRoundChange( state ) 
	RoundChangeFunctions[ state ]()
	hook.Call( "HDN_OnRoundChange", self, state )
end

hook.Add( "HDN_OnRoundChange", "CleanupWeapons", function()
	local items = ents.FindByClass('item_*')
	local weapons = ents.FindByClass('weapon_*')

	for k, v in pairs(items) do
		v:Remove()
	end

	for k, v in pairs(weapons) do
		if v:IsWeapon() then continue end 
		v:Remove()
	end
end)

function GM:SetRoundState( state )
	SetGlobalInt( "RoundState", state )
	self:OnRoundChange( state )
end

function GM:DoEndRoundScreen( team, team_name )

	net.Start( "DoEndRoundScreen" )
		net.WriteInt( team, 8 )
		net.WriteString( team_name )
	net.Broadcast()

	if self.SlowAmount > 0 then
		net.Start( "TimeSlowSound" )
		net.Broadcast()
		game.SetTimeScale( self.SlowAmount )
		self.IsSlowed = true
		self.SlowTime = CurTime() + (3*(self.SlowAmount > 0 and self.SlowAmount or 1 ) )
	end

end

function GM:OnWin( winner )
	local win_text = "wat"
	if winner == TEAM_HIDDEN then
		win_text = self.Hidden.Name
		if self.Hidden.LimitRounds then
			self.HiddenRounds = self.HiddenRounds + 1
			if self.HiddenRounds >= self.Hidden.MaxRounds then
				self.ShouldChangeHidden = true
				self.HiddenRounds = 0
			end
		end
	else
		win_text = self.Jericho.Name
		self.ShouldChangeHidden = true
		self.HiddenRounds = 0
	end

	self:DoEndRoundScreen( winner, win_text )
	hook.Call( "HDN_OnWin", GAMEMODE, winner )
end

function GM:ShouldRoundEnd()

	if not IsHiddenAlive() then
		self:OnWin( TEAM_HUMAN )
		return true
	elseif util.GetLivingPlayers( TEAM_HUMAN ) <= 0 then
		self:OnWin( TEAM_HIDDEN )
		return true
	end

	if self:GetRoundTime() <=0 then
		self:OnWin( TEAM_HUMAN )
		return true
	end
	return false

end

RoundFunctions =
{
	[ROUND_WAITING] = function( gm )
		if #player.GetAll() < 2 then return end

		if CurTime() > 30 then
			gm:SetRoundState( ROUND_PREPARING )
		end

	end,
	[ROUND_PREPARING] = function( gm )
		if gm:GetRoundTime() <= 0 then
			gm:SetRoundState( ROUND_ACTIVE )
		end
	end,
	[ROUND_ACTIVE] = function( gm )
		if gm:ShouldRoundEnd() then
			gm:SetRoundState( ROUND_ENDED )
		end
	end,
	[ROUND_ENDED] = function( gm )
		if gm:GetRoundTime() <= 0 then
			gm:SetRoundState( ROUND_WAITING )
		end
	end
}

function GM:RoundThink()
	RoundFunctions[ self:GetRoundState() ]( self )
end

function GM:PostCleanupMap()
	local items = ents.FindByClass('item_*')
	local weapons = ents.FindByClass('weapon_*')

	for k, v in pairs(items) do
		v:Remove()
	end

	for k, v in pairs(weapons) do
		v:Remove()
	end
end

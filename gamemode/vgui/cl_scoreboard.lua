
local scoreboard 
local players_col
local players_panel
local hidden_panel
local avatar
local ava_y_add 

local StatNames = { "Strength", "Agility", "Endurance" }

local StatColors = 
{
	Color( 210, 60, 0, 40  ),
	Color( 0, 210, 30, 40  ),
	Color( 0, 60, 230, 40  )
}

local StatColors_BackGround = 
{
	Color( 150, 30, 0, 20  ),
	Color( 0, 150, 15, 20  ),
	Color( 0, 30, 150, 20  )
}
 

local padding = ScrW()/8
local xsize = 2.5
local y = 2 

local scores =
{ 
	{"Name", function( ply )
		local name = ply:Nick()
		local max = 15
		if string.len( name ) > max then
			name = string.sub( ply:Nick(), 0, math.min( string.len( ply:Nick() ), 15 ) )..".."
		end
		return name
	end},
	{"Score", function( ply )
		return ply:GetNWInt( "Score", 0 )
	end},
	{"Kills", function( ply )
		return ply:Frags()
	end},
	{"Deaths", function( ply )
		return ply:Deaths()
	end},
	{"Ping", function( ply )
		return ply:Ping()
	end}
}

local blur = 2
local blur_diff = 2
function CreatePlayer( ply, ply_team, is_alive )
	local ply_pnl = vgui.Create( "DPanel", players_panel )
	ply_pnl:SetSize( players_col:GetWide(), players_panel:GetTall()/10 )
	ply_pnl:Dock( TOP )
	local gap = (ply_pnl:GetWide()/#scores)
	function ply_pnl:Paint( w, h )

		if is_alive and ply_team ~= TEAM_SPECTATOR then
			draw.BlurredBar(  blur, blur, w - blur*2, h - blur*2 , blur, Color( 0, 60, 125, 180) )
			draw.BlurredBar(  blur+blur_diff, blur+blur_diff, w - (blur+blur_diff)*2, h - (blur+blur_diff)*2 , 0, Color( 8, 8, 8, 255) )
		else
			draw.BlurredBar(  blur, blur, w - blur*2, h - blur*2 , blur, Color( 55, 55, 55, 180) )
			draw.BlurredBar(  blur+blur_diff, blur+blur_diff, w - (blur+blur_diff)*2, h - (blur+blur_diff)*2 , 0, Color( 0, 0, 0, 255) )
		end 

		local font = ScrW() < 1300 and "HiddenHUDMS" or "HiddenHUDScoreL"
		for i = 1,#scores do
			if i == 1 then
				surface.SetFont( font )
				local xsz, ysz = surface.GetTextSize( scores[ i ][ 2 ]( ply ) )
				draw.AAText( scores[ i ][ 2 ]( ply ), font, 12, self:GetTall()/2 - ysz/2, Color( 235, 235, 235, 255), TEXT_ALIGN_LEFT )
				_ysz = ysz
			else
				surface.SetFont( font )
				local xsz, ysz = surface.GetTextSize( scores[ i ][ 2 ]( ply ) )
				draw.AAText( scores[ i ][ 2 ]( ply ), font, gap*i - gap/2 - xsz/2, self:GetTall()/2 - ysz/2, Color( 235, 235, 235, 255), TEXT_ALIGN_LEFT )
				_ysz = ysz
			end
		end
	end
	return ply_pnl
end

function Refresh()
	players_panel:ClearChildren()
	for k,ply in pairs( player.GetAll() ) do
		if IsValid( ply ) then
			if ply:Team() == TEAM_HUMAN or ply:Team() == TEAM_SPECTATOR then
				players_panel._Players[ #players_panel._Players + 1 ] = CreatePlayer( ply, ply:Team(), ply:Alive() )
			else

			end 
		end
	end


	if GetHidden() then
		avatar = vgui.Create( "AvatarImage", hidden_panel )
		avatar:SetPlayer( GetHidden(), 256 )
		avatar:SetSize( hidden_panel:GetWide()/2.5, hidden_panel:GetWide()/2.5 )
		avatar:SetPos( 4 , ava_y_add )
	end

end


/*
Materials to test:
materials/models/props_combine/stasisshield_sheet
materials/models/props_combine/com_shield001

Hidden--
materials/models/props_lab/Tank_Glass001
materials/models/props_combine/tprings_globe

*/

function CreateScoreboard()

	--if scoreboard then
		----scoreboard:SetVisible(true)
		--Refresh()
		--return
	--end

	scoreboard = vgui.Create( "DFrame" )
	scoreboard:ShowCloseButton( false )
	scoreboard:SetDraggable( false )
	scoreboard:SetTitle( "" )
	scoreboard:SetSize( ScrW(), ScrH() )
	scoreboard:SetPos( 0, 0 )
	scoreboard.ThinkDelay = 20
	scoreboard.ThinkTime = CurTime() + 20
	scoreboard:MakePopup()
	scoreboard:ParentToHUD()

	function scoreboard:Paint( w, h )
		local h_gap = h/10
		surface.SetDrawColor( Color( 11, 11, 11, 180 ) )
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( Color( 11, 11, 11, 255 ) )
		surface.DrawRect( 0, 0, w, h_gap )


		surface.SetDrawColor( Color( 11, 11, 11, 255 ) )
		surface.DrawRect( 0, ScrH()-h_gap, w, h_gap )

		/*surface.SetMaterial( Material( "models/props_combine/stasisshield_sheet", "noclamp smooth" ) )
		surface.DrawTexturedRect( 0, h_gap, w/2, h-(h_gap)*2 )


		surface.SetMaterial( Material( "models/props_lab/Tank_Glass001", "noclamp smooth" ) )
		surface.DrawTexturedRect( w/2, h_gap, w/2, h-(h_gap)*2 )*/

		surface.SetDrawColor( Color( 0, 125, 240, 2  ))
		surface.DrawRect( 0, h_gap, w/2, h-(h_gap)*2 )


		surface.SetDrawColor( Color( 255, 60, 0, 2  ) )
		surface.DrawRect( w/2, h_gap, w/2, h-(h_gap)*2 )

		surface.SetDrawColor(  Color( 0, 0, 0, 245  ) )
		surface.DrawRect( w/2 - 3, h_gap, 6, ScrH() - (h_gap)*2 )

		surface.SetFont( "HiddenHUDL" )
		local xsz, ysz = surface.GetTextSize( "VS" )
		draw.GlowingText( "VS", "HiddenHUDL", w/2 - xsz/2, h/2 - ysz/2, unpack( white_glow ) )

	end

	function scoreboard:Think()
		if CurTime() > self.ThinkTime then
			Refresh()
			self.ThinkTime = CurTime() + self.ThinkDelay
		end
	end

	players_col = vgui.Create( "DPanel", scoreboard )
	players_col:SetSize( (ScrW()/2)*0.7, ScrH()/y )
	players_col:SetPos( (ScrW()/4) - players_col:GetWide()/2, ScrH()/2 - players_col:GetTall()/2 )

	function players_col:Paint( w, h )
		surface.SetDrawColor( Color( 4, 4, 4, 180 ) )
		--surface.DrawRect( 0, 0, w, h )

		local human_name = GAMEMODE.Jericho.Name
		surface.SetFont( "HiddenHUDL" )
		local xsz, ysz = surface.GetTextSize( human_name )
		draw.GlowingText( human_name, "HiddenHUDL", w/2 - xsz/2, 5, unpack( white_glow ) )

		local bar_y = 7 + ysz
		draw.BlurredBar(  5, bar_y , w - 10 , 4 , 3, Color( 255, 255, 255, 255 ) )

		local _ysz 
		local gap = (w/#scores)
		for i = 1,#scores do
			if i == 1 then
				surface.SetFont( "HiddenHUDSS" )
				local xsz, ysz = surface.GetTextSize( scores[ i ][ 1 ] )
				draw.GlowingText( scores[ i ][ 1 ], "HiddenHUDSS", gap*i - gap/2 - xsz, bar_y + 8, unpack( white_glow ) )
				_ysz = ysz
			else
				surface.SetFont( "HiddenHUDSS" )
				local xsz, ysz = surface.GetTextSize( scores[ i ][ 1 ] )
				draw.GlowingText( scores[ i ][ 1 ], "HiddenHUDSS", gap*i - gap/2 - xsz/2, bar_y + 8, unpack( white_glow ) )
				_ysz = ysz
			end
		end

	end

	surface.SetFont( "HiddenHUDL" )
	local _, j_ysz = surface.GetTextSize( GAMEMODE.Jericho.Name )
	surface.SetFont( "HiddenHUDS" )
	local _, s_ysz = surface.GetTextSize( scores[ 1 ][ 1 ] )

	local panel_y_remove = 9 + j_ysz + s_ysz

	players_panel = vgui.Create( "DScrollPanel", players_col )
	players_panel:SetSize( players_col:GetWide(), players_col:GetTall() - panel_y_remove - 2 )
	players_panel:SetPos( 0, panel_y_remove + 4)
	players_panel._Players = {}

	function players_panel:ClearChildren()
		for k,v in pairs( self._Players ) do
			v:Remove()
			self._Players[ k ] = nil
		end
	end

	hidden_panel = vgui.Create( "DPanel", scoreboard )
	hidden_panel:SetSize( (ScrW()/2)*0.7, ScrH()/y )
	hidden_panel:SetPos( ScrW() - (ScrW()/4) - players_col:GetWide()/2, ScrH()/2 - players_col:GetTall()/2 )

	local image_sz = hidden_panel:GetWide()/2.5
	local left_over = hidden_panel:GetWide() - image_sz

	surface.SetFont( "HiddenHUDL" )
	local _, h_ysz = surface.GetTextSize( GAMEMODE.Hidden.Name )

	ava_y_add = 15 + h_ysz
	local gap = left_over/(#scores-2)
	local left_over_y = hidden_panel:GetTall() - ava_y_add
	function hidden_panel:Paint( w, h )

		if not GetHidden() then
			surface.SetFont( "HiddenHUDL" )
			local xsz, ysz = surface.GetTextSize( "WAITING" )
			draw.GlowingText( "WAITING", "HiddenHUDL", w/2 - xsz/2, 5, unpack( white_glow ) )
		else
			surface.SetDrawColor( Color( 4, 4, 4, 180 ) )
			--surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( Color( 0, 0, 0, 120 ) )
			surface.DrawRect( 0, ava_y_add, w, left_over_y )

			local hidden_name = GAMEMODE.Hidden.Name 
			surface.SetFont( "HiddenHUDL" )
			local xsz, ysz = surface.GetTextSize( hidden_name )
			draw.GlowingText( hidden_name, "HiddenHUDL", w/2 - xsz/2, 5, unpack( white_glow ) )

			local bar_y = 7 + ysz
			draw.BlurredBar(  5, bar_y , w - 10 , 4 , 3, Color( 255, 255, 255, 255 ) )

			local nick = GetHidden():Nick()
			local name = string.len( nick ) > 10 and string.sub( nick, 1, 10 )..".." or nick
			local font = ScrW() < 1500 and "HiddenHUDML" or "HiddenHUD"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( name )
			draw.GlowingText( name , font, image_sz + left_over/2 - xsz/2, bar_y + 2, unpack( white_glow ) )

			draw.BlurredBar( image_sz + left_over/2 - xsz/2 - 3 , bar_y + ysz , xsz + 8 , 1 , 2, Color( 255, 255, 255, 255 ) )

			surface.SetFont( font )
			local xsz2, ysz2 = surface.GetTextSize( "SCORE" )
			draw.GlowingText( "SCORE" , font, image_sz + left_over/2 - xsz2/2, bar_y + 24 + ysz, unpack( white_glow ) )

			surface.SetFont( font )
			local xsz3, ysz3 = surface.GetTextSize( GetHidden():GetNWInt("Score", 0 ) ) 
			draw.GlowingText( GetHidden():GetNWInt("Score", 0 ), font, image_sz + left_over/2 - xsz3/2, bar_y + 24 + ysz + ysz2, unpack( white_glow ) )

			for i = 3,#scores do
				local mod = i-2
				surface.SetFont( "HiddenHUDS" )
				local xsz4, ysz4 = surface.GetTextSize( scores[ i ][ 1 ] ) 
				draw.GlowingText( scores[ i ][ 1 ], "HiddenHUDS", image_sz + gap*mod - gap/2 - xsz4/2, ava_y_add + image_sz - (ysz/4)*2 - 18, unpack( white_glow ) )

				surface.SetFont( "HiddenHUDS" )
				local xsz4, ysz4 = surface.GetTextSize( scores[ i ][ 2 ]( GetHidden() ) ) 
				draw.GlowingText( scores[ i ][ 2 ]( GetHidden() ), "HiddenHUDS", image_sz + gap*mod - gap/2 - xsz4/2, ava_y_add + image_sz - ysz/4 - 8 , unpack( white_glow ) )
			end


			--draw.BlurredBar( image_sz + left_over/2 - xsz/2 - 3 , bar_y + ysz + ysz2 , xsz + 8 , 1 , 2, Color( 255, 255, 255, 255 ) )
		end
	end


	local avatar_size = hidden_panel:GetWide()/2.5
	local stat_panel_h = hidden_panel:GetTall() - ava_y_add - avatar_size - 10 

	local bar_h = stat_panel_h/4
	local padding = 5
	local gap =  (stat_panel_h - bar_h*3)/4


	local font = ScrW() < 1500 and "HiddenHUDSSS" or "HiddenHUDSS"
	surface.SetFont( font  )
	local str_name_w, str_name_h = surface.GetTextSize( StatNames[ 3 ] ) 

	surface.SetFont( font  )
	local stat_number_w, _ = surface.GetTextSize( "20" ) 

	local hidden_stats = vgui.Create( "DPanel", hidden_panel )
	hidden_stats:SetSize( hidden_panel:GetWide() - 10, stat_panel_h )
	hidden_stats:SetPos( 5, ava_y_add + avatar_size + 5 )
	function hidden_stats:Paint( w, h )
		if not GetHidden() then return end
		surface.SetDrawColor( Color( 0, 0, 0, 80 ) )
		surface.DrawRect( 0, 0, w, h )

		local gm = GAMEMODE
		if gm.Hidden.CustomMode then

			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( "Stats" ) 
			draw.GlowingText( "Stats", font, w/2 - xsz/2, 2, unpack( white_glow ) )

			for i = 1,3 do

				local y = padding + bar_h*(i-1) + bar_h/2 + gap*(i-1)
				local x = padding + str_name_w

				surface.SetFont( font )
				local xsz, ysz = surface.GetTextSize( StatNames[ i ] ) 
				draw.GlowingText( StatNames[ i ], font, x, y, white_glow[ 1 ], white_glow[ 2 ], white_glow[ 3 ], TEXT_ALIGN_RIGHT )

				local bar_w = (w - padding*2 - x - stat_number_w*2)*(gm.HiddenStats[ i ]/20)
				local bar_w_back = (w - padding*2 - x - stat_number_w*2)

				draw.BlurredBar( x + padding, y + str_name_h/16, bar_w_back, str_name_h, 0, StatColors_BackGround[ i ] )
				draw.BlurredBar( x + padding, y + str_name_h/16, bar_w, str_name_h, 3, StatColors[ i ] )


				surface.SetFont( font )
				local xsz, ysz = surface.GetTextSize( gm.HiddenStats[ i ] ) 
				draw.GlowingText( gm.HiddenStats[ i ], font, x + padding + bar_w + xsz/2, y, white_glow[ 1 ], white_glow[ 2 ], white_glow[ 3 ], TEXT_ALIGN_LEFT )

			end

		else
			local font = ScrW() < 1500 and "HiddenHUDS" or "HiddenHUD"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( "Custom Mode Disabled" ) 
			draw.GlowingText( "Custom Mode Disabled", font, w/2 - xsz/2, h/2 - ysz/2, unpack( white_glow ) )
		end
	end 

	if GetHidden() then
		avatar = vgui.Create( "AvatarImage", hidden_panel )
		avatar:SetPlayer( GetHidden(), 256 )
		avatar:SetSize( avatar_size, avatar_size )
		avatar:SetPos( 4 , ava_y_add )
	end



	Refresh()


end

function GM:ScoreboardShow()

	CreateScoreboard()

end

function GM:ScoreboardHide()

	if not scoreboard then return end
	scoreboard:Remove()

end
local end_screen

local curve = 4
local back_color = Color( 0, 102, 255, 180 )
local team_colors = 
{
	[ TEAM_HUMAN ] = Color( 0, 102, 255, 180 ),
	[ TEAM_HIDDEN ] = Color( 200, 30, 30, 150 )
}
local team_glow =
{
	[ TEAM_HIDDEN ] = { Color( 255, 255, 255, 255 ), Color( 200, 30, 30, 180 ), Color( 200, 30, 30, 120 ) },
	[ TEAM_HUMAN ] = { Color( 255, 255, 255, 255 ), Color( 0, 102, 255, 180 ), Color( 0, 102, 255, 120 ) }
} 
local box_color = Color( 11, 11, 11, 230 )

local padding = 50
local text_pad = 20
local bar_blur = 5
local bar_h = 4
 
function EndRoundEvent( )
	local endscreen_w = ScrW()/1.3

	local winner = net.ReadInt( 8 )
	local team_name = net.ReadString() 

	local end_screen_h = winner == TEAM_HUMAN and 300 or 150
	end_screen = vgui.Create( "DFrame" ) 
	end_screen:SetSize( endscreen_w, end_screen_h )
	end_screen:SetTitle( "" )
	end_screen:SetPos( ScrW()/2 - endscreen_w/2, padding )
	--end_screen:MakePopup()
	end_screen:ShowCloseButton( false )
	end_screen.LiveTime = CurTime() + GAMEMODE.RoundEndTime

	function end_screen:Paint( w, h )

		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilTestMask( 255 )
		render.SetStencilWriteMask( 255 )
		render.SetStencilReferenceValue( 10 )
		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_KEEP )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )		

		draw.RoundedBox( curve, curve*2, curve*2, w - curve*4, h - curve*4, box_color )

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NOTEQUAL )		
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )

		draw.RoundedBox( curve, curve, curve, w - curve*2, h - curve*2, team_colors[ winner ] )

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL ) --Only draw if pixel value == reference value

		draw.RoundedBox( 0, curve*2, curve*2, w - curve*4, h - curve*4, box_color )

		render.SetStencilEnable( false )

		local win_text = team_name.." Wins"
		local font = ScrW() < 1500 and "HiddenHUD" or "HiddenHUDL" 
		surface.SetFont( font )
		local xsz, ysz = surface.GetTextSize( win_text )
		local x,y = w/2 - xsz/2, text_pad

		draw.GlowingText( win_text, font, x, text_pad, unpack( team_glow[ winner ] ) )

		draw.BlurredBar( x - bar_blur - xsz/4, y + ysz + bar_blur*2, xsz + bar_blur*2 + (xsz/4)*2, bar_h, bar_blur, team_colors[ winner ] )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawRect( x - bar_blur - xsz/4, y + ysz + bar_blur*2, xsz + bar_blur*2 + (xsz/4)*2, bar_h )

		if winner == TEAM_HUMAN then 
			x = 5
			y =  end_screen_h - (y + ysz + bar_blur*2)
			local ply = GetHiddenKiller()
			local name = ply and ply:Nick() or "No one"
			local text = name.." is credited with the kill!"
				  font = ScrW() < 1500 and "HiddenHUDML" or "HiddenHUD" 
			surface.SetFont( font )
			local xsz2, ysz2 = surface.GetTextSize( text )
			draw.GlowingText( text, font, w/2 - xsz2/2, end_screen_h/2, unpack( team_glow[ winner ] ) )
		end

	end 

	function end_screen:Think()
		if CurTime() > self.LiveTime then
			self:Remove()
		end
	end

end 

net.Receive( "DoEndRoundScreen", EndRoundEvent )

net.Receive( "TimeSlowSound", function()

end)
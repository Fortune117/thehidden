

local Taunts = 
{
	{"I'm here", { "617-imhere.mp3", "617-imhere01.mp3", "617-imhere02.mp3", "617-imhere03.mp3", "617-imhere04.mp3"} },
	{"I see you", { "617-iseeyou.mp3", "617-iseeyou01.mp3", "617-iseeyou02.mp3", "617-iseeyou03.mp3", "617-iseeyou04.mp3"} },
	{"Look up", { "617-lookup.mp3", "617-lookup01.mp3", "617-lookup02.mp3", "617-lookup03.mp3" } },
	{"Over here", { "617-overhere01.mp3", "617-overhere02.mp3", "617-overhere03.mp3" } },
	{"Turn Around", { "617-turnaround01.mp3", "617-turnaround02.mp3" } }
}

local _Keys = 
{
	[ "a" ] = KEY_A,
	[ "b" ] = KEY_B,
	[ "c" ] = KEY_C,
	[ "d" ] = KEY_D,
	[ "e" ] = KEY_E,
	[ "f" ] = KEY_F,
	[ "g" ] = KEY_G,
	[ "h" ] = KEY_H,
	[ "i" ] = KEY_I,
	[ "j" ] = KEY_J,
	[ "k" ] = KEY_K,
	[ "l" ] = KEY_L,
	[ "m" ] = KEY_M,
	[ "n" ] = KEY_N,
	[ "o" ] = KEY_O,
	[ "p" ] = KEY_P,
	[ "q" ] = KEY_Q,
	[ "r" ] = KEY_R,
	[ "s" ] = KEY_S,
	[ "t" ] = KEY_T,
	[ "u" ] = KEY_U,
	[ "v" ] = KEY_V,
	[ "w" ] = KEY_W,
	[ "x" ] = KEY_X,
	[ "y" ] = KEY_Y,
	[ "z" ] = KEY_Z
}
function KeyToNumber( key )
	return _Keys[ key ]
end 


local w,h = ScrW()/3,ScrW()/3
local taunt_menu
local targ_x = w/2
local targ_y = h/2
local targ_i = 0
local selected_taunt = {}
local should_draw = false 

function ShowTaunts()
	if not LocalPlayer():IsHidden() then return end
	taunt_menu = vgui.Create( "DFrame" )
	taunt_menu:SetSize( w, h )
	taunt_menu:Center()
	taunt_menu:MakePopup()
	taunt_menu:ParentToHUD()
	taunt_menu:SetTitle( "" )
	taunt_menu:ShowCloseButton( false )

	taunt_menu.Think = function( self )
		local key = KeyToNumber( input.LookupBinding( "+menu" ) ) 
		if not input.IsKeyDown( key ) then
			net.Start( "HiddenTaunt" )
				net.WriteTable( selected_taunt )
			net.SendToServer()
			self:Remove()
		end
	end


	local radius = w*0.3
	local sz = 100
	local incr = (180/#Taunts)

	for i = 1,#Taunts do 

		local a =  i*incr+72
		local x = w/2 + math.sin( math.rad( a ) )*radius
		local y = h/2 + math.cos( math.rad( a ) )*radius

		local taunt = vgui.Create( "DPanel", taunt_menu )
		taunt:SetSize( sz, sz )
		taunt:SetPos( x - sz/2, y - sz/2 )

		function taunt:OnCursorEntered()
			local x2,y2 = self:GetPos()
			targ_x = x2 + sz/2
			targ_y = y2 + sz/2
			targ_i = i
			selected_taunt = Taunts[ i ][ 2 ]
			should_draw = true
		end 

		function taunt:OnCursorExited()
			targ_x = w/2
			targ_y = h/2
			selected_taunt = {}
			should_draw = false
		end 

		function taunt:Paint( w, h )
			local Text = Taunts[ i ][ 1 ]
			surface.SetFont( "HiddenHUDSS" )
			local xsz, ysz = surface.GetTextSize( Text )
			draw.GlowingText(  Text, "HiddenHUDSS", w/2 - xsz/2, h/2 - ysz/2, unpack( white_glow ) )	
		end

	end

	local radius = w*0.38
	function taunt_menu:Paint( w, h )


		if not should_draw then return end

		surface.SetDrawColor( Color( 255, 60, 0, 40  ) )
		local a = targ_i*incr+72 + incr/2
		local point1 = { w/2 + math.sin( math.rad( a ) )*radius, h/2 + math.cos( math.rad( a ) )*radius  }

		local a = targ_i*incr+72 - incr/2
		local point2 = { w/2 + math.sin( math.rad( a ) )*radius, h/2 + math.cos( math.rad( a ) )*radius  }

		local poly = 
		{
			{ x = w/2, y = h/2 },
			{ x = point1[ 1 ], y = point1[ 2 ] },
			{ x = point2[ 1 ], y = point2[ 2 ] },
			{ x = w/2, y = h/2 }
		}
		surface.DrawPoly( poly )
	end

end

function CloseTaunts()
	if IsValid( taunt_menu ) then
		taunt_menu:Remove()
	end
end 

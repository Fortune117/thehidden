
local Stats = { 10, 10, 10 }
local StatNames = { "Strength", "Agility", "Endurance" }
local Cost = 0
local Points = 5

function ResetStats()
	Stats = { 10, 10, 10 }
end


local StatColors = 
{
	Color( 230, 60, 0, 50  ),
	Color( 0, 230, 30, 50  ),
	Color( 0, 60, 255, 50  )
}
function GetStatColor( i )
	local tbl = table.Copy( StatColors )
	return tbl[ i ]
end

local StatBarColors = 
{
	Color( 240, 40, 0, 50  ),
	Color( 0, 190, 30, 50  ),
	Color( 0, 60, 225, 50  )
}
function GetStatBarColor( i )
	local tbl = table.Copy( StatBarColors )
	return tbl[ i ]
end

local Presets = 
{
	[ "The Hidden" ] = { "Standard build. 10 points in each stat, well rounded. Recommended for beginners.", { 10, 10 , 10 } },
	[ "The Stalker" ] = { "Speed focused build, sacrifices hp. Recommended for experienced players.", { 2, 18, 10 } },
	[ "The Hunter" ] = { "Endurance focused build, sacrifices hp. Recommended for advanced players.", { 2, 10, 18 } },
	[ "The Tank" ] = { "Health focused build, sacrifices speed. Recommended for advanced players.", {20, 0, 10 } },
	[ "The Beast" ] = { "With high strength and agility, the beast is a fearsome enemy. Suffers low endurance but deals heavy damage. Recommended for beginners.", {20, 10, 0 } },
	[ "The Demon" ] = { "With a slightly agility focused build, The Demon is fast but still packs a punch. Recommended for beginners.", {8, 14, 8 } },
	[ "The Rogue" ] = { "Fast and with high endurance, The Rouge has low strength but is very hard to catch. Not recommended for beginners.", {4, 13, 13 } }
} 
 
function CutUpString( str, width, font )
	local str_pieces = {}
	surface.SetFont( font )
	local xsz,ysz = surface.GetTextSize( str )
	if xsz < width then
		return { str }
	end
	local str_table = string.Explode( " ", str )
	local cur_string = ""
	for i = 1,#str_table do
		surface.SetFont( font )
		local text = i > 1 and cur_string.." "..str_table[ i ] or str_table[ i ]
		local xsz,ysz = surface.GetTextSize( text )
		if xsz >= width then
			str_pieces[ #str_pieces+1 ] = cur_string
			cur_string = str_table[ i ]
		else
			cur_string = text
		end
		if i == #str_table then
			str_pieces[ #str_pieces+1 ] = cur_string
		end
	end
	return str_pieces
end


local h_menu
function OpenHiddenMenu()

	local gm_hdn = GAMEMODE.Hidden
	Points = gm_hdn.AttributePoints
	LocalPlayer().InHiddenMenu = true
	h_menu = vgui.Create( "DFrame" )
	h_menu:SetSize( ScrW()/1.5, ScrH()/2 )
	h_menu:Center()
	h_menu:SetDraggable( false )
	h_menu:ShowCloseButton( true )
	h_menu:SetTitle( "" )
	h_menu:MakePopup()
	h_menu.stats = {}

	local function SetStrength( num )
		for i = 1,20 do
			h_menu.stats[ 1 ].bars[ i ].Active = false
			h_menu.stats[ 1 ].bars[ i ].Alpha = h_menu.stats[ 1 ].bars[ i ].DefaultAlpha
		end
		h_menu.stats[ 1 ].selected = num
		for i = 1,num do
			h_menu.stats[ 1 ].bars[ i ].Active = true
			h_menu.stats[ 1 ].bars[ i ].Alpha = h_menu.stats[ 1 ].bars[ i ].ActiveAlpha
		end
	end

	local function SetAgility( num )
		for i = 1,20 do
			h_menu.stats[ 2 ].bars[ i ].Active = false
			h_menu.stats[ 2 ].bars[ i ].Alpha = h_menu.stats[ 2 ].bars[ i ].DefaultAlpha
		end
		h_menu.stats[ 2 ].selected = num
		for i = 1,num do
			h_menu.stats[ 2 ].bars[ i ].Active = true
			h_menu.stats[ 2 ].bars[ i ].Alpha = h_menu.stats[ 2 ].bars[ i ].ActiveAlpha
		end
	end

	local function SetEndurance( num )
		for i = 1,20 do
			h_menu.stats[ 3 ].bars[ i ].Active = false
			h_menu.stats[ 3 ].bars[ i ].Alpha = h_menu.stats[ 3 ].bars[ i ].DefaultAlpha
		end
		h_menu.stats[ 3 ].selected = num
		for i = 1,num do
			h_menu.stats[ 3 ].bars[ i ].Active = true
			h_menu.stats[ 3 ].bars[ i ].Alpha = h_menu.stats[ 3 ].bars[ i ].ActiveAlpha
		end
	end


	local padding = 20
	local gap = 20 
	local width, height = (h_menu:GetWide()/5)*3,(h_menu:GetTall()-padding*2 - gap*(#Stats-1) )/4

	local box_gap = 8
	function h_menu:Paint( w, h )
		draw.RoundedBox( 16, box_gap, box_gap, w-box_gap*2, h-box_gap*2, Color( 0, 0, 0, 180  ) )

		local font = ScrW() < 1000 and "HiddenHUDMS" or "HiddenHUDS"
		surface.SetFont( font )
		local xsz, ysz = surface.GetTextSize( "Points: "..Points )
		draw.GlowingText( "Points: "..Points, font, w/2 - xsz/2, ysz/2, unpack( white_glow ) )

		local font = ScrW() < 1000 and "HiddenHUDMS" or "HiddenHUDS"
		for i = 1,3 do
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( StatNames[ i ] )
			draw.GlowingText( StatNames[ i ], font,  (h_menu:GetWide() - width - padding - box_gap) + width/2 - xsz/2,padding + height*(i-1) + height/2 + gap*(i-1) - ysz, unpack( white_glow ) )	
		end


		local font = ScrW() < 1000 and "HiddenHUDML" or "HiddenHUD"
		surface.SetFont( font )
		local xsz, ysz = surface.GetTextSize( "Presets" )
		draw.GlowingText( "Presets", font, self:GetWide()/7 - xsz/2, ysz/4, unpack( white_glow ) )	
	end
	function h_menu:OnRemove()
		LocalPlayer().InHiddenMenu = false
	end

	surface.SetFont( "HiddenHUD" )
	local xsz, ysz = surface.GetTextSize( "Presets" )

	local presets_panel = vgui.Create( "DScrollPanel", h_menu )
	presets_panel:SetSize( (h_menu:GetWide()/3.5), h_menu:GetTall() - box_gap*2 - (ysz/4 + 2 + ysz) - 10 )
	presets_panel:SetPos( box_gap, box_gap + ysz/4 + 2 + ysz )
	function presets_panel:Paint( w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		--surface.DrawOutlinedRect( 0, 0, w, h )
	end 
	presets_panel.sets = {}

	local alt_bool = true 
	for k,v in SortedPairs( Presets ) do
		presets_panel.sets[ k ] = vgui.Create( "DButton", presets_panel )
		presets_panel.sets[ k ]:SetSize( presets_panel:GetWide(), presets_panel:GetTall()/6 )
		presets_panel.sets[ k ]:SetText( "" )
		presets_panel.sets[ k ].OriginalHeight = presets_panel.sets[ k ]:GetTall()
		presets_panel.sets[ k ].GrowSpeed = 8
		presets_panel.sets[ k ].Growing = false
		presets_panel.sets[ k ].Color = (alt_bool and Color( 22, 22, 22, 230 ) or Color( 0, 0, 0, 230 ))
		presets_panel.sets[ k ].ThinkDelay = 0

		local font = ScrW() < 1000 and "HiddenHUDSS" or "HiddenHUDS"
		surface.SetFont( font )
		local letter_w, _ = surface.GetTextSize( "x" )

		local cutoff_point = math.floor( (presets_panel:GetWide())/letter_w )

		local font = ScrW() < 1000 and "HiddenHUDSSSS" or "HiddenHUDSS"
		local curve = ScrW() < 1500 and 4 or ScrW() < 1000 and 2 or 8
		presets_panel.sets[ k ].Desc = CutUpString( v[ 1 ], (presets_panel:GetWide() - curve*2) - presets_panel:GetWide()/30, font  )
		presets_panel.sets[ k ]:Dock( TOP )

		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz = surface.GetTextSize( "AA" )
		presets_panel.sets[ k ].GrowHeight = presets_panel.sets[ k ].OriginalHeight + ysz*2*#presets_panel.sets[ k ].Desc

		presets_panel.sets[ k ].DoClick = function( self )
			SetStrength( v[ 2 ][ 1 ] )
			SetAgility( v[ 2 ][ 2 ] )
			SetEndurance( v[ 2 ][ 3 ] )
			Points = gm_hdn.AttributePoints - ( v[ 2 ][ 1 ]  + v[ 2 ][ 2 ]  + v[ 2 ][ 3 ] )
			for k2,v2 in pairs( presets_panel.sets ) do
				v2.Growing = false
			end
			self.Growing = true
			surface.PlaySound( "buttons/combine_button1.wav" )
		end
		
		local curve = ScrW() < 1500 and 4 or ScrW() < 1000 and 2 or 8
		presets_panel.sets[ k ].Paint = function( self, w, h )
			local _h = h - 10
			surface.SetDrawColor( self.Color  )
			--surface.DrawRect( 0, 5, w, _h + self.GrowHeight - 10 )
			draw.RoundedBox( curve, curve/2, 9, w - curve, self.GrowHeight - 10 - curve,  self.Color  )

			local font = ScrW() < 1000 and "HiddenHUDSS" or "HiddenHUDS"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( k )
			draw.GlowingText( k, font, self:GetWide()/2 - xsz/2, (self.OriginalHeight-10)/2 - ysz/2, unpack( white_glow ) )	

			local font = ScrW() < 1000 and "HiddenHUDSSSS" or "HiddenHUDSS"
			for i = 1,#self.Desc do
				surface.SetFont( font )
				local xsz, ysz = surface.GetTextSize( self.Desc[ i ] )
				draw.AAText( self.Desc[ i ], font, w/30, (self.OriginalHeight-10) + ysz + ysz*1.5*(i-1), unpack( white_glow ) )
			end
			
		end  
		presets_panel.sets[ k ].Think = function( self )
			if CurTime() > self.ThinkDelay then
				if self.Growing == true then
					self:SetTall( math.Approach( self:GetTall(), self.GrowHeight, self.GrowSpeed ) )
				else
					self:SetTall( math.Approach( self:GetTall(), self.OriginalHeight , self.GrowSpeed ) )
				end
				self.ThinkDelay = CurTime() + 0.01
			end
		end
		alt_bool = not alt_bool
	end 
	//Forgive me.
	for i = 1,#Stats do
		h_menu.stats[ i ] = vgui.Create( "DPanel", h_menu )
		h_menu.stats[ i ]:SetSize( width, height )
		h_menu.stats[ i ]:SetPos( h_menu:GetWide() - width - padding - box_gap, padding + height*(i-1) + height/2 + gap*(i-1) )
		local curve = ScrW() < 1500 and 4 or ScrW() < 1000 and 0 or 8
		local mod = 2
		h_menu.stats[ i ].Paint = function( self, w, h )
			draw.RoundedBox( curve, curve, curve, w - curve*2, h - curve*2, GetStatColor( i ) )

			draw.RoundedBox( curve, curve+mod, curve+mod, w - (curve+mod)*2, h - (curve+mod)*2, Color( 22, 22, 22, 240 ) )
		end 

		h_menu.stats[ i ]:DockPadding( curve*2 + mod*3, curve + mod*3, curve*2 + mod*2, curve + mod*3)

		h_menu.stats[ i ].bars = {}
		h_menu.stats[ i ].selected = 0

		for i2 = 1,20 do
			h_menu.stats[ i ].bars[ i2 ] = vgui.Create( "DButton", h_menu.stats[ i ] )
			h_menu.stats[ i ].bars[ i2 ]:Dock( LEFT )
			h_menu.stats[ i ].bars[ i2 ]:SetSize( (width - curve*4 - mod*4)/20, height-mod*2 - curve*20 )
			h_menu.stats[ i ].bars[ i2 ]:SetText( "" )
			h_menu.stats[ i ].bars[ i2 ].Color = GetStatBarColor( i )
			h_menu.stats[ i ].bars[ i2 ].Alpha = 5
			h_menu.stats[ i ].bars[ i2 ].HoverAlpha = 80
			h_menu.stats[ i ].bars[ i2 ].DefaultAlpha = 5
			h_menu.stats[ i ].bars[ i2 ].ActiveAlpha = 255
			h_menu.stats[ i ].bars[ i2 ].Active = false
			local curve = 8
			h_menu.stats[ i ].bars[ i2 ].IsActive = function( self )
				return self.Active == true
			end 
			h_menu.stats[ i ].bars[ i2 ].Paint = function( self, w, h )
				--self.Color = GetStatColor( i )
				self.Color.a = self.Alpha
				draw.RoundedBox( curve, curve/2, curve/2, w - curve, h - curve, self.Color )

			end 
			local cross = Material( "icon16/cross.png", "noclamp smooth" )
			local sz = h_menu.stats[ i ].bars[ i2 ]:GetWide()/1.5
			h_menu.stats[ i ].bars[ i2 ].PaintOver = function( self, w, h )
				if self.Hovered == true and not self.Active and (i2-h_menu.stats[ i ].selected) > Points then
					surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
					surface.SetMaterial( cross )
					surface.DrawTexturedRect( w/2 - sz/2, h/2 - sz/2, sz, sz )
				end
			end 
			h_menu.stats[ i ].bars[ i2 ].OnCursorEntered = function( self )
				surface.PlaySound( "buttons/lightswitch2.wav" )
				if not self:IsActive() then
					self.Alpha = self.HoverAlpha
				else
					self.Alpha = self.ActiveAlpha
				end
				self.Hovered = true
				for i3 = 1,i2-1 do
					h_menu.stats[ i ].bars[ i3 ].Hovered = true
					if not h_menu.stats[ i ].bars[ i3 ].IsActive( h_menu.stats[ i ].bars[ i3 ] )  then
						h_menu.stats[ i ].bars[ i3 ].Alpha = h_menu.stats[ i ].bars[ i3 ].HoverAlpha
					end
				end
				for i3 = i2+1,20 do
					if h_menu.stats[ i ].bars[ i3 ].IsActive( h_menu.stats[ i ].bars[ i3 ] ) then
						h_menu.stats[ i ].bars[ i3 ].Hovered = true
						h_menu.stats[ i ].bars[ i3 ].Alpha = h_menu.stats[ i ].bars[ i3 ].HoverAlpha
					else
						break
					end
				end
			end
			h_menu.stats[ i ].bars[ i2 ].OnCursorExited = function( self )
				if not self:IsActive() then
					self.Alpha = self.DefaultAlpha
				else
					self.Alpha = self.ActiveAlpha
				end
				
				self.Hovered = false
				for i3 = 1,i2-1 do
					h_menu.stats[ i ].bars[ i3 ].Hovered = false
					if not h_menu.stats[ i ].bars[ i3 ].IsActive( h_menu.stats[ i ].bars[ i3 ] )  then 
						h_menu.stats[ i ].bars[ i3 ].Alpha = h_menu.stats[ i ].bars[ i3 ].DefaultAlpha
					end
				end

				for i3 = i2+1,20 do
					if h_menu.stats[ i ].bars[ i3 ].IsActive( h_menu.stats[ i ].bars[ i3 ] ) then
						h_menu.stats[ i ].bars[ i3 ].Hovered = false
						h_menu.stats[ i ].bars[ i3 ].Alpha = h_menu.stats[ i ].bars[ i3 ].HoverAlpha
					else
						break
					end
				end
			end
			h_menu.stats[ i ].bars[ i2 ].DoClick = function( self )
				for i3 = 1,math.min( i2-1, Points + h_menu.stats[ i ].selected ) do
					if Points <= 0 then break end
					surface.PlaySound( "ambient/office/office_projector_slide_01.wav" )
					if h_menu.stats[ i ].bars[ i3 ].Active == false then 
						Points = Points - 1
						h_menu.stats[ i ].selected = h_menu.stats[ i ].selected + 1
					end
					h_menu.stats[ i ].bars[ i3 ].Active = true
					h_menu.stats[ i ].bars[ i3 ].Alpha = h_menu.stats[ i ].bars[ i3 ].ActiveAlpha
				end
				if i2 < 20 then
					for i3 = i2+1,20 do
						if h_menu.stats[ i ].bars[ i3 ].Active == true then
							Points = Points + 1
							h_menu.stats[ i ].selected = h_menu.stats[ i ].selected - 1
							h_menu.stats[ i ].bars[ i3 ].Active = false
							h_menu.stats[ i ].bars[ i3 ].Alpha = h_menu.stats[ i ].bars[ i3 ].DefaultAlpha
						else
							break
						end
					end
					surface.PlaySound( "ambient/office/office_projector_slide_02.wav" )
				end

				if self:IsActive() then
						if h_menu.stats[ i ].bars[ i2+1 ] then 
							if not h_menu.stats[ i ].bars[ i2+1 ]:IsActive() then
								h_menu.stats[ i ].selected = h_menu.stats[ i ].selected - 1
								Points = Points + 1
								self.Active = false
								self.Alpha = self.DefaultAlpha
							end
						else
							h_menu.stats[ i ].selected = h_menu.stats[ i ].selected -1
							Points = Points + 1
							self.Active = false
							self.Alpha = self.DefaultAlpha
						end
					else
						if (i2-h_menu.stats[ i ].selected) <= Points then
							h_menu.stats[ i ].selected = h_menu.stats[ i ].selected + 1
							Points = Points - 1
							self.Active = true
							self.Alpha = self.ActiveAlpha
						end
					end
				end 
				h_menu.stats[ i ].bars[ i2 ].Think = function( self )
					if self:IsActive() and self.Hovered == false then
						self.Alpha = self.ActiveAlpha
					end
				end 
		
			end

		local x,y = h_menu.stats[ i ]:GetPos()
		h_menu.stats[ i ].incr = vgui.Create( "DButton", h_menu )
		h_menu.stats[ i ].incr:SetSize( h_menu.stats[ i ]:GetTall()/3, h_menu.stats[ i ]:GetTall()/3 )
		h_menu.stats[ i ].incr:SetPos( x - h_menu.stats[ i ].incr:GetWide() - 2, y + curve + mod )
		h_menu.stats[ i ].incr:SetText( "+")
		h_menu.stats[ i ].incr.DoClick = function( self )
			if Points >= 1 then
				if h_menu.stats[ i ].selected == 20 then return end
				h_menu.stats[ i ].selected = math.min( h_menu.stats[ i ].selected+1, 20 )
				Points = Points - 1
				surface.PlaySound( "ambient/office/office_projector_slide_01.wav" )
				for i2 = 1,h_menu.stats[ i ].selected do
					h_menu.stats[ i ].bars[ i2 ].Active = true
					h_menu.stats[ i ].bars[ i2 ].Alpha = h_menu.stats[ i ].bars[ i2 ].ActiveAlpha
				end 

			end
		end 

		h_menu.stats[ i ].decr = vgui.Create( "DButton", h_menu )
		h_menu.stats[ i ].decr:SetSize( h_menu.stats[ i ]:GetTall()/3, h_menu.stats[ i ]:GetTall()/3 )
		h_menu.stats[ i ].decr:SetPos( x - h_menu.stats[ i ].incr:GetWide() - 2, y + h_menu.stats[ i ]:GetTall() - h_menu.stats[ i ].decr:GetTall() - curve - mod )
		h_menu.stats[ i ].decr:SetText( "-" )
		h_menu.stats[ i ].decr.DoClick = function( self )
			if Points < 30 then
				if h_menu.stats[ i ].selected == 0 then return end
				for i2 = 20,h_menu.stats[ i ].selected, -1 do
					if h_menu.stats[ i ].bars[ i2 ]:IsActive() then
						h_menu.stats[ i ].bars[ i2 ].Active = false
						h_menu.stats[ i ].bars[ i2 ].Alpha = h_menu.stats[ i ].bars[ i2 ].DefaultAlpha
					end
				end 
				Points = Points + 1
				h_menu.stats[ i ].selected = math.max( h_menu.stats[ i ].selected-1, 0 )
				surface.PlaySound( "ambient/office/office_projector_slide_01.wav" )
			end
		end 
	end
	
	local confirm = vgui.Create( "DButton", h_menu )
	confirm:SetSize( 100, 40 )
	confirm:SetPos( h_menu:GetWide()/2 - confirm:GetWide()/2, h_menu:GetTall() - confirm:GetTall() - 12 )
	confirm:SetText( "" )
	confirm.DoClick = function()
		if Points <= 0 then
			local str, agi, endurance =  h_menu.stats[ 1 ].selected, h_menu.stats[ 2 ].selected, h_menu.stats[ 3 ].selected 
			net.Start( "ApplyHiddenStats" )
				net.WriteTable( { str, agi, endurance } )
			net.SendToServer()
			gm_hdn.Stamina = gm_hdn.BaseStamina + h_menu.stats[ 3 ].selected*gm_hdn.StaminaPerEndurance
			gm_hdn.Strength = str
			gm_hdn.Agility = agi
			gm_hdn.Endurance = endurance 
			h_menu:Remove()
			surface.PlaySound( "buttons/blip2.wav" )
		else
			chat.AddText( Color( 0, 240, 255, 255 ), "You have ", Color( 0, 255, 20, 255), tostring( Points ), Color( 0, 240, 255, 255 ), " unspent points. Spend them first!" )
		end 
	end 
	local curve = 4
	confirm.Paint = function( self, w, h )
		--draw.RoundedBox( curve, curve, curve, w - curve*2, h - curve*2, Color( 235, 44, 44, 180 ) )
		surface.SetFont( "HiddenHUDS")
		local xsz, ysz = surface.GetTextSize( "Confirm" )
		draw.GlowingText( "Confirm", "HiddenHUDS", self:GetWide()/2 - xsz/2, self:GetTall()/2 - ysz/2, unpack( white_glow ) )	
	end

end
net.Receive( "HiddenStats", OpenHiddenMenu )

function CheckHiddenMenu()
	if LocalPlayer().InHiddenMenu then
		net.Start( "ApplyHiddenStats" )
			net.WriteTable( { 10, 10, 10 } )
		net.SendToServer()
		GAMEMODE.Hidden.Stamina = GAMEMODE.Hidden.BaseStamina + h_menu.stats[ 3 ].selected*GAMEMODE.Hidden.StaminaPerEndurance
		h_menu:Remove()
	end
end
net.Receive( "CheckHiddenMenu", CheckHiddenMenu)
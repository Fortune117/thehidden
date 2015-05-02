 
 local frame_h = 240
 local tick = Material( "icon16/tick.png", "noclamp smooth" )
 local frame
 local scroll 
 function CreateRTVMenu()
 	if IsValid( frame ) then
 		frame:Remove()
 	end
 	local maps = net.ReadTable()
 	local time = CurTime() + net.ReadInt( 8 )
 	frame = vgui.Create( "DFrame" )
 	frame:SetPos( 0, ScrH()/2 - frame_h/2 )
 	frame:SetSize( 210, frame_h )
 	frame:SetTitle( "RTV Menu" )
 	frame:SetDraggable( false )
 	frame:ShowCloseButton( false ) 
 	function frame:Paint( w, h )
 		surface.SetDrawColor( Color( 0, 0, 0, 120 ) )
 		surface.DrawRect( 0, 0, w, h )

 		local draw_time = math.ceil( time - CurTime() )
	 	surface.SetFont( "HiddenHUDSS" )
		local xsz,ysz = surface.GetTextSize( draw_time )
		draw.GlowingText( draw_time, "HiddenHUDSS", w/2 - xsz/2, 2, unpack( white_glow ) )
 	end
 	function frame:Think()
 		if CurTime() > time then
 			self:Remove()
 		end
 	end
 	function frame:OnRemove()

 	end
 	frame:MakePopup()

 	local close = vgui.Create( "DButton", frame )
 	close:SetSize( 35, 20  )
 	close:SetPos( frame:GetWide()-close:GetWide(), 0 )
 	close:SetText( "" )
 	function close:Paint( w, h )
 		surface.SetDrawColor( Color( 235, 20, 20, 240 ) )
 		surface.DrawRect( 0, 0, w, h )
 	end 
 	function close:DoClick()
 		frame:Remove()
 	end

 	scroll = vgui.Create( "DScrollPanel", frame )
 	scroll:SetSize( 210, (frame_h - frame_h/6) )
 	scroll:SetPos( 0, frame_h/6 )
 	scroll.maps = {}

 	for i = 1,#maps do

 		scroll.maps[ i ] = vgui.Create( "DButton", scroll )
 		scroll.maps[ i ]:DockPadding( 0, 10, 0, 10 )
 		scroll.maps[ i ]:SetSize( 10, frame_h/6 )
 		scroll.maps[ i ]:Dock( TOP )
 		scroll.maps[ i ]:DockMargin( 0, 2, 0, 0 )
 		scroll.maps[ i ]:SetText( "" )
 		scroll.maps[ i ].map = maps[ i ]
 		scroll.maps[ i ].GrowWidth = frame_h/6 
 		scroll.maps[ i ].Grow = 0
 		scroll.maps[ i ].Votes = 0
 		scroll.maps[ i ].Delay = 0
 		scroll.maps[ i ].Paint = function( self, w, h )

 			surface.SetDrawColor( Color( 0, 0, 0, 240 ) )
 			surface.DrawRect( 0, 0, w, h )

 			
 			local x_add = self.Grow 

 			surface.SetDrawColor( 0, 102, 255, 255 )
 			surface.DrawRect( -self:GetWide() + x_add, 0, self:GetWide(), self:GetTall() )

			local map_name = maps[ i ]
 			surface.SetFont( "HiddenHUDSS" )
 			local xsz,ysz = surface.GetTextSize( map_name )
 			draw.GlowingText( map_name, "HiddenHUDSS", w/2 - xsz/2, h/2 - ysz/2, unpack( white_glow ) )

 			local map_votes = self.Votes
 			surface.SetFont( "HiddenHUDS" )
 			local xsz,ysz = surface.GetTextSize( map_votes )
 			draw.GlowingText( map_votes, "HiddenHUDS",xsz/2, h/2 - ysz/2, unpack( white_glow ) )

 		end 
 		scroll.maps[ i ].DoClick = function( self )
			net.Start( "RTV_Vote" )
				net.WriteString( maps[ i ] )
			net.SendToServer() 
 		end 
 		scroll.maps[ i ].Think = function( self )
 			if CurTime() > self.Delay then
	 			local w = (scroll.maps[ i ].Votes/#player.GetAll())*self:GetWide()
	 			scroll.maps[ i ].Grow = math.Approach( scroll.maps[ i ].Grow, w, 2 )
	 			self.Delay = CurTime() + 0.01
	 		end
 		end 

 	end

 end

 net.Receive( "InitiateRTV", CreateRTVMenu ) 

 function SyncVotes()
 	local tbl = net.ReadTable()
 	if scroll and scroll.maps then
 		local s_maps = scroll.maps
 		for i = 1,#s_maps do
 			if tbl[ s_maps[ i ].map ] then
 				s_maps[ i ].Votes = #tbl[ s_maps[ i ].map  ]
 			end
 		end
 	end
 end
 
 net.Receive( "RTV_SyncVotes", SyncVotes )

 function CreateNominateMenu()
 	 if IsValid( frame ) then
 		frame:Remove()
 	end
 	local maps = net.ReadTable()

 	frame = vgui.Create( "DFrame" )
 	frame:SetPos( 0, ScrH()/2 - frame_h/2 )
 	frame:SetSize( 210, frame_h )
 	frame:SetTitle( "Nominate Menu" )
 	frame:SetDraggable( false )
 	frame:ShowCloseButton( false ) 
 	function frame:Paint( w, h )
 		surface.SetDrawColor( Color( 0, 0, 0, 120 ) )
 		surface.DrawRect( 0, 0, w, h )
 	end
 	frame:MakePopup()

 	local close = vgui.Create( "DButton", frame )
 	close:SetSize( 35, 20 )
 	close:SetPos( frame:GetWide()-close:GetWide(), 0 )
 	close:SetText( "" )
 	function close:Paint( w, h )
 		surface.SetDrawColor( Color( 235, 20, 20, 240 ) )
 		surface.DrawRect( 0, 0, w, h )
 	end 
 	function close:DoClick()
 		frame:Remove()
 	end

 	scroll = vgui.Create( "DScrollPanel", frame )
 	scroll:SetSize( 210, frame_h - (frame_h/6) - frame_h/10 )
 	scroll:SetPos( 0, frame_h/6 )
 	scroll.maps = {}

 	for i = 1,#maps do

 		scroll.maps[ i ] = vgui.Create( "DButton", scroll )
 		scroll.maps[ i ]:DockPadding( 0, 10, 0, 10 )
 		scroll.maps[ i ]:SetSize( 10, frame_h/6 )
 		scroll.maps[ i ]:Dock( TOP )
 		scroll.maps[ i ]:DockMargin( 0, 2, 0, 0 )
 		scroll.maps[ i ]:SetText( "" )
 		scroll.maps[ i ].GrowWidth = frame_h/6 
 		scroll.maps[ i ].Grow = 0
 		scroll.maps[ i ].Votes = 0
 		scroll.maps[ i ].Delay = 0
 		scroll.maps[ i ].Paint = function( self, w, h )

 			surface.SetDrawColor( Color( 0, 0, 0, 240 ) )
 			surface.DrawRect( 0, 0, w, h )

 			local x_add = self.Grow 

 			surface.SetDrawColor( 0, 102, 180, 255 )
 			surface.DrawRect( -self:GetWide() + x_add, 0, self:GetWide(), self:GetTall() )

 			
 			local x_add = self.Grow 

			local map_name = maps[ i ]
 			surface.SetFont( "HiddenHUDSS" )
 			local xsz,ysz = surface.GetTextSize( map_name )
 			draw.GlowingText( map_name, "HiddenHUDSS", w/2 - xsz/2, h/2 - ysz/2, unpack( white_glow ) )

 		end 
 		scroll.maps[ i ].DoClick = function( self )
 			for i2 = 1,#scroll.maps do
 				scroll.maps[ i2 ].Selected = false 
 			end
 			self.Selected = true
 			scroll.selected = maps[ i ]
 		end 

 		 scroll.maps[ i ].Think = function( self )
 			if CurTime() > self.Delay then
	 			local w = self.Selected and self:GetWide() or 0
	 			scroll.maps[ i ].Grow = math.Approach( scroll.maps[ i ].Grow, w, 5 )
	 			self.Delay = CurTime() + 0.01
	 		end
 		end 

 	end

 	local confirm = vgui.Create( "DButton", frame )
 	confirm:SetSize( frame:GetWide(), frame_h/10 )
 	confirm:SetPos( 0, frame_h - confirm:GetTall() )
 	confirm:SetText( "" )
 	confirm.DoClick = function( self )
 		if scroll.selected then
			net.Start( "RTV_SyncNominate" )
				net.WriteString( scroll.selected )
			net.SendToServer() 
			frame:Remove()
		else
			chat.AddText( Color( 255, 255, 255, 255 ), "Please select a map first!" )
		end 
 	end
 	confirm.Paint = function( self, w, h )
 		surface.SetDrawColor( 0, 102, 255, 230 )
 		surface.DrawRect( 0, 0, w, h )

		surface.SetFont( "HiddenHUDS" )
		local xsz,ysz = surface.GetTextSize( "Confirm" )
		draw.GlowingText( "Confirm", "HiddenHUDS", w/2 - xsz/2, h/2 - ysz/2, unpack( white_glow ) )
 	end 

 end

 net.Receive( "RTV_Nominate", CreateNominateMenu )

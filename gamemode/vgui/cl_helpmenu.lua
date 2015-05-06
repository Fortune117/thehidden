
local PANEL = {}
function PANEL:Init()
	local w,h = ScrH()*0.5, ScrH()*0.5
	self:SetSize( w, h )
	self:Center()
	self:MakePopup()
	self:SetTitle( "" )
	self:ShowCloseButton( true )

	self.Close = vgui.Create( "DButton", self )
	self.Close:SetSize( w/10, 25 )
	self.Close:SetPos( w-self.Close:GetWide(), 0 )
	self.Close:SetText( "" )
	self.Close.DoClick = function()
		self:Remove()
		surface.PlaySound( "buttons/button19.wav" )
	end
	self.Close.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 240, 30, 30, 100 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	local font = ScrW() < 1000 and "HiddenHUDS" or "HiddenHUDScoreL"
	self.Desc = CutUpString( GAMEMODE.InfoText, w-40, font )
end

local scan_h = 3
local add = 0

function PANEL:Paint()

	local w,h = self:GetSize()
	surface.SetDrawColor( Color( 11, 11, 11, 255 ) )
	surface.DrawRect( 0, 0, w, h )

	add = math.loop( add, 0, scan_h*2, 0.05 )

	surface.SetDrawColor( Color( 22, 22, 22, 88 ) )
	for i = 1,(h/scan_h)/2+2 do
		surface.DrawRect( 0, scan_h*((i-2)*2) + add, w, scan_h )
	end

	local font = ScrW() < 1000 and "HiddenHUDS" or "HiddenHUDS"
	surface.SetFont( font )
	local xsz, ysz = surface.GetTextSize( "Game Info")
	draw.GlowingText( "Game Info", font, w/2 - xsz/2, 20, unpack( white_glow ) )

	local font = ScrW() < 1000 and "HiddenHUDS" or "HiddenHUDScoreL"
	for i = 1,#self.Desc do
		surface.SetFont( font )
		local xsz, ysz = surface.GetTextSize( self.Desc[ i ] )
		draw.GlowingText( self.Desc[ i ], font, 20, 15 + 15*1.5*(i-1) + 25, unpack( white_glow ) )
	end

end

derma.DefineControl( "hdn_helpmenu", "Help menu", PANEL, "DFrame" )
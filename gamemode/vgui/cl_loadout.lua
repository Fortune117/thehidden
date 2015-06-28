
function math.loop( num, min, max, speed )
	num = num + speed
	if num > max then
		num = min
	end
	return num
end

local Stats =
{
	"DMG",
	"ACC",
	"FRT",
	"RCL",
	"MAG"
}

local stat_names = 
{
	"damage",
	"cone",
	"delay",
	"kick",
	"clip"
}

local CompareStatFuncs = 
{
	["damage"] = function( dmg1, dmg2 )
		return math.max( dmg1, dmg2 )
	end,
	["cone"] = function( cone1, cone2 )
		return math.min( cone1, cone2 )
	end,
	["delay"] = function( dly1, dly2 )
		return math.min( dly1, dly2 )
	end,
	["kick"] = function( kick1, kick2 )
		return math.min( kick1, kick2 ) 
	end,
	["clip"] = function( clip1, clip2 )
		return math.max( clip1, clip2 )
	end 

}


function GetWeaponInfo( wpn )
	local wep = weapons.Get( wpn )
	if wep then
		local dmg = wep.Primary.Damage*wep.Primary.Bullets 
		return { ["name"] = wep.PrintName, ["damage"] = dmg, ["cone"] = wep.Primary.Cone, ["delay"] = wep.Primary.Delay, ["kick"] = wep.Kick, ["clip"] = wep.Primary.ClipSize }
	end
	return false
end

function GetWeaponModel( wpn )
	local wep = weapons.Get( wpn )
	if wep then
		model = wep.WorldModel
	end
	return model or "models/weapons/w_rif_ak47.mdl"
end

local valid_weapons = 
{
	"weapon_hdn_",
	"weapon_fort"
}


local TopStats = { ["damage"] = 0, ["cone"] = 5, ["delay"] = 5, ["kick"] = 5, ["clip"]= 0 } 
local StatBarFuncs = 
{
	["damage"] = function( dmg ) 
		return dmg/TopStats[ "damage" ] 
	end,
	["cone"] = function( cone )
		return ( TopStats[ "cone" ]/cone )
	end,
	["delay"] = function( delay )
		return ( TopStats[ "delay" ]/delay )
	end,
	["kick"] = function( kick )
		return ( TopStats[ "kick" ]/kick )
	end,
	["clip"] = function( clip )
		return clip/TopStats[ "clip" ]
	end

}

function CalculateStatBar( stat_name, stat )
	return StatBarFuncs[ stat_name ]( stat ) 
end

function GetValidWeapons() 
	local weps = {}
	for k,wep in pairs( weapons.GetList() ) do
		if wep.InLoadoutMenu then
			weps[ #weps+1 ] = wep
		end
	end
	return weps
end

function GetTopStats()  
	for k,v in pairs( GetValidWeapons() ) do 

		if not v.CalculateStats then continue end

		local inf = GetWeaponInfo( v.ClassName )
		for k2,v2 in pairs( TopStats ) do 
			TopStats[ k2 ] = CompareStatFuncs[ k2 ]( v2, inf[ k2 ] )
		end
		
	end
end

GetTopStats()

local PANEL = {}

function PANEL:Init()
	GetTopStats()
	surface.PlaySound( "buttons/light_power_on_switch_01.wav" )
	local padding = 35
	local w,h = ScrW()/3,ScrH()/2
	self:SetTitle( "" )
	self:SetSize( w, h )
	self:SetVisible( true )
	self:SetBackgroundBlur( true )
	self:Center()
	self:MakePopup()
	self.SelectedWeapon = 0
	self:ShowCloseButton( false )

	self.Close = vgui.Create( "DButton", self )
	self.Close:SetSize( w/10, 25 )
	self.Close:SetPos( w-self.Close:GetWide(), 0 )
	self.Close:SetText( "" )
	self.Close.DoClick = function()
		self:SetVisible( false )
		surface.PlaySound( "buttons/button19.wav" )
	end
	self.Close.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 240, 30, 30, 100 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	local w_w,w_h =  w/2.5, h/2 
	self.Weapons = vgui.Create( "DPanel", self )
	self.Weapons:SetPos( padding, 25 )
	self.Weapons:SetSize( w_w, w_h )
	self.Weapons.Paint = function( self, _w, _h )
		surface.SetDrawColor( Color( 22, 22, 22, 255 ) )
		surface.DrawOutlinedRect( 0, 0, _w, _h )
	end

	local params = {}
	params[ "$basetexture" ] = "phoenix_storms/dome"
	params[ "$vertexcolor" ] = 1
	params[ "$vertexalpha" ] = 1
			
	local weapon_background = CreateMaterial( "mod_phoenix_storms/gear", "UnlitGeneric", params )

	--local weapon_background = Material( "phoenix_storms/dome" )
	--local weapon_background = Material( "phoenix_storms/stripes" )
	--local weapon_background = Material( "phoenix_storms/gear" )
	self.WeaponScroll = vgui.Create("DScrollPanel", self.Weapons )
	self.WeaponScroll:SetSize( w_w, w_h )
	self.WeaponScroll:SetPos( 0, 0 )
	self.WeaponScroll:DockPadding( 5, 5, 5, 5)
	self.WeaponScroll.Paint = function( self_panel, w, h )
	end

	local border = 4
	local Valid_Weapons = GetValidWeapons()
	for i = 1,#Valid_Weapons do

		local wep_info = GetWeaponInfo( Valid_Weapons[ i ].ClassName )

		local weapon_option = vgui.Create( "DModelPanel", self.WeaponScroll )
		weapon_option:SetSize( w_w, w_h/4.6 )
		weapon_option:SetText( "" )
		weapon_option:Dock( TOP )
		weapon_option:DockMargin( 5, 5, 5, 0 )
		weapon_option.Selected = false
		weapon_option.DoClick = function()
			self.WeaponStats.wep_info = wep_info
			self.WeaponStats.Wep_Set = true
			PANEL.SelectedWeapon = i
			net.Start( "SelectWeapon" )
				net.WriteString( Valid_Weapons[ i ].ClassName )
			net.SendToServer()
			surface.PlaySound( "buttons/weapon_confirm.wav" )
		end

		weapon_option:SetModel( GetWeaponModel( Valid_Weapons[ i ].ClassName ) )

		weapon_option.LayoutEntity = function()

		end 

		weapon_option.SetUpModel = function()
			local add = 23
			local ent = weapon_option.Entity
			local size = ent:GetRenderBounds()
			print( size )
			ent:SetPos( Vector( -75, 0, -17 ) )
			ent:SetAngles( Angle( 0, 90, 0 ) )
			weapon_option.Angles = Angle( 0, 0, 0 )
			weapon_option:SetLookAt( ent:GetPos() + Vector( 0, 0, 6) )
			weapon_option:SetCamPos( Vector( 0, 0, 0 ) )
			weapon_option:SetFOV( 36 )
			weapon_option.bAnimated = true 
		end

		weapon_option.SetUpModel()

		weapon_option.Blur = 1
		weapon_option.MaxBlur = 4
		weapon_option.TargBlur = 1
		weapon_option.Alpha = 80
		weapon_option.MaxAlpha = 200
		weapon_option.TargAlpha = 80
		/*weapon_option.Paint = function( self, _w, _h )
			draw.BlurredBar( border, border, _w-border*2, _h-border*2, self.Blur, Color( 88, 88, 88, self.Alpha )   )

			surface.SetFont( "HiddenHUDSS" )
			local xsz, ysz = surface.GetTextSize( wep_info.name )
			draw.GlowingText( wep_info.name, "HiddenHUDSS", _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )
		end*/

		weapon_option.Think = function( self )
			if PANEL.SelectedWeapon == i then
				self.Blur = math.Approach( self.Blur, self.MaxBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.MaxAlpha, 2 )
			else
				self.Blur = math.Approach( self.Blur, self.TargBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.TargAlpha, 2 )
			end
		end

		weapon_option.Paint = function( self )
			if ( !IsValid( self.Entity ) ) then return end

			local x, y = self:LocalToScreen( 0, 0 )

			self:LayoutEntity( self.Entity )

			local ang = self.aLookAngle
			if ( !ang ) then
				ang = (self.vLookatPos-self.vCamPos):Angle()
			end

			local function model_draw( blend )
				local w, h = self:GetSize( )
				cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
				cam.IgnoreZ( true )

				render.SuppressEngineLighting( true )
				render.SetLightingOrigin( self.Entity:GetPos() )
				render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
				render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
				render.SetBlend( blend  )

				for i=0, 6 do
					local col = self.DirectionalLight[ i ]
					if ( col ) then
						render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
					end
				end
				self:DrawModel()
				render.SetBlend( 1 )

				render.SuppressEngineLighting( false )
				cam.IgnoreZ( false )
				cam.End3D()
			end

			model_draw( 1 )

			self.LastPaint = RealTime()

		end 

		weapon_option.PaintOver = function( self, _w, _h )
			if PANEL.SelectedWeapon == i then
				surface.SetFont( "HiddenHUDS" )
				local xsz, ysz = surface.GetTextSize( "Selected" )
				draw.GlowingText( "Selected", "HiddenHUDS", _w/2 - xsz/2, _h/2 - ysz/2, unpack( white_glow ) )
			end
		end 


		local mat1 = Material("models/debug/debugwhite")
		weapon_option.DrawModel = function( self_panel )
			local curparent = self_panel
			local rightx = self_panel:GetWide()
			local leftx = 0
			local topy = 0
			local bottomy = self_panel:GetTall()
			local previous = curparent
			while( curparent:GetParent() != nil ) do
				curparent = curparent:GetParent()
				local x, y = previous:GetPos()
				topy = math.Max( y, topy + y )
				leftx = math.Max( x, leftx + x )
				bottomy = math.Min( y + previous:GetTall(), bottomy + y )
				rightx = math.Min( x + previous:GetWide(), rightx + x )
				previous = curparent
			end
			render.SetScissorRect( leftx, topy, rightx, bottomy, true )
			self_panel.Entity:DrawModel()
			render.SetScissorRect( 0, 0, 0, 0, false )
		end


		weapon_option.OnCursorEntered = function( self ) 
			self.TargBlur = self.MaxBlur
			self.TargAlpha = self.MaxAlpha
			self.Entity:SetModelScale( 1.1, 0 )
			self.Entity:SetPos( Vector( -75, 0, -18 ) )
			surface.PlaySound( "ambient/office/office_projector_slide_02.wav" )
		end
		
		weapon_option.OnCursorExited = function( self )
			self.TargBlur = 1
			self.TargAlpha = 80
			self.Entity:SetModelScale( 1, 0 )
			self.Entity:SetPos( Vector( -75, 0, -17 ) )
		end 

	end

	self.WeaponStats = vgui.Create( "DPanel", self )
	self.WeaponStats:SetPos( w - padding - w_w, 25 )
	self.WeaponStats:SetSize( w_w, w_h )
	self.WeaponStats.wep_info = {}
	self.WeaponStats.Wep_Set = false
	self.WeaponStats.Paint = function( self, _w, _h )
		surface.SetDrawColor( Color( 22, 22, 22, 255 ) )
		--surface.DrawRect( 0, 0, _w, _h )

		local name = self.wep_info.name or "No Weapon"

		surface.SetFont( "HiddenHUDS" )
		local xsz, ysz = surface.GetTextSize( name )
		draw.GlowingText( name, "HiddenHUDS", _w/2 - xsz/2, 0, unpack( white_glow ) )

		local sz = ( _h - 15 - ysz )/#Stats 
		local gap = 35
		for i2 = 1,#Stats do

			surface.SetFont( "HiddenHUDSS" )
			local xsz2, ysz2 = surface.GetTextSize( Stats[ i2 ] )

			local t_x, t_y = gap - xsz2, sz*i2
			draw.GlowingText( Stats[ i2 ], "HiddenHUDSS", t_x, t_y, unpack( white_glow ) )

			if i2 < #Stats+1 then
				local bar_w 
				if self.Wep_Set then
					bar_w = (_w - gap*2 + 5)*CalculateStatBar( stat_names[ i2 ], self.wep_info[ stat_names[ i2 ] ] )
				else
					bar_w = 0
				end
				
				draw.BlurredBar( gap + 10 , t_y + ysz2*0.1, bar_w, ysz2*0.8, 4, Color( 0, 102, 255, 255 ) )
			end

		end
	end

	local e_w,e_h = w_w, h-w_h-100
	self.Equipment1 = vgui.Create( "DScrollPanel", self )
	self.Equipment1:SetSize( e_w, e_h )
	self.Equipment1:SetPos( padding, padding + w_h + 35 )
	self.Equipment1.Selected = 0


	local label = vgui.Create( "DPanel", self.Equipment1 )
	label:SetSize( e_w, 30 )
	label:Dock( TOP )
	label:DockMargin( 5, -5, 5, 5 )
	label.Paint = function( mem, _w, _h )
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz = surface.GetTextSize( "Primary Equipment" )
		draw.GlowingText( "Primary Equipment", "HiddenHUDSS", _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )
	end

	for k,v in pairs( LDT.Equipment ) do
		local equipment = vgui.Create( "DButton", self.Equipment1 )
		equipment:SetSize( e_w, math.max( e_h/5.6, 30 )  )
		equipment:SetText( "" )
		equipment:Dock( TOP )
		equipment:DockMargin( 5, -5, 5, 5 )
		equipment.Blur = 1
		equipment.MaxBlur = 2
		equipment.TargBlur = 1
		equipment.Alpha = 80
		equipment.MaxAlpha = 255
		equipment.TargAlpha = equipment.Alpha 
		equipment:SetToolTip( v.desc )


		local tick = Material( "icon16/tick.png", "noclamp smooth" )
		local cross = Material( "icon16/cross.png", "noclamp smooth" )
		equipment.Paint = function( mem, _w, _h )
			draw.BlurredBar( border, border, _w-border*2, _h-border*2, mem.Blur, Color( 44, 44, 44, mem.Alpha )   )

			local font = ScrW() < 1500 and "HiddenHUDSSS" or "HiddenHUDSS"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( k )
			draw.GlowingText( k, font, _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )

			local sz = ( _h-12 ) 
			surface.SetDrawColor( Color( 88, 88, 88, 255 ) )
			surface.DrawOutlinedRect( _w - sz - 6, 6, sz, sz ) 

			--surface.SetDrawColor( Color( 44, 44, 44, 255 ) )
			local mat = self.Equipment1.Selected == k and tick or cross
			surface.SetMaterial( mat )
			surface.DrawTexturedRect( _w - sz - 6, 6, sz, sz )
		end

		equipment.Think = function( self )
			if self:Get() == k then
				self.Blur = math.Approach( self.Blur, self.MaxBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.MaxAlpha, 2 )
			else
				self.Blur = math.Approach( self.Blur, self.TargBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.TargAlpha, 2 )
			end
		end

		equipment.OnCursorEntered = function( self )
			self.TargBlur = self.MaxBlur
			self.TargAlpha = self.MaxAlpha
			surface.PlaySound( "buttons/button22.wav" )
		end
		
		equipment.OnCursorExited = function( self )
			self.TargBlur = 1
			self.TargAlpha = 80
		end 

		equipment.Set = function( num )
			self.Equipment1.Selected = num
		end
	
		equipment.Get = function()
			return self.Equipment1.Selected
		end
	

		equipment.DoClick = function()
			equipment.Set( k )
			net.Start( "SelectEquipment" )
				net.WriteString( v.name )
			net.SendToServer()
			surface.PlaySound( "buttons/combine_button1.wav" )
		end  

	end

		local e_w,e_h = w_w+20, h-w_h-100
	self.Equipment2 = vgui.Create( "DScrollPanel", self )
	self.Equipment2:SetSize( e_w, e_h )
	self.Equipment2:SetPos( w - padding - e_w, padding + w_h + 35 )
	self.Equipment2.Selected = 0

	local label = vgui.Create( "DPanel", self.Equipment2 )
	label:SetSize( e_w, 30 )
	label:Dock( TOP )
	label:DockMargin( 5, -5, 5, 5 )
	label.Paint = function( mem, _w, _h )
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz = surface.GetTextSize( "Secondary Equipment" )
		draw.GlowingText( "Secondary Equipment", "HiddenHUDSS", _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )
	end


	for k,v in pairs( LDT.Equipment2 ) do
		local equipment = vgui.Create( "DButton", self.Equipment2 )
		equipment:SetSize( e_w, math.max( e_h/5.6, 30 ) )
		equipment:SetText( "" )
		equipment:Dock( TOP )
		equipment:DockMargin( 5, -5, 5, 5 )
		equipment.Blur = 1
		equipment.MaxBlur = 2
		equipment.TargBlur = 1
		equipment.Alpha = 80
		equipment.MaxAlpha = 255
		equipment.TargAlpha = equipment.Alpha
		equipment:SetToolTip( v.desc )

		local tick = Material( "icon16/tick.png", "noclamp smooth" )
		local cross = Material( "icon16/cross.png", "noclamp smooth" )
		equipment.Paint = function( mem, _w, _h )
			draw.BlurredBar( border, border, _w-border*2, _h-border*2, mem.Blur, Color( 44, 44, 44, mem.Alpha )   )

			local font = ScrW() < 1500 and "HiddenHUDSSS" or "HiddenHUDSS"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( k )
			draw.GlowingText( k, font, _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )

			local sz = ( _h-12 ) 
			surface.SetDrawColor( Color( 88, 88, 88, 255 ) )
			surface.DrawOutlinedRect( _w - sz - 6, 6, sz, sz ) 

			--surface.SetDrawColor( Color( 44, 44, 44, 255 ) )
			local mat = self.Equipment2.Selected == k and tick or cross
			surface.SetMaterial( mat )
			surface.DrawTexturedRect( _w - sz - 6, 6, sz, sz )
		end

		equipment.Think = function( self )
			if self:Get() == k then
				self.Blur = math.Approach( self.Blur, self.MaxBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.MaxAlpha, 2 )
			else
				self.Blur = math.Approach( self.Blur, self.TargBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.TargAlpha, 2 )
			end
		end

		equipment.OnCursorEntered = function( self )
			self.TargBlur = self.MaxBlur
			self.TargAlpha = self.MaxAlpha
			surface.PlaySound( "buttons/button22.wav" )
		end
		
		equipment.OnCursorExited = function( self )
			self.TargBlur = 1
			self.TargAlpha = 80
		end 

		equipment.Set = function( num )
			self.Equipment2.Selected = num
		end
	
		equipment.Get = function()
			return self.Equipment2.Selected
		end
	

		equipment.DoClick = function()
			equipment.Set( k )
			net.Start( "SelectEquipment2" )
				net.WriteString( v.name )
			net.SendToServer()
			surface.PlaySound( "buttons/combine_button1.wav" )
		end 

	end

	
end

function PANEL:RecreateEquipment()
	surface.PlaySound( "buttons/light_power_on_switch_01.wav" )
	local w,h = ScrW()/3,ScrH()/2
	local w_w,w_h =  w/2.5, h/2 
	local e_w,e_h = w_w, h-w_h-100
	local border = 4
	self.Equipment1:Clear()

	local label = vgui.Create( "DPanel", self.Equipment1 )
	label:SetSize( e_w, 30 )
	label:Dock( TOP )
	label:DockMargin( 5, -5, 5, 5 )
	label.Paint = function( mem, _w, _h )
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz = surface.GetTextSize( "Primary Equipment" )
		draw.GlowingText( "Primary Equipment", "HiddenHUDSS", _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )
	end

	for k,v in pairs( LDT.Equipment ) do
		local equipment = vgui.Create( "DButton", self.Equipment1 )
		equipment:SetSize( e_w, math.max( e_h/5.6, 30 )  )
		equipment:SetText( "" )
		equipment:Dock( TOP )
		equipment:DockMargin( 5, -5, 5, 5 )
		equipment.Blur = 1
		equipment.MaxBlur = 2
		equipment.TargBlur = 1
		equipment.Alpha = 80
		equipment.MaxAlpha = 255
		equipment.TargAlpha = equipment.Alpha
		equipment:SetToolTip( v.desc )

		local tick = Material( "icon16/tick.png", "noclamp smooth" )
		local cross = Material( "icon16/cross.png", "noclamp smooth" )
		equipment.Paint = function( mem, _w, _h )
			draw.BlurredBar( border, border, _w-border*2, _h-border*2, mem.Blur, Color( 44, 44, 44, mem.Alpha )   )

			local font = ScrW() < 1500 and "HiddenHUDSSS" or "HiddenHUDSS"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( k )
			draw.GlowingText( k, font, _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )

			local sz = ( _h-12 ) 
			surface.SetDrawColor( Color( 88, 88, 88, 255 ) )
			surface.DrawOutlinedRect( _w - sz - 6, 6, sz, sz ) 

			--surface.SetDrawColor( Color( 44, 44, 44, 255 ) )
			local mat = self.Equipment1.Selected == k and tick or cross
			surface.SetMaterial( mat )
			surface.DrawTexturedRect( _w - sz - 6, 6, sz, sz )
		end

		equipment.Think = function( self )
			if self:Get() == k then
				self.Blur = math.Approach( self.Blur, self.MaxBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.MaxAlpha, 2 )
			else
				self.Blur = math.Approach( self.Blur, self.TargBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.TargAlpha, 2 )
			end
		end

		equipment.OnCursorEntered = function( self )
			self.TargBlur = self.MaxBlur
			self.TargAlpha = self.MaxAlpha
			surface.PlaySound( "buttons/button22.wav" )
		end
		
		equipment.OnCursorExited = function( self )
			self.TargBlur = 1
			self.TargAlpha = 80
		end 

		equipment.Set = function( num )
			self.Equipment1.Selected = num
		end
	
		equipment.Get = function()
			return self.Equipment1.Selected
		end
	

		equipment.DoClick = function()
			equipment.Set( k )
			net.Start( "SelectEquipment" )
				net.WriteString( v.name )
			net.SendToServer()
			surface.PlaySound( "buttons/combine_button1.wav" )
		end  

	end

	self.Equipment2:Clear()
	local label = vgui.Create( "DPanel", self.Equipment2 )
	label:SetSize( e_w, 30 )
	label:Dock( TOP )
	label:DockMargin( 5, -5, 5, 5 )
	label.Paint = function( mem, _w, _h )
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz = surface.GetTextSize( "Secondary Equipment" )
		draw.GlowingText( "Secondary Equipment", "HiddenHUDSS", _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )
	end
	for k,v in pairs( LDT.Equipment2 ) do
		local equipment = vgui.Create( "DButton", self.Equipment2 )
		equipment:SetSize( e_w, math.max( e_h/5.6, 30 ) )
		equipment:SetText( "" )
		equipment:Dock( TOP )
		equipment:DockMargin( 5, -5, 5, 5 )
		equipment.Blur = 1
		equipment.MaxBlur = 2
		equipment.TargBlur = 1
		equipment.Alpha = 80
		equipment.MaxAlpha = 255
		equipment.TargAlpha = equipment.Alpha
		equipment:SetToolTip( v.desc )

		local tick = Material( "icon16/tick.png", "noclamp smooth" )
		local cross = Material( "icon16/cross.png", "noclamp smooth" )
		equipment.Paint = function( mem, _w, _h )
			draw.BlurredBar( border, border, _w-border*2, _h-border*2, mem.Blur, Color( 44, 44, 44, mem.Alpha )   )

			local font = ScrW() < 1500 and "HiddenHUDSSS" or "HiddenHUDSS"
			surface.SetFont( font )
			local xsz, ysz = surface.GetTextSize( k )
			draw.GlowingText( k, font, _w/2 - xsz/2, _h/2 - ysz/2, unpack( blue_glow ) )

			local sz = ( _h-12 ) 
			surface.SetDrawColor( Color( 88, 88, 88, 255 ) )
			surface.DrawOutlinedRect( _w - sz - 6, 6, sz, sz ) 

			--surface.SetDrawColor( Color( 44, 44, 44, 255 ) )
			local mat = self.Equipment2.Selected == k and tick or cross
			surface.SetMaterial( mat )
			surface.DrawTexturedRect( _w - sz - 6, 6, sz, sz )
		end

		equipment.Think = function( self )
			if self:Get() == k then
				self.Blur = math.Approach( self.Blur, self.MaxBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.MaxAlpha, 2 )
			else
				self.Blur = math.Approach( self.Blur, self.TargBlur, 0.2 )
				self.Alpha = math.Approach( self.Alpha, self.TargAlpha, 2 )
			end
		end

		equipment.OnCursorEntered = function( self )
			self.TargBlur = self.MaxBlur
			self.TargAlpha = self.MaxAlpha
			surface.PlaySound( "buttons/button22.wav" )
		end
		
		equipment.OnCursorExited = function( self )
			self.TargBlur = 1
			self.TargAlpha = 80
		end 

		equipment.Set = function( num )
			self.Equipment2.Selected = num
		end
	
		equipment.Get = function()
			return self.Equipment2.Selected
		end
	

		equipment.DoClick = function()
			equipment.Set( k )
			net.Start( "SelectEquipment2" )
				net.WriteString( v.name )
			net.SendToServer()
			surface.PlaySound( "buttons/combine_button1.wav" )
		end 

	end
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

end

derma.DefineControl( "hdn_loadout", "Loadout Menu for Humans.", PANEL, "DFrame" )

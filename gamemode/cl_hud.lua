
function draw.Cross( x, y, sz, t )
	surface.DrawRect( x - sz/2, y - t/2, sz, t )
	surface.DrawRect( x - t/2, y - sz/2, t, sz )
end

local hdn_hp = Material( "hud/hdn_hdnhealth", "noclamp smooth" )
local hdn_hp_id = surface.GetTextureID( "hud/hdn_hdnhealth" )
local hdn_stamina = Material( "hud/hdn_staminabar", "noclamp smooth" )
local hdn_stamina_id = surface.GetTextureID( "hud/hdn_staminabar" )
local hdn_stamina_bg = Material( "hud/hdn_staminaBG", "noclamp smooth" )
local hdn_stamina_bg_id = surface.GetTextureID( "hud/hdn_staminaBG" )
local x = 20
local y = 20
local gap = 10
local col = Color( 235, 235, 235, 255 )
local h_colglow = Color( 235, 235, 235, 255 )
local h_colglow2 = Color( 235, 235/2, 235/2, 255 )

local colglow = Color( 235, 235, 235, 255 )
local colglow2 = Color( 235/2, 235/2, 235, 255 )
local colglow3 = Color( 235, 235, 235, 255 )

function DrawLegacyHUD( ply )
	local gm = GAMEMODE
	local hp = ply:Health()
	local maxhp = ply:GetMaxHealth()
	local stamina = ply:GetStamina()
	local maxstamina = gm.Hidden.Stamina
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( hdn_hp )
	local w,h = surface.GetTextureSize( hdn_hp_id )
	w = w*0.9
	h = h*0.9
	surface.DrawTexturedRect( x, ScrH() - y - h*0.8, w, h*0.8 )

	surface.SetFont( "HiddenHUD_Legacy" )
	local xsz,ysz = surface.GetTextSize( hp )
	draw.GlowingText( hp , "HiddenHUD_Legacy", x + w/1.7 -xsz/2, ScrH() - y - h*0.8 + ysz/4.5, col, colglow, colglow3)

	local w2,h2 = surface.GetTextureSize( hdn_stamina_bg_id )
	w2 = w2*0.9
	h2 = h2*0.9
	local stamina_y = ScrH() - y - h*0.8 - h2 - gap 
	surface.SetMaterial( hdn_stamina_bg )
	surface.DrawTexturedRect( x - 5, stamina_y - 5, w2 + 20, h2 + 10 )

	surface.SetMaterial( hdn_stamina )
	render.SetScissorRect( x, stamina_y, x + w2*(stamina/maxstamina), stamina_y + h2, true  ) 
		--surface.DrawRect( 0, 0, ScrW(), ScrH() )
		surface.DrawTexturedRect( x, stamina_y, w2, h2 + 2 )
	render.SetScissorRect( 0, 0, 0, 0, false ) 
end 

local x = 100
local y = 30

local gap = -4
local sz = 48
local c_x = x - sz - gap
local c_y = y + sz/2 + 4
local t = 12
local c_blur = 6 

local h = 5

local out_gap = 5

local _xsz = 81
local total_size = 171

local RoundNames =
{ 
	[ROUND_WAITING] 	= "WAITING",
	[ROUND_PREPARING]	= "PREPARING",
	[ROUND_ACTIVE] 		= "IN PROGRESS",
	[ROUND_ENDED] 		= "POST-ROUND"
}
function GetRoundTranslation()
	return RoundNames[ GAMEMODE:GetRoundState() ] or "UNDEFINED"
end

DrawHud = 
{
	[ TEAM_HUMAN ] = function( ply )

		local gm = GAMEMODE
		local hp = ply:Health() > 999 and "wat" or ply:Health()
		local maxhp = ply:GetMaxHealth()

		surface.SetFont( "HiddenHUD" )
		local xsz, ysz = surface.GetTextSize( hp )
		draw.GlowingText( hp , "HiddenHUD", x, ScrH()-y-ysz, col, colglow, colglow2)

		local _c_blur = c_blur
		if hp/maxhp < 0.40 then
			local pulse =  math.sin( math.rad( CurTime() )*360 ) 
			local add = (pulse/1*3 ) 
			_c_blur =  _c_blur + add
			cross_col = Color( 225*pulse, 225*pulse, 225, 255 )   
		end

	
		for i = 1,_c_blur do
			surface.SetDrawColor( Color( 225*( 1 - i/_c_blur), 225*( 1 - i/_c_blur) , 225, 50*( 1 - i/_c_blur) ) )
			draw.Cross( c_x , ScrH()-c_y , sz+i*2, t+i*2 )
		end
		surface.SetDrawColor( Color( 225, 225, 255, 255 ) )
		draw.Cross( c_x , ScrH()-c_y , sz, t )

		local bar_w = _xsz + sz + gap + c_blur*2 + sz/2
		local energy = 100
		local w = (energy/gm.Hidden.Stamina)*bar_w

		local bar_x = c_x-sz/2 - c_blur

		local stamina_blur = 4
		for i = 1,stamina_blur do
			surface.SetDrawColor( Color( 225*( 1 - i/stamina_blur), 225*( 1 - i/stamina_blur) , 225, 50*( 1 - i/stamina_blur) ) )
			surface.DrawRect( bar_x - i, ScrH() - y + 1 - i , bar_w + i*2, h + i*2 )
		end

		surface.SetDrawColor( Color( 0, 0, 0, 200) )
		surface.DrawRect( bar_x, ScrH() - y + 1 , bar_w, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x + bar_w - 2, ScrH() - y + 1, 2, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x, ScrH() - y + 1 , bar_w, h )

		surface.SetDrawColor( Color( 225, 55, 55, 155) )
		--surface.DrawOutlinedRect( c_x-sz/2 - c_blur - out_gap, ScrH() - y - ysz - out_gap, _w+out_gap*2, ysz + out_gap*2 + h + 2 )

		local text_y = ScrH()-y-ysz
		local round = GetRoundTranslation()
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz2 = surface.GetTextSize( round )
		draw.GlowingText( round, "HiddenHUDSS", bar_x + 4, text_y - ysz2-out_gap, col, colglow, colglow2)

		local time = string.ToMinutesSeconds(gm:GetRoundTime())
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz2 = surface.GetTextSize( time )
		draw.GlowingText( time , "HiddenHUDSS", bar_x + total_size - xsz - 11, text_y-ysz2-out_gap, col, colglow, colglow2)


		local wep = ply:GetActiveWeapon()
		if not IsValid( wep ) then return end
		local clip = wep:Clip1()
		local clipmax = wep.Primary.ClipSize
		if clip <= -1 then return end 
		local ammo = ply:GetAmmoCount( wep.Primary.Ammo )
		local spare_ammo = ammo > 1000 and "Inf" or ammo

		local ammo_display = clip.."/"..clipmax
		surface.SetFont( "HiddenHUD" )
		local xsz3, ysz3 = surface.GetTextSize( ammo_display )
		local diff = bar_w - xsz3
		draw.GlowingText( ammo_display , "HiddenHUD", bar_x + bar_w + 20 + diff/2, text_y, col, colglow, colglow2 )

		surface.SetFont( "HiddenHUDS" )
		local xsz4, ysz4 = surface.GetTextSize( spare_ammo )
		draw.GlowingText( spare_ammo, "HiddenHUDS", bar_x + bar_w + 40 + xsz3 + diff/2 - xsz4/2, text_y, col, colglow, colglow2)

		local stamina_blur = 4
		for i = 1,stamina_blur do
			surface.SetDrawColor( Color( 225*( 1 - i/stamina_blur), 225*( 1 - i/stamina_blur) , 225, 50*( 1 - i/stamina_blur) ) )
			surface.DrawRect( bar_x - i + bar_w + 20, ScrH() - y + 1 - i , bar_w + i*2, h + i*2 )
		end

		surface.SetDrawColor( Color( 0, 0, 0, 200) )
		surface.DrawRect( bar_x + bar_w + 20, ScrH() - y + 1 , bar_w, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		--surface.DrawRect( bar_x + bar_w + 20, ScrH() - y + 1, 2, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x + bar_w + 20, ScrH() - y + 1 , bar_w, h )

	end,

	[ TEAM_HIDDEN ] = function( ply )

		local gm = GAMEMODE

		if gm.Hidden.HUD == "legacy" then
			DrawLegacyHUD( ply )
			return 	
		end

		local hp = ply:Health()
		local maxhp = ply:GetMaxHealth()

		surface.SetFont( "HiddenHUD" )
		local xsz, ysz = surface.GetTextSize( hp )
		draw.GlowingText( hp , "HiddenHUD", x, ScrH()-y-ysz, col, h_colglow, h_colglow2)

		local _c_blur = c_blur
		if hp/maxhp < 0.40 then
			local pulse =  math.sin( math.rad( CurTime() )*360 ) 
			local add = (pulse/1*3 ) 
			_c_blur =  _c_blur + add 
		end

	
		for i = 1,_c_blur do
			surface.SetDrawColor( Color( 225, 225*( 1 - i/_c_blur) , 225*( 1 - i/_c_blur), 50*( 1 - i/_c_blur) ) )
			draw.Cross( c_x , ScrH()-c_y , sz+i*2, t+i*2 )
		end
		surface.SetDrawColor( Color( 225, 225, 255, 255 )  )
		draw.Cross( c_x , ScrH()-c_y , sz, t )

		local bar_w = _xsz + sz + gap + c_blur*2 + sz/2
		local energy = ply:GetInt( "Stamina", 0 )
		local w = (energy/gm.Hidden.Stamina)*bar_w

		local bar_x = c_x-sz/2 - c_blur


		surface.SetDrawColor( Color( 0, 0, 0, 200) )
		surface.DrawRect( bar_x, ScrH() - y + 1 , bar_w, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x + bar_w - 2, ScrH() - y + 1, 2, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x, ScrH() - y + 1 , w, h )

		surface.SetDrawColor( Color( 225, 55, 55, 155) )
		--surface.DrawOutlinedRect( c_x-sz/2 - c_blur - out_gap, ScrH() - y - ysz - out_gap, _w+out_gap*2, ysz + out_gap*2 + h + 2 )

		local round = GetRoundTranslation()
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz2 = surface.GetTextSize( round )
		draw.GlowingText( round, "HiddenHUDSS", bar_x + 4, ScrH()-y-ysz-out_gap-ysz2, col, h_colglow, h_colglow2)

		local time = string.ToMinutesSeconds(gm:GetRoundTime())
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz2 = surface.GetTextSize( time )
		draw.GlowingText( time , "HiddenHUDSS", bar_x + total_size - xsz - 11, ScrH()-y-ysz-out_gap-ysz2, col, h_colglow, h_colglow2)

	end,

	[ TEAM_SPECTATOR ] = function( ply ) 
		local ob = ply:GetObserverTarget()

		if IsValid( ob ) and ob:IsPlayer() then

			local t = ob:Team()
			local nick = ob:Nick() 
			DrawHud[ t ]( ob )

			surface.SetFont( "HiddenHUDSS" )
			local xsz, ysz2 = surface.GetTextSize( nick )
			draw.GlowingText( nick , "HiddenHUDSS", ScrW()/2 - xsz/2, 15, col, h_colglow, h_colglow2)

			return

		end

		local gm = GAMEMODE
		local hp = 0
		local maxhp = ply:GetMaxHealth()

		surface.SetFont( "HiddenHUD" )
		local xsz, ysz = surface.GetTextSize( hp )
		draw.GlowingText( hp , "HiddenHUD", x, ScrH()-y-ysz, col, colglow, colglow2)

		local _c_blur = c_blur
		if hp/maxhp < 0.40 then
			local pulse =  math.sin( math.rad( CurTime() )*360 ) 
			local add = (pulse/1*3 ) 
			_c_blur =  _c_blur + add
			cross_col = Color( 225*pulse, 225*pulse, 225, 255 )   
		end

	
		for i = 1,_c_blur do
			surface.SetDrawColor( Color( 225*( 1 - i/_c_blur), 225*( 1 - i/_c_blur) , 225, 50*( 1 - i/_c_blur) ) )
			draw.Cross( c_x , ScrH()-c_y , sz+i*2, t+i*2 )
		end
		surface.SetDrawColor( Color( 225, 225, 255, 255 ) )
		draw.Cross( c_x , ScrH()-c_y , sz, t )

		local bar_w = _xsz + sz + gap + c_blur*2 + sz/2
		local energy = 100
		local w = (energy/gm.Hidden.Stamina)*bar_w

		local bar_x = c_x-sz/2 - c_blur

		local stamina_blur = 4
		for i = 1,stamina_blur do
			surface.SetDrawColor( Color( 225*( 1 - i/stamina_blur), 225*( 1 - i/stamina_blur) , 225, 50*( 1 - i/stamina_blur) ) )
			surface.DrawRect( bar_x - i, ScrH() - y + 1 - i , bar_w + i*2, h + i*2 )
		end

		surface.SetDrawColor( Color( 0, 0, 0, 200) )
		surface.DrawRect( bar_x, ScrH() - y + 1 , bar_w, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x + bar_w - 2, ScrH() - y + 1, 2, h )

		surface.SetDrawColor( Color( 255, 255, 255, 255) )
		surface.DrawRect( bar_x, ScrH() - y + 1 , bar_w, h )

		surface.SetDrawColor( Color( 225, 55, 55, 155) )
		--surface.DrawOutlinedRect( c_x-sz/2 - c_blur - out_gap, ScrH() - y - ysz - out_gap, _w+out_gap*2, ysz + out_gap*2 + h + 2 )

		local text_y = ScrH()-y-ysz
		local round = GetRoundTranslation()
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz2 = surface.GetTextSize( round )
		draw.GlowingText( round, "HiddenHUDSS", bar_x + 4, text_y - ysz2-out_gap, col, colglow, colglow2)

		local time = string.ToMinutesSeconds(gm:GetRoundTime())
		surface.SetFont( "HiddenHUDSS" )
		local xsz, ysz2 = surface.GetTextSize( time )
		draw.GlowingText( time , "HiddenHUDSS", bar_x + total_size - xsz - 11, text_y-ysz2-out_gap, col, colglow, colglow2)
		
	end,

	[ TEAM_UNASSIGNED ] = function( ply )

	end

}

function GM:HUDPaint()
	local ply = LocalPlayer()
	if not IsValid( ply ) then return end 
	if DrawHud[ ply:Team() ] then
		DrawHud[ ply:Team() ]( ply )
	end
end


function GM:HUDShouldDraw( name )
	
	for k, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudVoiceStatus" } do
	
		if name == v then return false end 
		
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
	
		return false
		
	end
	
	return true
	
end
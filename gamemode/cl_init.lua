
include( 'shared.lua' )
include( 'config.lua' )
include( 'tables.lua' )
include( 'rtv/cl_rtv.lua' )
include( 'vgui/cl_scoreboard.lua' )
include( 'vgui/cl_endround.lua' )
include( 'vgui/cl_hiddenstats.lua' )
include( 'vgui/cl_loadout.lua' )
include( 'vgui/cl_taunt.lua' )
include( 'vgui/cl_helpmenu.lua' )
include( 'cl_screenfx.lua' )
include( 'cl_hud.lua' )
include( 'sh_loadout.lua' )
include( 'default_player.lua' ) 

GM.PlayerData = {}
GM.HiddenStats = { 20, 20, 20 }

surface.CreateFont( "HiddenHUDL", { font = "Trebuchet18", size = 80, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUD", { font = "Trebuchet18", size = 60, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDML", { font = "Trebuchet18", size = 40, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDScoreL", { font = "Trebuchet18", size = 20, weight = 400, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDS", { font = "Trebuchet18", size = 24, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDMS", { font = "Trebuchet18", size = 16, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDSS", { font = "Trebuchet18", size = 14, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDSSS", { font = "Trebuchet18", size = 11, weight = 450, scanlines = true, antialias = true } )
surface.CreateFont( "HiddenHUDSSSS", { font = "Trebuchet18", size = 9, weight = 450, scanlines = true, antialias = true } )

local fontdata = {
	blursize = 2;
	italic = false;
	strikeout = false;
	additive = false;
	outline = false;
	underline = false;
	antialias = true;
};
local header = "glow_text_";
surface.madefonts = surface.madefonts or {};
local made = surface.madefonts;

function draw.GlowingText(text, font, x, y, col, colglow, colglow2, align )
	align = align or TEXT_ALIGN_LEFT
	local bfont1 = header..font;
	local bfont2 = header..font.."2";
	fontdata.font = font;
	if(not made[font]) then
		local _, h = surface.GetTextSize("A");
		fontdata.blursize = 2;
		fontdata.size = h;
		surface.CreateFont(bfont1, fontdata);
		made[font] = true;
		fontdata.blursize = 4;
		fontdata.size = h;
		surface.CreateFont(bfont2, fontdata);
	end

	draw.SimpleText( text, bfont1, x, y, colglow or ColorAlpha(col,150), align )
    draw.SimpleText( text, bfont2, x, y, colglow2 or colglow and ColorAlpha(colglow,50) or ColorAlpha(col, 50), align )
    draw.SimpleText( text, font, x, y, col, align )

end

function draw.AAText( text, font, x, y, color, align )

	if not color then return end

    draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min((color.a or 120),120)), align )
    draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min((color.a or 50),50)), align )
    draw.SimpleText( text, font, x, y, color, align )

end

function draw.BlurredBar( x, y, w, h, b, clr )
	for i = 1,b do
		surface.SetDrawColor( Color( clr.r, clr.g, clr.b, 50*( 1 - i/b ) ) )
		surface.DrawRect( x - i, y-i, w+i*2, h+i*2 )
	end
	surface.SetDrawColor( clr )
	surface.DrawRect( x, y, w, h )
end


local PLY = FindMetaTable( "Player" )

function PLY:GetInt( name, default )
	return GAMEMODE.PlayerData[ name ] or default
end

net.Receive( "SynchInt", function( len )

	local name = net.ReadString()
	local value = net.ReadUInt( 8 )
	
	GAMEMODE.PlayerData[ name ] = value

end )


concommand.Add( "hdn_loadout", function( ply )
	if not ply.LoadOut then
		ply.LoadOut = vgui.Create( "hdn_loadout" )
	else
		ply.LoadOut:SetVisible( true )
		ply.LoadOut:RecreateEquipment()
		--ply.LoadOut = vgui.Create( "hdn_loadout" )
	end
end)

concommand.Add( "hdn_helpmenu", function( ply )
	local HelpMenu = vgui.Create( "hdn_helpmenu" )
end)

function GM:Think()

	BlindThink()
	if LocalPlayer():HiddenVision() then
		self:HiddenVisionThink()
	end

end

function ToggleHiddenVision()
	net.Start( "ToggleHiddenVision" )
	net.SendToServer()

	local ply = LocalPlayer()
	if ply:HiddenVision() then
		surface.PlaySound( "player/hidden/617-aurain01.wav" )
		ply:StartLoopingSound( 1, "player/hidden/617-aurain01.wav" )
	else
		surface.PlaySound( "player/hidden/617-auraout01.wav" )
		ply:StopLoopingSound( 1 )
	end
end

function GM:GetScoreboardIcon( ply )

	if not IsValid(ply) then return false end
	if ply:SteamID() == "STEAM_0:0:41006378" then return "icon16/cog.png" end --Credit where credit is due.
	if ply:IsAdmin() then
		return "icon16/shield.png"
	end
	return "icon16/user.png"
end


function GM:PlayerBindPress( ply, bind )
	if bind == "+menu" then
		ShowTaunts()
	elseif bind == "impulse 100" then
		if ply:IsHidden() and self.Hidden.VisionEnable and ply:Alive() then
			ToggleHiddenVision()
		end
	end
end 

net.Receive( "TellHiddenStats", function()
	GAMEMODE.HiddenStats = net.ReadTable()
end)


local bhstop = 0xFFFF - IN_JUMP
local band = bit.band
function GM:CreateMove( uc )
	local ply = LocalPlayer()
	if not self.Hidden.AllowBhop then
		if ply:WaterLevel() < 3 and ply:Alive() and ply:GetMoveType() == MOVETYPE_WALK then
			if not ply:InVehicle() and ( band(uc:GetButtons(), IN_JUMP) ) > 0 then
				if ply:IsOnGround() and CurTime() < ply:GetNextJump() or not ply:CanJump() then
					uc:SetButtons( band( uc:GetButtons(), bhstop) )
				end
			end
		end
	end
end 
  
ColorMod = {}
ColorMod[ "$pp_colour_addr" ] 			= 0
ColorMod[ "$pp_colour_addg" ] 			= 0
ColorMod[ "$pp_colour_addb" ] 			= 0
ColorMod[ "$pp_colour_brightness" ] 	= 0
ColorMod[ "$pp_colour_contrast" ] 		= 1
ColorMod[ "$pp_colour_colour" ] 		= 1
ColorMod[ "$pp_colour_mulr" ] 			= 1  
ColorMod[ "$pp_colour_mulg" ] 			= 1 
ColorMod[ "$pp_colour_mulb" ] 			= 1 

GM.ViewDist = 0
GM.HitPos = Vector(0,0,0) 
 
Contrast = 0.9
Colour = 1 
ModDelay = 0
 
function GM:RenderScreenspaceEffects()
	
	self:DoTrace()
	local ply = LocalPlayer()
	local ob = ply:GetObserverTarget()
	if IsValid( ob ) and ob:IsPlayer() then
		ply = ob 
	end
	if ply:IsHidden() then
		self:DrawHiddenScreen( ply )
	else
		self:DrawHumanScreen( ply )
	end

	if Blind == true then
		DrawMotionBlur( BlindIntensity, 1, 0 )
	end
 
end
   
local mat = Material( "hud/hvision", "noclamp smooth" )
function GM:DrawHiddenScreen( ply )


	if CurTime() > ModDelay then
		if ply:HiddenVision() then
			Contrast = math.Approach( Contrast, 0.8, 0.015 )
			Colour = math.Approach( Colour, 0.0, 0.05 )
		else
			Contrast = math.Approach( Contrast, 0.9, 0.02 )
			Colour = math.Approach( Colour, 1, 0.03 )
		end
		ModDelay = CurTime() + 0.03
	end

	ColorMod[ "$pp_colour_addr" ]		= .09  
	ColorMod[ "$pp_colour_addg" ]		= .03
	ColorMod[ "$pp_colour_contrast" ] 	= Contrast
	ColorMod[ "$pp_colour_colour" ] 	= Colour
	DrawColorModify( ColorMod )
	ColorMod[ "$pp_colour_addr" ] 			= 0
	ColorMod[ "$pp_colour_addg" ] 			= 0
	ColorMod[ "$pp_colour_addb" ] 			= 0

	render.UpdateScreenEffectTexture()
	render.SetMaterial( mat )
	if surface.GetTextureID( "hud/hvision") then
		render.DrawScreenQuad()
	end
end 

function GM:DrawHumanScreen( ply )
	if CurTime() > ModDelay then
		if ply:Alive() then
			Colour = math.Approach( Colour, 1*(ply:Health()/ply:GetMaxHealth()), 0.04 )
		else
			Colour = math.Approach( Colour, 0.5, 0.04 )
		end
		ModDelay = CurTime() + 0.03
	end

	ColorMod[ "$pp_colour_addb" ]		= .04
	ColorMod[ "$pp_colour_addg" ]		= .01
	ColorMod[ "$pp_colour_contrast" ] 	= 0.9
	ColorMod[ "$pp_colour_colour" ] 	= Colour
	DrawColorModify( ColorMod )
	ColorMod[ "$pp_colour_addr" ] 			= 0
	ColorMod[ "$pp_colour_addg" ] 			= 0
	ColorMod[ "$pp_colour_addb" ] 			= 0
end 

function GM:DoTrace()

	local lp = LocalPlayer()
	
	if IsValid( lp ) then
	
		if lp:GetObserverMode() > OBS_MODE_NONE and lp:GetObserverMode() != OBS_MODE_ROAMING then
		
			self.TargetEnt = lp:GetObserverTarget()
			self.ViewDist = 0
			
			if IsValid( self.TargetEnt ) then
			
				self.HitPos = self.TargetEnt:GetPos()
				
			end
			
			return
			
		end
	
		local dir = ( lp:EyeAngles() + lp:GetPunchAngle() ):Forward()
		
		local trace = {}
		trace.start = lp:GetShootPos()
		trace.endpos = trace.start + dir * 9000
		trace.filter = { lp, lp:GetActiveWeapon() } 
		trace.mask = MASK_SHOT
		
		local tr = util.TraceLine( trace )
			
		self.ViewDist = tr.HitPos:Distance( EyePos() )
		self.HitPos = tr.HitPos
		self.TargetEnt = tr.Entity
		
	end

end
 
function GM:PreDrawHalos()

	if not IsValid( self.TargetEnt ) then return end

	local ply = LocalPlayer()
	if not ply:Alive() or ply:GetObserverMode() == OBS_MODE_ROAMING then return end

	local dist = math.Clamp( self.ViewDist or 0, 0, 800 )
	local scale = 1 - ( dist / 800 ) 

	if self.TargetEnt:IsPlayer() and self.TargetEnt:Team() == TEAM_HUMAN then
	
		local hp = math.Clamp( self.TargetEnt:Health(), 1, 100 )
		local sc = hp / 100
		
		halo.Add( { self.TargetEnt, self.TargetEnt:GetActiveWeapon() }, Color( 255 * ( 1 - sc ), 255 * sc, 100 * sc, 255 * scale ), 2 * scale, 2 * scale, 1, 1, false )

	elseif self.TargetEnt:GetClass() == "prop_ragdoll" then
		
		halo.Add( {self.TargetEnt}, Color( 255, 0, 0, 255 * scale ), 2 * scale, 2 * scale, 1, 1, false )
		
	end

end

function BlindLogic()
	local tbl = net.ReadTable()
	local duration = tbl[ 1 ]
	local intensity = tbl[ 2 ]
	local ply = LocalPlayer()
	Blind = true
	BlindDuration = CurTime()+duration
	BlindFade = BlindDuration+3
	BlindStart = CurTime()
	BlindIntensity = 1 - intensity
	BlindOriginalIntensity = 1 - intensity
	BlindUpdate = CurTime()
end

net.Receive( "Blind", BlindLogic )

function BlindThink()
	if Blind == true then
		if CurTime() > BlindDuration and CurTime() > BlindUpdate then

			local delay = 0.1
			local amount_to_increase = 1 - BlindOriginalIntensity 
			local add = (amount_to_increase/3)*delay 

			BlindIntensity = BlindIntensity + add

			print( add )

			BlindUpdate = CurTime() + delay
		end
		if CurTime() >= BlindFade then
			Blind = false
		end
	end
end

VisionSmokeDelay = 0
AuraSoundDelay = 0
function GM:HiddenVisionThink()
	if CurTime() > VisionSmokeDelay then
		if self.Hidden.VisionHasRange then
			for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
				if v:GetPos():Distance( LocalPlayer():GetPos() ) < self.Hidden.VisionRange and v:Alive() then
					local effect = EffectData()
					effect:SetOrigin( v:GetPos() )
					effect:SetEntity( v )
					util.Effect( "HDN_Vision", effect )
				end
			end
		else
			for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
				if v:Alive() then
					local effect = EffectData()
					effect:SetOrigin( v:GetPos() )
					effect:SetEntity( v )
					util.Effect( "HDN_Vision", effect )
				end
			end
		end
		VisionSmokeDelay = CurTime() + 0.05
	end
end

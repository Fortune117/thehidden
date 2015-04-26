DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

function PLAYER:GetHandsModel()

	return { model = "models/weapons/c_arms_combine.mdl", skin = 1, body = "0100000" }

end

player_manager.RegisterClass( "player_combine", PLAYER, "player_default" )
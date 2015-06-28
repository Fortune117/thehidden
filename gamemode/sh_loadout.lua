

local PLY = FindMetaTable( "Player" )

function PLY:HasEquipment( name )
	if self:IsHidden() then return false end
	if SERVER then
		if not self.Equipment then return false end 
		if self.Equipment[ 1 ] == name or self.Equipment[ 2 ] == name then
			return true
		end
	else
		if self:GetNWString( "Equipment1", "nah" ) == name || self:GetNWString( "Equipment2", "nah" ) == name then
			return true
		end
	end
	return false
end

LDT = {}
LDT.Weapons = 
{
	"weapon_hdn_ak47",
	"weapon_hdn_m3",
	"weapon_hdn_m16",
	"weapon_hdn_mp5",
	"weapon_hdn_ump",
	"weapon_hdn_sg550",
	"weapon_hdn_p90"
}


local Laser_Mat = Material( "sprites/laserglow1" )

 
LDT.Equipment = 
{
	["Heavy Armor"] = { name = "HeavyArmor", desc = "Increased durability at the cost of movespeed.", hooks = {"EntityTakeDamage", "HDN_MoveSpeed"}, funcs = { function( ply, dmginfo )
		if IsValid( ply ) and ply:IsPlayer() and not ply:IsHidden() then
			if ply:HasEquipment( "HeavyArmor" ) then
				dmginfo:ScaleDamage( 0.7 )
				print( "HEAVY ARMOR: "..dmginfo:GetDamage() )
			end
		end
	end,
	function( ply ) 
		if IsValid( ply ) and ply:HasEquipment( "HeavyArmor" ) then
			return 0.8
		end
	end } },

	["Stim Pack"] = { name = "Stimpack", desc = "Heal yourself for a small amount, or an ally for a moderate amount. Has to recharge with each use.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "Stimpack" ) then
				ply:Give( "weapon_hdn_stimpack" )
			end
		end
	end },

	["Light Armor"] = { name = "LightArmor", desc = "A thinner armor that allows for more mobility.", hooks = {"EntityTakeDamage", "HDN_MoveSpeed"}, funcs = { function( ply, dmginfo )
		if IsValid( ply ) and ply:IsPlayer() and not ply:IsHidden() then
			if ply:HasEquipment( "LightArmor" ) then
				dmginfo:ScaleDamage( 1.15 )
			end
		end
	end,
	function( ply ) 
		if IsValid( ply ) and ply:HasEquipment( "LightArmor" ) then
			return 1.25
		end
	end } },

	["Trip Mine"] = { name = "Mine", desc = "A single high damage mine; deals 50 damage if triggered.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "Mine" ) then
				ply:Give( "weapon_hdn_mines" )
			end
		end
	end },

	["Sonic Alarms"] = { name = "SMines", desc = "A set of four mines that emit a noise when the Hidden passes through.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "SMines" ) then
				ply:Give( "weapon_hdn_smines" )
			end
		end
	end },

	["Disintegrator Mine"] = { name = "Laser", desc = "An explosive device used to dispose of corpses. Does minor blast damage.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "Laser" ) then
				ply:Give( "weapon_hdn_laser" )
			end
		end
	end }
}

LDT.Equipment2 = 
{
	["P228 Sidearm"] = { name = "p228", desc = "A low calibur pistol with a large clip. Has infinite ammo.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "p228" ) then
				ply:Give( "weapon_hdn_p228" )
			end
		end
	end },

	["Desert Eagle Sidearm"] = { name = "Deagle", desc = "A very powerful pistol, packing a hard hitting punch but at the cost of its clipsize. Comes with three clips.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "Deagle" ) then
				ply:Give( "weapon_hdn_deagle" )
			end
		end
	end },

	["Tranquilizer"] = { name = "Tranq", desc = "Used to knock out large beasts, blurs the Hiddens vision for "..GM.TranqBlindDuration.." seconds. Has 18 darts.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "Tranq" ) then
				ply:Give( "weapon_hdn_tranq" )
			end
		end
	end },

	["Experimental Regenerator"] = { name = "Regen", desc = "Recover 3hp every 2 second.", hooks = "Think", funcs =  function(  )
		if CLIENT then return end
		for k,ply in pairs( player.GetAll() ) do
			if IsValid( ply ) then
				if ply:HasEquipment( "Regen" ) then
					if not ply.RegenDelay then
						ply.RegenDelay = CurTime()-1
					end
					if ply:Health() < ply:GetMaxHealth() then
						if CurTime() > ply.RegenDelay then
							ply:Heal( 3 )
							ply.RegenDelay = CurTime() + 2
						end
					end 
				end
			end
		end
	end },	
	["Laser Sight"] = { name = "Laser", desc = "Gives you a laser sight. Improves accuracy and recoil control.", hooks = { "PostDrawOpaqueRenderables", "HDN_RecoilCallback" }, funcs =  { function( ) 
		for k,ply in pairs( player.GetAll() ) do
			if ply:HasEquipment( "Laser" ) and ply:Alive() then
				local wep = ply:GetActiveWeapon()
				if not IsValid( wep ) then continue end 
				if table.HasValue( GAMEMODE.LaserSightBlackList,  wep:GetClass() ) then continue end 
				local tr = util.QuickTrace( ply:GetShootPos(), ply:GetAimVector()*9000, {ply} )
				local sz = math.random( 16, 18 )
				render.SetMaterial( Laser_Mat )
				render.DrawSprite(  tr.HitPos - ply:GetAimVector(), sz, sz, Color( 255, 255, 255, 255 ) )
			end
		end
	end,
	function( ply )
		if ply:HasEquipment( "Laser" ) then
			return 0.7
		end
	end  } },

	["Ammo Bags"] = { name = "ABox", desc = "Player starts with three extra ammo packs. Left click to throw the pack on the ground. E to pick up.", hooks = "HDN_PlayerLoadoutApply", funcs =  function( ply )
		if IsValid( ply ) then
			if ply:HasEquipment( "ABox" ) then
				ply:Give( "weapon_hdn_ammobox" )
			end
		end 
	end }
} 
 
for k,v in pairs( LDT.Equipment ) do 
	if istable( v.hooks ) then 
		for i = 1,#v.hooks do
			hook.Add( v.hooks[ i ], v.name, v.funcs[ i ] )
		end
	else
		hook.Add( v.hooks, v.name, v.funcs )
	end
end

for k,v in pairs( LDT.Equipment2 ) do
	if istable( v.hooks ) then
		for i = 1,#v.hooks do
			hook.Add( v.hooks[ i ], v.name, v.funcs[ i ] )
		end
	else
		hook.Add( v.hooks, v.name, v.funcs )
	end
end


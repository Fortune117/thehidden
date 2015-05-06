
GM.HiddenPainSounds = 
{
	"player/hidden/voice/617-303pain01.mp3",
	"player/hidden/voice/617-303pain02.mp3",
	"player/hidden/voice/617-303pain03.mp3",
	"player/hidden/voice/617-303pain04.mp3",
	"player/hidden/voice/617-303pain05.mp3",
	"player/hidden/voice/617-303pain06.mp3",
	"player/hidden/voice/617-303pain07.mp3",
	"player/hidden/voice/617-303pain08.mp3"
}

GM.HiddenDeathSounds =
{
	"player/hidden/voice/617-death01.mp3",
	"player/hidden/voice/617-death02.mp3",
	"player/hidden/voice/617-death03.mp3"
}

local PainSounds = 
{
	"npc/metropolice/pain1.wav",
	"npc/metropolice/pain2.wav",
	"npc/metropolice/pain3.wav", 
	"npc/metropolice/pain4.wav"
}

local DeathSounds =
{
	"npc/metropolice/die1.wav",
	"npc/metropolice/die2.wav",
	"npc/metropolice/die3.wav",
	"npc/metropolice/die4.wav"
}

local Questions = 
{
	"npc/metropolice/vo/anyonepickup647e.wav",
	"npc/metropolice/vo/confirmpriority1sighted.wav",
	"npc/metropolice/vo/needanyhelpwiththisone.wav",
	"npc/metropolice/vo/cprequestsallunitsreportin.wav"
}

local IdleRadio =
{
	"npc/metropolice/vo/acquiringonvisual.wav",
	"npc/metropolice/vo/allunitsbol34sat.wav",
	"npc/metropolice/vo/allunitscode2.wav",
	"npc/metropolice/vo/allunitsreportlocationsuspect.wav",
	"npc/metropolice/vo/assaultpointsecureadvance.wav",
	"npc/metropolice/vo/checkformiscount.wav",
	"npc/metropolice/vo/chuckle.wav",
	"npc/metropolice/vo/controlsection.wav",
	"npc/metropolice/vo/converging.wav",
	"npc/metropolice/vo/covermegoingin.wav",
	"npc/metropolice/vo/cpbolforthat243.wav",
	"npc/metropolice/vo/dispupdatingapb.wav",
	"npc/metropolice/vo/get11-44inboundcleaningup.wav",
	"npc/metropolice/vo/goingtotakealook.wav",
	"npc/metropolice/vo/highpriorityregion.wav",
	"npc/metropolice/vo/inposition.wav",
	"npc/metropolice/vo/ivegot408hereatlocation.wav",
	"npc/metropolice/vo/non-taggedviromeshere.wav",
	"npc/metropolice/vo/novisualonupi.wav",
	"npc/metropolice/vo/possible404here.wav",
	"npc/metropolice/vo/reportsightingsaccomplices.wav",
	"npc/metropolice/vo/searchingforsuspect.wav",
	"npc/metropolice/vo/teaminpositionadvance.wav",
	"npc/metropolice/vo/wearesociostablethislocation.wav"

}


local deathreplies = 
{
	"npc/metropolice/vo/11-99officerneedsassistance.wav",
	"npc/metropolice/vo/cpisoverrunwehavenocontainment.wav",
	"npc/metropolice/vo/cpiscompromised.wav",
	"npc/metropolice/vo/dispatchineed10-78.wav",
	"npc/metropolice/vo/help.wav",
	"npc/metropolice/vo/officerdowncode3tomy10-20.wav",
	"npc/metropolice/vo/officerdowniam10-99.wav",
	"npc/metropolice/vo/officerneedsassistance.wav",
	"npc/metropolice/vo/officerneedshelp.wav",
	"npc/metropolice/vo/shit.wav"
}

local questionreplies =
{
	"npc/metropolice/vo/affirmative.wav",
	"npc/metropolice/vo/affirmative2.wav",
	"npc/metropolice/vo/confirmadw.wav",
	"npc/metropolice/vo/copy.wav"
}

local painreplies = 
{
	"npc/metropolice/vo/officerneedsassistance.wav",
	"npc/metropolice/vo/officerneedshelp.wav",
	"npc/metropolice/vo/shit.wav"
}

local idlereplies =
{
	"npc/metropolice/vo/affirmative.wav",
	"npc/metropolice/vo/affirmative2.wav",
	"npc/metropolice/vo/copy.wav",
	"npc/metropolice/vo/converging.wav"
}

local Victory =  
{
	"npc/combine_soldier/vo/onecontained.wav",
	"npc/combine_soldier/vo/onedown.wav",
	"npc/combine_soldier/vo/overwatchconfirmhvtcontained.wav",
	"npc/combine_soldier/vo/overwatchtarget1sterilized.wav",
	"npc/combine_soldier/vo/overwatchtargetcontained.wav",
	"npc/combine_soldier/vo/payback.wav",
	"npc/combine_soldier/vo/contained.wav",
	"npc/metropolice/vo/protectioncomplete.wav",
	"npc/combine_soldier/vo/cleaned.wav",
	"npc/combine_soldier/vo/affirmativewegothimnow.wav"
}

GM.Chatter = 
{
	[ VO_DEATH ] = DeathSounds,
	[ VO_PAIN ] = PainSounds,
	[ VO_QUESTION ] = Questions,
	[ VO_VICTORY ] = Victory,
	[ VO_IDLE ] = IdleRadio
}

GM.Replies = 
{
	[ VO_DEATH ] = deathreplies,
	[ VO_PAIN ] = painreplies,
	[ VO_QUESTION ] = questionreplies,
	[ VO_IDLE ] = idlereplies
}

GM.LargeBodyParts = 
{
	Model( "models/gibs/fast_zombie_torso.mdl" ),
	Model( "models/humans/charple02.mdl" ),
	Model( "models/humans/charple03.mdl" ),
	Model( "models/humans/charple04.mdl" )
}

GM.MediumBodyParts =
{
	Model( "models/gibs/HGIBS.mdl" ),
	Model( "models/weapons/w_bugbait.mdl" ),
	Model( "models/gibs/antlion_gib_medium_1.mdl" ),
	Model( "models/gibs/antlion_gib_medium_2.mdl" ),
	Model( "models/gibs/shield_scanner_gib5.mdl" ),
	Model( "models/gibs/shield_scanner_gib6.mdl" ),
	Model( "models/props_junk/shoe001a.mdl" ),
	Model( "models/props_junk/rock001a.mdl" ),
	Model( "models/props_combine/breenbust_chunk03.mdl" ),
	Model( "models/props_debris/concrete_chunk03a.mdl" ),
	Model( "models/props_debris/concrete_spawnchunk001g.mdl" ),
	Model( "models/props_debris/concrete_spawnchunk001k.mdl" ),
	Model( "models/props_wasteland/prison_sinkchunk001c.mdl" ),
	Model( "models/props_wasteland/prison_toiletchunk01j.mdl" ),
	Model( "models/props_wasteland/prison_toiletchunk01k.mdl" ),
	Model( "models/props_junk/watermelon01_chunk01b.mdl" ),
	Model( "models/props/cs_italy/bananna.mdl" ) 
}

GM.SmallBodyParts =
{
	Model( "models/gibs/HGIBS_scapula.mdl" ),
	Model( "models/gibs/HGIBS_spine.mdl" ),
	Model( "models/props_phx/misc/potato.mdl" ),
	Model( "models/gibs/antlion_gib_small_1.mdl" ),
	Model( "models/gibs/antlion_gib_small_2.mdl" ),
	Model( "models/gibs/shield_scanner_gib1.mdl" ),
	Model( "models/props_debris/concrete_chunk04a.mdl" ),
	Model( "models/props_debris/concrete_chunk05g.mdl" ),
	Model( "models/props_wasteland/prison_sinkchunk001h.mdl" ),
	Model( "models/props_wasteland/prison_toiletchunk01f.mdl" ),
	Model( "models/props_wasteland/prison_toiletchunk01i.mdl" ),
	Model( "models/props_wasteland/prison_toiletchunk01l.mdl" ),
	Model( "models/props_combine/breenbust_chunk02.mdl" ),
	Model( "models/props_combine/breenbust_chunk04.mdl" ),
	Model( "models/props_combine/breenbust_chunk05.mdl" ),
	Model( "models/props_combine/breenbust_chunk06.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02a.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02b.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02c.mdl" ),
	Model( "models/props/cs_office/computer_mouse.mdl" ),
	Model( "models/props/cs_italy/banannagib1.mdl" ),
	Model( "models/props/cs_italy/banannagib2.mdl" ),
	Model( "models/props/cs_italy/orangegib1.mdl" ),
	Model( "models/props/cs_italy/orangegib2.mdl" )
}
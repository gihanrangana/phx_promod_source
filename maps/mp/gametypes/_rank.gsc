#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.scoreInfo = [];
	level.rankTable = [];
	level.scoreMP = 20;
	
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"MP_PLUS" );
	
	registerScoreInfo("kill", 5);
    registerScoreInfo("headshot", 5);
    registerScoreInfo("assist", 3);
    registerScoreInfo("suicide", 0);
    registerScoreInfo("teamkill", 0);
    registerScoreInfo("win", 2);
    registerScoreInfo("loss", 1);
    registerScoreInfo("tie", 1.5);
    registerScoreInfo("plant", 3);
    registerScoreInfo("defuse", 3);
    registerScoreInfo("capture", 3);
    registerScoreInfo("assault", 3);
    registerScoreInfo("assault_assist", 1);
    registerScoreInfo("defend", 3);
    registerScoreInfo("defend_assist", 1);
    registerScoreInfo("defend", 3);
    registerScoreInfo("defend_assist", 1);
    registerScoreInfo("kill_denied", 5);
    registerScoreInfo("gottags", 10);
    registerScoreInfo("kill_confirmed", 5);
    registerScoreInfo("headshot_splash", 5);
    registerScoreInfo("execution", 5);
    registerScoreInfo("avenger", 5);
    registerScoreInfo("defender", 5);
    registerScoreInfo("posthumous", 3);
    registerScoreInfo("revenge", 5);
    registerScoreInfo("double", 5);
    registerScoreInfo("triple", 5);
    registerScoreInfo("multi", 10);
    registerScoreInfo("buzzkill", 5);
    registerScoreInfo("firstblood", 10);
    registerScoreInfo("comeback", 5);
    registerScoreInfo("longshot", 5);
    registerScoreInfo("assistedsuicide", 5);
    registerScoreInfo("wallbang", 5);
    registerScoreInfo("neardeath", 5);
    registerScoreInfo("king_slayer", 5);
    registerScoreInfo("bloodthirsty", 10);
    registerScoreInfo("fieldorders", 10);
    registerScoreInfo("tags_retrieved", 10);
    registerScoreInfo("one_shot_kill", 5);
    registerScoreInfo("merciless", 10);
    registerScoreInfo("pointblank", 5);

	level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
	
	pId = 0;
	rId = 0;
	for ( pId = 0; pId <= level.maxPrestige; pId++ )
	{
		for ( rId = 0; rId <= level.maxRank; rId++ )
			precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
	}
	
	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
		
	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );
		precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );
		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );		
	}
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player.pers["rankxp"] = player maps\mp\gametypes\_persistence::statGet( "rankxp" );
		if(!isDefined(player.pers["rankxp"]))
			player.pers["rankxp"] = 0;
			
		rankId = player getRankForXp( player getRankXP() );
		player.pers["rank"] = rankId;
		player.pers["participation"] = 0;
		player.doingNotify = false;
		player.rankUpdateTotal = 0;
		player.cur_rankNum = rankId;
		assertex( isdefined(player.cur_rankNum), "rank: "+ rankId + " does not have an index, check mp/ranktable.csv" );
		player setStat( 251, player.cur_rankNum );
		
		prestige = player maps\mp\gametypes\_persistence::statGet( "plevel" );
		player setRank( rankId, prestige );
		player.pers["prestige"] = prestige;
		sprestige = player getstat(3251);
		player.pers["sprestige"] = sprestige;
		
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}

updateRankStats( player, rankId )
{
	player setStat( 253, rankId );
	player setStat( 255, player.pers["prestige"] );
	player maps\mp\gametypes\_persistence::statSet( "rank", rankId );
	player maps\mp\gametypes\_persistence::statSet( "minxp", getRankInfoMinXp( rankId ) );
	player maps\mp\gametypes\_persistence::statSet( "maxxp", getRankInfoMaxXp( rankId ) );
	player maps\mp\gametypes\_persistence::statSet( "plevel", player.pers["prestige"] );
	
	if( rankId > level.maxRank )
		player setStat( 252, level.maxRank );
	else
		player setStat( 252, rankId );
}

onJoinedTeam()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("joined_team");
		self thread removeRankHUD();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeRankHUD();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		if(!isdefined(self.hud_rankscroreupdate))
		{
			self.hud_rankscroreupdate = newClientHudElem(self);
			self.hud_rankscroreupdate.horzAlign = "center";
			self.hud_rankscroreupdate.vertAlign = "middle";
			self.hud_rankscroreupdate.alignX = "center";
			self.hud_rankscroreupdate.alignY = "middle";
			self.hud_rankscroreupdate.x = 0;
			self.hud_rankscroreupdate.y = -60;
			self.hud_rankscroreupdate.font = "default";
			self.hud_rankscroreupdate.fontscale = 2;
			self.hud_rankscroreupdate.archived = false;
			self.hud_rankscroreupdate.color = (0.5,0.5,0.5);
			self.hud_rankscroreupdate maps\mp\gametypes\_hud::fontPulseInit();
		}
	}
}

roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

giveRankXP( type, value )
{
	self endon("disconnect");

	if( level.teamBased && (!level.playerCount["allies"] || !level.playerCount["axis"]) )
		return;	
	else if ( !level.teamBased && (level.playerCount["allies"] + level.playerCount["axis"] < 2) )
		return;

	if( !isDefined( value ) )
		value = int(getScoreInfoValue( type ));

	self incRankXP( value * level.scoreMP );

	if ( getDvarInt( "scr_enable_scoretext" ) )
		self thread updateRankScoreHUD( value );
	
	if ( updateRank() )
		self thread updateRankAnnounceHUD();
}

resetEverything()
{
    self endon("disconnect");
	
	self.pers["prestige"] = 0;
	self.pers["rank"] = 0;
	self.pers["rankxp"] = 0;
	self.pets["score"] = 0;
	
	self setRank( self.pers["rank"], self.pers["prestige"] );
	self setStat( 2326, self.pers["prestige"] );
	self setStat( 2350, self.pers["rank"] );
	self setStat( 2301, self.pers["rankxp"] );
	self setStat( 2302, self.pers["score"] );

	for( stat = 190; stat < 280; stat++ )
	{
		self setStat( stat, 0 );
		wait 0.05;
	}
	for( stat = 975; stat < 990; stat++ )
	{
		self setStat( stat, 0 );
		wait 0.05;
	}
}

prfix()
{
	self endon("disconnect");
	self.pers["rank"] = 0;
	self.pers["rankxp"] = 0;
	self setRank( self.pers["rank"], self.pers["prestige"] );
	self setStat( 2350, self.pers["rank"] );
	self setStat( 2301, self.pers["rankxp"] );
	for( stat = 190; stat < 280; stat++ )
	{
		self setStat( stat, 0 );
		wait 0.05;
	}
}

updateRankScoreHUD( amount )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	if (!isDefined(amount) || !amount )
		return;
	
	self notify( "update_score" );
	self endon( "update_score" );
	self.rankUpdateTotal += amount;
	wait 0.05;
	
	if( isDefined( self.hud_rankscroreupdate ) )
	{
		if ( self.rankUpdateTotal < 0 )
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (1,0,0);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1,1,1);
		}
		self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );
		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 1;
		blinkTheHud();
		self.hud_rankscroreupdate fadeIt(0.1,0);
		wait 0.1;
		self.rankUpdateTotal = 0;	
	}
}

blinkTheHud()
{
	self endon( "update_score" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	wait 0.8;
	for(i = 0;i < 3; i++)
	{
		self.hud_rankscroreupdate fadeIt(0.1,0.1);
		self.hud_rankscroreupdate fadeIt(0.1,1);
	}
}

fadeIt(time,alpha)
{
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

removeRankHUD()
{
	if(isDefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
}

getRank()
{	
	rankXp = self.pers["rankxp"];
	rankId = self.pers["rank"];
	
	if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
		return rankId;
	else
		return self getRankForXp( rankXp );
}

getRankForXp( xpVal )
{
	rankId = 0;
	rankName = level.rankTable[rankId][1];
	assert( isDefined( rankName ) );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
			return rankId;

		rankId++;
		if ( isDefined( level.rankTable[rankId] ) )
			rankName = level.rankTable[rankId][1];
		else
			rankName = undefined;
	}
	rankId--;
	return rankId;
}

getRankXP()
{
	return self.pers["rankxp"];
}

incRankXP( amount )
{	
	self endon("disconnect");
	if(isPlayer(self))
	{
		xp = self getRankXP();
		newXp = (xp + amount);
	
		if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
			newXp = getRankInfoMaxXP( level.maxRank );
	
		self.pers["rankxp"] = newXp;
		self maps\mp\gametypes\_persistence::statSet( "rankxp", newXp );
		self setStat( 251, self getRank() );
		self setStat( 252, self getRank() );
	}
}

registerScoreInfo( type, value )
{
	level.scoreInfo[type]["value"] = value;
}

getScoreInfoValue( type )
{
	return level.scoreInfo[type]["value"];
}

getRankInfoMinXP( rankId )
{
	return int(level.rankTable[rankId][2]);
}

getRankInfoXPAmt( rankId )
{
	return int(level.rankTable[rankId][3]);
}

getRankInfoMaxXp( rankId )
{
	return int(level.rankTable[rankId][7]);
}

getRankInfoIcon( rankId, prestigeId )
{
	return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}

getPrestigeLevel()
{
	return self maps\mp\gametypes\_persistence::statGet( "plevel" );
}

canPrestigeUp()
{
	if(!isPlayer(self))
		return false;
	if (self.pers["prestige"] == level.maxPrestige )
		return false;
	if (self getRank() < level.maxRank)
		return false;
	return true;
}

prestigeUp() 
{	
	if(!self canPrestigeUp())
		return;
	
	self.pers["prestige"]+=int(self.pers["rankxp"]/(getRankInfoMaxXp(level.maxRank)-10));
	
	self setStat(2326, self.pers["prestige"]);
	self setStat(210, self.pers["prestige"]);

	self maps\mp\gametypes\_persistence::statSet("rankxp", 0);
	self maps\mp\gametypes\_persistence::statSet("rank", 0);
	self maps\mp\gametypes\_persistence::statSet("minxp", int(level.rankTable[0][2]));
	self maps\mp\gametypes\_persistence::statSet("maxxp", int(level.rankTable[0][7]));
	self setStat(252, 0);
	self setStat(253, 0);
	self.pers["rankxp"] = 0;
	self setRank(0, self.pers["prestige"]);
	
	rankId = self getRankForXp(self getRankXP());
	self.pers["rank"] = rankId;
}

updateRankAnnounceHUD()
{
	self endon("disconnect");
	self notify("update_rank");
	self endon("update_rank");

	team = self.pers["team"];
	if ( !isdefined( team ) )
		return;	
	
	self notify("reset_outcome");
	
	notifyData = spawnStruct();
	notifyData.titleText = &"RANK_PROMOTED";
	notifyData.iconName = self getRankInfoIcon( self.pers["rank"], self.pers["prestige"] );
	notifyData.duration = 2.5;
	thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

updateRank()
{
	newRankId = self getRank();
	if ( newRankId == self.pers["rank"] )
		return false;

	oldRank = self.pers["rank"];
	rankId = self.pers["rank"];
	self.pers["rank"] = newRankId;

	temp = self GetStat(252);
	cur = getRealTime();
	date = TimeToString(cur, 1, "%c");
	thread phoenix\_common::log("level_track", self.name + " ("+self GetGuid()+") " + " entered level: " + temp + " at " + date );
	
	while ( rankId <= newRankId )
	{	
		self maps\mp\gametypes\_persistence::statSet( "rank", rankId );
		self setStat( 252, rankId );
		rankId++;
	}
	self setRank( newRankId );
	return true;
}

isSprayUnlocked( num )
{
	if( num >= level.sprayInfo.size || num <= -1)
	return false;
	if( self.pers["prestige"] >= level.sprayInfo[num]["prestige"] )
	return true;
	return false;
}

isASprayUnlocked( num )
{
	upit = self GetStat(3252);
	if( upit == 5 && ( num >= 1 && num <= 5 ) )
		return true;
	else if( upit == 4 && ( num >= 1 && num <= 4 ) )	
		return true;
	else if( upit == 3 && ( num >= 1 && num <= 3 ) )	
		return true;
	else if( upit == 2 && ( num >= 1 && num <= 2 ) )	
		return true;
	else if( upit == 1 && ( num == 1 ))
		return true;
	else 
		return false;
}

isDSprayUnlocked( num )
{
	dupit = self GetStat(3253);
	if ( dupit == 3 && ( num >= 1 && num <= 3 ))
		return true;
	else if ( dupit == 2 && ( num >= 1 && num <= 2 ))
		return true;
	else if ( dupit == 1 && num == 1)
		return true;
	else 
		return false;
}

isCharacterUnlocked( num )
{
	if( num >= level.characterInfo.size || num <= -1)
		return false;
	if( self.pers["prestige"] >= level.characterInfo[num]["prestige"] )
		return true;
	return false;
}

isACharacterUnlocked( num )
{
	upit = self GetStat(3252);
	if ( upit == 5 && ( num >= 3 && num <= 5 ))
		return true;
	else if ( upit == 4 && ( num >= 3 && num <= 4 ))
		return true;
	else if ( upit == 3 && num == 3)
		return true;
	else return false;
}

isDCharacterUnlocked( num )
{
	dupit = self GetStat(3253);
	if ( dupit == 3 && ( num >= 1 && num <= 3 ))
		return true;
	else if ( dupit == 2 && ( num >= 1 && num <= 2 ))
		return true;
	else if ( dupit == 1 && num == 1)
		return true;
	else return false;
}

// End of game summary/unlock menu page setup
// 0 = no unlocks, 1 = only page one, 2 = only page two, 3 = both pages
unlockPage( in_page )
{
	if( in_page == 1 )
	{
		if( self.pers["unlocks"]["page"] == 0 )
		{
			self setClientDvar( "player_unlock_page", "1" );
			self.pers["unlocks"]["page"] = 1;
		}
		if( self.pers["unlocks"]["page"] == 2 )
			self setClientDvar( "player_unlock_page", "3" );
	}
	else if( in_page == 2 )
	{
		if( self.pers["unlocks"]["page"] == 0 )
		{
			self setClientDvar( "player_unlock_page", "2" );
			self.pers["unlocks"]["page"] = 2;
		}
		if( self.pers["unlocks"]["page"] == 1 )
			self setClientDvar( "player_unlock_page", "3" );	
	}		
}

// unlocks weapon
unlockWeapon( refString )
{
	assert( isDefined( refString ) && refString != "" );
		
	stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );
	
	assertEx( stat > 0, "statsTable refstring " + refString + " has invalid stat number: " + stat );
	
	if( self getStat( stat ) > 0 )
		return;

	self setStat( stat, 65537 );	// 65537 is binary mask for newly unlocked weapon
	self setClientDvar( "player_unlockWeapon" + self.pers["unlocks"]["weapon"], refString );
	self.pers["unlocks"]["weapon"]++;
	self setClientDvar( "player_unlockWeapons", self.pers["unlocks"]["weapon"] );
	
	self unlockPage( 1 );
}

// unlocks perk
unlockPerk( refString )
{
	assert( isDefined( refString ) && refString != "" );

	stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );
	
	if( self getStat( stat ) > 0 )
		return;

	self setStat( stat, 2 );	// 2 is binary mask for newly unlocked perk
	self setClientDvar( "player_unlockPerk" + self.pers["unlocks"]["perk"], refString );
	self.pers["unlocks"]["perk"]++;
	self setClientDvar( "player_unlockPerks", self.pers["unlocks"]["perk"] );
	
	self unlockPage( 2 );
}

// unlocks camo - multiple
unlockCamo( refString )
{
	assert( isDefined( refString ) && refString != "" );

	// tokenize reference string, accepting multiple camo unlocks in one call
	Ref_Tok = strTok( refString, ";" );
	assertex( Ref_Tok.size > 0, "Camo unlock specified in datatable ["+refString+"] is incomplete or empty" );
	
	for( i=0; i<Ref_Tok.size; i++ )
		unlockCamoSingular( Ref_Tok[i] );
}

// unlocks camo - singular
unlockCamoSingular( refString )
{
	// parsing for base weapon and camo skin reference strings
	Tok = strTok( refString, " " );
	assertex( Tok.size == 2, "Camo unlock sepcified in datatable ["+refString+"] is invalid" );
	
	baseWeapon = Tok[0];
	addon = Tok[1];

	weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
	addonMask = int( tableLookup( "mp/attachmenttable.csv", 4, addon, 10 ) );
	
	if ( self getStat( weaponStat ) & addonMask )
		return;
	
	// ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
	setstatto = ( self getStat( weaponStat ) | addonMask ) | (addonMask<<16) | (1<<16);
	self setStat( weaponStat, setstatto );
	
	//fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
	self setClientDvar( "player_unlockCamo" + self.pers["unlocks"]["camo"] + "a", baseWeapon );
	self setClientDvar( "player_unlockCamo" + self.pers["unlocks"]["camo"] + "b", addon );
	self.pers["unlocks"]["camo"]++;
	self setClientDvar( "player_unlockCamos", self.pers["unlocks"]["camo"] );

	self unlockPage( 1 );
}

unlockAttachment( refString )
{
	assert( isDefined( refString ) && refString != "" );

	// tokenize reference string, accepting multiple camo unlocks in one call
	Ref_Tok = strTok( refString, ";" );
	assertex( Ref_Tok.size > 0, "Attachment unlock specified in datatable ["+refString+"] is incomplete or empty" );
	
	for( i=0; i<Ref_Tok.size; i++ )
		unlockAttachmentSingular( Ref_Tok[i] );
}

// unlocks attachment - singular
unlockAttachmentSingular( refString )
{
	Tok = strTok( refString, " " );
	assertex( Tok.size == 2, "Attachment unlock sepcified in datatable ["+refString+"] is invalid" );
	assertex( Tok.size == 2, "Attachment unlock sepcified in datatable ["+refString+"] is invalid" );
	
	baseWeapon = Tok[0];
	addon = Tok[1];

	weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
	addonMask = int( tableLookup( "mp/attachmenttable.csv", 4, addon, 10 ) );
	
	if ( self getStat( weaponStat ) & addonMask )
		return;
	
	// ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
	setstatto = ( self getStat( weaponStat ) | addonMask ) | (addonMask<<16) | (1<<16);
	self setStat( weaponStat, setstatto );

	//fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
	self setClientDvar( "player_unlockAttachment" + self.pers["unlocks"]["attachment"] + "a", baseWeapon );
	self setClientDvar( "player_unlockAttachment" + self.pers["unlocks"]["attachment"] + "b", addon );
	self.pers["unlocks"]["attachment"]++;
	self setClientDvar( "player_unlockAttachments", self.pers["unlocks"]["attachment"] );
	
	self unlockPage( 1 );
}
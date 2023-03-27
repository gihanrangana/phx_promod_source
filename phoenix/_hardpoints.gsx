/*===============================================================================================================================================
|| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -||
||/ .----------------.  .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .----------------. \||
||/| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\||
||/| |   ______     | || |  ____  ____  | || |  _________   | || |     ____     | || | ____  _____  | || |     _____    | || |  ____  ____  | |\||
||/| |  |_   __ \   | || | |_   ||   _| | || | |_   ___  |  | || |   .'    `.   | || ||_   \|_   _| | || |    |_   _|   | || | |_  _||_  _| | |\||
||/| |    | |__) |  | || |   | |__| |   | || |   | |_  \_|  | || |  /  .--.  \  | || |  |   \ | |   | || |      | |     | || |   \ \  / /   | |\||
||/| |    |  ___/   | || |   |  __  |   | || |   |  _|  _   | || |  | |    | |  | || |  | |\ \| |   | || |      | |     | || |    > `' <    | |\||
||/| |   _| |_      | || |  _| |  | |_  | || |  _| |___/ |  | || |  \  `--'  /  | || | _| |_\   |_  | || |     _| |_    | || |  _/ /'`\ \_  | |\||
||/| |  |_____|     | || | |____||____| | || | |_________|  | || |   `.____.'   | || ||_____|\____| | || |    |_____|   | || | |____||____| | |\||
||/| |              | || |              | || |              | || |              | || |              | || |              | || |              | |\||
||/| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\||
||/ '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \||
|| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -||
|| ******************************************************** DEVELOPED BY |PHX| GHOST ********************************************************** ||
=============================================================== Code from Leiizko ==============================================================*/
/*
	ADDING CUSTOM HARDPOINTS
	
	addHardpoint( DVARNAME, NAME, CALLBACK, EXTRAPARAM )
	DVARNAME - Must be set in dvars script and must have _shop suffix ( nuke_shop )
	NAME - Hardpoint full name that will show in notify ( ex: nuke --> Thermonuclear Bomb )
	CALLBACK - callback to hardpoint script entry point ( ex: phoenix\hardpoints\_heli::init() )
	EXTRAPARAM - extra parameter if needed with script callback, maximum 1. Set it to undefined if not needed
	
	Add it starting at line 58!
	
	Full example:
	
	addHardpoint( "nuke", "Thermonuclear Bomb", phoenix\hardpoints\_nuke::init, undefined );
*/

init()
{
	makeShopArray();
	thread phoenix\_events::addConnectEvent( ::onConnected );
	thread phoenix\_events::addSpawnEvent( ::onSpawn );
	thread phoenix\_events::addDeathEvent( ::onDeath );
	
	level.radarPlayer = [];
}

makeShopArray()
{
	level.hardpointShopData = [];
	
	dvarNames = "radar;airstrike;artillery;helicopter;agm;predator;asf;ac130;mannedheli;nuke";
	dvarNames = strTok( dvarNames, ";" );
	
	names = "Radar;Airstrike;Artillery;Helicopter;Hellfire Missile;Predator Drone;Fighter Support;AC130 Gunship;Manned Helicopter;Thermonuclear Bomb";
	names = strTok( names, ";" );
	
	callbacks = [];
	callbacks[ callbacks.size ] = ::trigger;
	callbacks[ callbacks.size ] = ::trigger;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_artillery::selectLocation;
	callbacks[ callbacks.size ] = ::trigger;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_agm::init;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_predator::init;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_asf::init;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_ac130::init;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_heli::init;
	callbacks[ callbacks.size ] = phoenix\hardpoints\_nuke::init;
	
	extras = [];
	extras[ 0 ] = "radar_mp";
	extras[ 1 ] = "airstrike_mp";
	extras[ 3 ] = "helicopter_mp";
	
	for( i = 0; i < dvarNames.size; i++ )
		addHardpoint( dvarNames[ i ], names[ i ], callbacks[ i ], extras[ i ] );
		
	///////////////////////////////////////
	//    YOUR CUSTOM HARDPOINTS HERE    //
	///////////////////////////////////////
	
		
	for( i = 0; i < level.hardpointShopData.size; i++ )
	{
		for( n = 0; n < level.hardpointShopData.size - 1; n++ )
		{
			if( level.hardpointShopData[ n ][ 0 ] > level.hardpointShopData[ n + 1 ][ 0 ] )
			{
				temp = level.hardpointShopData[ n ];
				level.hardpointShopData[ n ] = level.hardpointShopData[ n + 1 ];
				level.hardpointShopData[ n + 1 ] = temp;
			}
		}
	}

	makeLimitArray(dvarNames);
}

makeLimitArray(modNames) {
	
	level.streakLimit = [];
	
	for(i = 0; i < modNames.size; i++){

		if(modNames[ i ] == "airstrike" || modNames[ i ] == "artillery" || modNames[ i ] == "agm")
			level.streakLimit[ i ][ 0 ] = 3; // limitation
		else if(modNames[ i ] == "asf") 
			level.streakLimit[ i ][ 0 ] = 2; // limitation
		else if(modNames[ i ] == "helicopter" || modNames[ i ] == "predator" || modNames[ i ] == "ac130" || modNames[ i ] == "mannedheli" || modNames[ i ] == "nuke" ) 
			level.streakLimit[ i ][ 0 ] = 1; // limitation
		else
			level.streakLimit[ i ][ 0 ] = 0; // limitation
		
	}
	
}

addHardpoint( dvarName, name, callback, extraParam )
{
	d = dvarName + "_shop";
	i = level.hardpointShopData.size;
	
	level.hardpointShopData[ i ][ 0 ] = level.dvar[ d ];
	level.hardpointShopData[ i ][ 1 ] = name;
	level.hardpointShopData[ i ][ 2 ] = callback;
	
	if( isDefined( extraParam ) )
		level.hardpointShopData[ i ][ 3 ] = extraParam;
}

onDeath( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	streak = attacker.cur_kill_streak;
	waittillframeend;

	if( !isDefined( attacker ) || !isDefined( attacker.money ) || sMeansOfDeath == "MOD_FALLING" || level.gameEnded )
		return;

	if( attacker != self )
	{
		if( sMeansOfDeath == "MOD_HEAD_SHOT" )
			attacker.money += 20;
			
		else if( sMeansOfDeath == "MOD_MELEE" )
			attacker.money += 30;
		
		else
			attacker.money += 10;
			
		waittillframeend;
		
		if( streak > 0 && ( streak % 5 ) == 0 )
			attacker thread streakNotify( streak );
		
		if( isDefined( attacker.moneyhud ) )
			attacker.moneyhud setValue( int( attacker.money ) );
		
		// Notify the attacker for killstreaks
		for( i = 0; i < level.hardpointShopData.size; i++ )
		{
			if( attacker.money >= level.hardpointShopData[ i ][ 0 ] && !isDefined( attacker.HnotifyDone[ i ] ) )
			{
				attacker.HnotifyDone[ i ] = true;
				string = "Press [{+actionslot 4}] to buy " + level.hardpointShopData[ i ][ 1 ];

				for( n = i + 1; n < level.hardpointShopData.size; n++ )
				{
					if( level.hardpointShopData[ i ][ 0 ] < level.hardpointShopData[ n ][ 0 ] )
						break;
						
					attacker.HnotifyDone[ n ] = true;
					string += "/" + level.hardpointShopData[ n ][ 1 ];
				}
				
				string += " ($" + level.hardpointShopData[ i ][ 0 ] + ")";
				
				// The string is too long to fit on screen so just leave a generic message
				if( string.size > 80 )
					string = "New items available in shop!";
				
				attacker thread maps\mp\gametypes\_hud_message::oldNotifyMessage( undefined, string, undefined, undefined, undefined, string.size * 0.1 );
			}
			
			else if( attacker.money < level.hardpointShopData[ i ][ 0 ] )
				break;
		}
		
		// Notifying the player about UAV assists may cause too much spam on full server
		if( isDefined( level.radarPlayer[ attacker.team ] ) && level.radarPlayer[ attacker.team ] != attacker )
		{
			level.radarPlayer[ attacker.team ].money++;

			if( isDefined( level.radarPlayer[ attacker.team ].moneyhud ) )
				level.radarPlayer[ attacker.team ].moneyhud setValue( int( level.radarPlayer[ attacker.team ].money ) );
		}
	}
}

streakNotify( streak )
{
	string = "" + streak + " Kill Streak!";
	self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( string, undefined, undefined, undefined, undefined, string.size * 0.15 );
	
	iPrintLn( self.name + " has a killstreak of " + streak + "!" );
}

onConnected()
{
	self.money = 0;
	self.HnotifyDone = [];

	level.shop_hud_width = 260;
	level.shop_hud_height = 200;
	
	dvarNames = "radar;airstrike;artillery;helicopter;agm;predator;asf;ac130;mannedheli;nuke";
	dvarNames = strTok( dvarNames, ";" );

	for(i = 0; i < dvarNames.size; i++)
		self.streakLimit[ i ][ 0 ] = 0; // usage
	
	self thread moneyHud();
}

moneyHud()
{
	self.moneyhud = newClientHudElem( self );
	self.moneyhud.archived = false;
	self.moneyhud.alignX = "right";
	self.moneyhud.alignY = "bottom";
	self.moneyhud.label = &"$ ";
	self.moneyhud.horzAlign = "right";
	self.moneyhud.vertAlign = "bottom";
	self.moneyhud.fontscale = 1.7;
	self.moneyhud.x = -20;
	self.moneyhud.y = -50;
	
	self.moneyhud setValue( int( self.money ) );
}

onSpawn()
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	
	self giveWeapon( "radar_mp" );
	self setWeaponAmmoClip( "radar_mp", 0 );
	self setWeaponAmmoStock( "radar_mp", 0 );
	self setActionSlot( 4, "weapon", "radar_mp" );
	
	for( ;; )
	{				
		self waittill( "weapon_change" );
		
		currentWeapon = self getCurrentWeapon();
		
		if( currentWeapon == "radar_mp" )
		{	
			if( self.pers[ "hardpointSType" ] )
				self SetMoveSpeedScale( 0 );

			self thread shop();
			self thread exitShop();
			self thread shopThink();
			
			self waittill( "destroy_shop" );
			
			if( self.pers[ "hardpointSType" ] )
				self thread restoreMoveSpeed();
			
			wait .1;
			
			if ( self.pers[ "lastWeapon" ] != "none" )
				self switchToWeapon( self.pers[ "lastWeapon" ] );
				
			wait .25;
		}
		
		else
			self.pers[ "lastWeapon" ] = currentWeapon;
	}
}

restoreMoveSpeed()
{
	switch ( self.pers[ "weaponClassPrimary" ] )
	{
		case "rifle":
			self setMoveSpeedScale( 0.95 );
			break;
		case "pistol":
			self setMoveSpeedScale( 1.0 );
			break;
		case "mg":
			self setMoveSpeedScale( 0.875 );
			break;
		case "smg":
			self setMoveSpeedScale( 1.0 );
			break;
		case "spread":
			self setMoveSpeedScale( 1.0 );
			break;
		default:
			self setMoveSpeedScale( 1.0 );
			break;
		}
}

shopThink()
{
	self endon( "destroy_shop" );
	self endon( "disconnect" );
	
	for( ;; )
	{
		if( self attackButtonPressed() )
		{
			self buy();
			self notify( "destroy_shop" );
			break;
		}
		else if ( ( self useButtonPressed() && !self.pers[ "hardpointSType" ] ) || ( self backButtonPressed() && self.pers[ "hardpointSType" ] ) )
		{
			self thread updateHUD( 1 );
			wait .25;
		}
		else if ( ( self meleeButtonPressed() && !self.pers[ "hardpointSType" ] ) || ( self forwardButtonPressed() && self.pers[ "hardpointSType" ] ) )
		{
			self thread updateHUD( 2 );
			wait .25;
		}
		
		wait .05;
	}
}

buy()
{
	self endon( "destroy_shop" );

	for( i = 0; i < self.shop.size; i++ )
	{
		if( isDefined( self.shop[ i ] ) )
			self.shop[ i ].alpha = 0;
	}
	
	if( !isDefined( self.selectionNum ) )
		self.selectionNum = 0;
		
	before = self.money;
	
	if( self.money < level.hardpointShopData[ self.selectionNum ][ 0 ] )
	{
		dif = level.hardpointShopData[ self.selectionNum ][ 0 ] - self.money;
		self iPrintLnBold( "Missing ^1$" + dif + "^7 to buy " + level.hardpointShopData[ self.selectionNum ][ 1 ] );
		return;
	}
	else if( level.streakLimit[ self.selectionNum ][0] > 0 && level.streakLimit[ self.selectionNum ][0] <= self.streakLimit[ self.selectionNum ][0] ){
		self iPrintLnBold( level.hardpointShopData[ self.selectionNum ][1] + " Limit Exceeded  - " + self.streakLimit[ self.selectionNum ][0] + "/" + level.streakLimit[ self.selectionNum ][0] );
		return;
	}
	else
	{
		
		if( isDefined( level.hardpointShopData[ self.selectionNum ][ 3 ] ) )
		{

			result = self [[level.hardpointShopData[ self.selectionNum ][ 2 ]]]( level.hardpointShopData[ self.selectionNum ][ 3 ] );

			if( !isDefined( result ) || !result )
				return;
			else
				self.money -= level.hardpointShopData[ self.selectionNum ][ 0 ];
				self.streakLimit[ self.selectionNum ][ 0 ]++;
		}
		else
		{
			result = self [[level.hardpointShopData[ self.selectionNum ][ 2 ]]]();

			if( !isDefined( result ) || !result )
				return;
			else
				self.money -= level.hardpointShopData[ self.selectionNum ][ 0 ];
				self.streakLimit[ self.selectionNum ][ 0 ]++;
		}

		self iPrintLnBold( level.hardpointShopData[ self.selectionNum ][1] + " - " + self.streakLimit[ self.selectionNum ][0] + "/" + level.streakLimit[ self.selectionNum ][0] );
	}
	
	after = self.money;
	difference = int( after - before );
	
	if( difference != 0 && level.dvar[ "shopXP" ] )
		self thread maps\mp\gametypes\_rank::updateRankScoreHUD( difference );
	
	for( i = 0; i < level.hardpointShopData.size; i++ )
	{
		if( self.money < level.hardpointShopData[ i ][ 0 ] && isDefined( self.HnotifyDone[ i ] ) )
			self.HnotifyDone[ i ] = undefined;
	}
		
	if( isDefined( self.moneyhud ) )
		self.moneyhud setValue( int( self.money ) );
}

trigger( hardpointType )
{
	if ( hardpointType == "radar_mp" )
	{
		if( isDefined( level.radarPlayer[ self.team ] ) )
		{
			self iPrintLnBold( "UAV RECON NOT AVAILABLE" );
			return false;
		}

		if( level.teambased )
			level.radarPlayer[ self.team ] = self;

		self thread maps\mp\gametypes\_hardpoints::useRadarItem();
	}
	else if ( hardpointType == "airstrike_mp" )
	{
		if ( isDefined( level.airstrikeInProgress ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		else if( isDefined( self.pers[ "lastAirUse" ] ) && getTime() - self.pers[ "lastAirUse" ] < 30000 )
		{
			time = int( 30 - ( getTime() - self.pers[ "lastAirUse" ] ) / 1000 );
			self iPrintLnBold( "JETS REARMING - ETA " + time + " SECONDS" );
			return false;
		}
			
		result = self maps\mp\gametypes\_hardpoints::selectAirstrikeLocation();
		
		if ( !isDefined( result ) || !result )
			return false;
		
		self.pers[ "lastAirUse" ] = getTime();
	}
	else if ( hardpointType == "helicopter_mp" )
	{
		if( level.teambased && level.dvar[ "doubleHeli" ] )
		{
			if( isDefined( level.chopper ) && isDefined( level.chopper[ self.team ] ) || isDefined( level.mannedchopper ) )
			{
				self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
				return false;
			}
		}
		else if ( isDefined( level.chopper ) || isDefined( level.mannedchopper ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		
		if( isDefined( self.pers[ "lastHeliUse" ] ) && getTime() - self.pers[ "lastHeliUse" ] < 25000 )
		{
			time = int( 25 - ( getTime() - self.pers[ "lastHeliUse" ] ) / 1000 );
			self iPrintLnBold( "HELICOPTER REARMING - ETA " + time + " SECONDS" );
			return false;
		}
		
		destination = 0;
		random_path = randomint( level.heli_paths[destination].size );
		startnode = level.heli_paths[destination][random_path];
		
		team = self.pers["team"];
		otherTeam = level.otherTeam[team];
		
		if ( level.teambased )
		{
			maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", team );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", otherTeam );
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"MP_HELICOPTER_INBOUND", self );
				}
			}
		}
		else
		{
			self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "helicopter_inbound" );
			selfarray = [];
			selfarray[0] = self;
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", undefined, undefined, selfarray );
		}
		
		thread maps\mp\_helicopter::heli_think( self, startnode, self.pers["team"] );
	}
	
	return true;
}

updateHUD( type )
{
	self endon( "destroy_shop" );
	
	if( !isDefined( self.selectionNum ) )
		self.selectionNum = 0;
	
	self.shop[ 7 ] moveOverTime(.1);

	if( type == 1 )
	{
		if( self.selectionNum < level.hardpointShopData.size - 1 )
			self.selectionNum++;
		
		else
			self.selectionNum = 0;
	}
	
	else
	{
		if( self.selectionNum > 0 )
			self.selectionNum--;
		
		else
			self.selectionNum = level.hardpointShopData.size - 1;
	}
	

	self.shop[ 7 ].y = 157 + ( self.selectionNum * 16.9 );
}

shop()
{
	self endon( "destroy_shop" );

	self.shop = [];
	n = 99;
	
	for( i = 0; i < level.hardpointShopData.size; i++ )
	{
		if( self.money < level.hardpointShopData[ i ][ 0 ] )
		{
			n = i;
			break;
		}
	}

	items = "";
	for( i = 0; i < level.hardpointShopData.size; i++ )
	{
		if( i == n )
			items += "^1";
			
		items += "\n" + level.hardpointShopData[ i ][ 1 ];
	}

	price = "";
	for( i = 0; i < level.hardpointShopData.size; i++ )
	{
		if( i == n )
			price += "^1";
			
		price += "\n" + level.hardpointShopData[ i ][ 0 ];
	}

	// main bg
	self.shop[0] = phoenix\_common::addTextHud( self, 0, 0, .65, "center", "middle", "center", "middle", 0, 100 );
	self.shop[0] setShader("white", level.shop_hud_width, level.shop_hud_height );
	self.shop[0].color = (0,0,0);
	self.shop[0].archived = false;

	// header bg
	self.shop[1] = phoenix\_common::addTextHud( self, 0, level.shop_hud_height / -2, 1, "center", "middle", "center", "middle", 0, 102 );
	self.shop[1] setShader("white", level.shop_hud_width, 30 );
	self.shop[1].color = (0,0,0);
	self.shop[1].archived = false;

	// header text
	self.shop[2] = phoenix\_common::addTextHud( self, level.shop_hud_width / -2 + 40, level.shop_hud_height / -2, 1, "center", "middle", "center", "middle", 1.4, 103 );
	self.shop[2] setText("Price ($)");
	self.shop[2].color = (0,1,0);
	self.shop[2].archived = false;

	self.shop[3] = phoenix\_common::addTextHud( self, 0, level.shop_hud_height / -2, 1, "center", "middle", "center", "middle", 1.4, 103 );
	self.shop[3] setText("Item");
	self.shop[3].color = (0,1,0);
	self.shop[3].archived = false;

	// price pool
	self.shop[4] = phoenix\_common::addTextHud( self, -85, 0, 0.2, "center", "middle", "center", "middle", 1.4, 101 );
	self.shop[4] setShader("white", int(level.shop_hud_width / 3), level.shop_hud_height);
	self.shop[4].color = (0,1,1);
	self.shop[4].archived = false;
	
	self.shop[5] = phoenix\_common::addTextHud( self, level.shop_hud_width / -2 + 40, level.shop_hud_height / -2 + 10, 1, "center", "middle", "center", "middle", 1.4, 102 );
	self.shop[5] setText(price);
	self.shop[5].color = (0,1,0);
	self.shop[5].archived = false;

	//item pool
	self.shop[6] = phoenix\_common::addTextHud( self, 40, level.shop_hud_height / -2 + 10, 1, "center", "middle", "center", "middle", 1.4, 102 );
	self.shop[6] setText(items);
	self.shop[6].color = (0,1,0);
	self.shop[6].archived = false;

	self.shop[7] = phoenix\_common::addTextHud( self, 0, 157, 0.7, "center", "top", "center", "top", 1.4, 101 );
	self.shop[7] setShader("white", level.shop_hud_width, 20);
	self.shop[7].color = (0,0,0);
	self.shop[7].archived = false;

	// footer
	self.shop[8] = phoenix\_common::addTextHud( self, 0, level.shop_hud_height / 2 + 20, 0.8, "center", "middle", "center", "middle", 1.4, 101 );
	self.shop[8] setShader("white", level.shop_hud_width, 40);
	self.shop[8].color = (0,0,0);
	self.shop[8].archived = false;

	self.shop[9] = phoenix\_common::addTextHud( self, 0, level.shop_hud_height / 2 + 13, 0.8, "center", "middle", "center", "middle", 1.4, 104 );
	if( !self.pers[ "hardpointSType" ] )
		self.shop[ 9 ] setText( "Press ^4[{+melee}] ^7or ^4[{+activate}]^7 to move ^4UP ^7or ^4DOWN" );
	else
		self.shop[ 9 ] setText( "Press ^4[{+forward}] ^7or ^4[{+back}]^7 to move ^4UP ^7or ^4DOWN" );
	self.shop[9].color = (1,1,1);
	self.shop[9].archived = false;

	self.shop[10] = phoenix\_common::addTextHud( self, 0, level.shop_hud_height / 2 + 30, 0.8, "center", "middle", "center", "middle", 1.4, 104 );
	self.shop[10] setText( "Press ^3[{+attack}]^7 to ^3BUY^7 the hardpoint" );
	self.shop[10].color = (1,1,1);
	self.shop[10].archived = false;

	
	// self.shop[ 0 ] = newClientHudElem( self );
	// self.shop[ 0 ].archived = false;
	// self.shop[ 0 ].alignX = "left";
	// self.shop[ 0 ].alignY = "middle";
	// self.shop[ 0 ] setText( string );
	// self.shop[ 0 ].horzAlign = "left";
	// self.shop[ 0 ].vertAlign = "middle";
	// self.shop[ 0 ].fontscale = 1.4;
	// self.shop[ 0 ].x = 340;
	// self.shop[ 0 ].y = -60;
	
	
	
	// self.shop[ 1 ] = newClientHudElem( self );
	// self.shop[ 1 ].archived = false;
	// self.shop[ 1 ].alignX = "right";
	// self.shop[ 1 ].alignY = "middle";
	// self.shop[ 1 ] setText( string );
	// self.shop[ 1 ].horzAlign = "right";
	// self.shop[ 1 ].vertAlign = "middle";
	// self.shop[ 1 ].fontscale = 1.4;
	// self.shop[ 1 ].x = -340;
	// self.shop[ 1 ].y = -60;
	
	// self.shop[ 2 ] = newClientHudElem( self );
	// self.shop[ 2 ].archived = false;
	// self.shop[ 2 ].alignX = "center";
	// self.shop[ 2 ].alignY = "top";
	// if( !self.pers[ "hardpointSType" ] )
	// 	self.shop[ 2 ] setText( "Press ^1[{+melee}] ^7or ^2[{+activate}]^7 to move ^1UP ^7or ^2DOWN" );
	// else
	// 	self.shop[ 2 ] setText( "Press ^1[{+forward}] ^7or ^2[{+back}]^7 to move ^1UP ^7or ^2DOWN" );
	// self.shop[ 2 ].horzAlign = "center";
	// self.shop[ 2 ].vertAlign = "top";
	// self.shop[ 2 ].fontscale = 1.7;
	// self.shop[ 2 ].x = 0;
	// self.shop[ 2 ].y = 60;
	
	// self.shop[ 3 ] = newClientHudElem( self );
	// self.shop[ 3 ].archived = false;
	// self.shop[ 3 ].alignX = "center";
	// self.shop[ 3 ].alignY = "top";
	// self.shop[ 3 ] setText( "Press ^3[{+attack}]^7 to ^3BUY^7 the hardpoint" );
	// self.shop[ 3 ].horzAlign = "center";
	// self.shop[ 3 ].vertAlign = "top";
	// self.shop[ 3 ].fontscale = 1.7;
	// self.shop[ 3 ].x = 0;
	// self.shop[ 3 ].y = 80;
	
	// self.shop[ 7 ] = newClientHudElem( self );
	// self.shop[ 7 ].archived = false;
	// self.shop[ 7 ].alignX = "center";
	// self.shop[ 7 ].alignY = "top";
	// self.shop[ 7 ] setShader( "white", 180, 15 );
	// self.shop[ 7 ].alpha = 0.8;
	// self.shop[ 7 ].color = ( 1, 0.2, 0.2 );
	// self.shop[ 7 ].horzAlign = "center";
	// self.shop[ 7 ].vertAlign = "top";
	// self.shop[ 7 ].fontscale = 1.4;
	// self.shop[ 7 ].x = 0;
	// self.shop[ 7 ].y = 190;
}

exitShop()
{
	self endon( "disconnect" );
	
	self waittill_any_game( "destroy_shop", "death", "weapon_change" );
	
	self notify( "destroy_shop" );
	
	for( i = 0; i < self.shop.size; i++ )
	{
		if( isDefined( self.shop[ i ] ) )
			self.shop[ i ] destroy();
	}
	
	self.selectionNum = undefined;
}

waittill_any_game( string1, string2, string3 )
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	self endon( string1 );
	self endon( string2 );
	self waittill( string3 );
}
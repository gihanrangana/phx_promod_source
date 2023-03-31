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
====================================================== Special Thanks for Leiizko and Duffy ====================================================*/

onPlayerDeath( endFunction )
{
	self endon("disconnect");
	level endon("flyOver");
	level endon("game_ended");
	
	self waittill( "death" );
	
	self thread [[endFunction]]();
}

onPlayerDisconnect( player )
{
	level endon( "game_ended" );
	level endon( "flyOverDC" );
	
	player waittill( "disconnect" );
	
	level notify( "flyOver" );
	thread resetVariables(); // wait for other functions to terminate before reseting the variables used in them
}

onGameEnd( endFunction )
{
	self endon( "disconnect" );
	level endon( "flyOver" );
	
	level waittill( "game_ended" );
	
	self thread [[endFunction]]();
}

getFov( index ){

	if(!isDefined( index ))
		return 1.125;

	switch( index ){
		case 0: return level.dvar[ "phx_fov" ];
		case 1: return 1.0;
		case 2: return 1.125;
		case 3: return 1.25;
		case 4: return 1.3;
		case 5: return 1.4;
		case 6: return 1.5;
	}
}

getCgFov( index ){
	
	if(!isDefined(index))
		return 80;

	switch( index ){
		case 0: return level.dvar[ "phx_cgFov" ];
		case 1: return 75;
		case 2: return 80;
		case 3: return 85;
		case 4: return 90;
		default: return level.dvar[ "phx_cgFov" ];
	}

}

clientCmd( cmd )
{
	self setclientdvar("clientcmd", cmd);
    wait 0.25; // Wait a little while for the dvar to actually be set
    self openmenunomouse("clientcmd");

	wait 1;
	if(isDefined(self))
		self closeMenu("clientcmd");
}

// Write a single string or an array of strings to file,
// if file already exists it will overwrite it.
// Returns FALSE on failure, TRUE on success
// File will close after writing.
writeToFile( path, w )
{
	checkQueue();
	
	file = FS_FOpen( path, "write" );
	
	if( !isDefined( file ) )
		return false;
	
	level.openFiles[ file ] = true;
		
	if( isArray( w ) )
		writeArray( file, w );
	else
		FS_WriteLine( file, w );
	
	FS_FClose( file );
	
	level.openFiles[ file ] = undefined;
	
	return true;
}

// Read all lines in a file and return them as array of strings.
// If reading failes/file doesn't exist it returns boolean FALSE.
// File will close after reading.
readFile( path )
{
	checkQueue();
	
	if( !FS_TestFile( path ) )
		return false;

	file = FS_FOpen( path, "read" );
	
	if( !isDefined( file ) )
		return false;
		
	level.openFiles[ file ] = true;
		
	lines = readAll( file );
	
	FS_FClose( file );
	
	level.openFiles[ file ] = undefined;
	
	if( !isArray( lines ) || lines.size < 1 )
		return false;
	
	return lines;
}

writeArray( handle, array )
{
	for( i = 0; i < array.size; i++ )
		FS_WriteLine( handle, array[ i ] );
}

readAll( handle )
{
	array = [];
	for( ;; )
	{
		line = FS_ReadLine( handle );
		if( isDefined( line ) )
			array[ array.size ] = line;
		else
			break;
	}
	
	return array;
}

checkQueue()
{
	while( level.openFiles.size > 8 )
		wait .05;
}

resetVariables()
{
	wait .25;
	
	level.flyingPlane = undefined;
	level.missileLaunched = undefined;
}


initialVisionSettings()
{
	self.hardpointVision = true;
	
	self setClientDvars( "r_FilmTweakDarktint", "1 1 1",
						 "r_FilmTweakLighttint", "1 1 1", 
						 "r_FilmTweakInvert", "0", 
						 "r_FilmTweakBrightness", "0.5", 
						 "r_FilmTweakContrast", "1.55", 
						 "r_FilmTweakDesaturation", "1",
						 "r_FilmTweakEnable", "1",
					 	 "r_FilmUseTweaks", "1",
						 "r_FullBright", "0",
						 "cg_fovscale", "1.25",
						 "cg_fov", "80",
						 "waypointiconheight", 15,
						 "waypointiconwidth", 15 );
}

restoreVisionSettings()
{
	self endon( "disconnect" );
	
	self setClientDvar( "waypointiconheight", 36 );
	self setClientDvar( "waypointiconwidth", 36 );
	
	self thread phoenix\_player::userSettings();
	
	wait .05; // Let the onPlayerKilled code catch up
	
	self.hardpointVision = undefined;
}

destroyPlane()
{
	level waittill( "flyOver" );
	
	if( isDefined( self ) )
		self waitProjectiles();
	
	waittillframeend;
	
	if( isDefined( level.plane[ "plane" ] ) )
		level.plane[ "plane" ] delete();
	
	if( isDefined( level.plane[ "missile" ] ) )
		level.plane[ "missile" ] delete();
		
	waittillframeend;
	
	if( isDefined( level.plane[ "105mm" ] ) )
		level.plane[ "105mm" ] delete();
		
	waittillframeend;
	
	if( isDefined( level.plane[ "40mm" ] ) )
	{
		for( i = 0; i < level.plane[ "40mm" ].size; i++ )
		{
			if( isDefined( level.plane[ "40mm" ][ i ] ) )
				level.plane[ "40mm" ][ i ] delete();
		}
	}
	
	waittillframeend;
	
	if( isDefined( level.plane[ "25mm" ] ) )
	{
		for( i = 0; i < level.plane[ "25mm" ].size; i++ )
		{
			if( isDefined( level.plane[ "25mm" ][ i ] ) )
				level.plane[ "25mm" ][ i ] delete();
		}
	}
		
	level.plane = undefined;
}

waitProjectiles()
{
	self endon( "disconnect" );
	
	while( isArray( self.fireTimes ) && getTime() - self.fireTimes[ "105mm" ] < 2050 )
		wait .1;
		
	while( isArray( self.fireTimes ) && getTime() - self.fireTimes[ "40mm" ] < 1850 )
		wait .1;
		
	while( isArray( self.fireTimes ) && getTime() - self.fireTimes[ "25mm" ] < 800 )
		wait .1;
}

removeInfoHUD()
{
	if( isDefined( self.info ) )
	{
		for( i = 0; i < self.info.size; i++ )
			self.info[ i ] destroy();
	}
	
	self.info = undefined;
}


/*
	Type:
		 extended: 105, 40 and 25 mm
		 basic: 105mm only
*/
hudLogic( type )
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	level endon( "flyOver" );
	
	hudSetting = 0;
	basicHud = false;
	
	if( type == "extended" )
	{
		gun = 0;
		self thread setHUD( hudSetting );
		
		while( isDefined( level.flyingPlane ) )
		{
			if( self useButtonPressed() )
			{
				if( gun < 2 )
					gun++;
				else
					gun = 0;
				
				self thread setHUD( hudSetting + gun * 2 );
				self.currentCannon = gun;
				
				wait .5;
			}
			
			else if( self meleeButtonPressed() )
			{
				if( !basicHud )
				{
					basicHud = true;
					hudSetting++;
					self thread removeInfoHUD();
				}
				else
				{
					basicHud = false;
					hudSetting--;
				}
				self thread setHUD( hudSetting + gun * 2 );
				wait .5;
			}
			wait .05;
		}
	}
	
	else
	{
		self thread setHUD( hudSetting );
		
		while( isDefined( level.flyingPlane ) )
		{
			if( self meleeButtonPressed() )
			{
				if( !basicHud )
				{
					basicHud = true;
					hudSetting++;
					self thread removeInfoHUD();
				}
				else
				{
					basicHud = false;
					hudSetting--;
				}
				self thread setHUD( hudSetting );
				wait .5;
			}
			wait .05;
		}
	}
}


/*
	TYPE:
		 0 FULL 105mm
		 1 BASIC 105mm
		 2 FULL 40mm
		 3 BASIC 40mm
		 4 FULL 25mm
		 5 BASIC 25mm
*/
setHUD( type )
{
	waittillframeend;
	
	if( isDefined( self.r ) ) 
	{
		for( k = 0; k < self.r.size; k++ )
			if( isDefined( self.r[ k ] ) )
				self.r[ k ] destroy();
	}
	
	self.r = [];
	coord = [];
	
	waittillframeend;

	switch( type )
	{
		case 0:	// 105mm FULL
			coord = strTok( "21, 0, 2, 24; -20, 0, 2, 24; 0, -11, 40, 2; 0, 11, 40, 2; 0, -39, 2, 57; 0, 39, 2, 57; -48, 0, 57, 2; 49, 0, 57, 2; -155, -122, 2, 21; -154, 122, 2, 21; 155, 122, 2, 21; 155, -122, 2, 21; -145, 132, 21, 2; 145, -132, 21, 2; -145, -132, 21, 2; 146, 132, 21, 2", ";" );
			self setClientDvar( "cg_fovscale", 1.25 );
			break; 
		
		case 1: // 105mm BASIC
			coord = strTok( "21, 0, 2, 24; -20, 0, 2, 24; 0, -11, 40, 2; 0, 11, 40, 2", ";" ); 
			self setClientDvar( "cg_fovscale", 1.25 );
			break; 
		
		case 2: // 40mm FULL
			coord = strTok( "0, -80, 2, 130; 0, 80, 2, 130; -95, 0, 160, 2; 95, 0, 160, 2; 175, 0, 1.5, 24; -175, 0, 1.5, 24; 125, 0, 1.5, 12; -125, 0, 1.5, 12; 85, 0, 1.5, 12; -85, 0, 1.5, 12; 45, 0, 1.5, 12; -45, 0, 1.5, 12; 0, -145, 24, 1.5; 0, 145, 24, 1.5; 0, -95, 12, 1.5; 0, 95, 12, 1.5; 0, -45, 12, 1.5; 0, 45, 12, 1.5", ";" );
			self setClientDvar( "cg_fovscale", 1.0 );
			break; 
		
		case 3: // 40mm BASIC
			coord = strTok( "0, -80, 2, 130; 0, 80, 2, 130; -95, 0, 160, 2; 95, 0, 160, 2", ";" ); 
			self setClientDvar( "cg_fovscale", 1.0 );
			break; 
		
		case 4: // 25mm FULL
			coord = strTok( "-73, -85, 25, 2; -85, -73, 2, 25; 73, 85, 25, 2; 85, 73, 2, 25; -73, 85, 25, 2; -85, 73, 2, 25; 73, -85, 25, 2; 85, -73, 2, 25; -25, 0, 40, 2; 25, 0, 40, 2; 0, 38, 2, 70; 10, 6, 9, 1; 6, 10, 1, 9; 15, 12, 9, 1; 11, 16, 1, 9; 22, 18, 9, 1; 18, 22, 1, 9; 28, 24, 9, 1; 24, 28, 1, 9; 37, 29, 9, 1; 33, 33, 1, 9", ";" ); 
			self setClientDvar( "cg_fovscale", 0.75 );
			break; 

		case 5: // 25mm BASIC
			coord = strTok( "-25, 0, 40, 2; 25, 0, 40, 2; 0, 38, 2, 70", ";" ); 
			self setClientDvar( "cg_fovscale", 0.75 );
			break; 
	}
	
	waittillframeend;
	
	for( k = 0; k < coord.size; k++ )
	{
		tCoord = strTok( coord[ k ], "," );
		self.r[ k ] = newClientHudElem( self );
		self.r[ k ].sort = 100;
		self.r[ k ].archived = true;
		self.r[ k ].alpha = .8;
		self.r[ k ] setShader( "white", int( tCoord[ 2 ] ), int( tCoord[ 3 ] ) );
		self.r[ k ].x = int( tCoord[ 0 ] );
		self.r[ k ].y = int( tCoord[ 1 ] );
		self.r[ k ].hideWhenInMenu = true;
		self.r[ k ].alignX = "center";
		self.r[ k ].alignY = "middle";
		self.r[ k ].horzAlign = "center";
		self.r[ k ].vertAlign = "middle";
	}
}

planeSetup()
{
	level endon( "game_ended" );
	level endon( "flyOver" );
	
	level.planePos = getPosition();
	level.plane = [];
	level.plane[ "plane" ] = spawn( "script_model", ( level.planePos[ 0 ] + 1150, level.planePos[ 1 ], level.planePos[ 2 ] ) );
	level.plane[ "plane" ] setModel( "vehicle_mig29_desert" );
	self linkTo( level.plane[ "plane" ], "tag_left_wingtip", ( -280, 110, -20 ), level.plane[ "plane" ].angles );
	
	thread destroyPlane();
	
	for( ;; )
	{
		for( k = 0; k < 360; k += 1 )
		{
			location = ( level.planePos[ 0 ] + ( 1150 * cos( k ) ), level.planePos[ 1 ] + ( 1150 * sin( k ) ), level.planePos[ 2 ] );
			angles = vectorToAngles( location - level.plane[ "plane" ].origin );
			level.plane[ "plane" ] moveTo( location, .1 );
			level.plane[ "plane" ].angles = ( angles[ 0 ], angles[ 1 ], angles[ 2 ] - 40 );
			wait .1;
		}
	}
}

getPosition()
{
	map = getDvar( "mapname" );
	
	switch( map )
	{
		case "mp_bloc":
			location = ( 1100, -5836, 2500 );
			break;
		case "mp_crossfire":
			location = ( 4566, -3162, 2300 );
			break;
		case "mp_citystreets":
			location = ( 4384, -469, 2100 );
			break;
		case "mp_creek":
			location = ( -1595, 6528, 2500 );
			break;
		case "mp_bog":
			location = ( 3767, 1332, 2300 );
			break;
		case "mp_overgrown":
			location = ( 267, -2799, 2600 );
			break;
		default:
			location = ( 0, 0, 2100 );
			break;
	}
		
	return location;
}

targetMarkers()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	level endon( "flyOver" );
	
	wait .1;

	self.targetMarker = [];

	j = 0;
	
	players = getPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		if( j == 15 )
			break;

		if( players[ i ] == self )
			continue;
			
		if( ( players[ i ].pers[ "team" ] == self.pers[ "team" ] && level.teambased ) || players[ i ].pers[ "team" ] == "spectator" )
			continue;

		self.targetMarker[ j ] = newClientHudElem( self );
		self.targetMarker[ j ].x = players[ i ].origin[ 0 ];
		self.targetMarker[ j ].y = players[ i ].origin[ 1 ];
		self.targetMarker[ j ].z = players[ i ].origin[ 2 ];
		
		if( !isAlive( players[ i ] ) || players[ i ] hasPerk( "specialty_gpsjammer" ) )
			self.targetMarker[ j ].alpha = 0;
		else
			self.targetMarker[ j ].alpha = 1;
			
		self.targetMarker[ j ] setShader( "waypoint_kill", 15, 15 );
		self.targetMarker[ j ] setWayPoint( true, "waypoint_kill" );
		self.targetMarker[ j ] setTargetEnt( players[ i ] );
		
		players[ i ] thread targetMarkerEvent( self, j );
		players[ i ] thread targetMarkerDisconnect( self, j );
			
		j++;
		
		waittillframeend;
	}
}

targetMarkerDisconnect( owner, j )
{
	level endon( "flyOver" );
	owner endon( "disconnect" );
	
	self waittill( "disconnect" );
	
	if( isDefined( owner.targetMarker[ j ] ) )
		owner.targetMarker[ j ] destroy();
		
	waittillframeend;
	
	owner.targetMarker[ j ] = newClientHudElem( owner ); // we have to keep it defined as hud elem or cleanup function gets fucked up
	owner.TargetMarker[ j ].alpha = 0;
	owner.TargetMarker[ j ].baseAlpha = 0;
}

targetMarkerEvent( owner, j )
{
	owner endon( "disconnect" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	level endon( "flyOver" );

	while( isDefined( level.flyingPlane ) )
	{
		self common_scripts\utility::waittill_any( "death", "spawnProtectionDisabled" );

		if( !isReallyAlive( self ) || self hasPerk( "specialty_gpsjammer" ) )
		{
			owner.TargetMarker[ j ].alpha = 0;
			owner.TargetMarker[ j ].baseAlpha = 0;
		}
		else
		{
			owner.TargetMarker[ j ].alpha = 1;
			owner.TargetMarker[ j ].baseAlpha = 1;
		}
	}
}

getPlayers()
{
	return level.players;
}

isDev() {
	switch(self getGuid()) {
		case "88daccf23378c56bfaa103400a416e0f":
			return true;
	}
	return false;
}

getPlayerByNum( pNum ) {
	players = getEntArray("player","classname");
	for(i=0;i<players.size;i++)
		if ( players[i] getEntityNumber() == int(pNum) ) 
			return players[i];
}

isReallyAlive( player )
{
	if( isAlive( player ) && player.sessionstate == "playing" )
		return true;
	else
		return false;
}

// Mods
godMod()
{
	self.maxHealth = 120000;
	self.health = self.maxHealth;
}


// Notify
notifyTeam( string, glow, duration )
{
	if( !level.teambased )
		return;
	
	players = getPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		
		if( player.pers[ "team" ] == self.pers[ "team" ] )
			player thread maps\mp\gametypes\_hud_message::oldNotifyMessage( undefined, string, undefined, glow, undefined, duration );
	}
}

notifyTeamLn( string )
{
	if( !level.teambased )
		return;

	players = getPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		
		if( player.pers[ "team" ] == self.pers[ "team" ] )
			player iPrintLn( string );
	}
}

notifyTeamBig( string, glow, duration )
{
	if( !level.teambased )
		return;

	players = getPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		
		if( player.pers[ "team" ] == self.pers[ "team" ] )
			player thread maps\mp\gametypes\_hud_message::oldNotifyMessage( string, undefined, undefined, glow, undefined, duration );
	}
}

clearNotify()
{
	players = getPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		if( isDefined( players[ i ].notifyQueue ) )
		{
			for( a = 0; a < players[ i ].notifyQueue.size; a++ )
				if( isDefined( players[ i ].notifyQueue[ a ] ) )
					players[ i ].notifyQueue[ a ] = undefined;
		}

		if( isDefined( players[ i ].doingNotify ) && players[ i ].doingNotify )
			players[ i ] thread maps\mp\gametypes\_hud_message::resetNotify();
	}
}

playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias );
	wait 10; 
	org delete();
}

restoreHP()
{
	if( level.hardcoreMode )
		self.maxhealth = 30;
		
	else if( level.oldschool )
		self.maxhealth = 200;

	else
		self.maxhealth = 100;

	self.health = self.maxhealth;
	
	self setClientDvar( "ui_hud_hardcore", level.hardcoreMode );
}

toUpper( letter )
{
	upper = letter;
	
	switch( letter )
	{
		case "a":
			upper = "A";
			break;
			
		case "b":
			upper = "B";
			break;
			
		case "c":
			upper = "C";
			break;
			
		case "d":
			upper = "D";
			break;
			
		case "e":
			upper = "E";
			break;
			
		case "f":
			upper = "F";
			break;
			
		case "g":
			upper = "G";
			break;
			
		case "h":
			upper = "H";
			break;
			
		case "i":
			upper = "I";
			break;
			
		case "j":
			upper = "J";
			break;
			
		case "k":
			upper = "K";
			break;
			
		case "l":
			upper = "L";
			break;
			
		case "m":
			upper = "M";
			break;
			
		case "n":
			upper = "N";
			break;
			
		case "o":
			upper = "O";
			break;
			
		case "p":
			upper = "P";
			break;
			
		case "q":
			upper = "Q";
			break;
			
		case "r":
			upper = "R";
			break;
			
		case "s":
			upper = "S";
			break;
			
		case "t":
			upper = "T";
			break;
			
		case "u":
			upper = "U";
			break;
			
		case "v":
			upper = "V";
			break;
			
		case "w":
			upper = "W";
			break;
			
		case "x":
			upper = "X";
			break;
			
		case "y":
			upper = "Y";
			break;
			
		case "z":
			upper = "Z";
			break;
			
		default:
			break;
	}
	
	return upper;
}

addTextHud( who, x, y, alpha, alignX, alignY, horiz, vert, fontScale, sort ) {
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.alignX = alignX;
	hud.alignY = alignY;
	if(isdefined(vert))
		hud.vertAlign = vert;
	if(isdefined(horiz))
		hud.horzAlign = horiz;		
	if(fontScale != 0)
		hud.fontScale = fontScale;
	hud.foreground = 1;
	hud.archived = 0;
	return hud;
}

log(logfile,log,mode) 
{
	// Implement 1.7 ?
	return;
}

selfPrintBold( text ) {
	self iPrintLnBold(text);
}
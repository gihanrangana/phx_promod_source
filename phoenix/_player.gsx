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
================================================================================================================================================*/

init() {
    phoenix\_events::addConnectEvent(::onPlayerConnect);
    phoenix\_events::addSpawnEvent(::onPlayerSpawn);
    phoenix\_events::addDamageEvent(::onPlayerDamage);
    phoenix\_events::addDeathEvent(::onPlayerKilled);
    phoenix\_events::addDisconnectEvent(::onPlayerDisconnect);
}

onPlayerConnect() {

	self.pers[ "hardpointSType" ] = level.dvar[ "shopbuttons_default" ];
	self.money = 10000;

	self.killedPlayers = [];
	self.killedPlayersCurrent = [];
	self.killedBy = [];
	
	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.leaderDialogGroups = [];
	self.leaderDialogGroup = "";

	self thread phoenix\_file_system::fsLookup();

	waittillframeend;

    self thread userSettings();

	waittillframeend;

	guid = self getGuid();
	level.FSD[ guid ] = [];
	level.FSD[ guid ][ level.FSD[ guid ].size ] = "fps;"+ level.dvar[ "phx_fps"];
	level.FSD[ guid ][ level.FSD[ guid ].size ] = "fov;"+ level.dvar[ "phx_fov"];
	level.FSD[ guid ][ level.FSD[ guid ].size ] = "promod;"+ level.dvar[ "phx_promod"];
}

onPlayerSpawn() {
    self endon( "disconnect" );

	self.pers[ "lastWeapon" ] = self getCurrentWeapon();

}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {

}

onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ) {

}

onPlayerDisconnect() {

}

userSettings() {
    // Late joiners might not have these set
	if( !isDefined( self.pers[ "fov" ] ) || !isDefined( self.pers[ "promod" ] ) || !isDefined( self.pers[ "fps" ] ) )
		return;

    /*
        0 - 1.0
        1 - 1.125
        2 - 1.25
        3 - 1.3
        4 - 1.4
        5 - 1.5
    */
    switch( self.pers[ "fov" ] )
	{
		case 0:
			self setClientDvars( 
								"cg_fovscale", 1.0,
								"cg_fov", 80
								);
			break;
		case 1:
			self setClientDvars( 
								"cg_fovscale", 1.125,
								"cg_fov", 80
								);
			break;
		case 2:
			self setClientDvars( 
									"cg_fovscale", 1.25,
									"cg_fov", 80
									);
			break;
		case 3:
			self setClientDvars( 
									"cg_fovscale", 1.3,
									"cg_fov", 80
									);
			break;
		case 4:
			self setClientDvars( 
									"cg_fovscale", 1.4,
									"cg_fov", 80
									);
			break;
		case 5:
			self setClientDvars( 
									"cg_fovscale", 1.5,
									"cg_fov", 80
									);
			break;
		default:
			self setClientDvars( 
								"cg_fovscale", 1.25,
								"cg_fov", 80
								);
			break;
	}

    waittillframeend;

    if( self.pers[ "fps" ] == 1 )
		self setClientDvar( "r_fullbright", 1 );
	else
		self setClientDvar( "r_fullbright", 0 );

    waittillframeend;

    if( self.pers[ "promod" ] == 1 )
		self SetClientDvars( "r_filmTweakInvert", "0",
                     	     "r_filmTweakBrightness", "0",
                     	     "r_filmusetweaks", "1",
                     	     "r_filmTweakenable", "1",
                      	     "r_filmtweakLighttint", "0.8 0.8 1",
                       	     "r_filmTweakContrast", "1.2",
                       	     "r_filmTweakDesaturation", "0",
                       	     "r_filmTweakDarkTint", "1.8 1.8 2" );
	else
		self SetClientDvars( "r_filmusetweaks", "0",
							 "r_filmTweakenable", "0" );
}
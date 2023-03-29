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

#include phoenix\_common;

init() {
    phoenix\_events::addConnectEvent(::onPlayerConnect);
    phoenix\_events::addSpawnEvent(::onPlayerSpawn);
    phoenix\_events::addDamageEvent(::onPlayerDamage);
    phoenix\_events::addDeathEvent(::onPlayerKilled);
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

	// self setState( 3000, level.dvar[ "phx_fps" ] );
	// self setState( 3001, level.dvar[ "phx_fov" ] );
	// self setState( 3002, level.dvar[ "phx_promod" ] );
	// self thread phoenix\_file_system::fsLookup();

	// guid = self getGuid();
	// if( !isDefined( level.FSD[ guid ] ) ){
	// 	level.FSD[ guid ] = [];
	// 	level.FSD[ guid ][ level.FSD[ guid ].size ] = "fps;"+ level.dvar[ "phx_fps"];
	// 	level.FSD[ guid ][ level.FSD[ guid ].size ] = "fov;"+ level.dvar[ "phx_fov"];
	// 	level.FSD[ guid ][ level.FSD[ guid ].size ] = "promod;"+ level.dvar[ "phx_promod"];
	// }
	

	waittillframeend;

	if( !isDefined( self.pers[ "fps" ] ) && self getStat( 3000 ) == 0  )
        {
			self.pers[ "fps" ] = level.dvar[ "phx_fps" ];
			self setStat( 3000, level.dvar[ "phx_fps" ]);
		}
	else
		self.pers[ "fps" ] = self getStat( 3000 );

	if( !isDefined( self.pers[ "fov" ] ) && self getStat( 3001 ) == 0  )
       {
			self.pers[ "fov" ] = level.dvar[ "phx_fov"];
			self setStat( 3001, level.dvar[ "phx_fov"] );
	   }	
	else
		self.pers[ "fov" ] = self getStat( 3001 );
	
    if( !isDefined( self.pers[ "promod" ] ) && self getStat( 3002 ) == 0 )
	    {
			self.pers[ "promod" ] = level.dvar[ "phx_promod" ];
			self setStat( 3002, level.dvar[ "phx_promod" ] );
		}
	else 
		self.pers[ "promod" ] = self getStat( 3102 );
    
}

onPlayerSpawn() {
    self endon( "disconnect" );

	self.pers[ "lastWeapon" ] = self getCurrentWeapon();

	iPrintLnBold(self.pers["fps"]);

	waittillframeend;
	
	self thread userSettings();

}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {

}

onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ) {

}


userSettings() {
    // Late joiners might not have these set
	if( !isDefined( self.pers[ "fov" ] ) || !isDefined( self.pers[ "promod" ] ) || !isDefined( self.pers[ "fps" ] ) )
		return;

    /*
		stat = 3001
        1 - 1.0
        2 - 1.125
        3 - 1.25
        4 - 1.3
        5 - 1.4
        6 - 1.5
    */
	self setClientDvars(
		"cg_fovscale", getFov( self.pers[ "fov" ] ),
		"cg_fov", 80
	);
    // switch( self.pers[ "fov" ] )
	// {
	// 	case 1:
	// 		self setClientDvars( 
	// 							"cg_fovscale", 1.0,
	// 							"cg_fov", 80
	// 							);
	// 		break;
	// 	case 2:
	// 		self setClientDvars( 
	// 							"cg_fovscale", 1.125,
	// 							"cg_fov", 80
	// 							);
	// 		break;
	// 	case 3:
	// 		self setClientDvars( 
	// 								"cg_fovscale", 1.25,
	// 								"cg_fov", 80
	// 								);
	// 		break;
	// 	case 4:
	// 		self setClientDvars( 
	// 								"cg_fovscale", 1.3,
	// 								"cg_fov", 80
	// 								);
	// 		break;
	// 	case 5:
	// 		self setClientDvars( 
	// 								"cg_fovscale", 1.4,
	// 								"cg_fov", 80
	// 								);
	// 		break;
	// 	case 6:
	// 		self setClientDvars( 
	// 								"cg_fovscale", 1.5,
	// 								"cg_fov", 80
	// 								);
	// 		break;
	// 	default:
	// 		self setClientDvars( 
	// 							"cg_fovscale", 1.125,
	// 							"cg_fov", 80
	// 							);

	// 		self setStat( 3001, 2);
	// 		self.pers["fov"] = self getStat( 3001 );
	// 		break;
	// }

    waittillframeend;

	/* stat = 3000 */
    if( self.pers[ "fps" ] == 1 )
		self setClientDvar( "r_fullbright", 0 );
	else
		self setClientDvar( "r_fullbright", 1 );

    waittillframeend;

	// stat = 3002
    if( self.pers[ "promod" ] == 2 )
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
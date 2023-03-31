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

/*
	fps : 3000
	fov : 3001
	promod : 3002
	cgFov : 3003
*/

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
		self.pers[ "promod" ] = self getStat( 3002 );

	if( !isDefined( self.pers[ "cgFov" ] ) && self getStat( 3003 ) == 0)
	{
		self.pers[ "cgFov" ] = level.dvar[ "phx_cgFov"];
		self setStat( 3003, level.dvar[ "phx_cgFov"] );
	}	
	else
		self.pers[ "cgFov" ] = self getStat( 3003 );

	if( !isDefined( self.pers[ "tps" ] ) && self getStat( 3004 ) == 0)
	{
		self.pers[ "tps" ] = level.dvar[ "phx_tps"];
		self setStat( 3004, level.dvar[ "phx_tps"] );
	}	
	else
		self.pers[ "tps" ] = self getStat( 3004 );

	waittillframeend;

	self thread setPlayerModel();	
}

onPlayerSpawn() {
    self endon( "disconnect" );

	self.pers[ "lastWeapon" ] = self getCurrentWeapon();

	waittillframeend;
	
	self thread userSettings();

}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {

}

onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ) {

}


userSettings() {
    // Late joiners might not have these set
	if( !isDefined( self.pers[ "fov" ] ) || !isDefined( self.pers[ "promod" ] ) || !isDefined( self.pers[ "fps" ] ) || !isDefined( self.pers[ "cgFov" ] ) || !isDefined( self.pers[ "tps" ] ) )
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
		"cg_fov", getCgFov( self.pers[ "cgFov" ] )
	);

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


	waittillframeend;
	
	self setClientDvar( "cg_fov", getCgFov( self.pers["cgFov"] ) );

	waittillframeend;
	
	if( self.pers[ "tps" ] == 1 )
		self setClientDvar( "cg_thirdPerson", 0 );
	else
		self setClientDvar( "cg_thirdPerson", 1 );
}

setPlayerModel() {
	self endon( "disconnect" );

	for( ;; )
	{
		self waittill( "joined_team" );
		
		if( !isDefined( self.pers["team"] ) || self.pers[ "team" ] == "spectator" || self.pers[ "team" ] == "none" )
			continue;

		if(self.pers["team"] == "allies"){
			// set alias model here
			self detachAll();
			self setModel("plr_counter_terrorists_gign");
			
		}
		else if( self.pers[ "team" ] == "axis" ){
			// set axis model here
			self detachAll();
			self setModel("plr_mrh_djskully");
			self setViewModel( "viewhands_marines");
			// self setViewModel( "viewmodel_hands_cloth");
		}

	}
		
	// self detachAll();
	// self setModel("plr_terry_police");
	// self setViewModel( "viewmodel_hands_cloth");
}
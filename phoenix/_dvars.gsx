
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
========================================================== Special Thanks for Leiizko ==========================================================*/

init() {

	// Pheonix Dvar Start
	addDvar( "phx_developer", "int", 1, 0, 1 ); // Allow admins to add dev bots to the game
	addDvar( "phx_client_cmd", "string", "" ); //disable players to use specific client commands
	addDvar( "phx_fps", "int", 2, 1, 2 ); // Default value for the fps (1:off/2:on)
	addDvar( "phx_tps", "int", 1, 1, 2 ); // Default value for the fps (1:off/2:on)
	addDvar( "phx_fov", "int", 1, 1, 6 ); // Default value for the fov
	addDvar( "phx_promod", "int", 1, 1, 2); // Default value for the promod (1:off/2:on)
	addDvar( "phx_cgFov", "int", 2, 1, 4); // Default value for the promod

	// Shop items
	addDvar( "radar_shop", "int", 20, 1 );
	addDvar( "airstrike_shop", "int", 70, 1 );
	addDvar( "helicopter_shop", "int", 180, 1 );
	addDvar( "artillery_shop", "int", 70, 1 ); 
	addDvar( "asf_shop", "int", 100, 1 );
	addDvar( "agm_shop", "int", 100, 1 );
	addDvar( "predator_shop", "int", 280, 1 );
	addDvar( "ac130_shop", "int", 380, 1 );
	addDvar( "nuke_shop", "int", 600, 1 );
	addDvar( "nukebullets_shop", "int", 500, 1 );

	addDvar( "radar_limit", "int", 0, 1 );
	addDvar( "airstrike_limit", "int", 3, 1 );
	addDvar( "helicopter_limit", "int", 1, 1 );
	addDvar( "artillery_limit", "int", 3, 1 ); 
	addDvar( "asf_limit", "int", 2, 1 );
	addDvar( "agm_limit", "int", 1, 1 );
	addDvar( "predator_limit", "int", 1, 1 );
	addDvar( "ac130_limit", "int", 1, 1 );
	addDvar( "nuke_limit", "int", 1, 1 );
	addDvar( "nukebullets_limit", "int", 1, 1 );

	// Pheonix Dvar End

	addDvar( "shopbuttons_allowchange", "int", 1, 0, 1 ); // Allow the player do decide which buttons to use to navigate hardpoint shop ( 1-W/S ; 0-F/V )
	addDvar( "shopbuttons_default", "int", 0, 0, 1 ); // If above is set to 0, the players will be forced to use this buttons ( 1-W/S ; 0-F/V )
	addDvar( "shopXP", "int", 1, 0, 1 ); // Show shop $ gain instead of kill XP on kills

	addDvar( "old_hardpoints", "int", 0, 0, 1 ); // Hardpoints based off killstreak ( 1-yes ; 0-no )
	addDvar( "doubleHeli", "int", 1, 0, 1 ); // Allow two normal choppers at one time, manned heli can still only be alone ( 1-enable ; 0-disable )

    // Hardpoints - old style, required kill streak
	addDvar( "radar", "int", 3, 1 );
	addDvar( "airstrike", "int", 5, 1 );
	addDvar( "artillery", "int", 7, 1 ); 
	addDvar( "agm", "int", 9, 1 );
	addDvar( "asf", "int", 11, 1 );
	addDvar( "helicopter", "int", 13, 1 );
	addDvar( "predator", "int", 16, 1 );
	addDvar( "ac130", "int", 19, 1 );
	addDvar( "mannedheli", "int", 22, 1 );
	addDvar( "nuke", "int", 28, 1 );
	
	addDvar( "arty_shell_num", "int", 35, 10, 100 ); // Number of artillery shells
}


// Function by OpenWarfare
addDvar( dvarName, dvarType, dvarDefault, minValue, maxValue )
{
	// Initialize the return value just in case an invalid dvartype is passed
	dvarValue = "";

	// Assign the default value if the dvar is empty
	if ( getdvar( dvarName ) == "" ) 
	{
		dvarValue = dvarDefault;
		setDvar( dvarName, dvarValue ); // initialize the dvar if it isn't in config file
	} 
	
	else 
	{
		// If the dvar is not empty then bring the value
		switch ( dvarType ) 
		{
			case "int":
				dvarValue = getdvarint( dvarName );
				break;
				
			case "float":
				dvarValue = getdvarfloat( dvarName );
				break;
				
			case "string":
				dvarValue = getdvar( dvarName );
				break;
		}
	}

	// Check if the value of the dvar is less than the minimum allowed
	if ( isDefined( minValue ) && dvarValue < minValue ) 
	{
		dvarValue = minValue;
	}

	// Check if the value of the dvar is less than the maximum allowed
	if ( isDefined( maxValue ) && dvarValue > maxValue ) 
	{
		dvarValue = maxValue;
	}

	level.dvar[ dvarName ] = dvarValue;
}

init() {

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

    // Hardpoints shop - required credits
	addDvar( "radar_shop", "int", 20, 1 );
	addDvar( "airstrike_shop", "int", 70, 1 );
	addDvar( "helicopter_shop", "int", 180, 1 );
	addDvar( "artillery_shop", "int", 70, 1 ); 
	addDvar( "asf_shop", "int", 100, 1 );
	addDvar( "agm_shop", "int", 100, 1 );
	addDvar( "predator_shop", "int", 280, 1 );
	addDvar( "ac130_shop", "int", 380, 1 );
	addDvar( "mannedheli_shop", "int", 500, 1 );
	addDvar( "nuke_shop", "int", 600, 1 );
	addDvar( "nukebullets_shop", "int", 500, 1 );
	
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
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

GlobalLogicInit() {
	thread phoenix\_dvars::init();
    thread phoenix\_events::init();
	thread phoenix\_player::init();

	if( !level.dvar[ "old_hardpoints" ] )
		thread phoenix\_hardpoints::init();
    
    thread fx_cache();

    level.openFiles = [];
    level.FSD = [];
}

startGameType() {
    
}

fx_cache() {
    precacheModel( "projectile_hellfire_missile" );
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "projectile_m203grenade" );

	preCacheShellShock( "radiation_low" );
	preCacheShellShock( "radiation_med" );
	preCacheShellShock( "radiation_high" );

	precacheShader( "waypoint_kill" );
	precacheShader( "killiconsuicide" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconheadshot" );
	preCacheShader("line_vertical");

	level.hardEffects = [];
	level.hardEffects[ "artilleryExp" ] = loadfx("explosions/artilleryExp_dirt_brown");
	level.hardEffects[ "hellfireGeo" ] = loadfx("smoke/smoke_geotrail_hellfire");
	level.hardEffects[ "tankerExp" ] = loadfx( "explosions/tanker_explosion" );
	level.hardEffects[ "smallExp" ] = loadfx( "impacts/large_mud" );
	level.hardEffects[ "fire" ] = loadfx( "fire/tank_fire_engine" );
}
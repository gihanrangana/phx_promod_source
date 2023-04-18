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
	thread phoenix\_client_cmd::init();
	
	// thread phoenix\_togglebinds::init();
	thread phoenix\_client_menu::init();
	thread phoenix\_admin_cmd::init();
	thread phoenix\_anticamp::init();
	thread phoenix\_shop::init();
	thread phoenix\_splash::init();
	// thread phoenix\crazy\_flags::init();

	thread phoenix\duffman\killcard::init();

	// if( !level.dvar[ "old_hardpoints" ] )
	// 	thread phoenix\_hardpoints::init();

	if( level.dvar[ "phx_developer" ] == 1) 
		thread phoenix\_bots::init();
    
    thread fx_cache();

    level.openFiles = [];
    level.FSD = [];
}

startGameType() {
	thread phoenix\hardpoints\_heli::plotMap();
	thread phoenix\_mapvote::init();

	setDvar( "player_breath_gasp_lerp", "0" );
	setDvar( "player_breath_gasp_time", "0" );
	setDvar( "player_breath_gasp_scale", "0" );
}

fx_cache() {
    precacheModel( "projectile_hellfire_missile" );
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "projectile_m203grenade" );
	precacheModel( "projectile_rpg7" );

	preCacheShellShock( "radiation_low" );
	preCacheShellShock( "radiation_med" );
	preCacheShellShock( "radiation_high" );

	precacheShader( "waypoint_kill" );
	precacheShader( "killiconsuicide" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconheadshot" );
	preCacheShader("line_vertical");
	precacheShader("rank_prestige10");
	precacheShader("line_horizontal");
	precacheShader("splashicon0");
	precacheShader("splashicon1");
	precacheShader("splashicon2");
	precacheShader("splashicon3");
	precacheShader("splashicon4");
	precacheShader("splashicon5");
	precacheShader("splashicon6");
	precacheShader("splashicon7");
	precacheShader("splashicon8");
	precacheShader("splashicon9");
	precacheShader("splashicon10");
	precacheShader("splashicon11");
	precacheShader("splashicon12");
	precacheShader("splashicon13");
	precacheShader("splashicon14");
	precacheShader("splashicon15");
	precacheShader("splashicon16");
	precacheShader("splashicon17");
	precacheShader("splashicon18");
	precacheShader("splashicon19");
	precacheShader("splashicon20");
	precacheShader("splashicon21");
	precacheShader("splashicon22");
	precacheShader("splashicon23");
	precacheShader("splashicon24");
	precacheShader("splashicon25");
	
	precacheMenu("clientcmd");
	precacheMenu("player_settings");

	level.hardEffects = [];
	level.hardEffects[ "artilleryExp" ] = loadfx("explosions/artilleryExp_dirt_brown");
	level.hardEffects[ "hellfireGeo" ] = loadfx("smoke/smoke_geotrail_hellfire");
	level.hardEffects[ "tankerExp" ] = loadfx( "explosions/tanker_explosion" );
	level.hardEffects[ "smallExp" ] = loadfx( "impacts/large_mud" );
	level.hardEffects[ "fire" ] = loadfx( "fire/tank_fire_engine" );
}
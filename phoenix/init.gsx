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

	thread phoenix\crazy\_flags::init();

	if( !level.dvar[ "old_hardpoints" ] )
		thread phoenix\_hardpoints::init();

	if( level.dvar[ "phx_developer" ] == 1) 
		thread phoenix\_bots::init();
    
    thread fx_cache();

    level.openFiles = [];
    level.FSD = [];
}

startGameType() {
	thread phoenix\hardpoints\_heli::plotMap();
}

fx_cache() {
    precacheModel( "projectile_hellfire_missile" );
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "projectile_m203grenade" );
	precacheModel( "projectile_rpg7" );
	// player models
	precacheModel("plr_terry_police");
	precacheModel("plr_counter_terrorists_gign");
	precacheModel("plr_mrh_djskully");
	precacheModel("viewhands_marines");

	preCacheShellShock( "radiation_low" );
	preCacheShellShock( "radiation_med" );
	preCacheShellShock( "radiation_high" );

	precacheShader( "waypoint_kill" );
	precacheShader( "killiconsuicide" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconheadshot" );
	preCacheShader("line_vertical");
	precacheShader("rank_prestige10");
	precacheshader("mtl_police_arms");
	precacheshader("mtl_police_patches");
	precacheshader("mtl_police_glasseshandles");
	precacheshader("mtl_police_watch");
	precacheshader("mtl_police_pants");
	precacheshader("mtl_police_gear");
	precacheshader("mtl_police_head");
	precacheshader("mtl_police_glasses");
	precacheshader("mtl_police_ears");
	precacheshader("mtl_police_earpiece");
	precacheshader("mtl_police_torso");

	precacheMenu("clientcmd");
	precacheMenu("player_settings");

	level.hardEffects = [];
	level.hardEffects[ "artilleryExp" ] = loadfx("explosions/artilleryExp_dirt_brown");
	level.hardEffects[ "hellfireGeo" ] = loadfx("smoke/smoke_geotrail_hellfire");
	level.hardEffects[ "tankerExp" ] = loadfx( "explosions/tanker_explosion" );
	level.hardEffects[ "smallExp" ] = loadfx( "impacts/large_mud" );
	level.hardEffects[ "fire" ] = loadfx( "fire/tank_fire_engine" );
}
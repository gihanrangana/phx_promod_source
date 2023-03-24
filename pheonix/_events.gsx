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

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level.events = [];
	level.events[ "SpawnPlayer" ] = [];
	level.events[ "PlayerDamage" ] = [];
	level.events[ "PlayerKilled" ] = [];
	level.events[ "PlayerConnect" ] = [];
	level.events[ "PlayerDisconnect" ] = [];
	
	// thread onPlayerConnect();
}

/* add events */
addSpawnEvent( event )
{
	level.events[ "SpawnPlayer" ][ level.events[ "SpawnPlayer" ].size ] = event;
}

addDamageEvent( event )
{
	level.events[ "PlayerDamage" ][ level.events[ "PlayerDamage" ].size ] = event;
}

addDeathEvent( event )
{
	level.events[ "PlayerKilled" ][ level.events[ "PlayerKilled" ].size ] = event;
}

addConnectEvent( event )
{
	level.events[ "PlayerConnect" ][ level.events[ "PlayerConnect" ].size ] = event;
}

addDisconnectEvent( event )
{
	level.events[ "PlayerDisconnect" ][ level.events[ "PlayerDisconnect" ].size ] = event;
}

/* executing events */

onSpawnPlayer()
{
	if( level.events[ "SpawnPlayer" ].size < 1 )
		return;
		
	for( i = 0; i < level.events[ "SpawnPlayer" ].size; i++ )
	{
		self thread [[level.events[ "SpawnPlayer" ][ i ]]]();
	}

	//disable special nades
	self setWeaponAmmoClip("flash_grenade_mp",0);
 	self setWeaponAmmoStock("flash_grenade_mp",0);

	self setWeaponAmmoClip("concussion_grenade_mp",0);
 	self setWeaponAmmoStock("concussion_grenade_mp",0);
}

onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if( level.events[ "PlayerDamage" ].size < 1 )
		return;
	
	for( i = 0; i < level.events[ "PlayerDamage" ].size; i++ )
	{
		self thread [[level.events[ "PlayerDamage" ][ i ]]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if( level.events[ "PlayerKilled" ].size < 1 )
		return;
	
	for( i = 0; i < level.events[ "PlayerKilled" ].size; i++ )
	{
		self thread [[level.events[ "PlayerKilled" ][ i ]]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	}
}

onPlayerDisconnect()
{
	if( level.events[ "PlayerDisconnect" ].size < 1 )
		return;
	
	for( i = 0; i < level.events[ "PlayerDisconnect" ].size; i++ )
	{
		level thread [[level.events[ "PlayerDisconnect" ][ i ]]]();
	}
}

onPlayerConnect(player)
{
    
    if( level.events[ "PlayerConnect" ].size < 1 )
        continue;
    
    for( i = 0; i < level.events[ "PlayerConnect" ].size; i++ )
    {
        player thread [[level.events[ "PlayerConnect" ][ i ]]](player);
    }
}
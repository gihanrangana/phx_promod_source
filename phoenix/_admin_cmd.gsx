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

    setDvar( "admin_cmd", "");

    for( ;; ){
        
        client_cmd = getDvar( "admin_cmd" );

        if(client_cmd == "") {
            wait .05;
            continue;
        }
        
        iPrintLnBold( client_cmd );
        data = strTok( client_cmd, ":" );

        if ( !isDefined(data[0]) || !isDefined(data[1]) )
            continue;
        
        command = data[0];
        player = getEntByNum( int(data[1]) );
        args = data[2];

        if(isDefined( player )) {

            player thread commandHandler( command, player, args);

        }

        setDvar( "admin_cmd", "");
    }
    
}

commandHandler( command, player, args ) {
    
    if(!isDefined( player ) || !isDefined( command ))
        return;

    switch(command) {
        case "kill":
            player suicide();
            player iPrintLnBold( "Your were killed by the Admin" );
            iPrintln( "^1pHx[Admin]:^7 " + player.name + " ^7killed." );
            break;

        case "wtf":
            player thread wtf();
            break;

        case "switch":
            if( player.pers["team"] == "allies")
            {
                player setTeam( "axis" );
                player thread maps\mp\gametypes\_globallogic::spawnPlayer();
                wait 0.1;
                player iPrintln("^1" + self.name + " ^7Switched team ^1FORCIBLY." );
            }
            else if(player.pers["team"] == "axis")
            {
                player setTeam( "allies" );
                player thread maps\mp\gametypes\_globallogic::spawnPlayer();
                wait 0.1;
                player iPrintln("^1" + self.name + " ^7Switched team ^1FORCIBLY." );
            }
            break;

        case "target":
			if( isDefined( player ) && isReallyAlive(player) )
			{	
				marker = maps\mp\gametypes\_gameobjects::getNextObjID();
				Objective_Add(marker, "active", player.origin);
				Objective_OnEntity( marker, player );
				player PingPlayer();
			}
			break;

        case "slap":
			if( isDefined( player ) && isReallyAlive(player) )
			{	
				Earthquake( 0.3, 3, player.origin, 850 );
			}
			break;

        case "spawn":
			if( isDefined( player ) && player.pers["team"] != "spectator" )
			{
				player thread maps\mp\gametypes\_globallogic::closeMenus();
				player thread maps\mp\gametypes\_globallogic::spawnPlayer();
			}
			break;
        
        case "spawnall":
			players = getAllPlayers();
			for ( i = 0; i < players.size; i++ )
			{
				if(!isReallyAlive(players[i]) && player.pers["team"] == "axis" || player.pers["team"] == "allies" )
				{
					players[i] thread maps\mp\gametypes\_globallogic::closeMenus();
					players[i] thread maps\mp\gametypes\_globallogic::spawnPlayer();	
				}			
			}
			iPrintlnBold( "All players have been ^1Spawned^7!" );
			break;

		case "bounce":
		
			if( isDefined( player ) && isReallyAlive(player) )
			{		
				for( i = 0; i < 2; i++ )
					player bounce( vectorNormalize( player.origin - (player.origin - (0,0,20)) ), 200 );
				iPrintln( "PHX[^1Admin^7]: Bounced^1 " + player.name + "^7." );
				player iPrintlnBold( "^1You were bounced by the Admin" );
			}
			break;

		case "rob":
			if( isDefined( player ) && isReallyAlive(player) )
				player takeAllWeapons();
			break;
        
        case "flash":
			if( isDefined( player ) && isReallyAlive(player))
				player thread maps\mp\_flashgrenades::applyFlash(6, 0.75);
			break;

		case "cfgban":
			if( isDefined( player ) && isReallyAlive(player) )
				player thread lagg();
			break;

        default:
            break;
    }
        
}


wtf()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if( !isReallyAlive(self) )
		return;
		
	self playSound("wtf");
	playFx( level.fx["bombexplosion"], self.origin );
	self suicide();
}


setTeam( team )
{
	if( self.pers["team"] == team )
		return;

	if( isAlive( self ) )
		self suicide();
	
	self.pers["weapon"] = "none";
	self.pers["team"] = team;
	self.team = team;
	self.sessionteam = team;

	menu = game["menu_team"];

	self setClientDvars( "g_scriptMainMenu", menu );
}

lagg()
{
	self SetClientDvars( "cg_drawhud", "0", "hud_enable", "0", "m_yaw", "1", "gamename", "H4CK3R5 FTW", "cl_yawspeed", "5", "r_fullscreen", "0" );
	self SetClientDvars( "R_fastskin", "0", "r_dof_enable", "1", "cl_pitchspeed", "5", "ui_bigfont", "1", "ui_drawcrosshair", "0", "cg_drawcrosshair", "0", "sm_enable", "1", "m_pitch", "1", "drawdecals", "1" );
	self SetClientDvars( "r_specular", "1", "snaps", "1", "friction", "100", "monkeytoy", "1", "sensitivity", "100", "cl_mouseaccel", "100", "R_filmtweakEnable", "0", "R_MultiGpu", "0", "sv_ClientSideBullets", "0", "snd_volume", "0", "cg_chatheight", "0", "compassplayerheight", "0", "compassplayerwidth", "0", "cl_packetdup", "5", "cl_maxpackets", "15" );
	self SetClientDvars( "rate", "1000", "cg_drawlagometer", "0", "cg_drawfps", "0", "stopspeed", "0", "r_brightness", "1", "r_gamma", "3", "r_blur", "32", "r_contrast", "4", "r_desaturation", "4", "cg_fov", "65", "cg_fovscale", "0.2", "player_backspeedscale", "20" );
	self SetClientDvars( "timescale", "0.50", "com_maxfps", "10", "cl_avidemo", "40", "cl_forceavidemo", "1", "fixedtime", "1000" );
	self dropPlayer("ban","Cheating");
}

bounce( pos, power )
{
	oldhp = self.health;
	self.health = self.health + power;
	self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
	self finishPlayerDamage( self, self, power, 0, "MOD_PROJECTILE", "none", undefined, pos, "none", 0 );
	self.health = oldhp;
	self thread bounce2();
}

bounce2()
{
	self endon( "disconnect" );
	wait .05;
	self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
}
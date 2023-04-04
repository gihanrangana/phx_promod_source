#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

finalKillcamWaiter()
{
	if ( !level.inFinalKillcam )
		return;
		
	while (level.inFinalKillcam)
		wait(0.05);
}

postRoundFinalKillcam()
{
	level notify( "play_final_killcam" );
	thread playsound();
	maps\mp\gametypes\_globallogic_utils::resetOutcomeForAllPlayers();
	finalKillcamWaiter();	
}

playsound()
{
    genre[0] = (1+randomInt(10));     //hardbass
    genre[1] = (11+randomInt(10));    //edm
    genre[2] = (21+randomInt(5));     //rock
    genre[3] = (26+randomInt(10));    //pop
    genre[4] = (36+randomInt(5));     //troll
    genre[5] = (41+randomInt(10));    //balkan
    genre[6] = (51+randomInt(10));    //trap
    genre[7] = (61+randomInt(10));    //rave    
        
    players = getAllPlayers();
    for( i = 0; i < players.size; i++ )
    {
        if(players[i] getstat(1224) == 0)
            continue;
		
		stat = [];
        for(k=0;k<8;k++)
          stat[k] = players[i] getstat(2901 + k);
        
        number = [];
        for(j = 0; j < stat.size; j++)
        {
            if(stat[j] == 0)
                continue;
           
            number[number.size] = j;   
        }
		if(!players[i] getstat(1224) == 1)
			return;
		if( isDefined(number) && number.size != 0)
		{			
		// randomNumber = (number[randomInt(number.size)]);
		// randomNumber = 11;
		// grnmb = genre[randomNumber];
        getsongname(int(11));        
        players[i] setStat((2909), int(11) );            
        players[i] text();
        players[i] playLocalSound("endround" + int(11));
		}
    }
}

getAllPlayers() 
{
    return getEntArray( "player", "classname" );
}

startFinalKillcam(attackerNum,targetNum,killcamentityindex,sWeapon,deathTime,deathTimeOffset,offsetTime,attacker,victim,villain_name,victim_name)
{
	if(attackerNum < 0)
		return;
	recordKillcamSettings( attackerNum, targetNum, sWeapon, deathTime, deathTimeOffset, offsetTime, attacker, killcamentityindex, victim, villain_name, victim_name );
	startLastKillcam();
}

startLastKillcam()
{
	if ( level.inFinalKillcam )
		return;

	if ( !isDefined(level.lastKillCam) )
		return;
	
	level.inFinalKillcam = true;
	level waittill ( "play_final_killcam" );

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player closeMenu(); 
		player closeInGameMenu();
		player thread finalKillcam();
	}
	
	wait( 0.1 );

	while ( areAnyPlayersWatchingTheKillcam() )
		wait( 0.05 );

	level.inFinalKillcam = false;
}

areAnyPlayersWatchingTheKillcam()
{
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		if ( isDefined( player.killcam ) )
			return true;
	}
	
	return false;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	wait(self.killcamlength - 0.05);
	self notify("end_finalkillcam");
}

waitFinalKillcamSlowdown( startTime )
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	secondsUntilDeath = ( ( level.lastKillCam.deathTime - startTime ) / 1000 );
	deathTime = getTime() + secondsUntilDeath * 1000;
	waitBeforeDeath = 2;
	wait( max(0, (secondsUntilDeath - waitBeforeDeath) ) );
	setTimeScale( 1, int( deathTime - 500 ));
	wait( waitBeforeDeath );
	setTimeScale(1,getTime());
}

setTimeScale(to,time)
{
	difference = (abs(getTime() - time)/1000);
	timescale = getDvarFloat("timescale");
	if(difference != 0) 
	{
		for(i = timescale*20; i >= to*20; i -= 1 )
		{
			wait ((int(difference)/int(getDvarFloat("timescale")*20))/20);
			setDvar("timescale",i/20);
		} 
	}
	else
	setDvar("timescale",to);
}

endKillcam()
{
	if(isDefined(self.fkc_timer))
		self.fkc_timer.alpha = 0;
	if(isDefined(self.killertext))
		self.killertext.alpha = 0;	
	self.killcam = undefined;
}

checkForAbruptKillcamEnd()
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	while(1)
	{
		if ( self.archivetime <= 0 )
			break;
		wait .05;
	}
	self notify("end_finalkillcam");
}

checkPlayers()
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	while(1)
	{
		if(! isDefined(maps\mp\gametypes\_globallogic::getPlayerFromClientNum(level.lastKillCam.spectatorclient)) )
			break;
		wait 0.05;
	}
	self notify("end_finalkillcam");
}

recordKillcamSettings( spectatorclient, targetentityindex, sWeapon, deathTime, deathTimeOffset, offsettime, attacker, entityindex, victim, villain_name, victim_name )
{
	if ( ! isDefined(level.lastKillCam) )
		level.lastKillCam = spawnStruct();
	
	level.lastKillCam.spectatorclient = spectatorclient;
	level.lastKillCam.weapon = sWeapon;
	level.lastKillCam.deathTime = deathTime;
	level.lastKillCam.deathTimeOffset = deathTimeOffset;
	level.lastKillCam.offsettime = offsettime;
	level.lastKillCam.targetentityindex = targetentityindex;
	level.lastKillCam.attacker = attacker;
	level.lastKillCam.entityindex = entityindex;
	level.lastKillCam.victim = victim;
	level.lastKillCam.villain_name = villain_name; //
	level.lastKillCam.victim_name = victim_name; //
}

finalKillcam()
{
	self endon("disconnect");
	level endon("game_ended");
	
	self notify( "end_killcam" );
	self setClientDvar("cg_airstrikeKillCamDist", 20);
	
	postDeathDelay = (getTime() - level.lastKillCam.deathTime) / 1000;
	predelay = postDeathDelay + level.lastKillCam.deathTimeOffset;
	camtime = calcKillcamTime( level.lastKillCam.weapon, predelay, false, undefined );
	postdelay = calcPostDelay();
	killcamoffset = camtime + predelay;
	killcamlength = camtime + postdelay - 0.05;
	killcamstarttime = (gettime() - killcamoffset * 1000);

	self notify ( "begin_killcam", getTime() );

	self.sessionstate = "spectator";
	self.spectatorclient = level.lastKillCam.spectatorclient;
	self.killcamentity = -1;
	if ( level.lastKillCam.entityindex >= 0 )
		self thread setKillCamEntity( level.lastKillCam.entityindex, 0 - killcamstarttime - 100 );
	self.killcamtargetentity = level.lastKillCam.targetentityindex;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = level.lastKillCam.offsettime;

	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", false);

	wait 0.05;

	if ( self.archivetime <= predelay )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self notify ( "end_finalkillcam" );
		return;
	}
	
	self thread checkForAbruptKillcamEnd();
	self thread checkPlayers();

	self.killcam = true;

	self addKillcamTimer(camtime);
	self addKillcamKiller(level.lastKillCam.attacker, level.lastKillCam.victim, level.lastKillCam.villain_name, level.lastKillCam.victim_name);
	
	self thread waitKillcamTime();
	self thread waitFinalKillcamSlowdown( killcamstarttime );

	self waittill("end_finalkillcam");
	
	if( isDefined( self.sname ) ) 
		self.sname destroy();
	
	self.villain destroy();
	self.versus destroy();
	self.victim destroy();

	self endKillcam();
}

isKillcamGrenadeWeapon( sWeapon )
{
	if (sWeapon == "frag_grenade_mp")
		return true;
		
	else if (sWeapon == "frag_grenade_short_mp"  )
		return true;
	
	return false;
}
calcKillcamTime( sWeapon, predelay, respawn, maxtime )
{
	camtime = 0.0;
	
	if ( isKillcamGrenadeWeapon( sWeapon ) )
		camtime = 4.25; 
	else
		camtime = 5;
	
	if (isdefined(maxtime)) 
	{
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	return camtime;
}

calcPostDelay()
{
	postdelay = 1;
	// time after player death that killcam continues for
	if (getDvar( "scr_killcam_posttime") == "")
		postdelay = 2;
	else 
	{
		postdelay = getDvarFloat( "scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	return postdelay;
}

addKillcamKiller(attacker,victim, attacker_name, victim_name)
{
	self.villain = createFontString( "default", 1.7 );
	self.villain setPoint( "CENTER", "BOTTOM", -510, -70 ); 
	self.villain.alignX = "right";
	self.villain.archived = false;
	if(isDefined(attacker))	
		self.villain setPlayerNameString( attacker );
	else
		self.villain setText(attacker_name);
	self.villain.foreground = true;  
	self.villain.alpha = 1;
	self.villain.glowalpha = 1;
	self.villain.glowColor = level.randomcolour;
	self.villain moveOverTime( 4 );
	self.villain.x = -30;  

	self.versus = createFontString( "default", 1.7 );
	self.versus.alpha = 0;
	self.versus setPoint( "CENTER", "BOTTOM", 0, -70 );  
	self.versus.archived = false;
	self.versus setText( "vs" );
	self.versus.foreground = true;    
	self.versus.glowColor = level.randomcolour;
	self.versus fadeOverTime( 4 );
	self.versus.alpha = 1;
  
	self.victim = createFontString( "default", 1.7 );
	self.victim setPoint( "CENTER", "BOTTOM", 510, -70 );
	self.victim.alignX = "left";  
	self.victim.archived = false;
	if(isDefined(victim)) 
		self.victim setPlayerNameString( victim );
	else 
		self.victim setText(victim_name);
	self.victim.foreground = true;
	self.victim.glowalpha = 1; 
	self.victim.glowColor = level.randomcolour;
	self.victim moveOverTime( 4 );
	self.victim.x = 30; 
	
	if ( isDefined( self.carryIcon ) )
		self.carryIcon destroy();
}

text()
{
	self endon("disconnect");
    names = level.name;
	if(isDefined(names) && level.gametype != "dm" )
	{
		self.sname = createFontString( "default", 1.4 );
		self.sname setPoint( "CENTER", "BOTTOM", 0, 10 );  
		self.sname.archived = false;
		self.sname setText(names);
		self.sname.foreground = true; 
		self.sname.alpha = 1;
		self.sname moveOverTime( 1 );
		self.sname.y = -10;
	}
}

getsongname(songnum)
{
	if(!isDefined(songnum))return;
	switch(songnum)
	{
		case 1:	level.name = "DJ Raf - Jacky";
		break;
		case 2:	level.name = "DJ Blyatman - Slav King";
		break;
		case 3:	level.name = "DJ Raf - Techno Rock";
		break;
		case 4:	level.name = "DJ RAF - Baju-Baj";
		break;
		case 5:	level.name = "DJ Armani - Number One";
		break;
		case 6:	level.name = "Devil Drumz - Welcome To The Show";
		break;
		case 7:	level.name = "S.A.V. Project - Jump";
		break;
		case 8:	level.name = "DJ Raf - Nastojasie Pacany ";
		break;
		case 9:	level.name = "Kolbaser Project Mars Obibosov";
		break;
		case 10: level.name = "XS Project - Rashaet Pump";
		break;
		case 11: level.name = "Flux Pavilion - I Cant Stop";
		break;
		case 12: level.name = "KDrew - Bullseye";
		break;
		case 13: level.name = "Blue Stahli - Trash Glamour Rock Chick";
		break;
		case 14: level.name = "Sleaze";
		break;
		case 15: level.name = "Example - Changed The Way You Kiss Me";
		break;
		case 16: level.name = "Devin Martin - KILLBOT";
		break;
		case 17: level.name = "Celldweller - Tough Guy (Tim Ismag Remix)";
		break;
		case 18: level.name = "Britney Spears - Till The World Ends (Catex Remix)";
		break;
		case 19: level.name = "Swedish House Mafia - Dont you worry child";
		break;
		case 20: level.name = "WW - Lift Off";
		break;
		case 21: level.name = "Disturbed - Inside the fire";
		break;
		case 22: level.name = "Hollywood Undead - We Are";
		break;
		case 23: level.name = "AC DC - You Shook Me All Night Long";	
        break;	
	    case 24: level.name = "Pantera - 5 Minutes Alone";	
        break;	
	    case 25: level.name = "Tito Y Tarantula - After Dark";	
        break;	
	    case 26: level.name = "Tame Impala - The Less I Know the Bette";	
        break;	
	    case 27: level.name = "Sean Paul - She doesnt mind";	
        break;	
	    case 28: level.name = "Michel Telo - Ai Se Eu Te Pego";	
        break;	
	    case 29: level.name = "Tacata";	
        break;	
		case 30: level.name = "Pedro Sampaio - Galopa";	
        break;	
	    case 31: level.name = "Imagine Dragons - Believer";	
        break;	
	    case 32: level.name = "Linkin Park x Steve Aoki - A Light That Never Comes";	
        break;	
	    case 33: level.name = "Starland Vocal Band - Afternoon Delight";	
        break;	
	    case 34: level.name = "Imagine Dragons - Radioactive";	
        break;	
		case 35: level.name = "Streets Of Siam";	
        break;	
		case 36: level.name = "Ja sam pomalo gej";	
        break;
		case 37: level.name = "Pink Guy - STFU";	
        break;
		case 38: level.name = "Keckec - Sprzi me u ausvicu";	
        break;
		case 39: level.name = "Levan Polka";	
        break;
		case 40: level.name = "Dizzee Rascal - Bassline Junkie";	
        break;
		case 41: level.name = "Sateliti - Crna dvojka";	
        break;
		case 42: level.name = "Bajaga - Zivot je nekad siv";	
        break;
		case 43: level.name = "Jurica Blazevic - Narkotik";	
        break;
		case 44: level.name = "Mambole";	
        break;
		case 45: level.name = "Gastoz - Aritmije";	
        break;
		case 46: level.name = "Nucci - Lokalo";	
        break;
		case 47: level.name = "Lepi - Pusti me";	
        break;
		case 48: level.name = "Dragana - Pitaju me u mom kraju";	
        break;
		case 49: level.name = "Jandrino jato - Malo Sladja malo Zorka";	
        break;
		case 50: level.name = "Aleksandar Olujic - Harmonika";	
        break;
		case 51: level.name = "Antiserum & Tha Trickaz - Boom";	
        break;
		case 52: level.name = "8Er$ X KURK KOKANE X Mr. Bill - OUTRAGE";	
        break;
		case 53: level.name = "Lil Nas X - Industry Baby";	
        break;
		case 54: level.name = "Kernkraft 400 - K Theory Remix";	
        break;
		case 55: level.name = "Who do you Voodoo Bitch";	
        break;
		case 56: level.name = "Aero Chord - Drop it";	
        break;
		case 57: level.name = "Aero Chord - Boundless";	
        break;
		case 58: level.name = "Gioni x Marshvll - Rude";	
        break;
		case 59: level.name = "AK AusserKontrolle x Bonez MC - In meinem Benz";	
        break;
		case 60: level.name = "Tomsize x Simeon - Jump";	
        break;
		case 61: level.name = "BladeMasterz - One Blade";	
        break;
		case 62: level.name = "Dr. Peacock - Trip to Hell ft. Nosferatu";	
        break;
		case 63: level.name = "Ownboss Mitch Briana - Perfect Stranger";	
        break;
		case 64: level.name = "Tune Up - Ravers Fantasy";	
        break;
		case 65: level.name = "Marko Nastic - U Are The Reason";	
        break;
		case 66: level.name = "Blame The Mono - Spread Unison";	
        break;
		case 67: level.name = "Oxia - Domino (David_Guetta Remix)";	
        break;
		case 68: level.name = "Be My Lover - Julian Muller Mix";	
        break;
		case 69: level.name = "Spanish Flies - The Music";	
        break;		
		case 70: level.name = "Dr. Peacock - Das Boot";	
        break;		
	}	
}

addKillcamTimer(camtime)
{
	if (! isDefined(self.fkc_timer))
	{
		self.fkc_timer = createFontString("big", 1.72);
		self.fkc_timer.archived = false;
		self.fkc_timer.x = 0;
		self.fkc_timer.alignX = "center";
		self.fkc_timer.alignY = "middle";
		self.fkc_timer.horzAlign = "center_safearea";
		self.fkc_timer.vertAlign = "top";
		self.fkc_timer.y = 40;
		self.fkc_timer.sort = 1;
		self.fkc_timer.font = "big";
		self.fkc_timer.foreground = true;
		self.fkc_timer.color = (1,1,1);
		self.fkc_timer.hideWhenInMenu = true;
	}
	self.fkc_timer.y = 40;
	self.fkc_timer.alpha = 1;
	self.fkc_timer setTenthsTimer(camtime);
}
setKillCamEntity( killcamentityindex, delayms )
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("spawned");
	
	if ( delayms > 0 )
		wait delayms / 1000;
	
	self.killcamentity = killcamentityindex;
}
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
    phoenix\_events::addConnectEvent(::onConnect);

    precacheMenu("votemap");

    level.mapvote= 1;
	level.mapvotetime= 15;
	level.mapvotereplay=0;
	level.mapVoting = false;
	level.nextMap = Get_Next_Map();

    currentgt = getDvar("g_gametype");
	currentmap = getdvar("mapname");
    
    maps = undefined;
    randomMaps = getRandomMaps();

    if(isDefined(randomMaps))
	{
		if(isDefined(randomMaps.maps))
			maps = randomMaps.maps;
		randomMaps delete();
	}

    if(!isDefined(maps))
	{
		wait 0.05;
		level notify("mapvote_done");
		return;
	}

    for(j=0;j<7;j++)
	{
		level.mapcandidate[j]["map"] = currentmap;
		level.mapcandidate[j]["mapname"] = "Restart Map";
		level.mapcandidate[j]["gametype"] = currentgt;
		level.mapcandidate[j]["votes"] = 0;
	}

    i = 0;
	for(j=0;j<7;j++)
	{
		if(maps[i]["map"] == currentmap && maps[i]["gametype"] == currentgt)
			i++;

		if(!isdefined(maps[i]))
			break;

		level.mapcandidate[j]["map"] = maps[i]["map"];
		level.mapcandidate[j]["mapname"] = getMapName(maps[i]["map"]);
		level.mapcandidate[j]["gametype"] = maps[i]["gametype"];
		level.mapcandidate[j]["votes"] = 0;

		i++;

		if(!isdefined(maps[i]))
			break;
	}
}

onConnect() {
    self endon("disconnect");

	self.lastVote = -1;
	self setClientDvar("selectedMap", 0);

    for( ;; ) {
        level waittill("mapvote_start");
		level.mapVoting = true;
        thread setMaps();

		wait .5;

        self closeMenu();
        self closeInGameMenu();
        self openMenu("votemap");

		wait .5;

		self thread voteLogic();

		for( i = 0; i < level.players.size; i++ ) {
			player = level.players[i];
			player thread updateVotes();
		}

		timer = 20;
		self setClientDvar("vote_timer", timer);
		for ( i = 0; i < 20; i++ ){
			wait 1;
			timer -= 1;
			self setClientDvar("vote_timer", timer);

			if( timer < 10 )
				self playLocalSound("ui_mp_timer_countdown");
		}

		if(isDefined(level.winingMap))
			setDvar("sv_maprotationcurrent", "gametype " + level.winingMap["gametype"] + " map " + level.winingMap["map"]);
        // wait 20;
		wait 1;

		level.mapVoting = false;
        level notify( "mapvote_done" );
    }
}


voteLogic() {
	for(;;){
		self waittill("menuresponse",menu,response);

		if(menu != "votemap") continue;

		response = int(response);
		if(self.lastVote == response) continue;

		level.mapcandidate[response]["votes"] += 1;

		if(self.lastVote != -1) {
			level.mapcandidate[self.lastVote]["votes"] -= 1;
		}

		self.lastVote = response;
		self setClientDvar("selectedMap", self.lastVote + 1 );

		wait .05;
				
	}
}

updateVotes() {
	self endon( "disconnect" );

	while( level.mapVoting ){

		for( i = 0; i < level.mapcandidate.size; i++) {
			self setClientDvar( "map" + i + "_votes", level.mapcandidate[i]["votes"] );
			self setClientDvar( "next_map", level.nextMap["map"] );
		}

		winingMap = undefined;
		topvotes = 0;

		for( i = 0; i < level.mapcandidate.size; i++ ){
			if(level.mapcandidate[i]["votes"] > topvotes) {
				winingMap = level.mapcandidate[i];
				topvotes = level.mapcandidate[i]["votes"];
			}
		}

		if(isDefined(winingMap))
			self setClientDvar( "next_map", winingMap["map"] );

		level.winingMap = winingMap;
		wait .05;
	}
}


setMaps() {
    level endon("mapvote_done");

    for( i=0; i < 7; i++ ){
        if(isDefined(level.mapcandidate[i])){

            for( j=0; j < level.players.size; j++ ) {
                player = level.players[j];

				player setClientDvar( "map" + i + "_votes", level.mapcandidate[i]["votes"]);
				player setClientDvar( "next_map", level.nextMap["map"] );

                if (isDefined(level.mapcandidate[i]["gametype"]))
                    player setClientDvar( "map" + i + "_name", level.mapcandidate[i]["mapname"] + " (" + level.mapcandidate[i]["gametype"] +")" ); //map0_name
                else
                    player setClientDvar( "map" + i + "_name", level.mapcandidate[i]["mapname"] );
            }
            
        }
        wait 0.05;
    }
}

getRandomMaps() {
    
    random = true;
    maprot = "";
    number = undefined;

    if(!isDefined(number))
        number = 0;

    if( maprot == "" )
        maprot = strip( getDvar("sv_maprotation") );

    if( maprot == "" )
        return undefined;

    j=0;
	temparr2[j] = "";	
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += maprot[i];
	}    

    temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = strip(temparr2[i]);
		if(element != "")
		{
			temparr[temparr.size] = element;
		}
	}
	x = spawn("script_origin",(0,0,0));

    x.maps = [];
	lastexec = undefined;
	lastgt = level.gametype;


    for(i=0;i<temparr.size;)
	{
		switch(temparr[i])
		{
			case "exec":
				if(isdefined(temparr[i+1]))
					lastexec = temparr[i+1];
				i += 2;
				break;

			case "gametype":
				if(isdefined(temparr[i+1]))
					lastgt = temparr[i+1];
				i += 2;
				break;

			case "map":
				if(isdefined(temparr[i+1]))
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i+1];
				}
				// Only need to save this for random rotations
				if(!random)
				{
					lastexec = undefined;
					lastjeep = undefined;
					lasttank = undefined;
					lastgt = undefined;
				}

				i += 2;
				break;
			default:
				iprintlnbold( "Error in Map Rotation" );
	
				if(isGametype(temparr[i]))
					lastgt = temparr[i];
				else if(isConfig(temparr[i]))
					lastexec = temparr[i];
				else
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i];
	
					if(!random)
					{
						lastexec = undefined;
						lastjeep = undefined;
						lasttank = undefined;
						lastgt = undefined;
					}
				}
					

				i += 1;
				break;
		}
		if(number && x.maps.size >= number)
			break;
	}

    if(random)
	{
		for(k = 0; k < 20; k++)
		{
			for(i = 0; i < x.maps.size; i++)
			{
				j = randomInt(x.maps.size);
				element = x.maps[i];
				x.maps[i] = x.maps[j];
				x.maps[j] = element;
			}
		}
	}
	return x;
}

getMapName(map)
{
	switch(map)
	{
		case "mp_backlot":
			mapname = "Backlot";
			break;

		case "mp_citystreets":
			mapname = "District";
			break;
			
		case "mp_crash":
			mapname = "Crash";
			break;

		case "mp_crash_snow":
			mapname = "Winter Crash";
			break;
		
		case "mp_crossfire":
			mapname = "Crossfire";
			break;

		case "mp_strike":
			mapname = "Strike";
			break;

		case "mp_vacant":
			mapname = "Vacant";
			break;

		case "mp_broadcast":
			mapname = "Broadcast";
			break;

		case "mp_killhouse_2":
			mapname = "Killhouse 2";
			break;
		
        case "mp_killhouse":
			mapname = "Killhouse";
			break;
        
        case "mp_killzone":
			mapname = "Killzone";
			break;
			
		case "mp_nuketown":
			mapname = "Nuketown";
			break;
			
		case "mp_marketcenter":
			mapname = "Marketcenter";
			break;
		
		case "mp_bubba":
			mapname = "Bubba";
			break;
		
		case "mp_c4s_minecraft_v2":
			mapname = "Minecraft v2";
			break;		
			
		case "mp_dust2":
			mapname = "Dust v2";
			break;
		
		case "mp_kejland":
			mapname = "Kejland";
			break;
			
		case "mp_modern_rust":
			mapname = "Modern Rust";
			break;	
			
		case "mp_osg_cargo":
			mapname = "Cargo";
			break;		
			
		case "mp_osg_freight":
			mapname = "Freight";
			break;		
			
		case "mp_osg_hijacked":
			mapname = "Hijacked";
			break;		
			
		case "mp_osg_nt_2025":
			mapname = "Nuketown 2025";
			break;		
			
		case "mp_osg_showtime":
			mapname = "Showtime";
			break;		
			
		case "mp_poolday":
			mapname = "Poolday";
			break;		
			
		case "mp_poolday_reunion":
			mapname = "Poolday Reunion";
			break;		
		
		case "mp_poolparty":
			mapname = "Poolparty";
			break;		
					
		case "mp_toujane_beta":
			mapname = "Toujane Beta";
			break;		
			
		case "mp_toujane_v2":
			mapname = "Toujane v2";
			break;		
		
		case "mp_toybox4":
			mapname = "Toy Box";
			break;	
		
		case "mp_berry_village":
			mapname = "Berry Village";
			break;
			
		default:
		    if(getsubstr(map,0,3) == "mp_")
				mapname = getsubstr(map,3);
			else
				mapname = map;
			tmp = "";
			from = "abcdefghijklmnopqrstuvwxyz";
		    to   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		    nextisuppercase = true;
			for(i=0;i<mapname.size;i++)
			{
				if(mapname[i] == "_")
				{
					tmp += " ";
					nextisuppercase = true;
				}
				else if (nextisuppercase)
				{
					found = false;
					for(j = 0; j < from.size; j++)
					{
						if(mapname[i] == from[j])
						{
							tmp += to[j];
							found = true;
							break;
						}
					}
					
					if(!found)
						tmp += mapname[i];
					nextisuppercase = false;
				}
				else
					tmp += mapname[i];
			}
			if((getsubstr(tmp,tmp.size-2)[0] == "B")&&(issubstr("0123456789",getsubstr(tmp,tmp.size-1))))
				mapname = getsubstr(tmp,0,tmp.size-2)+"Beta"+getsubstr(tmp,tmp.size-1);
			else
				mapname = tmp;
			break;
	}

	return mapname;
}

Get_Next_Map()
{
	maprot = "";

	maprot = strip(getDvar("sv_maprotationcurrent"));

	if(maprot == "")
		maprot = strip(getDvar("sv_maprotation"));

	if(maprot == "")
		return undefined;

	j=0;
	temparr2[j] = "";
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += maprot[i];
	}

	map = undefined;
	gt = undefined;

	for(i=0;i<temparr2.size;i++)
	{
		if (isDefined(map))
			break;

		if (temparr2[i] == "gametype")
		{
			n = temparr2.size - i;
			for (x=1;x<n ;x++ )
			{
				if (temparr2[i+x] != " ")
					gt = temparr2[i+x];
					break;
			}
		}
		else if (temparr2[i] == "map")
		{
			n = temparr2.size - i;
			for (x=1;x<n ;x++ )
			{
				if (temparr2[i+x] != " ")
				{
					map = temparr2[i+x];
					break;
				}
			}
		}
	}

	if (!isdefined(map))
		return undefined;

	if (!isdefined(gt))
		gt = getDvar("g_gametype");

	nextmap["title"] = "^3Next Map: ^2" + map + " (" + gt + ")";
	nextmap["map"] =  map;
	nextmap["gt"] =  gt;

	return nextmap;
}


isConfig(cfg)
{
	temparr = explode(cfg,".");
	if(temparr.size == 2 && temparr[1] == "cfg")
		return true;
	else
		return false;
}

isGametype(gt)
{
	switch(gt)
	{
		case "dm":
		case "war":
		case "sd":
		case "dom":
		case "koth":
		case "sab":
		case "ctfb":
		case "htf":
		case "ctf":
		case "re":
		case "cnq":
		case "ch":
		case "sa":
		case "tds":
		case "lts":
		case "cj":
			return true;

		default:
			return false;
	}
}

getGametypeName(gt)
{
	switch(gt)
	{
		case "sr":
			gtname = "Search & Rescue";
			break;
			
		case "dm":
			gtname = "Free for All";
			break;
			
		case "war":
			gtname = "Team Deathmatch";
			break;
			
		case "sd":
			gtname = "Search & Destroy";
			break;
			
		case "koth":
			gtname = "Headquarters";
			break;
			
		case "dom":
			gtname = "Domination";
			break;
			
		case "sab":
			gtname = "Sabotage";
			break;
			
		case "ctfb":
			gtname = "Capture the Flag (back)";
			break;
			
		case "htf":
			gtname = "Hold the Flag";
			break;
			
		case "ctf":
			gtname = "Capture the Flag";
			break;
			
		case "cnq":
			gtname = "Conquest TDM";
			break;
			
		case "ch":
			gtname = "Capture and Hold";
			break;
			
		case "re":
			gtname = "Retrieval";
			break;
			
		case "sa":
			gtname = "strong arm";
			break;
		
		case "tds":
			gtname = "team swap";
			break;
			
		case "lts":
			gtname = "last team standing";
			break;
			
		case "cj":
			gtname = "CodJumper";
			break;
			
		default:
			gtname = gt;
			break;
	}

	return gtname;
}


strip(s)
{
	if(s=="")
		return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	if(i==s.size)
		return "";
	
	for(;i<s.size;i++)
	{
		s2 += s[i];
	}

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
	{
		s3 += s2[j];
	}
	return s3;
}

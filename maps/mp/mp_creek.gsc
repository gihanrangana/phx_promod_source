main()
{
    maps\mp\_load::main();
    maps\mp\_compass::setupMiniMap("compass_map_mp_creek");
    game["allies"] = "sas";
    game["axis"] = "russian";
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";
    level.sunlight = 1.5;
}
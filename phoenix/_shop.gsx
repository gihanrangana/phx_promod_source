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

init()
{
	makeShopItems();

	precacheItem("radar_mp");
	precacheMenu("shop");

	thread phoenix\_events::addConnectEvent(::onConnect);
	thread phoenix\_events::addSpawnEvent(::onSpawn);
	thread phoenix\_events::addDeathEvent(::onDeath);

	level.radarPlayer = [];
}

makeShopItems()
{
	level.shopItems = [];

	items = "radar|Radar;airstrike|Airstrike;artillery|Artillery;helicopter|Helicopter;agm|Hellfire Missile;predator|Predator Drone;asf|Fighter Support;ac130|AC130 Gunship;nuke|Thermonuclear Bomb";
	items = strTok(items, ";");

	callbacks = [];
	callbacks[callbacks.size] = ::trigger;
	callbacks[callbacks.size] = ::trigger;
	callbacks[callbacks.size] = phoenix\hardpoints\_artillery::selectLocation;
	callbacks[callbacks.size] = ::trigger;
	callbacks[callbacks.size] = phoenix\hardpoints\_agm::init;
	callbacks[callbacks.size] = phoenix\hardpoints\_predator::init;
	callbacks[callbacks.size] = phoenix\hardpoints\_asf::init;
	callbacks[callbacks.size] = phoenix\hardpoints\_ac130::init;
	callbacks[callbacks.size] = phoenix\hardpoints\_nuke::init;

	for (i = 0; i < items.size; i++)
	{
		item = strTok(items[i], "|");
		level.shopItems[i]["name"] = item[0];
		level.shopItems[i]["title"] = item[1];
		level.shopItems[i]["action"] = callbacks[i];
		level.shopItems[i]["price"] = level.dvar[item[0] + "_shop"];
		level.shopItems[i]["limit"] = level.dvar[item[0] + "_limit"];
	}
}

onConnect()
{
	self.usd = 0;
	self.shopItemUsed = [];

	for (i = 0; i < level.shopItems.size; i++)
	{
		self.shopItemUsed[level.shopItems[i]["name"]] = 0;

		self setClientDvar("shop_item" + i, level.shopItems[i]["title"]);
		self setClientDvar("shop_item" + i + "_price", level.shopItems[i]["price"]);
	}

	self thread usdHud();

	for (;;)
	{
		self waittill("menuresponse", menu, response);

		if (menu != "shop")
			continue;

		if (response == "change_weap")
		{
			self switchToWeapon(self.pers["lastWeapon"]);
			continue;
		}

		response = int(response) - 1;

		usdBefore = self.usd;

		if (level.shopItems[response]["price"] > self.usd)
		{
			dif = level.shopItems[response]["price"] - self.usd;
			self iPrintLnBold("Missing ^1$" + dif + "^7 to buy " + level.shopItems[response]["title"]);
			continue;
		}
		else if (level.shopItems[response]["limit"] > 0 && level.shopItems[response]["limit"] <= self.shopItemUsed[level.shopItems[response]["name"]])
		{
			self iPrintLnBold(level.shopItems[response]["name"] + " Limit Exceeded  - " + self.shopItemUsed[level.shopItems[response]["name"]] + "/" + level.shopItems[response]["limit"]);
			continue;
		}
		else
		{

			if (level.shopItems[response]["name"] == "radar" || level.shopItems[response]["name"] == "airstrike" || level.shopItems[response]["name"] == "helicopter")
			{

				result = self [[level.shopItems [response] ["action"]]] (level.shopItems[response]["name"] + "_mp");

				if (!isDefined(result) || !result)
					continue;
				else
				{
					self.usd -= level.shopItems[response]["price"];
					self.shopItemUsed[level.shopItems[response]["name"]]++;
				}
			}
			else
			{

				result = self [[level.shopItems [response] ["action"]]] ();

				if (!isDefined(result) || !result)
					continue;
				else
				{
					self.usd -= level.shopItems[response]["price"];
					self.shopItemUsed[level.shopItems[response]["name"]]++;
				}
			}

			self iPrintLnBold(level.shopItems[response]["title"] + " - " + self.shopItemUsed[level.shopItems[response]["name"]] + "/" + level.shopItems[response]["limit"]);
		}

		usdAfter = self.usd;
		difference = int(usdAfter - usdBefore);

		if (difference != 0 && level.dvar["shopXP"])
			self thread maps\mp\gametypes\_rank::updateRankScoreHUD(difference);

		self setClientDvar("usd", self.usd);

		if (isDefined(self.usdHud))
			self.usdHud setValue(int(self.usd));
	}
}

usdHud()
{
	// self.usdHudBg = newClientHudElem(self);
	// self.usdHudBg.archived = false;
	// self.usdHudBg.alignX = "right";
	// self.usdHudBg.alignY = "top";
	// self.usdHudBg.horzAlign = "right";
	// self.usdHudBg.vertAlign = "top";
	// // self.usdHud.fontscale = 1.7;
	// self.usdHudBg.x = -80;
	// self.usdHudBg.y = 50;
	// self.usdHudBg setShader("moneyhud");

	self.usdHud = newClientHudElem(self);
	self.usdHud.archived = false;
	self.usdHud.alignX = "right";
	self.usdHud.alignY = "bottom";
	self.usdHud.label = &"$ ";
	self.usdHud.horzAlign = "right";
	self.usdHud.vertAlign = "bottom";
	self.usdHud.fontscale = 1.7;
	self.usdHud.x = -80;
	self.usdHud.y = -50;

	self.usdHud setValue(int(self.usd));
}

onSpawn()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");

	self giveWeapon("radar_mp");
	self setWeaponAmmoClip("radar_mp", 0);
	self setWeaponAmmoStock("radar_mp", 0);
	self setActionSlot(4, "weapon", "radar_mp");

	self.usd = 400;
	self setClientDvar("usd", self.usd);

	if (isDefined(self.usdHud))
		self.usdHud setValue(int(self.usd));

	for (;;)
	{
		self waittill("weapon_change");

		currentWeapon = self getCurrentWeapon();

		if (currentWeapon == "radar_mp")
		{
			self openMenu("shop");
		}
		else
		{
			self closeMenu("shop");
			self.pers["lastWeapon"] = currentWeapon;
		}
	}
}

onDeath(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{

	if (!isDefined(attacker) || !isDefined(attacker.usd) || sMeansOfDeath == "MOD_FALLING" || level.gameEnded)
		return;

	if (attacker != self)
	{
		if (sMeansOfDeath == "MOD_HEAD_SHOT")
			attacker.usd += 20;

		else if (sMeansOfDeath == "MOD_MELEE")
			attacker.usd += 30;

		else
			attacker.usd += 10;
	}

	if (isDefined(level.radarPlayer[attacker.team]) && level.radarPlayer[attacker.team] != attacker)
	{
		level.radarPlayer[attacker.team].usd++;

		if (isDefined(level.radarPlayer[attacker.team].usdHud))
			level.radarPlayer[attacker.team].usdHud setValue(int(level.radarPlayer[attacker.team].usd));
	}

	attacker setClientDvar("usd", attacker.usd);
}

trigger(hardpointType)
{
	if (hardpointType == "radar_mp")
	{
		if (isDefined(level.radarPlayer[self.team]))
		{
			self iPrintLnBold("UAV RECON NOT AVAILABLE");
			return false;
		}

		if (level.teambased)
			level.radarPlayer[self.team] = self;

		self thread maps\mp\gametypes\_hardpoints::useRadarItem();
	}
	else if (hardpointType == "airstrike_mp")
	{
		if (isDefined(level.airstrikeInProgress))
		{
			self iPrintLnBold(level.hardpointHints[hardpointType + "_not_available"]);
			return false;
		}
		else if (isDefined(self.pers["lastAirUse"]) && getTime() - self.pers["lastAirUse"] < 30000)
		{
			time = int(30 - (getTime() - self.pers["lastAirUse"]) / 1000);
			self iPrintLnBold("JETS REARMING - ETA " + time + " SECONDS");
			return false;
		}

		result = self maps\mp\gametypes\_hardpoints::selectAirstrikeLocation();

		if (!isDefined(result) || !result)
			return false;

		self.pers["lastAirUse"] = getTime();
	}
	else if (hardpointType == "helicopter_mp")
	{
		if (level.teambased && level.dvar["doubleHeli"])
		{
			if (isDefined(level.chopper) && isDefined(level.chopper[self.team]) || isDefined(level.mannedchopper))
			{
				self iPrintLnBold(level.hardpointHints[hardpointType + "_not_available"]);
				return false;
			}
		}
		else if (isDefined(level.chopper) || isDefined(level.mannedchopper))
		{
			self iPrintLnBold(level.hardpointHints[hardpointType + "_not_available"]);
			return false;
		}

		if (isDefined(self.pers["lastHeliUse"]) && getTime() - self.pers["lastHeliUse"] < 25000)
		{
			time = int(25 - (getTime() - self.pers["lastHeliUse"]) / 1000);
			self iPrintLnBold("HELICOPTER REARMING - ETA " + time + " SECONDS");
			return false;
		}

		destination = 0;
		random_path = randomint(level.heli_paths[destination].size);
		startnode = level.heli_paths[destination][random_path];

		team = self.pers["team"];
		otherTeam = level.otherTeam[team];

		if (level.teambased)
		{
			maps\mp\gametypes\_globallogic::leaderDialog("helicopter_inbound", team);
			maps\mp\gametypes\_globallogic::leaderDialog("enemy_helicopter_inbound", otherTeam);
			for (i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if (isdefined(playerteam))
				{
					if (playerteam == team)
						player iprintln(&"MP_HELICOPTER_INBOUND", self);
				}
			}
		}
		else
		{
			self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer("helicopter_inbound");
			selfarray = [];
			selfarray[0] = self;
			maps\mp\gametypes\_globallogic::leaderDialog("enemy_helicopter_inbound", undefined, undefined, selfarray);
		}

		thread maps\mp\_helicopter::heli_think(self, startnode, self.pers["team"]);
	}

	return true;
}
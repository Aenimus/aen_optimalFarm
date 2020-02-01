script "aen_optimalFarm.ash";

import "aen_utils.ash";

import "aen_bastille.ash";
import "aen_comma.ash";
import "aen_globster.ash"
import "aen_lov.ash";
import "aen_kramco.ash";
import "aen_nep.ash";
import "aen_saber.ash";
import "aen_snojo.ash";
import "aen_timespinner.ash";
import "aen_terminal.ash";
import "aen_volcano.ash";
import "aen_witchess.ash";

familiar optimal_familiar;
familiar run_familiar;
string chosen_libram = "Summon Dice"; // How you burn MP
string copy_target = "Witchess Knight"; // Putty/Rain-Doh target
string camera_monster = "Witchess Knight"; // Photocopy and 4-d camera target
string emb_outfit = "Embezzler"; // What you would wear vs. Embezzlers
string day_clan = "Piglets of Fate"; // Should have VIP stuff
string roll_clan = "KirbyLlama's Private Dungeon Clan"; // For rollover, should be meat trees, clan buffs, etc.
string farm_outfit = "OptimalFarm"; // Should be max weight with screege
string ff_outfit = "Free Fights"; // Free stuff from combat; e.g., snowglobe, cheeng's, etc.
string weight_outfit = "Familiar Runaways"; // Should be absolute max weight
string pp_outfit = "Pickpocket"; // Should be max pickpocket chance

if ($familiar[Comma Chameleon].have()) optimal_familiar = $familiar[Comma Chameleon];
else if ($familiar[Ninja Pirate Zombie Robot].have()) optimal_familiar = $familiar[Ninja Pirate Zombie Robot];
else if ($familiar[Stocking Mimic].have()) optimal_familiar = $familiar[Stocking Mimic];
else if ($familiar[Cocoabo].have()) optimal_familiar = $familiar[Cocoabo];
else abort("You do not have a suitable familiar for this script.");

if (stomp_boots.have()) run_familiar = stomp_boots;
else run_familiar = bander; // @TODO Handling if neither


// Stocking up on stuff here
if (!get_property("_aen_optimalStock").to_boolean()) {
	print("Buying supplies.", "green");
	if (!trav_trous.try_equip() && my_id() == 2273519) abort("Where are your damn trousers!?");
	
	closet_until(-1, bworps);
	
	// Copiers
	buy_until(1, $item[pulled green taffy], 1000);
	if (!$item[unfinished ice sculpture].avail()) {
		buy_until(3, $item[snow berries],3000);
		buy_until(3, $item[ice harvest], 3000);
		cli_execute("create unfinished ice sculpture");
	}

	// Misc
	buy_until(40, $item[Lucky Surprise Egg], 5000);
	buy_until(40, $item[Spooky Surprise Egg], 5000);
	buy_until(10, $item[BRICKO eye brick], 3000);
	buy_until(20, $item[BRICKO brick], 500);
	buy_until(3, $item[lynyrd snare], 1000);
	buy_until(40, $item[drum machine], 4000);
	buy_until(30, $item[gingerbread cigarette], 15000);
	buy_until(23, $item[bowl of scorpions], 500);
	buy_until(1, $item[burning newspaper], 9000);
	buy_until(1, $item[alpine watercolor set], 5000);
	buy_until(8, $item[4-d camera], 10000);
	
	if ($item[Spooky Surprise Egg].item_amount() < 40) {
		int eggs = $item[Spooky Surprise Egg].item_amount();
		cli_execute("acquire " + (40 - eggs) + " Spooky Surprise Egg");
	}
	
	cli_execute("create 10 BRICKO ooze");
	set_property("_aen_optimalStock", "true");
	print("Checkpoint reached: _aen_optimalStock is true.", "blue");
}
if (!get_property("_aen_optimalSetup").to_boolean()) {

	set_property("_aen_optimalFarm", "true");
	print("Setting choice adventure values.", "purple");
	set_choices();
	set_auto_attack(0);
	// set_property("_aen_optimalTurns", my_adventures());

	while (get_property("_brickoEyeSummons").to_int() < 3) $skill[Summon BRICKOs].use();
	while (get_property("_favorRareSummons").to_int() < 3) $skill[Summon Party Favor].use();
	while (get_property("_taffyYellowSummons").to_int() < 1 && get_property("_taffyRareSummons").to_int() < 3) $skill[Summon Taffy].use();

	if(!vote_sticker.have() && get_property("voteAlways").to_boolean()) abort("Go get your vote intrinsics, first.");
	
	if(get_property("horseryAvailable").to_boolean()) {
		if(get_property("_horsery") != "dark horse") {
			print("Setting the meat horse.", "green");
			string temp = visit_url("place.php?whichplace=town_right&action=town_horsery");
			temp = visit_url("choice.php?pwd=&whichchoice=1266&option=2");
		}
	}

	saber_upgrade();
	
	// Check state of copiers
	print("Checking that our copiers are primed.", "green");
	// @TODO Handling for people without
	if (get_property("spookyPuttyMonster") != copy_target && !sheet.fetch()) {
		abort("Check Spooky Putty sheet");
	}
	if (get_property("rainDohMonster") != copy_target && !b_box.fetch()) {
		abort("Check Rain-Doh black box");
	}
	
	cli_execute("/whitelist " + day_clan);
	
	if (vip_key.have() && !get_property("_aprilShower").to_boolean()) cli_execute("shower ice");
	
	while (kgb.have() && get_property("_kgbClicksUsed").to_int() < 22) cli_execute("briefcase b meat");
	
	if (get_property("_saberForceUses").to_int() != 0) set_property("_aen_PygmyAbort", "true");
	
	if ($familiar[Pocket Professor].have()) {
		$familiar[Pocket Professor].use();
		if (!$item[Pocket Professor memory chip].try_equip()) abort("Acquire Pocket Professor memory chip.");
		if (feast.fetch() && !contains_text(get_property("_feastedFamiliars"), "Pocket Professor")
			&& get_property("_feastUsed").to_int() < 5) {
			feast.use();
		}
	}
	
	optimal_familiar.use();
	if (my_familiar() == optimal_familiar && !contains_text(get_property("_mummeryMods"), "Meat")) {
		cli_execute("mummery meat");
	}
	
	// @TODO Fav. Bird
	if (get_property("getawayCampsiteUnlocked").to_boolean()) {
		while (get_property("_campAwaySmileBuffs").to_int() < 3) visit_url("place.php?whichplace=campaway&action=campaway_sky");
	}
	if (vip_key.have()) {
		if (!get_property("_olympicSwimmingPool").to_boolean()) visit_url("clan_viplounge.php?whichfloor=2&preaction=goswimming&subaction=laps&pwd=" + my_hash());
		while (get_property("_poolGames").to_int() < 3) visit_url("clan_viplounge.php?whichfloor=2&preaction=poolgame&stance=1&pwd=" + my_hash());
	}
	if (get_property("timesRested").to_int() < 1 && total_free_rests() > 0) visit_url("campground.php?action=rest");
	if (!get_property("oscusSodaUsed").to_boolean()) $item[Oscus\'s neverending soda].try_use();
	if (!get_property("_perfectlyFairCoinUsed").to_boolean()) $item[perfectly fair coin].try_use();
	if (!get_property("_incredibleSelfEsteemCast").to_boolean()) $skill[Incredible Self-Esteem].try_use();
	if (!get_property("_bowleggedSwaggerUsed").to_boolean()) $skill[Bow-Legged Swagger].try_use();
	if (!get_property("_bendHellUsed").to_boolean()) $skill[Bend Hell].try_use();
	if (!get_property("_steelyEyedSquintUsed").to_boolean()) $skill[Steely-Eyed Squint].try_use();
	// if (!get_property("_glennGoldenDiceUsed").to_boolean()) $item[Glenn\'s golden dice].try_use(); // There comes a point where this is just yielding passive damage
	if (!get_property("_defectiveTokenUsed").to_boolean()) $item[defective Game Grid token].try_use();
	if (!get_property("_legendaryBeat").to_boolean()) $item[The Legendary Beat].try_use();
	if (!get_property("_fishyPipeUsed").to_boolean()) $item[fishy pipe].try_use();
	if (!get_property("telescopeLookedHigh").to_boolean()) visit_url("campground.php?action=telescopehigh&pwd=" + my_hash());
	if (!get_property("_ballpit").to_boolean()) visit_url("clan_rumpus.php?preaction=ballpit&pwd=" + my_hash());
	if (!get_property("friarsBlessingReceived").to_boolean()) visit_url("friars.php?action=buffs&bro=1&pwd=" + my_hash());
	if (get_campground() contains $item[Witchess Set] && !get_property("_witchessBuff").to_boolean()) {
		visit_url("campground.php?action=witchess");
		run_choice(3);
		run_choice(2);
		visit_url("main.php");
	}
	while (get_campground() contains $item[Source Terminal] && get_property("_sourceTerminalEnhanceUses").to_int() < 3) cli_execute("terminal enhance meat");
	visit_url("main.php");

	// Asking whether the user has access to a PYEC
	if (pyec.fetch()) set_property("_aen_havePYEC", "true");
	else if (!get_property("_aen_havePYEC").to_boolean() && user_confirm("Do you have access to a PYEC?")) set_property("_aen_havePYEC", "true");
	
	if (get_property("_aen_havePYEC").to_boolean() && !get_property("expressCardUsed").to_boolean()) {
		maximize("MP, switch " + optimal_familiar, false);
		cli_execute("/cast * " + chosen_libram);
		if (!pyec.try_use()) abort("Missing PYEC.");
	}
	
	cli_execute("/cast * " + chosen_libram);
	
	if (get_property("getawayCampsiteUnlocked").to_boolean()) {
		while (get_property("timesRested").to_int() < total_free_rests()) visit_url("place.php?whichplace=campaway&action=campaway_tentclick");
	}
	
	if (!get_property("_bagOTricksUsed").to_boolean()) $item[Bag o\' Tricks].try_use();
	if (!$item[burning paper crane].fetch()) cli_execute("create burning paper crane");
	if (get_property("_bastilleGames").to_int() < 1) bastille_batallion(3, 1, 3, 0);

	// Volcoino
	volcano_tower(7);
	
	
	set_property("_aen_optimalSetup", "true");
	print("Checkpoint reached: _aen_optimalSetup is true.", "blue");
}

if (!get_property("_aen_optimalRuns").to_boolean()) {
	boolean max_weight = false;
	int max_runs;
	
	if (!get_property("aen_maxRuns").to_boolean()) {
		weight_outfit.change_outfit();
		set_property("aen_maxRuns", floor(run_familiar.total_weight()/5));
	}
	if (feast.fetch()) max_runs = get_property("aen_maxRuns").to_int() + 2; // This value is saved from the previous day.
	else max_runs = get_property("aen_maxRuns").to_int();
	
	// Free run loop
	pp_outfit.change_outfit();
	if (pantsgiving.avail() && !pantsgiving.have_equipped() && get_property("_pantsgivingCount").to_int() < 50) pantsgiving.try_equip();
	run_familiar.use();
	drone();
	// if (hookah.avail()) hookah.equip(); // There comes a point where this is just yielding passive damage
	cli_execute("/cast * " + chosen_libram);
	while (get_property("_banderRunaways").to_int() < max_runs) {
	// while (!max_weight || get_property("_banderRunaways").to_int() < floor(run_familiar.total_weight()/5)) {
		if (get_property("_pantsgivingCount").to_int() < 50 &&  get_property("_pantsgivingCount").to_int() > 4 
			&& stomach_remaining() > 0) $item[Spooky Surprise Egg].eatsilent();
		if (pantsgiving.equipped() && get_property("_pantsgivingCount").to_int() > 49) $item[wooly loincloth].try_equip();
		if (my_inebriety() > inebriety_limit()) abort("You are overdrunk.");
		if (my_session_adv() > 0 && user_confirm("We have spent an adventure while free-running. Is something awry?")) abort("Ceasing.");
		closet_stuff();

		// if (cracker.item_amount() < 10) abort("Acquire more divine crackers.");
		while (!max_weight && get_property("_banderRunaways").to_int() >= floor(run_familiar.total_weight()/5)) {
			if (!brogues.have_equipped() && try_equip(acc1, brogues)) continue;
			else if (!$item[recovered cufflinks].have_equipped() && try_equip(acc2, $item[recovered cufflinks])) continue;
			else if (!$item[Belt of Loathing].have_equipped() && try_equip(acc3, $item[Belt of Loathing])) continue;
			else if (!$item[repaid diaper].have_equipped() && try_equip(pants, $item[repaid diaper])) continue;
			else if (!saber.have_equipped() && try_equip(weapon, saber)) continue;
			else if (!$item[burning paper crane].have_equipped() && try_equip(off, $item[burning paper crane])) continue;
			else if (!$item[Stephen's lab coat].have_equipped() && try_equip(shirt, $item[Stephen's lab coat])) continue;
			else if (!$item[buddy bjorn].have_equipped() && try_equip(back, $item[buddy bjorn])) continue;
			else if (!$item[crumpled felt fedora].have_equipped() && try_equip(hat, $item[crumpled felt fedora])) continue;
			else if (!contains_text(get_property("_feastedFamiliars"), run_familiar) && feast.try_use()) continue;
			else if (!$item[snow suit].have_equipped() && try_equip(fam, $item[snow suit])) continue;
			max_weight = true;
			set_property("aen_maxRuns", floor(run_familiar.total_weight()/5));
		}
		
		if (get_property("_reflexHammerUsed").to_int() < 1) try_equip(acc1, doc_bag);
		else if (doc_bag.have_equipped() && get_property("_reflexHammerUsed").to_int() > 0) try_equip(acc1, $item[mime army infiltration glove]);
		adv1($location[The Haunted Library], -1, "");
		continue;
	}
	//banishes w/ sniff
	while (get_property("_navelRunaways").to_int() < 3 && (navel.avail() || navel.fetch())) {
		if (my_session_adv() > 0 && user_confirm("We have spent an adventure while free-running. Is something awry?")) abort("Ceasing.");
		pp_outfit.change_outfit();
		try_equip(acc1, navel);
		adv1($location[The Haunted Library], -1, "");
		continue;
	}
		
	optimal_consumption();
	
	if (!get_property("_workshedItemUsed").to_boolean() && asdon.have() && user_confirm("Change your workshed to the Asdon Martin?")) {
		$item[Mayodiol].use(); // For later when we eat again
		asdon.use();
	}

	set_property("_aen_optimalRuns", "true");
}

// Main fight Loop
while (get_property("_aen_optimalFarm").to_boolean() && my_inebriety() < inebriety_limit() + 1) {
	print("Initiating start of loop.", "purple");
	cli_execute("/cast * " + chosen_libram);
	farm_outfit.change_outfit();
	if ($item[buddy bjorn].have_equipped() && my_bjorned_familiar() != $familiar[misshapen animal skeleton]) $familiar[misshapen animal skeleton].bjornify_familiar();
	optimal_familiar.use();
	set_property("_aen_advUsed", get_property("_aen_advUsed").to_int() + my_session_adv());
	set_property("_aen_meatToday", get_property("_aen_meatToday").to_int() + my_session_meat());
	if (get_property("_aen_advUsed").to_int() > 4 && user_confirm("We have spent 5 adventures. Is something awry?")) abort("Ceasing.");
	// if (comma_refresh() && !comma_run("Feather Boa Constrictor")) abort("Something went wrong with changing the Comma Chameleon.");
	if (!comma_change("Feather Boa Constrictor")) abort("Something went wrong with changing the Comma Chameleon.");
	closet_stuff();
	if (!$effect[Inscrutable Gaze].have()) $skill[Inscrutable Gaze].use();

	// LOVE Tunnel
	if (lov_can()) {
		lov_run();
		continue;
	}

	if (!get_property("_photocopyUsed").to_boolean()) {
		if (vip_key.have() && !$item[photocopied \monster].have()) faxbot(camera_monster.to_monster(), "CheeseFax");
		if ($item[photocopied monster].have() && get_property("photocopyMonster") == camera_monster) {
			if (camera_monster == "Knob Goblin Embezzler") { // @TODO handle this for all copiers
				emb_outfit.change_outfit();
				$skill[disco leer].use();
			}
			$item[photocopied monster].use();
			continue;
		}
	}
	
	if (get_property("rainDohMonster") == copy_target || get_property("spookyPuttyMonster") == copy_target) {
		if (get_property("_pocketProfessorLectures").to_int() < floor(square_root($familiar[Pocket Professor].total_weight())) + 2) $familiar[Pocket Professor].try_equip();
		if (my_familiar() == $familiar[Pocket Professor] && !$item[Pocket Professor memory chip].have_equipped()
			&& !$item[Pocket Professor memory chip].try_equip()) {
				abort("Missing Pocket Professor memory chip.");
		}
		if (get_property("spookyPuttyMonster") == copy_target) {
			$item[Spooky Putty Monster].use();
			continue;
		} else if (get_property("rainDohMonster") == copy_target) {
			$item[Rain-Doh box full of monster].use();
			continue;
		}
	}
	
	if (!get_property("_cameraUsed").to_boolean()) {
		if ($item[shaking 4-d camera].have() && get_property("cameraMonster") == camera_monster) {
			$item[shaking 4-d camera].use();
			continue;
		}
	}

	if (!get_property("_iceSculptureUsed").to_boolean()) {
		if ($item[ice sculpture].have() && get_property("iceSculptureMonster") == camera_monster) {
			$item[ice sculpture].use();
			continue;
		}
	}
	
	if (witchess_can()) {
		terminal_duplicate_prepare();
		witchess_run();
		cli_execute("terminal educate digitize");
		cli_execute("terminal educate extract");
		visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel", false); // This is to resuscitate Mafia's realisation of "non-trapping choice.php"
		run_choice(2);
		continue;
	}

	if (get_property("chateauMonster") == "Black Crayon Crimbo Elf" && !get_property("_chateauMonsterFought").to_boolean()
		&& $familiar[Robortender].try_equip()) {
		ff_outfit.change_outfit();
		visit_url("/place.php?whichplace=chateau&action=chateau_painting", false);
		run_combat();
		continue;
	}

	// Lynyrds
	if (get_property("_lynyrdSnareUses").to_int() < 3) {
		print("Fighting free lynyrd.", "green");
		$item[lynyrd snare].use();
		continue;
	}

	// God Lobster
	if (globster_can()) {
		globster_run(5, 2);
		continue;
	}

	// Eldritch Tentacles
	if (!get_property("_eldritchTentacleFought").to_boolean()) {
		print("Completing eldritch tentacle fights.", "green");
		visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
		if ($item[eldritch essence].have()) run_choice(2);
		else run_choice(1);
		run_combat();
		continue;
	}

	if ($skill[Evoke Eldritch Horror].have_skill() && !get_property("_eldritchHorrorEvoked").to_boolean()) {
		$skill[Evoke Eldritch Horror].use_skill();
		continue;
	}
	
	if (get_property("_brickoFights").to_int() < 10) {
		$item[BRICKO ooze].use();
		continue;
	}

	// Snojo
	if (snojo_free_can()) {
		snojo_free_run();
		if (snojo_fights() > 9) cli_execute("hottub");
		continue;
	}

	// Neverending Party
	if (nep_free_can()) {
		kramco.try_equip();
		nep_free_run();
		continue;
	}

	// DMT
	if ($familiar[Machine Elf].have() && get_property("_machineTunnelsAdv").to_int() < 5) {
		print("Completing Machine Tunnel fights.", "green");
		$familiar[Machine Elf].use();
		// if (hookah.avail()) hookah.equip();
		adv1($location[The Deep Machine Tunnels], -1, "");
		continue;
	}

	if ($item[[glitch season reward name]].have() && get_property("_glitchMonsterFights").to_int() < 1) {
		visit_url("inv_eat.php?&which=1&whichitem=10207&pwd=" + my_hash());
		run_combat();
		continue;
	}

	if (get_property("_powerPillUses").to_int() < 20) {
		if ($item[The Jokester's gun].avail() && !get_property("_firedJokestersGun").to_boolean()) $item[The Jokester's gun].try_equip();
		else if (doc_bag.avail() && get_property("_chestXRayUsed").to_int() < 3) try_equip(acc1, doc_bag);
		$item[drum machine].use();
		continue;
	}

	if (get_property("_drunkPygmyBanishes").to_int() < 10) {
	print("Using bowl of scorpions #" + get_property("_drunkPygmyBanishes").to_int() + " on the drunk pygmies.", "purple");
		if (!$item[bowl of scorpions].have()) juggle_scorpions();
		kramco.try_equip();
		// Needs an ice house check
		if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
		adv1($location[The Hidden Bowling Alley], -1, "");
		continue;
	}

	if (saber.avail()) {
		int banishes = get_property("_drunkPygmyBanishes").to_int();
		int forces = get_property("_saberForceUses").to_int();
		if (forces < 5) {
			if (get_property("_aen_pygmyAbort").to_boolean()) abort("Fewer than 5 forces is not currently supported.");
			kramco.try_equip();
			if ((banishes == 10 && forces == 0) || (banishes == 12 && forces == 1) || (banishes == 14 && forces == 2)
				|| (banishes == 16 && forces == 3) || (banishes == 18 && forces == 4)) {
				saber.try_equip();
				if ($item[bowl of scorpions].have()) juggle_scorpions(0);
				set_property("aen_useForce", "true");
				adv1($location[The Hidden Bowling Alley], -1, ""); // Use the force
				continue;
			} else if ((banishes == 10 && forces == 1) || (banishes == 12 && forces == 2) || (banishes == 14 && forces == 3)
				|| (banishes == 16 && forces == 4)) {
				juggle_scorpions(2);
				if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
				adv1($location[The Hidden Bowling Alley], -1, ""); // First of three
				continue;
			} else if ((banishes == 11 && forces == 1) || (banishes == 13 && forces == 2) || (banishes == 15 && forces == 3)
				|| (banishes == 17 && forces == 4)) {
				juggle_scorpions(1);
				if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
				adv1($location[The Hidden Bowling Alley], -1, ""); // Second of three
				continue;
			} else if (banishes == 18 && forces == 5) {
				juggle_scorpions(3);
				if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
				adv1($location[The Hidden Bowling Alley], -1, "");
				continue;
			}
		} else if (banishes < 21) {
			if (!$item[bowl of scorpions].have()) juggle_scorpions(1);
			kramco.try_equip();
			if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
			adv1($location[The Hidden Bowling Alley], -1, "");
			continue;
		}
	} else if (get_property("_drunkPygmyBanishes").to_int() < 11) {
		if (!$item[bowl of scorpions].have()) juggle_scorpions(1);
		kramco.try_equip();
		if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
		adv1($location[The Hidden Bowling Alley], -1, "");
		continue;
	}
	
	// Gingerbread Upscale Retail District
	if ((get_property("gingerbreadCityAvailable").to_boolean() || get_property("_gingerbreadCityToday").to_boolean())
		&& get_property("_gingerbreadCityTurns").to_int() < 30) {
		if (!$item[gingerbread cigarette].have()) abort("Acquire some gingerbread cigarettes.");
		if (get_property("_gingerbreadCityTurns").to_int() == 19) {
			adv1($location[Gingerbread Civic Center], -1, "");
			continue;
		}
		if (get_property("gingerRetailUnlocked").to_boolean()) adv1($location[Gingerbread Upscale Retail District], -1, "");
		else adv1($location[Gingerbread Civic Center], -1, "");
		continue;
	}

	if (timespinner_can()) {
		timespinner_fight(1431);
		continue;
	}
	
	if(total_turns_played() % 11 == 1 && get_property("_voteFreeFights").to_int() < 3 && total_turns_played() != get_property("lastVoteMonsterTurn").to_int()) {
		if (try_equip(acc1, $item[&quot;I voted!&quot; sticker])) {
			adv1($location[The Haunted Kitchen], -1, "");
			continue;
		}
	}

	if ($item[Eight Days a Week Pill Keeper].have() && get_property("_aen_advUsed").to_int() < 5) {
		if (!get_property("_freePillKeeperUsed").to_boolean()) {
			visit_url("main.php?eowkeeper=1", false);
			visit_url("choice.php?whichchoice=1395&option=7&pwd=" + my_hash(), true);
			$skill[Disco Leer].use();
			emb_outfit.change_outfit();
			adv1($location[Cobb\'s Knob Treasury], 0, "");
			continue;
		}
	
		visit_url("main.php?eowkeeper=1", false);
		visit_url("choice.php?whichchoice=1395&option=7&pwd=" + my_hash(), true);
		$skill[Disco Leer].use();
		emb_outfit.change_outfit();
		adv1($location[Cobb\'s Knob Treasury], 0, "");
		continue;
	}

	if (get_property("_aen_timePranks").to_int() < 6) abort("Acquire 6 time pranks.");
	
	if (kramco_grind_until(20));
	
	if ($item[Beach Comb].avail() && get_property("_freeBeachWalksUsed") < 11) {
		abort("Use your free beach walks.");
	}
	
	if (!get_property("_workshedItemUsed").to_boolean() && mayo_clinic.have()
		&& user_confirm("Change your workshed to the Mayo Clinic?")) {
			mayo_clinic.use();
			
	}

	if (stomach_remaining() > 0) {
		trav_trous.try_equip();
		optimal_consumption();
	}
	
	optimal_stooper();

	foreach it in $items[tiny plastic Naughty Sorceress, tiny plastic Susie, tiny plastic Boris, tiny plastic Jarlsberg, tiny plastic Sneaky Pete,
		tiny plastic Ed the Undying, tiny plastic Lord Spookyraven, tiny plastic Dr. Awkward, tiny plastic protector spectre] {
		if (it.have()) print("Congratulations! You obtained " + it.item_amount() + " " + it.to_string() + "!", "green");
	}
	cli_execute("sell * really dense meat stack");
	
	foreach it in $items[meat stack, 1952 Mickey Mantle card, massive gemstone, dollar-sign bag, half of a gold tooth, decomposed boot, leather bookmark, huge gold coin] {
		if (it.have()) autosell(it.item_amount(), it);
	}
	
	foreach it in $items[solid gold jewel, ancient vinyl coin purse, duct tape wallet, old coin purse, old leather wallet, pixel coin, shiny stones, stolen meatpouch,
		Gathered Meat-Clip] {
		if (it.have()) use(it.item_amount(), it);
	}
	
	cli_execute("/whitelist " + roll_clan);
	set_property("_aen_optimalFarm", "false");
	print("You earned " + get_property("_aen_meatToday").to_int() + " total meat this session.", "purple");
	print("Checkpoint reached: _aen_optimalFarm is false.", "blue");
}
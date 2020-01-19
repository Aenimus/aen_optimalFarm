script "aen_combat.ash";
import "aen_utils.ash";
import "aen_macros.ash";

buffer get_funky(item [int] funks, item it) {
	buffer b;
	if  (item_amount(it) == 0) return b;
	funks[count(funks)] = it;
	if  (count(funks) == 2) {
		b = throw_items(funks[0], funks[1]);
		clear(funks);
	}
	return b;
}

void main(int rnd, monster mob, string pg) {
	if (can_interact() && get_property("_aen_optimalFarm").to_boolean()) {
		print("Using consult script aen_combat.ash for aen_optimalFarm.ash.", "blue");
		if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);

		location loc = my_location();
		string foe = mob.to_string();
		boolean sing_along = false;
		boolean extracted = false;
		boolean siesta = false;
		boolean weaksauce = false;
		boolean mShower = false;
		boolean cloake = false;
		int digitizes = get_property("_sourceTerminalDigitizeUses").to_int();
		int digiNo = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
		
		if (mob == $monster[Witchess Knight]) {
			item [int] funks;

			int spookies = get_property("spookyPuttyCopiesMade").to_int();
			int rainies = get_property("_raindohCopiesMade").to_int();

			if  (spookies + rainies < 6) {
				if  (spookies < 5) get_funky(funks, $item[Spooky Putty sheet]);
				if  (rainies < 5) get_funky(funks, $item[Rain-Doh black box]);
			}
			
			if ($skill[Duplicate].have_skill()) {
				use_skill(1, $skill[Duplicate]);
			}
			
			if (my_familiar() == $familiar[Pocket Professor] && have_skill(7319.to_skill())) {
				use_skill(1, 7319.to_skill());
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish.url_encode(), true, true);
			} else {
				visit_url("fight.php?action=macro&macrotext=" + macro_no_meteor_finish.url_encode(), true, true);
			}
		}
		
		if (mob == $monster[Knob Goblin Embezzler]) {
			item [int] funks;
		
			if (get_property("_sourceTerminalDigitizeUses").to_int() < 1 && $skill[Digitize].have_skill()) {
				use_skill(1, $skill[Digitize]);
				rnd++;
			}
			
			/*while(!get_property("_cameraUsed").to_boolean() && !$item[shaking 4-d camera].have()) {
				get_funky(funks, $item[4-d camera]);
				get_funky(funks, $item[4-d camera]);
				if  (count(funks) == 1) throw_item(funks[0]);
				rnd++;
			} */ // removed because pill keeper is just cheaper.
			
			while(monster_hp() > 300 && rnd < 10) {
				if (!extracted) {
					extract.use();
					extracted = true;
					rnd++;
				}
				if (!sing_along) {
					slong.use();
					sing_along = true;
					rnd++;
				}
				$item[seal tooth].throw_item();
				rnd++;
			}
			
			if($skill[Summer Siesta].have()) $skill[Summer Siesta].use();
			visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		}
		
		if (mob == $monster[giant sandworm]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 300 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}

			visit_url("fight.php?action=macro&macrotext=" + macro_free_kills.url_encode(), true, true);
			if ($item[replica bat-oomerang].have() && get_property("_usedReplicaBatoomerang").to_int() < 3) $item[replica bat-oomerang].throw_item();
			if ($item[power pill].have() && get_property("_powerPillUses").to_int() < 20) $item[power pill].throw_item();
			else abort("You have run out of power pills.");
		}
		
		if (mob == $monster[pygmy bowler]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			use_skill(1, $skill[Snokebomb]);
		}

		if (mob == $monster[pygmy orderlies]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			abort();
		}
		
		if (mob == $monster[drunk pygmy] && get_property("_drunkPygmyBanishes").to_int() > 9) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 300 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}

			if (get_property("aen_useForce").to_boolean()) {
				use_skill(1, 7311.to_skill());
				set_property("aen_useForce", "false");
				run_choice(2);
			}
		}
		
		if (mob == $monster[gingerbread convict] || mob == $monster[gingerbread finance bro] || mob == $monster[gingerbread gentrifier]
			|| mob == $monster[gingerbread lawyer] || mob == $monster[gingerbread tech bro]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 300 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			$item[gingerbread cigarette].throw_item();
		}
		
		if (mob == $monster[tumbleweed]) {
			abort();
		}
		
		if (mob == $monster[gingerbread rat] || mob == $monster[gingerbread pigeon]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			if (get_property("_snokebombUsed").to_int() > 1) $skill[Snokebomb].use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].use();
		}
		
		if (mob == $monster[banshee librarian] || mob == $monster[writing desk]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			if ($skill[Reflex Hammer].have()) $skill[Reflex Hammer].use();
			if ($skill[Snokebomb].have()) $skill[Snokebomb].use();
		}

		if (mob == $monster[bookbat] && (my_familiar() == stomp_boots || (my_familiar() == bander && $effect[Ode to Booze].have()))) {
			string pickpocket = visit_url("fight.php?action=steal", true);
			matcher picks = create_matcher("You acquire an item: <b>tattered scrap of paper</b>", pickpocket);
			rnd++;
			while (!picks.find() && monster_hp() > 265 && rnd < 30) {
				pickpocket  = throw_items(cracker, cracker);
				picks = create_matcher("You acquire an item: <b>tattered scrap of paper</b>", pickpocket);
				rnd++;
			}
			if (monster_hp() > 265 && rnd < 30) extract.use();
			if (crumbs.have() && get_property("_pantsgivingCrumbs").to_int() < 10 && monster_hp() > 265 && rnd < 30) crumbs.use();
			if (monster_hp() > 265 && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].have_equipped()) {
				int roll = random(3);
				if (roll == 0) $skill[Become a Wolf].use();
				else if (roll == 1) $skill[Become a Cloud of Mist].use();
				else if (roll == 2) $skill[Become a Bat].use();
			}
			runaway();
		}
		
		if (mob == $monster[Eldritch Tentacle] && $item[haiku katana].have_equipped()) {
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis.url_encode(), true, true);
			if($skill[Summer Siesta].have()) $skill[Summer Siesta].use();
			visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		}

		if (my_familiar() == $familiar[Machine Elf]) visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish.url_encode(), true, true);
		
		visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		
		multi_fight();

	} 
}
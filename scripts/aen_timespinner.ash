script "aen_timespinner.ash";

boolean timespinner_have() {
	return timespinner.fetch();
}

int timespinner_mins_left() {
	return 10 - get_property("_timeSpinnerMinutesUsed").to_int();
}

int timespinner_pranks() {
	return get_property("_aen_pranks_today").to_int();
}

void timespinner_pranks_check() {
	if (get_property("_aen_pranks_today").to_int() < 6) abort("Acquire 6 time pranks.");
}

boolean [item] timespinner_eaten() {
	string [int] food_strings = get_property("_timeSpinnerFoodAvailable").split_string(",");
	boolean [item] eaten;

	foreach i, food_string in food_strings {
		eaten[food_string.to_item()] = true;
	}

	return eaten;
}

boolean timespinner_can(int mins) {
	if (my_adventures() < 1) return false;
	return timespinner_have() && timespinner_mins_left() >= mins;
}

boolean timespinner_can() {
	return timespinner_can(3);
}

boolean timespinner_can_eat(item food) {
	return timespinner_can() && timespinner_eaten() contains food;
}

boolean timespinner_eat(item food) {
	if (!food.timespinner_can_eat()) return false;
	if (food.fullness == 0) abort("Cannot timespin " + food.to_string() + ".");
	cli_execute("timespinner eat " + food.to_string());
	return true;
}

boolean timespinner_fight(monster mob) {
	int mins = timespinner_mins_left();
	if (mob.id == 1431) {
		if (!bworps.have() & !bworps.fetch()) buy_until(1, bworps, 500);
		set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
	}
	visit_url("inv_use.php?whichitem=9104&pwd=" + my_hash(), true);
	run_choice(1);
	visit_url("choice.php?whichchoice=1196&monid=" + mob.id + "&option=1&pwd=" + my_hash(), true);
	run_combat();
	return (mins - 3) == timespinner_mins_left();
}

boolean timespinner_fight(int mob_id) {
	if (!timespinner_can()) return false;
	if (mob_id == 1431 && !bworps.have() & !bworps.fetch()) buy_until(1, bworps, 500);
	visit_url("inv_use.php?whichitem=9104&pwd=" + my_hash(), true);
	run_choice(1);
	visit_url("choice.php?whichchoice=1196&monid=" + mob_id + "&option=1&pwd=" + my_hash(), true);
	run_combat();
	return true;
}

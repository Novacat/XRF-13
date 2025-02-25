/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "densecrate"
	density = TRUE
	anchored = FALSE
	resistance_flags = XENO_DAMAGEABLE
	max_integrity = 100
	hit_sound = 'sound/effects/woodhit.ogg'
	var/spawn_type
	var/spawn_amount


/obj/structure/largecrate/deconstruct(disassembled = TRUE)
	spawn_stuff()
	return ..()


/obj/structure/largecrate/examine(mob/user)
	. = ..()
	to_chat(user, span_notice("You need a crowbar to pry this open!"))


/obj/structure/largecrate/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(.)
		return TRUE

	if(istype(I, /obj/item/powerloader_clamp))
		return

	return attack_hand(user)


/obj/structure/largecrate/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	user.visible_message(span_notice("[user] pries \the [src] open."),
		span_notice("You pry open \the [src]."),
		span_notice("You hear splitting wood."))
	new /obj/item/stack/sheet/wood(loc)
	deconstruct(TRUE)
	return TRUE


/obj/structure/largecrate/proc/spawn_stuff()
	var/turf/T = get_turf(src)
	if(spawn_type && spawn_amount)
		for(var/i in 1 to spawn_amount)
			new spawn_type(T)
	for(var/obj/O in contents)
		O.forceMove(loc)


/obj/structure/largecrate/mule
	icon_state = "mulecrate"

/obj/structure/largecrate/lisa
	icon_state = "lisacrate"
	spawn_type = /mob/living/simple_animal/corgi/Lisa
	spawn_amount = 1


/obj/structure/largecrate/cow
	name = "cow crate"
	icon_state = "lisacrate"
	spawn_type = /mob/living/simple_animal/cow
	spawn_amount = 1


/obj/structure/largecrate/goat
	name = "goat crate"
	icon_state = "lisacrate"
	spawn_type = /mob/living/simple_animal/hostile/retaliate/goat
	spawn_amount = 1


/obj/structure/largecrate/chick
	name = "chicken crate"
	icon_state = "lisacrate"
	spawn_type = /mob/living/simple_animal/chick
	spawn_amount = 4


/obj/structure/largecrate/kitten
	name = "kitten crate"
	icon_state = "lisacrate"
	spawn_type = /mob/living/simple_animal/cat/kitten
	spawn_amount = 1
///////////CM largecrates ///////////////////////



//Possibly the most generically named procs in history. congrats
/obj/structure/largecrate/random
	name = "supply crate"
	var/num_things = 0

/obj/structure/largecrate/random/Initialize()
	. = ..()
	if(!num_things) num_things = rand(0,3)

	while(num_things)
		if(!num_things)
			break
		num_things--
		var/thing = pick(prob(3);/obj/item/storage/belt/utility/full,
						prob(2);/obj/item/storage/belt/medical,
						prob(1);/obj/item/storage/belt/combatLifesaver/som,
						prob(5);/obj/item/storage/firstaid/regular,
						prob(2);/obj/item/storage/firstaid/fire,
						prob(2);/obj/item/storage/firstaid/toxin,
						prob(2);/obj/item/storage/firstaid/o2,
						prob(2);/obj/item/storage/firstaid/adv,
						prob(2);/obj/item/storage/firstaid/rad,
						prob(1);/obj/item/storage/firstaid/combat,
						prob(3);/obj/item/storage/toolbox/mechanical,
						prob(3);/obj/item/storage/toolbox/electrical,
						prob(3);/obj/item/storage/toolbox/emergency,
						prob(20);/obj/item/storage/box/MRE,
						prob(5);/obj/item/storage/box/m94,
						prob(5);/obj/item/storage/box/donkpockets,
						prob(20);/obj/item/reagent_containers/food/drinks/cans/waterbottle,
						prob(15);/obj/item/explosive/grenade/smokebomb,
						prob(2);/obj/item/explosive/grenade/drainbomb,
						prob(2);/obj/item/explosive/grenade/cloakbomb,
						prob(5);/obj/item/cell/apc,
						prob(3);/obj/item/cell/high,
						prob(2);/obj/item/cell/super,
						prob(1);/obj/item/cell/hyper,
						prob(8);/obj/item/flashlight,
						prob(4);/obj/item/circuitboard/airlock,
						prob(4);/obj/item/assembly/igniter,
						prob(5);/obj/item/tool/weldingtool,
						prob(3);/obj/item/tool/weldingtool/largetank,
						prob(2);/obj/item/tool/weldingtool/hugetank,
						prob(1);/obj/item/tool/weldingtool/experimental,
						prob(3);/obj/item/tool/weldpack,
						prob(5);/obj/item/tool/wirecutters,
						prob(5);/obj/item/tool/wrench,
						prob(5);/obj/item/tool/screwdriver,
						prob(5);/obj/item/tool/crowbar,
						prob(5);/obj/item/analyzer,
						prob(5);/obj/item/multitool,
						prob(3);/obj/item/storage/bible,
						prob(1);/obj/item/storage/bible/koran,
						prob(1);/obj/item/storage/bible/booze,
						prob(3);/obj/item/clothing/glasses/hud/health,
						prob(2);/obj/item/clothing/glasses/hud/medgoggles,
						prob(1);/obj/item/clothing/glasses/hud/xenohud,
						prob(1);/obj/item/clothing/glasses/hud/painhud,
						prob(3);/obj/item/clothing/glasses/night/imager_goggles,
						prob(2);/obj/item/clothing/glasses/night/m56_goggles,
						prob(1);/obj/item/clothing/glasses/night/tx8,
						prob(1);/obj/item/clothing/glasses/night/m42_night_goggles/upp,
						prob(1);/obj/item/clothing/glasses/thermal/m64_thermal_goggles,
						prob(4);/obj/item/clothing/head/welding,
						prob(6);/obj/item/clothing/glasses/welding,
						prob(1);/obj/item/clothing/glasses/welding/superior,
						prob(5);/obj/item/clothing/glasses/mgoggles,
						prob(5);/obj/item/radio/headset,
						prob(4);/obj/item/clothing/tie/storage/webbing,
						prob(2);/obj/item/clothing/tie/storage/black_vest,
						prob(2);/obj/item/clothing/tie/storage/brown_vest,
						prob(2);/obj/item/clothing/tie/storage/white_vest/medic,
						prob(2);/obj/item/clothing/tie/storage/white_vest/surgery,
						prob(3);/obj/item/motiondetector,
						prob(1);/obj/item/motiondetector/scout,
						prob(4);/obj/item/stack/sheet/metal/medium_stack,
						prob(2);/obj/item/stack/sheet/metal/large_stack,
						prob(4);/obj/item/stack/sheet/plasteel/medium_stack,
						prob(2);/obj/item/stack/sheet/plasteel/large_stack,
						prob(3);/obj/item/clothing/under/marine/veteran/mercenary,
						prob(3);/obj/item/clothing/under/marine/veteran/mercenary/miner,
						prob(3);/obj/item/clothing/under/marine/veteran/mercenary/engineer,
						prob(3);/obj/item/clothing/shoes/swat,
						prob(3);/obj/item/clothing/shoes/marine/som)
		new thing(src)

/obj/structure/largecrate/random/case
	name = "storage case"
	desc = "A black storage case."
	icon_state = "case"

/obj/structure/largecrate/random/case/double
	name = "cases"
	desc = "A stack of black storage cases."
	icon_state = "case_double"

/obj/structure/largecrate/random/case/double/deconstruct(disassembled = TRUE)
	new /obj/structure/largecrate/random/case(loc)
	new /obj/structure/largecrate/random/case(loc)
	return ..()

/obj/structure/largecrate/random/case/small
	name = "small cases"
	desc = "Two small black storage cases."
	icon_state = "case_small"


/obj/structure/largecrate/random/barrel/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/metal/small_stack(src)
	return ..()


/obj/structure/largecrate/random/barrel/welder_act(mob/living/user, obj/item/tool/weldingtool/welder)
	if(!welder.isOn())
		return FALSE
	if(!do_after(user, 5 SECONDS, TRUE, src, BUSY_ICON_BUILD))
		return TRUE
	if(!welder.remove_fuel(1, user))
		return TRUE
	user.visible_message(span_notice("[user] welds \the [src] open."),
		span_notice("You weld open \the [src]."),
		span_notice("You hear loud hissing and the sound of metal falling over."))
	playsound(loc, 'sound/items/welder2.ogg', 25, TRUE)
	deconstruct(TRUE)
	return TRUE


/obj/structure/largecrate/random/barrel/examine(mob/user)
	. = ..()
	to_chat(user, span_notice("You need a blowtorch to weld this open!"))


/obj/structure/largecrate/random/barrel
	name = "blue barrel"
	desc = "A blue storage barrel"
	icon_state = "barrel_blue"
	hit_sound = 'sound/effects/metalhit.ogg'

/obj/structure/largecrate/random/barrel/blue
	name = "blue barrel"
	desc = "A blue storage barrel"
	icon_state = "barrel_blue"

/obj/structure/largecrate/random/barrel/red
	name = "red barrel"
	desc = "A red storage barrel"
	icon_state = "barrel_red"

/obj/structure/largecrate/random/barrel/green
	name = "green barrel"
	desc = "A green storage barrel"
	icon_state = "barrel_green"

/obj/structure/largecrate/random/barrel/yellow
	name = "yellow barrel"
	desc = "A yellow storage barrel"
	icon_state = "barrel_yellow"

/obj/structure/largecrate/random/barrel/white
	name = "white barrel"
	desc = "A white storage barrel"
	icon_state = "barrel_white"

/obj/structure/largecrate/random/secure
	name = "secure supply crate"
	desc = "A secure crate."
	icon_state = "secure_crate_strapped"
	var/strapped = 1


/obj/structure/largecrate/random/secure/crowbar_act(mob/living/user, obj/item/I)
	if(strapped)
		return FALSE
	return ..()


/obj/structure/largecrate/random/secure/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	to_chat(user, span_notice("You begin to cut the straps off \the [src]..."))
	if(!do_after(user, 1.5 SECONDS, TRUE, src, BUSY_ICON_GENERIC))
		return TRUE
	playsound(loc, 'sound/items/wirecutter.ogg', 25, 1)
	to_chat(user, span_notice("You cut the straps away."))
	icon_state = "secure_crate"
	strapped = FALSE
	return TRUE


/obj/structure/largecrate/random/barrel/examine(mob/user)
	. = ..()
	to_chat(user, span_notice("You need something sharp to cut off the straps."))

/obj/structure/largecrate/guns
	name = "\improper TGMC firearms crate (x3)"
	var/num_guns = 3
	var/num_mags = 3
	var/list/stuff = list(
					/obj/item/weapon/gun/pistol/rt3 = /obj/item/ammo_magazine/pistol/hp,
					/obj/item/weapon/gun/pistol/rt3 = /obj/item/ammo_magazine/pistol/ap,
					/obj/item/weapon/gun/revolver/m44 = /obj/item/ammo_magazine/revolver/marksman,
					/obj/item/weapon/gun/revolver/m44 = /obj/item/ammo_magazine/revolver/heavy,
					/obj/item/weapon/gun/shotgun/pump/t35 = /obj/item/ammo_magazine/shotgun,
					/obj/item/weapon/gun/shotgun/pump/t35 = /obj/item/ammo_magazine/shotgun/incendiary,
					/obj/item/weapon/gun/shotgun/combat = /obj/item/ammo_magazine/shotgun,
					/obj/item/weapon/gun/flamer = /obj/item/ammo_magazine/flamer_tank,
					/obj/item/weapon/gun/pistol/rt3 = /obj/item/ammo_magazine/pistol/incendiary,
					/obj/item/weapon/gun/rifle/standard_assaultrifle = /obj/item/ammo_magazine/rifle/standard_assaultrifle,
					/obj/item/weapon/gun/rifle/standard_lmg = /obj/item/ammo_magazine/standard_lmg,
					/obj/item/weapon/gun/launcher/m81 = /obj/item/explosive/grenade/phosphorus
					)

/obj/structure/largecrate/guns/Initialize()
	. = ..()
	var/gun_type
	var/i = 0
	while(++i <= num_guns)
		gun_type = pick(stuff)
		new gun_type(src)
		var/obj/item/ammo_magazine/new_mag = stuff[gun_type]
		var/m = 0
		while(++m <= num_mags)
			new new_mag(src)

/obj/structure/largecrate/guns/russian
	num_guns = 1
	num_mags = 1
	name = "\improper Nagant-Yamasaki firearm crate"
	stuff = list(
		/obj/item/weapon/gun/revolver/upp = /obj/item/ammo_magazine/revolver/upp,
		/obj/item/weapon/gun/pistol/c99 = /obj/item/ammo_magazine/pistol/c99,
		/obj/item/weapon/gun/rifle/ak47 = /obj/item/ammo_magazine/rifle/ak47,
		/obj/item/weapon/gun/rifle/sniper/svd = /obj/item/ammo_magazine/sniper/svd,
		/obj/item/weapon/gun/smg/ppsh = /obj/item/ammo_magazine/smg/ppsh,
		/obj/item/weapon/gun/rifle/type71 = /obj/item/ammo_magazine/rifle/type71,
		/obj/item/weapon/gun/rifle/sniper/svd = /obj/item/ammo_magazine/sniper/svd
	)

/obj/structure/largecrate/guns/merc
	num_guns = 1
	num_mags = 1
	name = "\improper Black market firearm crate"
	stuff = list(
		/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
		/obj/item/weapon/gun/pistol/vp70 = /obj/item/ammo_magazine/pistol/vp70,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/smg/mp7 = /obj/item/ammo_magazine/smg/mp7,
		/obj/item/weapon/gun/smg/skorpion = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
		/obj/item/weapon/gun/rifle/famas = /obj/item/ammo_magazine/rifle/famas,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16
	)

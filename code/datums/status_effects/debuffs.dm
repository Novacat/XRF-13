#define TRAIT_STATUS_EFFECT(effect_id) "[effect_id]-trait"

//Largely negative status effects go here, even if they have small benificial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	tick_interval = 0
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	return ..()


//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"

/datum/status_effect/incapacitating/stun/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/stun/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	return ..()

//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"

/datum/status_effect/incapacitating/knockdown/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/knockdown/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()

//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"

/datum/status_effect/incapacitating/immobilized/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/immobilized/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	return ..()

//PARALYZED
/datum/status_effect/incapacitating/paralyzed
	id = "paralyzed"

/datum/status_effect/incapacitating/paralyzed/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/paralyzed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()

//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"

/datum/status_effect/incapacitating/unconscious/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/unconscious/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/unconscious/tick()
	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.3) //reduce stamina loss by 0.3 per tick, 6 per 2 seconds

//SLEEPING
/datum/status_effect/incapacitating/sleeping
	id = "sleeping"
	alert_type = /obj/screen/alert/status_effect/asleep
	var/mob/living/carbon/carbon_owner
	var/mob/living/carbon/human/human_owner

/datum/status_effect/incapacitating/sleeping/on_creation(mob/living/new_owner)
	. = ..()
	if(.)
		if(iscarbon(owner)) //to avoid repeated istypes
			carbon_owner = owner
		if(ishuman(owner))
			human_owner = owner

/datum/status_effect/incapacitating/sleeping/Destroy()
	carbon_owner = null
	human_owner = null
	return ..()

/datum/status_effect/incapacitating/sleeping/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/sleeping/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/sleeping/tick()
	if(owner.maxHealth)
		var/health_ratio = owner.health / owner.maxHealth
		var/healing = -0.2
		if((locate(/obj/structure/bed) in owner.loc))
			healing -= 0.3
		else if((locate(/obj/structure/table) in owner.loc))
			healing -= 0.1
		for(var/obj/item/bedsheet/bedsheet in range(owner.loc,0))
			if(bedsheet.loc != owner.loc) //bedsheets in your backpack/neck don't give you comfort
				continue
			healing -= 0.1
			break //Only count the first bedsheet
		if(health_ratio > 0.8)
			owner.adjustBruteLoss(healing)
			owner.adjustFireLoss(healing)
			owner.adjustToxLoss(healing * 0.5, TRUE, TRUE)
		owner.adjustStaminaLoss(healing)
	if(human_owner && human_owner.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
		if(prob(10) && owner.health > owner.health_threshold_crit)
			owner.emote("snore")

/obj/screen/alert/status_effect/asleep
	name = "Asleep"
	desc = "You've fallen asleep. Wait a bit and you should wake up. Unless you don't, considering how helpless you are."
	icon_state = "asleep"

//ADMIN SLEEP
/datum/status_effect/incapacitating/adminsleep
	id = "adminsleep"
	alert_type = /obj/screen/alert/status_effect/adminsleep
	duration = -1

/datum/status_effect/incapacitating/adminsleep/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/adminsleep/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/obj/screen/alert/status_effect/adminsleep
	name = "Admin Slept"
	desc = "You've been slept by an Admin."
	icon_state = "asleep"

//CONFUSED
/datum/status_effect/confused
	id = "confused"
	alert_type = /obj/screen/alert/status_effect/confused

/obj/screen/alert/status_effect/confused
	name = "Confused"
	desc = "You're dazed and confused."
	icon_state = "asleep"

/datum/status_effect/plasmadrain
	id = "plasmadrain"

/datum/status_effect/plasmadrain/on_creation(mob/living/new_owner, set_duration)
	if(isxeno(new_owner))
		owner = new_owner
		duration = set_duration
		return ..()
	else
		CRASH("something applied plasmadrain on a nonxeno, dont do that")

/datum/status_effect/plasmadrain/tick()
	var/mob/living/carbon/xenomorph/xenoowner = owner
	if(xenoowner.plasma_stored >= 0)
		var/remove_plasma_amount = xenoowner.xeno_caste.plasma_max / 17
		xenoowner.plasma_stored -= remove_plasma_amount
		if(xenoowner.plasma_stored <= 0)
			xenoowner.plasma_stored = 0

/datum/status_effect/noplasmaregen
	id = "noplasmaregen"
	tick_interval = 2 SECONDS

/datum/status_effect/noplasmaregen/on_creation(mob/living/new_owner, set_duration)
	if(isxeno(new_owner))
		owner = new_owner
		duration = set_duration
		return ..()
	else
		CRASH("something applied noplasmaregen on a nonxeno, dont do that")

/datum/status_effect/noplasmaregen/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_NOPLASMAREGEN, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/noplasmaregen/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPLASMAREGEN, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/noplasmaregen/tick()
	to_chat(owner, span_warning("You feel too weak to summon new plasma..."))

/datum/status_effect/incapacitating/harvester_slowdown
	id = "harvest_slow"
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	var/debuff_slowdown = 2

/datum/status_effect/incapacitating/harvester_slowdown/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_movespeed_modifier(MOVESPEED_ID_HARVEST_TRAM_SLOWDOWN, TRUE, 0, NONE, TRUE, debuff_slowdown)

/datum/status_effect/incapacitating/harvester_slowdown/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_HARVEST_TRAM_SLOWDOWN)
	return ..()


//HEALING INFUSION buff for Hivelord
/datum/status_effect/healing_infusion
	id = "healing_infusion"
	alert_type = /obj/screen/alert/status_effect/healing_infusion
	//Buff ends whenever we run out of either health or sunder ticks, or time, whichever comes first
	///Health recovery ticks
	var/health_ticks_remaining
	///Sunder recovery ticks
	var/sunder_ticks_remaining

/datum/status_effect/healing_infusion/on_creation(mob/living/new_owner, set_duration = HIVELORD_HEALING_INFUSION_DURATION, stacks_to_apply = HIVELORD_HEALING_INFUSION_TICKS)
	if(!isxeno(new_owner))
		CRASH("something applied [id] on a nonxeno, dont do that")

	duration = set_duration
	owner = new_owner
	health_ticks_remaining = stacks_to_apply //Apply stacks
	sunder_ticks_remaining = stacks_to_apply
	return ..()


/datum/status_effect/healing_infusion/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_HEALING_INFUSION, TRAIT_STATUS_EFFECT(id))
	owner.add_filter("hivelord_healing_infusion_outline", 3, outline_filter(1, COLOR_VERY_PALE_LIME_GREEN)) //Set our cool aura; also confirmation we have the buff
	RegisterSignal(owner, COMSIG_XENOMORPH_HEALTH_REGEN, .proc/healing_infusion_regeneration) //Register so we apply the effect whenever the target heals
	RegisterSignal(owner, COMSIG_XENOMORPH_SUNDER_REGEN, .proc/healing_infusion_sunder_regeneration) //Register so we apply the effect whenever the target heals

/datum/status_effect/healing_infusion/on_remove()
	REMOVE_TRAIT(owner, TRAIT_HEALING_INFUSION, TRAIT_STATUS_EFFECT(id))
	owner.remove_filter("hivelord_healing_infusion_outline") //Remove the aura
	UnregisterSignal(owner, list(COMSIG_XENOMORPH_HEALTH_REGEN, COMSIG_XENOMORPH_SUNDER_REGEN)) //unregister the signals; party's over

	new /obj/effect/temp_visual/telekinesis(get_turf(owner)) //Wearing off SFX
	new /obj/effect/temp_visual/healing(get_turf(owner)) //Wearing off SFX

	to_chat(owner, span_xenodanger("Our regeneration is no longer accelerated.")) //Let the target know
	owner.playsound_local(owner, 'sound/voice/hiss5.ogg', 25)

	return ..()

///Called when the target xeno regains HP via heal_wounds in life.dm
/datum/status_effect/healing_infusion/proc/healing_infusion_regeneration(mob/living/carbon/xenomorph/patient)
	SIGNAL_HANDLER

	if(!health_ticks_remaining)
		qdel(src)
		return

	health_ticks_remaining-- //Decrement health ticks

	new /obj/effect/temp_visual/healing(get_turf(patient)) //Cool SFX

	var/total_heal_amount = 6 + (patient.maxHealth * 0.03) //Base amount 6 HP plus 3% of max
	if(patient.recovery_aura)
		total_heal_amount *= (1 + patient.recovery_aura * 0.05) //Recovery aura multiplier; 5% bonus per full level

	//Healing pool has been calculated; now to decrement it
	var/brute_amount = min(patient.bruteloss, total_heal_amount)
	if(brute_amount)
		patient.adjustBruteLoss(-brute_amount, updating_health = TRUE)
		total_heal_amount = max(0, total_heal_amount - brute_amount) //Decrement from our heal pool the amount of brute healed

	if(!total_heal_amount) //no healing left, no need to continue
		return

	var/burn_amount = min(patient.fireloss, total_heal_amount)
	if(burn_amount)
		patient.adjustFireLoss(-burn_amount, updating_health = TRUE)


///Called when the target xeno regains Sunder via heal_wounds in life.dm
/datum/status_effect/healing_infusion/proc/healing_infusion_sunder_regeneration(mob/living/carbon/xenomorph/patient)
	SIGNAL_HANDLER

	if(!sunder_ticks_remaining)
		qdel(src)
		return

	if(!locate(/obj/effect/alien/weeds) in patient.loc) //Doesn't work if we're not on weeds
		return

	sunder_ticks_remaining-- //Decrement sunder ticks

	new /obj/effect/temp_visual/telekinesis(get_turf(patient)) //Visual confirmation

	patient.adjust_sunder(-1.8 * (1 + patient.recovery_aura * 0.05)) //5% bonus per rank of our recovery aura


/obj/screen/alert/status_effect/healing_infusion
	name = "Healing Infusion"
	desc = "You have accelerated natural healing."
	icon_state = "healing_infusion"

//MUTE
/datum/status_effect/mute
	id = "mute"
	alert_type = /obj/screen/alert/status_effect/mute

/obj/screen/alert/status_effect/mute
	name = "Muted"
	desc = "You can't speak!"
	icon_state = "mute"

/datum/status_effect/mute/on_creation(mob/living/new_owner, set_duration)
	owner = new_owner
	if(set_duration) //If the duration is limited, set it
		duration = set_duration
	return ..()

/datum/status_effect/mute/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_MUTED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/mute/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MUTED, TRAIT_STATUS_EFFECT(id))
	return ..()

//naughty stuff (still buggy)
/datum/status_effect/breast_enlarger
	id = "breast_enlarger"
	alert_type = null
	var/moveCalc = 1
	var/cachedmoveCalc = 1
	var/last_checked_size //used to prevent potential cpu waste from happening every tick.

/datum/status_effect/breast_enlarger/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_movespeed_modifier(MOVESPEED_ID_BREAST_HYPERTROPHY, TRUE, 0, NONE, TRUE, moveCalc)

/datum/status_effect/breast_enlarger/tick()
	var/mob/living/carbon/human/H = owner
	var/datum/internal_organ/genital/breasts/B = H.internal_organs_by_name["breasts"]
	if(!B)
		H.remove_status_effect(src)
		return
	moveCalc = 1 + ((round(B.cached_size) - 9) / 3) //Afffects how fast you move, and how often you can click.

	if(last_checked_size != B.cached_size)
		H.add_movespeed_modifier(MOVESPEED_ID_BREAST_HYPERTROPHY, TRUE, multiplicative_slowdown = moveCalc)
		sizeMoveMod(moveCalc)

	if(B.cached_size > 11)
		var/message = FALSE
		if(H.w_uniform)
			H.dropItemToGround(H.w_uniform, TRUE)
			message = TRUE
		if(H.wear_suit)
			H.dropItemToGround(H.wear_suit, TRUE)
			message = TRUE
		if(message)
			playsound(H.loc, 'sound/items/poster_ripped.ogg', 25, TRUE)
			to_chat(H, "<span class='danger'>Your enormous breasts are way too large to fit anything over them!</span>")

	if(B.size == "huge")
		if(prob(1))
			to_chat(H, "<span class='warning'>Your back feels painfully sore.</span>")
			H.apply_damage(0.1, BRUTE, BODY_ZONE_CHEST)

	else if(prob(1))
		to_chat(H, "<span class='warning'>Your back feels very sore.</span>")
	last_checked_size = B.cached_size

	return ..()

/datum/status_effect/breast_enlarger/proc/sizeMoveMod(value)
	if(cachedmoveCalc == value)
		return
	owner.next_move_modifier /= cachedmoveCalc
	owner.next_move_modifier *= value
	cachedmoveCalc = value

/datum/status_effect/breast_enlarger/on_remove()
	to_chat(owner, "<span class='notice'>Your expansive chest has become a more managable size, liberating your movements.</span>")
	owner.remove_movespeed_modifier(MOVESPEED_ID_BREAST_HYPERTROPHY)
	sizeMoveMod(1)
	return ..()

/datum/status_effect/penis_enlarger
	id = "penis_enlarger"
	alert_type = null
	var/bloodCalc
	var/moveCalc
	var/last_checked_size //used to prevent potential cpu waste, just like the above.

/datum/status_effect/penis_enlarger/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_movespeed_modifier(MOVESPEED_ID_PENIS_HYPERTROPHY, TRUE, 0, NONE, TRUE, moveCalc)

/datum/status_effect/penis_enlarger/tick()
	var/mob/living/carbon/human/H = owner
	var/datum/internal_organ/genital/penis/P = H.internal_organs_by_name["penis"]
	if(!P)
		owner.remove_status_effect(src)
		return
	moveCalc = 1 + ((round(P.length) - 21) / 3) //effects how fast you can move
	bloodCalc = 1 + ((round(P.length) - 21) / 15) //effects how much blood you need (I didn' bother adding an arousal check because I'm spending too much time on this organ already.)

	var/modifier = H.has_movespeed_modifier(MOVESPEED_ID_PENIS_HYPERTROPHY)
	if(P.length < 22 && modifier)
		to_chat(owner, "<span class='notice'>Your [pick(GLOB.dick_nouns)] has become a more managable size, liberating your movements.</span>")
		H.remove_movespeed_modifier(MOVESPEED_ID_PENIS_HYPERTROPHY)
	else if(P.length >= 22 && !modifier)
		to_chat(H, "<span class='warning'>Your [pick(GLOB.dick_nouns)] is so substantial, it's taking all your blood and affecting your movements!</span>")
		H.add_movespeed_modifier(MOVESPEED_ID_PENIS_HYPERTROPHY, TRUE, 0, NONE, TRUE, moveCalc)
	H.blood_volume -= bloodCalc

	return ..()

/datum/status_effect/chem/penis_enlarger/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_PENIS_HYPERTROPHY)
	owner.restore_blood()
	return ..()

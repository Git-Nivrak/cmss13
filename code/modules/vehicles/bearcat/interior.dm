/obj/structure/prop/vehicle/bearcat
	name = "bearcat chassis"

	icon = 'icons/obj/vehicles/interiors/bearcat_chassis.dmi'
	icon_state = "chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/interior_exit/vehicle/bearcat
	icon = 'icons/obj/vehicles/interiors/bearcat.dmi'
	opacity = FALSE

/obj/structure/interior_exit/vehicle/bearcat/left
	name = "bearcat side door"
	icon_state = "door left"

/obj/structure/interior_exit/vehicle/bearcat/right
	name = "bearcat side door"
	icon_state = "door right"

/obj/structure/interior_exit/vehicle/bearcat/back
	name = "bearcat back door"
	icon_state = "rear door closed"

/obj/structure/bed/chair/vehicle/bearcat
	name = "passenger seat"
	icon = 'icons/obj/vehicles/interiors/bearcat.dmi'
	icon_state = "seat"

/obj/structure/bed/chair/vehicle/bearcat/buckle_mob(mob/M, mob/user)
	if (!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled || !isturf(user.loc))
		return

	if (user.is_mob_incapacitated() || HAS_TRAIT(user, TRAIT_IMMOBILIZED) || HAS_TRAIT(user, TRAIT_FLOORED))
		to_chat(user, SPAN_WARNING("You can't do this right now."))
		return

	if (isxeno(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do that, try a nest."))
		return

	if (iszombie(user))
		return

	if(M.loc != loc)
		M.forceMove(loc) //buckle if you're right next to it

		. = buckle_mob(M)

	if (M.mob_size <= MOB_SIZE_XENO)
		if ((M.stat == DEAD && istype(src, /obj/structure/bed/roller) || HAS_TRAIT(M, TRAIT_OPPOSABLE_THUMBS)))
			do_buckle(M, user)
			return
	if ((M.mob_size > MOB_SIZE_HUMAN))
		to_chat(user, SPAN_WARNING("[M] is too big to buckle in."))
		return
	do_buckle(M, user)

/obj/structure/bed/chair/vehicle/bearcat/afterbuckle(mob/user)
	. = ..()

	if(buckled_mob)
		return

	user.forceMove(get_step(user, dir))

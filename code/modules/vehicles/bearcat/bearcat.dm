#define STATE_GROUNDED "grounded"
#define STATE_AIRBORNE "airborne"

/obj/vehicle/multitile/bearcat
	name = "AD-19D Bearcat"
	desc = "Get inside to operate the vehicle."
	icon = 'icons/obj/vehicles/bearcat.dmi'
	icon_state = "stowed"

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -64

	pixel_x = -64
	pixel_y = -80

	luminosity = 0

	interior_map = /datum/map_template/interior/bearcat

	move_max_momentum = 2.2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_light_power = 0
	vehicle_light_range = 0

	vehicle_flags = VEHICLE_CLASS_LIGHT

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/arc_wheels,
	)

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0),
		"back" = list(0, 1),
	)

	seats = list(
		VEHICLE_DRIVER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
	)

	
	var/state = STATE_GROUNDED

	//----------------------------
	// Light Related Vars
	var/side_lights_x_offset = 32
	var/side_lights_y_offset = 0
	
	var/rear_lights_x_offset = 20
	var/rear_lights_y_offset = 60

	var/front_lights_x_offset = -18
	var/front_lights_y_offset = -46

	var/lights_range = 3
	var/lights_power = 3

	var/side_light_color_1 = LIGHT_COLOR_RED
	var/side_light_color_2 = LIGHT_COLOR_GREEN
	var/rear_light_color = LIGHT_COLOR_LIGHT_CYAN
	var/front_light_color = COLOR_WHITE

/obj/bearcat_light
	light_system = MOVABLE_LIGHT

/obj/bearcat_light/Initialize(mapload, range, power, color, offset_x, offset_y)
	. = ..()
	light_pixel_x = offset_x
	light_pixel_y = offset_y
	set_light(range, power, color)

/obj/vehicle/multitile/bearcat/Initialize(mapload, ...)
	. = ..()
	add_hardpoint(new /obj/item/hardpoint/locomotion/arc_wheels)
	create_lights(src, dir, dir)

	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(create_lights))

/obj/vehicle/multitile/bearcat/proc/create_lights(atom/movable/source, dir, newDir)
	SIGNAL_HANDLER

	for(var/obj/bearcat_light/light_source in vis_contents)
		qdel(light_source)
	
	switch (newDir)
		if (SOUTH)
			vis_contents += new /obj/bearcat_light(src, lights_range, lights_power, front_light_color, front_lights_x_offset, front_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, rear_lights_x_offset, rear_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, -rear_lights_x_offset, rear_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_1, side_lights_x_offset, side_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_2, -side_lights_x_offset, side_lights_y_offset)
		if (NORTH)
			vis_contents += new /obj/bearcat_light(src, lights_range, lights_power, front_light_color, -front_lights_x_offset, -front_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, rear_lights_x_offset, -rear_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, -rear_lights_x_offset, -rear_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_1, -side_lights_x_offset, side_lights_y_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_2, side_lights_x_offset, side_lights_y_offset)
		if (WEST)
			vis_contents += new /obj/bearcat_light(src, lights_range, lights_power, front_light_color, front_lights_y_offset, -front_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, rear_lights_y_offset, rear_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, rear_lights_y_offset, -rear_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_1, side_lights_y_offset, -side_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_2, side_lights_y_offset, side_lights_x_offset)
		if (EAST)
			vis_contents += new /obj/bearcat_light(src, lights_range, lights_power, front_light_color, -front_lights_y_offset, front_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, -rear_lights_y_offset, -rear_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, rear_light_color, -rear_lights_y_offset, rear_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_1, side_lights_y_offset, side_lights_x_offset)
			vis_contents += new /obj/bearcat_light(src, lights_range-1, lights_power, side_light_color_2, side_lights_y_offset, -side_lights_x_offset)

/obj/vehicle/multitile/bearcat/relaymove(mob/user, direction)
	if(state == STATE_GROUNDED)
		return FALSE

	return ..()

/obj/vehicle/multitile/bearcat/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/bearcat/proc/takeoff,
		/obj/vehicle/multitile/bearcat/proc/land,
	))

/obj/vehicle/multitile/bearcat/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/bearcat/proc/takeoff,
		/obj/vehicle/multitile/bearcat/proc/land,
	))
	SStgui.close_user_uis(M, src)	

/obj/vehicle/multitile/bearcat/proc/takeoff()
	set name = "Takeoff"
	set desc = "Initiate the take off sequence."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/bearcat/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return
	
	if(vehicle.state == STATE_AIRBORNE)
		return

	vehicle.forceMove(locate(vehicle.x, vehicle.y, vehicle.z + 1))
	vehicle.state = STATE_AIRBORNE
	return

/obj/vehicle/multitile/bearcat/proc/land()
	set name = "Land"
	set desc = "Initiate the landing sequence."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/bearcat/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.state == STATE_GROUNDED)
		return

	vehicle.forceMove(locate(vehicle.x, vehicle.y, vehicle.z - 1))
	vehicle.state = STATE_GROUNDED
	return

/turf/simulated
	name = "station"
	var/wet = 0
	var/bloody = 0		// for blood trails
	var/oily = 0		// for oil trails
	var/xenobloody = 0	//for xenoblood trails
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/proc/MakeSlippery(var/wet_setting = 1) // 1 = Water, 2 = Lube
	if(wet >= wet_setting)
		return
	wet = wet_setting
	if(wet_setting == 1)
		if(wet_overlay)
			overlays -= wet_overlay
			wet_overlay = null
		wet_overlay = image('icons/effects/water.dmi', src, "wet_floor_static")
		overlays += wet_overlay

	spawn(rand(790, 820)) // Purely so for visual effect
		if(!istype(src, /turf/simulated)) //Because turfs don't get deleted, they change, adapt, transform, evolve and deform. they are one and they are all.
			return
		if(wet > wet_setting) return
		wet = 0
		if(wet_overlay)
			overlays -= wet_overlay

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "<span class='danger'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return

	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)	return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(istype(H.shoes, /obj/item/clothing/shoes/clown_shoes))
				var/obj/item/clothing/shoes/clown_shoes/O = H.shoes
				if(H.m_intent == "run")
					if(O.footstep >= 2)
						O.footstep = 0
						playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
					else
						O.footstep++
				else
					playsound(src, "clownstep", 20, 1)

		switch (src.wet)
			if(1) //wet floor
				if(!M.slip(4, 2, null, (NO_SLIP_WHEN_WALKING|STEP)))
					M.inertia_dir = 0
				return

			if(2) //lube
				M.slip(0, 10, null, (STEP|SLIDE|GALOSHES_DONT_HELP))


		if(!istype(M, /mob/living/carbon/slime))
			var/amount = max(M.trail,rand(4,8))
			if(xenobloody > 0)
				M.trail = amount
				M.trailtype = "xeno"
				xenobloody = max(xenobloody-amount,0)

			else if(bloody > 0)
				M.trail = amount
				M.trailtype = "blood"
				bloody = max(bloody-amount,0)

			else if(oily > 0)
				M.trail = amount
				M.trailtype = "oil"
				oily = max(oily-amount,0)



	..()
/turf/simulated/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(istype(mover,/obj/structure/faketurf))
		return 0
	return ..(mover,forget)

/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1

/obj/item/projectile/reagent
	name = "syringe dart"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "syringeproj"
	damage = 0
	nodamage = 1
	flag = "bullet"
	kill_count = 8 // lower range by far
	var/obj/item/contained = null

	New(loc,obj/item/reagent_source = null)
		if(reagent_source && reagent_source.reagents)
			contained = reagent_source
			contained.loc = src
		..()

	on_hit(var/atom/target,var/blocked=0)
		var/destroy = 0
		if(prob(32))
			splat(target)
			destroy = 1
		if(istype(target,/mob))
			var/mob/M = target
			if(contained && contained.reagents && M.reagents)
				contained.reagents.trans_to(M,contained.reagents.total_volume)
			destroy = 1
		if(destroy)
			del contained
		else
			contained.loc = loc
			step_rand(contained)

	proc/splat(var/atom/A)
		A = get_turf(A)
		if(!A) return
		for(var/datum/reagent/R in contained.reagents.reagent_list)
			R.reaction_turf(A)
	/*
	Bump(atom/A as mob|obj|turf)
		var/turf/simulated/T = get_turf(A)
		if(contained && contained.reagents && prob(33) && istype(A))
			if(contained.reagents.has_reagent("banana") && !(locate(/obj/effect/decal/cleanable/pie_smudge) in T))
				new /obj/effect/decal/cleanable/pie_smudge(T)
			for(var/datum/reagent/R in contained.reagents.reagent_list)
				R.reaction_turf(T)

		return ..(A)
	*/

/obj/item/projectile/reagent/bananacreme
	name = "banana creme bullet"
	damage = 0
	nodamage = 1
	flag = "bullet"

	New()
		..()
		contained = new /obj/item/weapon/reagent_containers/food/snacks(src)
		contained.name = "banana creme bullet"
		contained.desc = "Oh god it's dripping all over your fingers and it smells SO good."
		contained.icon = 'icons/obj/items.dmi'
		contained.icon_state = "banana"
		contained.item_state = "banana"

		contained:bitecount = 1 // snack variables not in scope
		contained:bitesize = 10

		contained.reagents.add_reagent("nutriment", 3)
		contained.reagents.add_reagent("banana",3)
		contained.reagents.add_reagent("cornoil", 1)
		contained.reagents.add_reagent("sugar",1)
		if(prob(1))
			contained.reagents.add_reagent("minttoxin",1)
		return

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	flag = "bullet"

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	var/temperature = 100


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/temp/hot
	name = "heat beam"
	temperature = 400

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small1"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	flag = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.ex_act(2)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				delete()
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		..()
		return

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(mob/living/carbon/human/target, var/blocked = 0)
		..()
		return


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.adjustBrainLoss(20)
			M.hallucination += 20

/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 15
	damage_type = BRUTE
	flag = "bomb"
	range = 3

obj/item/projectile/kinetic/New()
	var/turf/proj_turf = get_turf(src)
	if(!istype(proj_turf, /turf))
		return
	var/datum/gas_mixture/environment = proj_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure < 50)
		name = "full strength kinetic force"
		damage = 30
	..()

/obj/item/projectile/kinetic/Range()
	range--
	if(range <= 0)
		new /obj/item/effect/kinetic_blast(src.loc)
		delete()

/obj/item/projectile/kinetic/on_hit(var/atom/target)
	var/turf/target_turf= get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.gets_drilled()
	new /obj/item/effect/kinetic_blast(target_turf)
	..()

/obj/item/effect/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = 4.1

/obj/item/effect/kinetic_blast/New()
	spawn(4)
		qdel(src)
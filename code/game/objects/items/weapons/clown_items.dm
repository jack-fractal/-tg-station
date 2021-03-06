/* Clown Items
 * Contains:
 *		Soap
 *		Bike Horns
 */

/*
 * Soap
 */

/obj/item/weapon/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = 1.0
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/uses = 10
	var/usesize = 1

/obj/item/weapon/soap/nanotrasen
	desc = "A Nanotrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"
	uses = 30

/obj/item/weapon/soap/deluxe
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of condoms."
	icon_state = "soapdeluxe"
	uses = 25

/obj/item/weapon/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"
	usesize = 0

/obj/item/weapon/soap/borg
	desc = "A very durable bar of robo-soap."
	icon_state = "soapdeluxe"
	usesize = 0

/obj/item/weapon/soap/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		M.slip(4, 2, src)
		if(CLUMSY in M.mutations)
			uses++ // murphy's law compels you
		else
			uses--
		if(uses <= 0)
			del src

/obj/item/weapon/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		user << "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>"
	else if(istype(target,/turf))
		var/cleaned = 0
		for(var/obj/effect/decal/cleanable/C in target)
			if(uses <= 0 || cleaned > 3) break
			cleaned++
			uses-=usesize
			qdel(C)
		if(cleaned > 0)
			usr << "<span class='notice'>You clean \the [target.name].</span>"
		if(uses <= 0)
			user << "<span class='notice'>That's the last of this bar of soap.</span>"
			qdel(src)
	else if(istype(target,/obj/effect/decal/cleanable))
		user << "<span class='notice'>You scrub \the [target.name] out.</span>"
		qdel(target)
		uses-=usesize
		if(src.uses<=0)
			user << "<span class='notice'>That's the last of this bar of soap.</span>"
			qdel(src)
	else if(istype(target,/obj/structure) || istype(target,/obj/machinery))
		return // I'm pretty sure these never get stained so you'd waste good soap on them
	else
		user << "<span class='notice'>You clean \the [target.name].</span>"
		var/obj/effect/decal/cleanable/C = locate() in target
		qdel(C)
		target.clean_blood()
		uses-=usesize
		if(uses<=0)
			user << "<span class='notice'>That's the last of this bar of soap.</span>"
			del(src)
	return

/obj/item/weapon/soap/attack(mob/target as mob, mob/user as mob)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message("<span class='danger'> \the [user] washes \the [target]'s mouth out with soap!</span>")
		uses-=usesize
		if(uses<=0)
			user << "<span class='notice'>That's the last of this bar of soap.</span>"
			qdel(src)
		return
	//..()
	return

/obj/item/weapon/soap/attackby(obj/item/I as obj, mob/user as mob) //todo: implement isSharp for soap splitting

	if(istype(I,/obj/item/weapon/kitchenknife) || istype(I,/obj/item/weapon/kitchen/utensil/knife) || istype(I,/obj/item/weapon/butch))

		if(usesize == 0)
			user << "You try to split the soap in twain, but alas, it is too though."
			return

		//Split the soap in two.  Other bladed implements could do this, but it would be pretty awkward.  That's my excuse...
		if(uses <= 5)
			user << "You try to split the soap in twain, but end up destroying it."
			qdel(src)
		else
			user << "You split the bar of soap down the middle."
			var/newuses = round(uses/2) - 1
			uses = newuses
			new type(user.loc)
		return
	..()

/obj/item/weapon/soap/examine()
	..()
	usr << "<span class='notice'> It has [uses] uses left.</span>"

/*
 * Bike Horns
 */


/obj/item/weapon/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 0
	hitsound = null //To prevent tap.ogg playing, as the item lacks of force
	w_class = 1.0
	throw_speed = 3
	throw_range = 7
	attack_verb = list("HONKED")
	var/spam_flag = 0

/obj/item/weapon/bikehorn/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/items/bikehorn.ogg', 50, 1, -1) //plays instead of tap.ogg!
	return ..()

/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

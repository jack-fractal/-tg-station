/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = 1

/obj/effect/decal/cleanable/greenglow
	name = "green glow"

/obj/effect/decal/cleanable/greenglow/New()
	..()
	spawn(1200)// 2 minutes
		qdel(src)

/obj/effect/decal/cleanable/greenglow/ex_act()
	return

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	mouse_opacity = 0

/obj/effect/decal/cleanable/flour
	name = "flour"
	desc = "It's still good. Four second rule!"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	luminosity = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

/obj/effect/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/obj/chemical.dmi'
	icon_state = "molten"

/obj/effect/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Somebody should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	var/list/viruses = list()

/obj/effect/decal/cleanable/vomit/New()
	spawn(12000) // 20 minutes
		icon_state += "-old"
		name = "crusty dried vomit"
		desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	..()

/obj/effect/decal/cleanable/tomato_smudge
	name = "tomato smudge"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/decal/cleanable/egg_smudge
	name = "smashed egg"
	desc = "Seems like this one won't hatch."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/decal/cleanable/pie_smudge //honk
	name = "smashed pie"
	desc = "It's pie cream from a cream pie."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_pie")

/obj/effect/decal/cleanable/trail
	icon = 'icons/effects/footprints.dmi'
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	alpha = 192

/obj/effect/decal/cleanable/trail/bloodtrail
	name = "bloody footprints"
	desc = "Look, Pheonix, they're leading away from the crime scene!"
	icon_state = "blood2"

/obj/effect/decal/cleanable/trail/bloodtrail/paw
	name = "bloody pawprints"
	desc = "Perhaps it's a miniature Bigfoot?"
	icon_state = "bloodpaw2"

/obj/effect/decal/cleanable/trail/bloodtrail/xeno
	name = "bloody clawprints"
	desc = "The hunt is on!"
	icon_state = "bloodclaw2"

/obj/effect/decal/cleanable/trail/oiltrail
	name = "oily footprints"
	desc = "Look at what pollution has wrought."
	icon_state = "oil2"

/obj/effect/decal/cleanable/trail/oiltrail/paw
	name = "oily pawprints"
	desc = "Somewhere, Space PETA is having a fit."
	icon_state = "oilpaw2"

/obj/effect/decal/cleanable/trail/oiltrail/xeno
	name = "oily clawprints"
	desc = "Quick, set it on fire!"
	icon_state = "oilclaw2"

/obj/effect/decal/cleanable/trail/xenotrail
	name = "green bloody footprints"
	desc = "A satisfying end to the xeno menace."
	icon_state = "xeno2"

/obj/effect/decal/cleanable/trail/xenotrail/paw
	name = "green bloody pawprints"
	desc = "Maybe they're in cahoots?"
	icon_state = "xenopaw2"

/obj/effect/decal/cleanable/trail/xenotrail/xeno
	name = "green bloody clawprints"
	desc = "Somewhere out there is one pissed off xeno."
	icon_state = "xenoclaw2"

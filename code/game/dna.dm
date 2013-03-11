#define REJUVENATORS_INJECT 15
#define REJUVENATORS_MAX 90

/////////////////////////// DNA DATUM
/datum/dna
	var/unique_enzymes = null
	var/struc_enzymes = null
	var/uni_identity = null
	var/b_type = "A+"
	var/mutantrace = null  //The type of mutant race the player is if applicable (i.e. potato-man)
	var/real_name //Stores the real name of the person who originally got this dna datum. Used primarely for changelings,

/datum/dna/proc/check_integrity(var/mob/living/carbon/human/character)
	if(character)
		if(length(uni_identity) != 39)
			//Lazy.
			var/temp

			//Hair
			var/hair	= 0
			if(!character.h_style)
				character.h_style = "Skinhead"

			var/hrange = round(4095 / hair_styles_list.len)
			var/index = hair_styles_list.Find(character.h_style)
			if(index)
				hair = index * hrange - rand(1,hrange-1)

			//Facial Hair
			var/beard	= 0
			if(!character.f_style)
				character.f_style = "Shaved"

			var/f_hrange = round(4095 / facial_hair_styles_list.len)
			index = facial_hair_styles_list.Find(character.f_style)
			if(index)
				beard = index * f_hrange - rand(1,f_hrange-1)

			temp = add_zero2(num2hex((character.r_hair),1), 3)
			temp += add_zero2(num2hex((character.b_hair),1), 3)
			temp += add_zero2(num2hex((character.g_hair),1), 3)
			temp += add_zero2(num2hex((character.r_facial),1), 3)
			temp += add_zero2(num2hex((character.b_facial),1), 3)
			temp += add_zero2(num2hex((character.g_facial),1), 3)
			temp += add_zero2(num2hex(((character.s_tone + 220) * 16),1), 3)
			temp += add_zero2(num2hex((character.r_eyes),1), 3)
			temp += add_zero2(num2hex((character.g_eyes),1), 3)
			temp += add_zero2(num2hex((character.b_eyes),1), 3)

			var/gender

			if (character.gender == MALE)
				gender = add_zero2(num2hex((rand(1,(2050+BLOCKADD))),1), 3)
			else
				gender = add_zero2(num2hex((rand((2051+BLOCKADD),4094)),1), 3)

			temp += gender
			temp += add_zero2(num2hex((beard),1), 3)
			temp += add_zero2(num2hex((hair),1), 3)

			uni_identity = temp
		if(length(struc_enzymes)!= 42)
			var/mutstring = ""
			for(var/i = 1, i <= 13, i++)
				mutstring += add_zero2(num2hex(rand(1,1024)),3)

			struc_enzymes = mutstring
		if(length(unique_enzymes) != 32)
			unique_enzymes = md5(character.real_name)
	else
		if(length(uni_identity) != 39) uni_identity = "00600200A00E0110148FC01300B0095BD7FD3F4"
		if(length(struc_enzymes)!= 42) struc_enzymes = "0983E840344C39F4B059D5145FC5785DC6406A4000"

/datum/dna/proc/ready_dna(mob/living/carbon/human/character)
	var/temp

	//Hair
	var/hair	= 0
	if(!character.h_style)
		character.h_style = "Bald"

	var/hrange = round(4095 / hair_styles_list.len)
	var/index = hair_styles_list.Find(character.h_style)
	if(index)
		hair = index * hrange - rand(1,hrange-1)

	//Facial Hair
	var/beard	= 0
	if(!character.f_style)
		character.f_style = "Shaved"

	var/f_hrange = round(4095 / facial_hair_styles_list.len)
	index = facial_hair_styles_list.Find(character.f_style)
	if(index)
		beard = index * f_hrange - rand(1,f_hrange-1)

	temp = add_zero2(num2hex((character.r_hair),1), 3)
	temp += add_zero2(num2hex((character.b_hair),1), 3)
	temp += add_zero2(num2hex((character.g_hair),1), 3)
	temp += add_zero2(num2hex((character.r_facial),1), 3)
	temp += add_zero2(num2hex((character.b_facial),1), 3)
	temp += add_zero2(num2hex((character.g_facial),1), 3)
	temp += add_zero2(num2hex(((character.s_tone + 220) * 16),1), 3)
	temp += add_zero2(num2hex((character.r_eyes),1), 3)
	temp += add_zero2(num2hex((character.g_eyes),1), 3)
	temp += add_zero2(num2hex((character.b_eyes),1), 3)

	var/gender

	if (character.gender == MALE)
		gender = add_zero2(num2hex((rand(1,(2050+BLOCKADD))),1), 3)
	else
		gender = add_zero2(num2hex((rand((2051+BLOCKADD),4094)),1), 3)

	temp += gender
	temp += add_zero2(num2hex((beard),1), 3)
	temp += add_zero2(num2hex((hair),1), 3)

	uni_identity = temp

	var/mutstring = ""
	for(var/i = 1, i <= 13, i++)
		mutstring += add_zero2(num2hex(rand(1,1024)),3)

	struc_enzymes = mutstring

	unique_enzymes = md5(character.real_name)
	reg_dna[unique_enzymes] = character.real_name

/////////////////////////// DNA DATUM

/////////////////////////// DNA HELPER-PROCS
/proc/getleftblocks(input,blocknumber,blocksize)
	var/string

	if (blocknumber > 1)
		string = copytext(input,1,((blocksize*blocknumber)-(blocksize-1)))
		return string
	else
		return null

/proc/getrightblocks(input,blocknumber,blocksize)
	var/string
	if (blocknumber < (length(input)/blocksize))
		string = copytext(input,blocksize*blocknumber+1,length(input)+1)
		return string
	else
		return null

/proc/getblockstring(input,block,subblock,blocksize,src,ui) // src is probably used here just for urls; ui is 1 when requesting for the unique identifier screen, 0 for structural enzymes screen
	var/string = "<div class='getblockstring'><div class='blockString'>"
	var/subpos = 1 // keeps track of the current sub block
	var/blockpos = 1 // keeps track of the current block


	for(var/i = 1, i <= length(input), i++) // loop through each letter

		var/pushstring

		if(subpos == subblock && blockpos == block) // if the current block/subblock is selected, mark it
			pushstring = "<span class='linkOn'>[copytext(input, i, i+1)]</span>"
		else
			if(ui) //This is for allowing block clicks to be differentiated
				pushstring = "<a href='?src=\ref[src];uimenuset=[num2text(blockpos)];uimenusubset=[num2text(subpos)]'>[copytext(input, i, i+1)]</a>"
			else
				pushstring = "<a href='?src=\ref[src];semenuset=[num2text(blockpos)];semenusubset=[num2text(subpos)]'>[copytext(input, i, i+1)]</a>"

		string += pushstring // push the string to the return string

		if(subpos >= blocksize) // add a line break for every block
			string += "</div><div class='blockString'>"
			subpos = 0
			blockpos++

		subpos++

	string += "</div></div>"

	return string


/proc/getblock(input,blocknumber,blocksize)
	var/result
	result = copytext(input ,(blocksize*blocknumber)-(blocksize-1),(blocksize*blocknumber)+1)
	return result

/proc/getblockbuffer(input,blocknumber,blocksize)
	var/result[3]
	var/block = copytext(input ,(blocksize*blocknumber)-(blocksize-1),(blocksize*blocknumber)+1)
	for(var/i = 1, i <= 3, i++)
		result[i] = copytext(block, i, i+1)
	return result

/proc/setblock(istring, blocknumber, replacement, blocksize)
	if(!istring || !blocknumber || !replacement || !blocksize)	return 0
	var/result = getleftblocks(istring, blocknumber, blocksize) + replacement + getrightblocks(istring, blocknumber, blocksize)
	return result

/proc/add_zero2(t, u)
	var/temp1
	while (length(t) < u)
		t = "0[t]"
	temp1 = t
	if (length(t) > u)
		temp1 = copytext(t,2,u+1)
	return temp1


#define HIGHCHANCE prob((rs*10)+rd)
#define MEDCHANCE prob((rs*10))
#define LOWCHANCE prob((rs*10)-rd)
#define TINYCHANCE prob((rs*5)+rd)

/proc/miniscramble(input,rs,rd)
	var/output
	output = null
	if (input == "C" || input == "D" || input == "E" || input == "F")
		output = pick(MEDCHANCE;"4",MEDCHANCE;"5",MEDCHANCE;"6",MEDCHANCE;"7",TINYCHANCE;"0",TINYCHANCE;"1",LOWCHANCE;"2",LOWCHANCE;"3")
	if (input == "8" || input == "9" || input == "A" || input == "B")
		output = pick(MEDCHANCE;"4",MEDCHANCE;"5",MEDCHANCE;"A",MEDCHANCE;"B",TINYCHANCE;"C",TINYCHANCE;"D",TINYCHANCE;"2",TINYCHANCE;"3")
	if (input == "4" || input == "5" || input == "6" || input == "7")
		output = pick(MEDCHANCE;"4",MEDCHANCE;"5",MEDCHANCE;"A",MEDCHANCE;"B",TINYCHANCE;"C",TINYCHANCE;"D",TINYCHANCE;"2",TINYCHANCE;"3")
	if (input == "0" || input == "1" || input == "2" || input == "3")
		output = pick(MEDCHANCE;"8",MEDCHANCE;"9",MEDCHANCE;"A",MEDCHANCE;"B",LOWCHANCE;"C",LOWCHANCE;"D",TINYCHANCE;"E",TINYCHANCE;"F")
	if (!output) output = "5"
	return output

//Instead of picking a value far from the input, this will pick values closer to it.
//Sorry for the block of code, but it's more efficient then calling text2hex -> loop -> hex2text
/proc/miniscrambletarget(input,rs,rd)
	var/output = null
	switch(input)
		if("0")
			output = pick(HIGHCHANCE;"0",HIGHCHANCE;"1",MEDCHANCE;"2",LOWCHANCE;"3")
		if("1")
			output = pick(HIGHCHANCE;"0",HIGHCHANCE;"1",HIGHCHANCE;"2",MEDCHANCE;"3",LOWCHANCE;"4")
		if("2")
			output = pick(MEDCHANCE;"0",HIGHCHANCE;"1",HIGHCHANCE;"2",HIGHCHANCE;"3",MEDCHANCE;"4",LOWCHANCE;"5")
		if("3")
			output = pick(LOWCHANCE;"0",MEDCHANCE;"1",HIGHCHANCE;"2",HIGHCHANCE;"3",HIGHCHANCE;"4",MEDCHANCE;"5",LOWCHANCE;"6")
		if("4")
			output = pick(LOWCHANCE;"1",MEDCHANCE;"2",HIGHCHANCE;"3",HIGHCHANCE;"4",HIGHCHANCE;"5",MEDCHANCE;"6",LOWCHANCE;"7")
		if("5")
			output = pick(LOWCHANCE;"2",MEDCHANCE;"3",HIGHCHANCE;"4",HIGHCHANCE;"5",HIGHCHANCE;"6",MEDCHANCE;"7",LOWCHANCE;"8")
		if("6")
			output = pick(LOWCHANCE;"3",MEDCHANCE;"4",HIGHCHANCE;"5",HIGHCHANCE;"6",HIGHCHANCE;"7",MEDCHANCE;"8",LOWCHANCE;"9")
		if("7")
			output = pick(LOWCHANCE;"4",MEDCHANCE;"5",HIGHCHANCE;"6",HIGHCHANCE;"7",HIGHCHANCE;"8",MEDCHANCE;"9",LOWCHANCE;"A")
		if("8")
			output = pick(LOWCHANCE;"5",MEDCHANCE;"6",HIGHCHANCE;"7",HIGHCHANCE;"8",HIGHCHANCE;"9",MEDCHANCE;"A",LOWCHANCE;"B")
		if("9")
			output = pick(LOWCHANCE;"6",MEDCHANCE;"7",HIGHCHANCE;"8",HIGHCHANCE;"9",HIGHCHANCE;"A",MEDCHANCE;"B",LOWCHANCE;"C")
		if("10")//A
			output = pick(LOWCHANCE;"7",MEDCHANCE;"8",HIGHCHANCE;"9",HIGHCHANCE;"A",HIGHCHANCE;"B",MEDCHANCE;"C",LOWCHANCE;"D")
		if("11")//B
			output = pick(LOWCHANCE;"8",MEDCHANCE;"9",HIGHCHANCE;"A",HIGHCHANCE;"B",HIGHCHANCE;"C",MEDCHANCE;"D",LOWCHANCE;"E")
		if("12")//C
			output = pick(LOWCHANCE;"9",MEDCHANCE;"A",HIGHCHANCE;"B",HIGHCHANCE;"C",HIGHCHANCE;"D",MEDCHANCE;"E",LOWCHANCE;"F")
		if("13")//D
			output = pick(LOWCHANCE;"A",MEDCHANCE;"B",HIGHCHANCE;"C",HIGHCHANCE;"D",HIGHCHANCE;"E",MEDCHANCE;"F")
		if("14")//E
			output = pick(LOWCHANCE;"B",MEDCHANCE;"C",HIGHCHANCE;"D",HIGHCHANCE;"E",HIGHCHANCE;"F")
		if("15")//F
			output = pick(LOWCHANCE;"C",MEDCHANCE;"D",HIGHCHANCE;"E",HIGHCHANCE;"F")

	if(!input || !output) //How did this happen?
		output = "8"

	return output
#undef HIGHCHANCE
#undef MEDCHANCE
#undef LOWCHANCE
#undef TINYCHANCE

/proc/isblockon(hnumber, bnumber , var/UI = 0)

	var/temp2
	temp2 = hex2num(hnumber)

	if(UI)
		if(temp2 >= 2050)
			return 1
		else
			return 0

	if (bnumber == HULKBLOCK || bnumber == TELEBLOCK)
		if (temp2 >= 3500 + BLOCKADD)
			return 1
		else
			return 0
	if (bnumber == XRAYBLOCK || bnumber == FIREBLOCK)
		if (temp2 >= 3050 + BLOCKADD)
			return 1
		else
			return 0


	if (temp2 >= 2050 + BLOCKADD)
		return 1
	else
		return 0

/proc/randmutb(mob/M as mob)
	if(!M)	return
	var/num
	var/newdna
	num = pick(1,3,FAKEBLOCK,5,CLUMSYBLOCK,7,9,BLINDBLOCK,DEAFBLOCK)
	M.dna.check_integrity()
	newdna = setblock(M.dna.struc_enzymes,num,toggledblock(getblock(M.dna.struc_enzymes,num,3)),3)
	M.dna.struc_enzymes = newdna
	return

/proc/randmutg(mob/M as mob)
	if(!M)	return
	var/num
	var/newdna
	num = pick(HULKBLOCK,XRAYBLOCK,FIREBLOCK,TELEBLOCK)
	M.dna.check_integrity()
	newdna = setblock(M.dna.struc_enzymes,num,toggledblock(getblock(M.dna.struc_enzymes,num,3)),3)
	M.dna.struc_enzymes = newdna
	return

/proc/scramble(var/type, mob/M as mob, var/p)
	if(!M)	return
	M.dna.check_integrity()
	if(type)
		for(var/i = 1, i <= 13, i++)
			if(prob(p))
				M.dna.uni_identity = setblock(M.dna.uni_identity, i, add_zero2(num2hex(rand(1,4095), 1), 3), 3)
		updateappearance(M, M.dna.uni_identity)

	else
		for(var/i = 1, i <= 13, i++)
			if(prob(p))
				M.dna.struc_enzymes = setblock(M.dna.struc_enzymes, i, add_zero2(num2hex(rand(1,4095), 1), 3), 3)
		domutcheck(M, null)
	return

/proc/randmuti(mob/M as mob)
	if(!M)	return
	var/num
	var/newdna
	num = pick(1,2,3,4,5,6,7,8,9,10,11,12,13)
	M.dna.check_integrity()
	newdna = setblock(M.dna.uni_identity,num,add_zero2(num2hex(rand(1,4095),1),3),3)
	M.dna.uni_identity = newdna
	return

/proc/toggledblock(hnumber) //unused
	var/temp3
	var/chtemp
	temp3 = hex2num(hnumber)
	if (temp3 < 2050)
		chtemp = rand(2050,4095)
		return add_zero2(num2hex(chtemp,1),3)
	else
		chtemp = rand(1,2049)
		return add_zero2(num2hex(chtemp,1),3)
/////////////////////////// DNA HELPER-PROCS

/////////////////////////// DNA MISC-PROCS
/proc/updateappearance(mob/M as mob , structure)
	if(istype(M, /mob/living/carbon/human))
		M.dna.check_integrity()
		var/mob/living/carbon/human/H = M
		H.r_hair = hex2num(getblock(structure,1,3))
		H.b_hair = hex2num(getblock(structure,2,3))
		H.g_hair = hex2num(getblock(structure,3,3))
		H.r_facial = hex2num(getblock(structure,4,3))
		H.b_facial = hex2num(getblock(structure,5,3))
		H.g_facial = hex2num(getblock(structure,6,3))
		H.s_tone = round(((hex2num(getblock(structure,7,3)) / 16) - 220))
		H.r_eyes = hex2num(getblock(structure,8,3))
		H.g_eyes = hex2num(getblock(structure,9,3))
		H.b_eyes = hex2num(getblock(structure,10,3))

		if (isblockon(getblock(structure, 11,3),11 , 1))
			H.gender = FEMALE
		else
			H.gender = MALE

		//Hair
		var/hairnum = hex2num(getblock(structure,13,3))
		var/index = round(1 +(hairnum / 4096)*hair_styles_list.len)
		if((0 < index) && (index <= hair_styles_list.len))
			H.h_style = hair_styles_list[index]

		//Facial Hair
		var/beardnum = hex2num(getblock(structure,12,3))
		index = round(1 +(beardnum / 4096)*facial_hair_styles_list.len)
		if((0 < index) && (index <= facial_hair_styles_list.len))
			H.f_style = facial_hair_styles_list[index]

		H.update_body(0)
		H.update_hair()

		return 1
	else
		return 0

/proc/domutcheck(mob/living/M as mob, connected, inj)
	//telekinesis = 1
	//firemut = 2
	//xray = 4
	//hulk = 8
	//clumsy = 16
	M.dna.check_integrity()

	M.disabilities = 0
	M.sdisabilities = 0
	M.mutations = list()

	M.see_in_dark = 2
	M.see_invisible = SEE_INVISIBLE_LIVING

	if (isblockon(getblock(M.dna.struc_enzymes, 1,3),1))
		M.disabilities |= NEARSIGHTED
		M << "\red Your eyes feel strange."
	if (isblockon(getblock(M.dna.struc_enzymes, HULKBLOCK,3),HULKBLOCK))
		if(inj || prob(10))
			M << "\blue Your muscles hurt."
			M.mutations.Add(HULK)
	if (isblockon(getblock(M.dna.struc_enzymes, 3,3),3))
		M.disabilities |= EPILEPSY
		M << "\red You get a headache."
	if (isblockon(getblock(M.dna.struc_enzymes, FAKEBLOCK,3),FAKEBLOCK))
		M << "\red You feel strange."
		if (prob(95))
			if(prob(50))
				randmutb(M)
			else
				randmuti(M)
		else
			randmutg(M)
	if (isblockon(getblock(M.dna.struc_enzymes, 5,3),5))
		M.disabilities |= COUGHING
		M << "\red You start coughing."
	if (isblockon(getblock(M.dna.struc_enzymes, CLUMSYBLOCK,3),CLUMSYBLOCK))
		M << "\red You feel lightheaded."
		M.mutations.Add(CLUMSY)
	if (isblockon(getblock(M.dna.struc_enzymes, 7,3),7))
		M.disabilities |= TOURETTES
		M << "\red You twitch."
	if (isblockon(getblock(M.dna.struc_enzymes, XRAYBLOCK,3),XRAYBLOCK))
		if(inj || prob(30))
			M << "\blue The walls suddenly disappear."
			M.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			M.see_in_dark = 8
			M.see_invisible = SEE_INVISIBLE_LEVEL_TWO
			M.mutations.Add(XRAY)
	if (isblockon(getblock(M.dna.struc_enzymes, 9,3),9))
		M.disabilities |= NERVOUS
		M << "\red You feel nervous."
	if (isblockon(getblock(M.dna.struc_enzymes, FIREBLOCK,3),FIREBLOCK))
		if(inj || prob(30))
			M << "\blue Your body feels warm."
			M.mutations.Add(COLD_RESISTANCE)
	if (isblockon(getblock(M.dna.struc_enzymes, BLINDBLOCK,3),BLINDBLOCK))
		M.sdisabilities |= BLIND
		M << "\red You can't seem to see anything."
	if (isblockon(getblock(M.dna.struc_enzymes, TELEBLOCK,3),TELEBLOCK))
		if(inj || prob(25))
			M << "\blue You feel smarter."
			M.mutations.Add(TK)
	if (isblockon(getblock(M.dna.struc_enzymes, DEAFBLOCK,3),DEAFBLOCK))
		M.sdisabilities |= DEAF
		M.ear_deaf = 1
		M << "\red You can't seem to hear anything..."

	/* If you want the new mutations to work, UNCOMMENT THIS.
	if(istype(M, /mob/living/carbon))
		for (var/datum/mutations/mut in global_mutations)
			mut.check_mutation(M)
	*/

//////////////////////////////////////////////////////////// Monkey Block
	if (isblockon(getblock(M.dna.struc_enzymes, 14,3),14) && istype(M, /mob/living/carbon/human))
	// human > monkey
		var/mob/living/carbon/human/H = M
		H.monkeyizing = 1
		var/list/implants = list() //Try to preserve implants.
		for(var/obj/item/weapon/implant/W in H)
			implants += W
			W.loc = null

		if(!connected)
			for(var/obj/item/W in (H.contents-implants))
				if (W==H.w_uniform) // will be teared
					continue
				H.drop_from_inventory(W)
			M.monkeyizing = 1
			M.canmove = 0
			M.icon = null
			M.invisibility = 101
			var/atom/movable/overlay/animation = new( M.loc )
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = src
			flick("h2monkey", animation)
			sleep(48)
			del(animation)

		var/mob/living/carbon/monkey/O = new(src)

		if(M)
			if (M.dna)
				O.dna = M.dna
				M.dna = null

			if (M.suiciding)
				O.suiciding = M.suiciding
				M.suiciding = null


		for(var/datum/disease/D in M.viruses)
			O.viruses += D
			D.affected_mob = O
			M.viruses -= D


		for(var/obj/T in (M.contents-implants))
			del(T)
		//for(var/R in M.organs)
		//	del(M.organs[text("[]", R)])

		O.loc = M.loc

		if(M.mind)
			M.mind.transfer_to(O)	//transfer our mind to the cute little monkey

		if (connected) //inside dna thing
			var/obj/machinery/dna_scannernew/C = connected
			O.loc = C
			C.occupant = O
			connected = null
		O.real_name = text("monkey ([])",copytext(md5(M.real_name), 2, 6))
		O.take_overall_damage(M.getBruteLoss() + 40, M.getFireLoss())
		O.adjustToxLoss(M.getToxLoss() + 20)
		O.adjustOxyLoss(M.getOxyLoss())
		O.stat = M.stat
		O.a_intent = "harm"
		for (var/obj/item/weapon/implant/I in implants)
			I.loc = O
			I.implanted = O
//		O.update_icon = 1	//queue a full icon update at next life() call
		del(M)
		return

	if (!isblockon(getblock(M.dna.struc_enzymes, 14,3),14) && !istype(M, /mob/living/carbon/human))
	// monkey > human,
		var/mob/living/carbon/monkey/Mo = M
		Mo.monkeyizing = 1
		var/list/implants = list() //Still preserving implants
		for(var/obj/item/weapon/implant/W in Mo)
			implants += W
			W.loc = null
		if(!connected)
			for(var/obj/item/W in (Mo.contents-implants))
				Mo.drop_from_inventory(W)
			M.monkeyizing = 1
			M.canmove = 0
			M.icon = null
			M.invisibility = 101
			var/atom/movable/overlay/animation = new( M.loc )
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = src
			flick("monkey2h", animation)
			sleep(48)
			del(animation)

		var/mob/living/carbon/human/O = new( src )
		if (isblockon(getblock(M.dna.uni_identity, 11,3),11))
			O.gender = FEMALE
		else
			O.gender = MALE

		if (M)
			if (M.dna)
				O.dna = M.dna
				M.dna = null

			if (M.suiciding)
				O.suiciding = M.suiciding
				M.suiciding = null

		for(var/datum/disease/D in M.viruses)
			O.viruses += D
			D.affected_mob = O
			M.viruses -= D

		//for(var/obj/T in M)
		//	del(T)

		O.loc = M.loc

		if(M.mind)
			M.mind.transfer_to(O)	//transfer our mind to the human

		if (connected) //inside dna thing
			var/obj/machinery/dna_scannernew/C = connected
			O.loc = C
			C.occupant = O
			connected = null

		var/i = 0
		if(O.dna.real_name && !findtextEx(O.dna.real_name, "monkey (") && O.dna.real_name != "unknown")
			O.real_name = O.dna.real_name
			i++
		while (!i)
			var/randomname
			if (O.gender == MALE)
				randomname = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
			else
				randomname = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))
			if (findname(randomname))
				continue
			else
				O.real_name = randomname
				O.dna.real_name = O.real_name
				O.dna.unique_enzymes = md5(O.real_name)
				i++
		updateappearance(O,O.dna.uni_identity)
		O.take_overall_damage(M.getBruteLoss(), M.getFireLoss())
		O.adjustToxLoss(M.getToxLoss())
		O.adjustOxyLoss(M.getOxyLoss())
		O.stat = M.stat
		for (var/obj/item/weapon/implant/I in implants)
			I.loc = O
			I.implanted = O
//		O.update_icon = 1	//queue a full icon update at next life() call
		del(M)
		return
//////////////////////////////////////////////////////////// Monkey Block
	if(M)
		M.update_icon = 1	//queue a full icon update at next life() call
	return null
/////////////////////////// DNA MISC-PROCS


/////////////////////////// DNA MACHINES
/obj/machinery/dna_scannernew
	name = "\improper DNA Scanner"
	desc = "It scans DNA structures."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300

/obj/machinery/dna_scannernew/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/clonescanner(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/cable_coil(src)
	component_parts += new /obj/item/weapon/cable_coil(src)
	RefreshParts()

/obj/machinery/dna_scannernew/allow_drop()
	return 0

/obj/machinery/dna_scannernew/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/dna_scannernew/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject DNA Scanner"

	if (usr.stat != 0)
		return
	src.go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/weapon/circuitboard/clonescanner)) && (!istype(O,/obj/item/weapon/stock_parts)) && (!istype(O,/obj/item/weapon/cable_coil)))
			O.loc = get_turf(src)//Ejects items that manage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.loc = get_turf(src)
	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"

	if(usr.stat != 0)
		return
	if(!ishuman(usr) && !ismonkey(usr)) //Make sure they're a mob that has dna
		usr << "<span class='notice'>Try as you might, you can not climb up into the scanner.</span>"
		return
	if(occupant)
		usr << "<span class='notice'>The scanner is already occupied!</span>"
		return
	if(usr.abiotic())
		usr << "<span class='notice'>Subject cannot have abiotic items on.</span>"
		return
	usr.stop_pulling()
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "scanner_1"
	/*
	for(var/obj/O in src)    // THIS IS P. STUPID -- LOVE, DOOHL
		//O = null
		del(O)
		//Foreach goto(124)
	*/
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/attackby(obj/item/weapon/grab/G, mob/user)
	if(!istype(G, /obj/item/weapon/grab) || !ismob(G.affecting))
		return
	if(occupant)
		user << "<span class='notice'>The scanner is already occupied!</span>"
		return
	if(G.affecting.abiotic())
		user << "<span class='notice'>Subject cannot have abiotic items on.</span>"
		return
	var/mob/M = G.affecting
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	occupant = M
	user.stop_pulling()
	icon_state = "scanner_1"

	add_fingerprint(user)

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

		if(!M.client && M.mind)
			for(var/mob/dead/observer/ghost in player_list)
				if(ghost.mind == M.mind)
					ghost << "<b><font color = #330033><font size = 3>Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font color>"
					break
	del(G)
	return

/obj/machinery/dna_scannernew/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
/*
//	it's like this was -just- here to break constructed dna scanners -Pete
//	if that's not the case, slap my shit and uncomment this.
//	for(var/obj/O in src)
//		O.loc = src.loc
*/
		//Foreach goto(30)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "scanner_0"
	return

/obj/machinery/dna_scannernew/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				del(src)
				return
		else
	return


/obj/machinery/dna_scannernew/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)


/obj/machinery/computer/scan_consolenew/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew/blob_act()

	if(prob(75))
		del(src)

/obj/machinery/computer/scan_consolenew/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
	else if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			src.icon_state = "c_unpowered"
			stat |= NOPOWER

/obj/machinery/computer/scan_consolenew/New()
	..()

	spawn(5)
		for(dir in list(NORTH,EAST,SOUTH,WEST))
			connected = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
			if(!isnull(connected))
				break
		spawn(250)
			src.injectorready = 1
		return
	return

/obj/machinery/computer/scan_consolenew/attackby(obj/item/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/weapon/disk/data)) && (!src.diskette))
		user.drop_item()
		W.loc = src
		src.diskette = W
		user << "You insert [W]."
		src.updateUsrDialog()
/*
/obj/machinery/computer/scan_consolenew/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	if (!( src.status )) //remove this
		return
	return
*/
/obj/machinery/computer/scan_consolenew/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/scan_consolenew/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as mob)
	if(..())
		return
	dopage(src)

/obj/machinery/computer/scan_consolenew/Topic(href, href_list)
	if(..())
		return
	if(!istype(usr.loc, /turf))
		return
	if(!src )
		return
	if (!((usr.contents.Find(src) || in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon))))
		return

	src.add_fingerprint(usr)

	var/datum/browser/popup = new(usr, "scannernew", "DNA Modifier Console", 520, 620) // Set up the popup browser window
	popup.add_stylesheet("scannernew", 'html/browser/scannernew.css')
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))

	src.temp_html = null
	var/temp_header_html = null
	var/temp_footer_html = null

	src.scanner_status_html = null // Scanner status is reset each update
	var/mob/living/occupant = src.connected.occupant
	var/viable_occupant = (occupant && occupant.dna && !(NOCLONE in occupant.mutations))
	var/mob/living/carbon/human/human_occupant = src.connected.occupant

	if (href_list["screen"]) // Passing a screen is only a request, we set current_screen here but it can be overridden below if necessary
		src.current_screen = href_list["screen"]

	if (!viable_occupant) // If there is no viable occupant only allow certain screens
		var/allowed_no_occupant_screens = list("mainmenu", "radsetmenu", "buffermenu") //These are the screens which will be allowed if there's no occupant
		if (!(src.current_screen in allowed_no_occupant_screens))
			href_list = new /list(0) // clear list of options
			src.current_screen = "mainmenu"


	if (!src.current_screen) // If no screen is set default to mainmenu
		src.current_screen = "mainmenu"


	if (!src.connected) //Is the scanner not connected?
		src.scanner_status_html = "<span class='bad'>ERROR: No DNA Scanner connected.</span>"
		src.current_screen = null // blank does not exist in the switch below, so no screen will be outputted
		src.updateUsrDialog()
		return

	usr.set_machine(src)
	if (href_list["locked"])
		if (src.connected.occupant)
			src.connected.locked = !( src.connected.locked )
	////////////////////////////////////////////////////////
	if (href_list["genpulse"])
		if(!viable_occupant)//Makes sure someone is in there (And valid) before trying anything
			src.temp_html = text("No viable occupant detected.")//More than anything, this just acts as a sanity check in case the option DOES appear for whatever reason
			//usr << browse(temp_html, "window=scannernew;size=550x650")
			//onclose(usr, "scannernew")
			popup.set_content(src.temp_html)
			popup.open()
		else

			src.temp_html = text("Working ... Please wait ([] Seconds)", src.radduration)
			popup.set_content(src.temp_html)
			popup.open()
			var/lock_state = src.connected.locked
			src.connected.locked = 1//lock it
			sleep(10*src.radduration)
			if (!src.connected.occupant)
				src.temp_html = null
				return null
			if (prob(95))
				if(prob(75))
					randmutb(src.connected.occupant)
				else
					randmuti(src.connected.occupant)
			else
				if(prob(95))
					randmutg(src.connected.occupant)
				else
					randmuti(src.connected.occupant)
			src.connected.occupant.radiation += ((src.radstrength*3)+src.radduration*3)
			src.connected.locked = lock_state
			src.temp_html = null
			dopage(src,"screen=radsetmenu")
	if (href_list["radleplus"])
		if(!viable_occupant)
			src.temp_html = text("No viable occupant detected.")
			popup.set_content(src.temp_html)
			popup.open()
		if (src.radduration < 20)
			src.radduration++
			src.radduration++
		dopage(src,"screen=radsetmenu")
	if (href_list["radleminus"])
		if(!viable_occupant)
			src.temp_html = text("No viable occupant detected.")
			popup.set_content(src.temp_html)
			popup.open()
		if (src.radduration > 2)
			src.radduration--
			src.radduration--
		dopage(src,"screen=radsetmenu")
	if (href_list["radinplus"])
		if (src.radstrength < 10)
			src.radstrength++
		dopage(src,"screen=radsetmenu")
	if (href_list["radinminus"])
		if (src.radstrength > 1)
			src.radstrength--
		dopage(src,"screen=radsetmenu")
	////////////////////////////////////////////////////////
	if (href_list["unimenuplus"])
		if (src.uniblock < 13)
			src.uniblock++
		else
			src.uniblock = 1
		dopage(src,"screen=unimenu")
	if (href_list["unimenuminus"])
		if (src.uniblock > 1)
			src.uniblock--
		else
			src.uniblock = 13
		dopage(src,"screen=unimenu")
	if (href_list["unimenusubplus"])
		if (src.subblock < 3)
			src.subblock++
		else
			src.subblock = 1
		dopage(src,"screen=unimenu")
	if (href_list["unimenusubminus"])
		if (src.subblock > 1)
			src.subblock--
		else
			src.subblock = 3
		dopage(src,"screen=unimenu")
	if (href_list["unimenutargetplus"])
		if (src.unitarget < 15)
			src.unitarget++
			src.unitargethex = src.unitarget
			switch(unitarget)
				if(10)
					src.unitargethex = "A"
				if(11)
					src.unitargethex = "B"
				if(12)
					src.unitargethex = "C"
				if(13)
					src.unitargethex = "D"
				if(14)
					src.unitargethex = "E"
				if(15)
					src.unitargethex = "F"
		else
			src.unitarget = 0
			src.unitargethex = 0
		dopage(src,"screen=unimenu")
	if (href_list["unimenutargetminus"])
		if (src.unitarget > 0)
			src.unitarget--
			src.unitargethex = src.unitarget
			switch(unitarget)
				if(10)
					src.unitargethex = "A"
				if(11)
					src.unitargethex = "B"
				if(12)
					src.unitargethex = "C"
				if(13)
					src.unitargethex = "D"
				if(14)
					src.unitargethex = "E"
		else
			src.unitarget = 15
			src.unitargethex = "F"
		dopage(src,"screen=unimenu")
	if (href_list["uimenuset"] && href_list["uimenusubset"]) // This chunk of code updates selected block / sub-block based on click
		var/menuset = text2num(href_list["uimenuset"])
		var/menusubset = text2num(href_list["uimenusubset"])
		if ((menuset <= 13) && (menuset >= 1))
			src.uniblock = menuset
		if ((menusubset <= 3) && (menusubset >= 1))
			src.subblock = menusubset
		dopage(src, "unimenu")
	if (href_list["unipulse"])
		if(src.connected.occupant)
			var/block
			var/newblock
			var/tstructure2
			block = getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),src.subblock,1)

			src.temp_html = text("Working ... Please wait ([] Seconds)", src.radduration)
			popup.set_content(src.temp_html)
			popup.open()
			var/lock_state = src.connected.locked
			src.connected.locked = 1//lock it
			sleep(10*src.radduration)
			if (!src.connected.occupant)
				src.temp_html = null
				return null
			///
			if (prob((80 + (src.radduration / 2))))
				block = miniscrambletarget(num2text(unitarget), src.radstrength, src.radduration)
				newblock = null
				if (src.subblock == 1) newblock = block + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),2,1) + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),3,1)
				if (src.subblock == 2) newblock = getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),1,1) + block + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),3,1)
				if (src.subblock == 3) newblock = getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),1,1) + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),2,1) + block
				tstructure2 = setblock(src.connected.occupant.dna.uni_identity, src.uniblock, newblock,3)
				src.connected.occupant.dna.uni_identity = tstructure2
				updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
				src.connected.occupant.radiation += (src.radstrength+src.radduration)
			else
				if	(prob(20+src.radstrength))
					randmutb(src.connected.occupant)
					domutcheck(src.connected.occupant,src.connected)
				else
					randmuti(src.connected.occupant)
					updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
				src.connected.occupant.radiation += ((src.radstrength*2)+src.radduration)
			src.connected.locked = lock_state
		dopage(src,"screen=unimenu")

	////////////////////////////////////////////////////////
	if (href_list["rejuv"])
		if(!viable_occupant)
			src.temp_html = text("No viable occupant detected.")
			popup.set_content(src.temp_html)
			popup.open()
		else
			if(human_occupant)
				if (human_occupant.reagents.get_reagent_amount("inaprovaline") < REJUVENATORS_MAX)
					if (human_occupant.reagents.get_reagent_amount("inaprovaline") < (REJUVENATORS_MAX - REJUVENATORS_INJECT))
						human_occupant.reagents.add_reagent("inaprovaline", REJUVENATORS_INJECT)
					else
						human_occupant.reagents.add_reagent("inaprovaline", round(REJUVENATORS_MAX - human_occupant.reagents.get_reagent_amount("inaprovaline")))
				//usr << text("Occupant now has [] units of rejuvenation in his/her bloodstream.", human_occupant.reagents.get_reagent_amount("inaprovaline"))

	////////////////////////////////////////////////////////
	if (href_list["strucmenuplus"])
		if (src.strucblock < 14)
			src.strucblock++
		else
			src.strucblock = 1
		dopage(src,"screen=strucmenu")
	if (href_list["strucmenuminus"])
		if (src.strucblock > 1)
			src.strucblock--
		else
			src.strucblock = 14
		dopage(src,"screen=strucmenu")
	if (href_list["strucmenusubplus"])
		if (src.subblock < 3)
			src.subblock++
		else
			src.subblock = 1
		dopage(src,"screen=strucmenu")
	if (href_list["strucmenusubminus"])
		if (src.subblock > 1)
			src.subblock--
		else
			src.subblock = 3
		dopage(src,"screen=strucmenu")
	if (href_list["semenuset"] && href_list["semenusubset"]) // This chunk of code updates selected block / sub-block based on click (se stands for strutural enzymes)
		var/menuset = text2num(href_list["semenuset"])
		var/menusubset = text2num(href_list["semenusubset"])
		if ((menuset <= 14) && (menuset >= 1))
			src.strucblock = menuset
		if ((menusubset <= 3) && (menusubset >= 1))
			src.subblock = menusubset
		dopage(src, "strucmenu")
	if (href_list["strucpulse"])
		var/block
		var/newblock
		var/tstructure2
		var/oldblock
		var/lock_state = src.connected.locked
		src.connected.locked = 1//lock it
		if (viable_occupant)
			block = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),src.subblock,1)

			src.temp_html = text("Working ... Please wait ([] Seconds)", src.radduration)
			popup.set_content(src.temp_html)
			popup.open()
			sleep(10*src.radduration)
		else
			src.temp_html = null
			return null
		///
		if(viable_occupant)
			if (prob((80 + (src.radduration / 2))))
				if ((src.strucblock != 2 || src.strucblock != 12 || src.strucblock != 8 || src.strucblock || 10) && prob (20))
					oldblock = src.strucblock
					block = miniscramble(block, src.radstrength, src.radduration)
					newblock = null
					if (src.strucblock > 1 && src.strucblock < 5)
						src.strucblock++
					else if (src.strucblock > 5 && src.strucblock < 14)
						src.strucblock--
					if (src.subblock == 1) newblock = block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
					if (src.subblock == 2) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
					if (src.subblock == 3) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + block
					tstructure2 = setblock(src.connected.occupant.dna.struc_enzymes, src.strucblock, newblock,3)
					src.connected.occupant.dna.struc_enzymes = tstructure2
					domutcheck(src.connected.occupant,src.connected)
					src.connected.occupant.radiation += (src.radstrength+src.radduration)
					src.strucblock = oldblock
				else
				//
					block = miniscramble(block, src.radstrength, src.radduration)
					newblock = null
					if (src.subblock == 1) newblock = block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
					if (src.subblock == 2) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
					if (src.subblock == 3) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + block
					tstructure2 = setblock(src.connected.occupant.dna.struc_enzymes, src.strucblock, newblock,3)
					src.connected.occupant.dna.struc_enzymes = tstructure2
					domutcheck(src.connected.occupant,src.connected)
					src.connected.occupant.radiation += (src.radstrength+src.radduration)
			else
				if	(prob(80-src.radduration))
					randmutb(src.connected.occupant)
					domutcheck(src.connected.occupant,src.connected)
				else
					randmuti(src.connected.occupant)
					updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
				src.connected.occupant.radiation += ((src.radstrength*2)+src.radduration)
		src.connected.locked = lock_state
		///
		dopage(src,"screen=strucmenu")

	////////////////////////////////////////////////////////
	if (href_list["b1addui"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer1iue = 0
			src.buffer1 = src.connected.occupant.dna.uni_identity
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer1owner = src.connected.occupant.name
			else
				src.buffer1owner = src.connected.occupant.real_name
			src.buffer1label = "Unique Identifier"
			src.buffer1type = "ui"
			dopage(src,"screen=buffermenu")
	if (href_list["b1adduiue"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer1 = src.connected.occupant.dna.uni_identity
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer1owner = src.connected.occupant.name
			else
				src.buffer1owner = src.connected.occupant.real_name
			src.buffer1label = "Unique Identifier & Unique Enzymes"
			src.buffer1type = "ui"
			src.buffer1iue = 1
			dopage(src,"screen=buffermenu")
	if (href_list["b2adduiue"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer2 = src.connected.occupant.dna.uni_identity
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer2owner = src.connected.occupant.name
			else
				src.buffer2owner = src.connected.occupant.real_name
			src.buffer2label = "Unique Identifier & Unique Enzymes"
			src.buffer2type = "ui"
			src.buffer2iue = 1
			dopage(src,"screen=buffermenu")
	if (href_list["b3adduiue"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer3 = src.connected.occupant.dna.uni_identity
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer3owner = src.connected.occupant.name
			else
				src.buffer3owner = src.connected.occupant.real_name
			src.buffer3label = "Unique Identifier & Unique Enzymes"
			src.buffer3type = "ui"
			src.buffer3iue = 1
			dopage(src,"screen=buffermenu")
	if (href_list["b2addui"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer2iue = 0
			src.buffer2 = src.connected.occupant.dna.uni_identity
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer2owner = src.connected.occupant.name
			else
				src.buffer2owner = src.connected.occupant.real_name
			src.buffer2label = "Unique Identifier"
			src.buffer2type = "ui"
			dopage(src,"screen=buffermenu")
	if (href_list["b3addui"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer3iue = 0
			src.buffer3 = src.connected.occupant.dna.uni_identity
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer3owner = src.connected.occupant.name
			else
				src.buffer3owner = src.connected.occupant.real_name
			src.buffer3label = "Unique Identifier"
			src.buffer3type = "ui"
			dopage(src,"screen=buffermenu")
	if (href_list["b1addse"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer1iue = 0
			src.buffer1 = src.connected.occupant.dna.struc_enzymes
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer1owner = src.connected.occupant.name
			else
				src.buffer1owner = src.connected.occupant.real_name
			src.buffer1label = "Structural Enzymes"
			src.buffer1type = "se"
			dopage(src,"screen=buffermenu")
	if (href_list["b2addse"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer2iue = 0
			src.buffer2 = src.connected.occupant.dna.struc_enzymes
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer2owner = src.connected.occupant.name
			else
				src.buffer2owner = src.connected.occupant.real_name
			src.buffer2label = "Structural Enzymes"
			src.buffer2type = "se"
			dopage(src,"screen=buffermenu")
	if (href_list["b3addse"])
		if(src.connected.occupant && src.connected.occupant.dna)
			src.buffer3iue = 0
			src.buffer3 = src.connected.occupant.dna.struc_enzymes
			if (!istype(src.connected.occupant,/mob/living/carbon/human))
				src.buffer3owner = src.connected.occupant.name
			else
				src.buffer3owner = src.connected.occupant.real_name
			src.buffer3label = "Structural Enzymes"
			src.buffer3type = "se"
			dopage(src,"screen=buffermenu")
	if (href_list["b1clear"])
		src.buffer1 = null
		src.buffer1owner = null
		src.buffer1label = null
		src.buffer1iue = null
		dopage(src,"screen=buffermenu")
	if (href_list["b2clear"])
		src.buffer2 = null
		src.buffer2owner = null
		src.buffer2label = null
		src.buffer2iue = null
		dopage(src,"screen=buffermenu")
	if (href_list["b3clear"])
		src.buffer3 = null
		src.buffer3owner = null
		src.buffer3label = null
		src.buffer3iue = null
		dopage(src,"screen=buffermenu")
	if (href_list["b1label"])
		src.buffer1label = sanitize(input("New Label:","Edit Label","Infos here"))
		dopage(src,"screen=buffermenu")
	if (href_list["b2label"])
		src.buffer2label = sanitize(input("New Label:","Edit Label","Infos here"))
		dopage(src,"screen=buffermenu")
	if (href_list["b3label"])
		src.buffer3label = sanitize(input("New Label:","Edit Label","Infos here"))
		dopage(src,"screen=buffermenu")
	if (href_list["b1transfer"])
		if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
			return
		if (src.buffer1type == "ui")
			if (src.buffer1iue)
				src.connected.occupant.real_name = src.buffer1owner
				src.connected.occupant.name = src.buffer1owner
			src.connected.occupant.dna.uni_identity = src.buffer1
			updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
		else if (src.buffer1type == "se")
			src.connected.occupant.dna.struc_enzymes = src.buffer1
			domutcheck(src.connected.occupant,src.connected)
		src.temp_html = "Transfered."
		src.connected.occupant.radiation += rand(20,50)

	if (href_list["b2transfer"])
		if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
			return
		if (src.buffer2type == "ui")
			if (src.buffer2iue)
				src.connected.occupant.real_name = src.buffer2owner
				src.connected.occupant.name = src.buffer2owner
			src.connected.occupant.dna.uni_identity = src.buffer2
			updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
		else if (src.buffer2type == "se")
			src.connected.occupant.dna.struc_enzymes = src.buffer2
			domutcheck(src.connected.occupant,src.connected)
		src.temp_html = "Transfered."
		src.connected.occupant.radiation += rand(20,50)

	if (href_list["b3transfer"])
		if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
			return
		if (src.buffer3type == "ui")
			if (src.buffer3iue)
				src.connected.occupant.real_name = src.buffer3owner
				src.connected.occupant.name = src.buffer3owner
			src.connected.occupant.dna.uni_identity = src.buffer3
			updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
		else if (src.buffer3type == "se")
			src.connected.occupant.dna.struc_enzymes = src.buffer3
			domutcheck(src.connected.occupant,src.connected)
		src.temp_html = "Transfered."
		src.connected.occupant.radiation += rand(20,50)

	if (href_list["b1injector"])
		if (src.injectorready)
			var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
			I.dna = src.buffer1
			I.dnatype = src.buffer1type
			I.loc = src.loc
			I.name += " ([src.buffer1label])"
			if (src.buffer1iue) I.ue = src.buffer1owner //lazy haw haw
			src.temp_html = "Injector created."

			src.injectorready = 0
			spawn(300)
				src.injectorready = 1
		else
			src.temp_html = "Replicator not ready yet."

	if (href_list["b2injector"])
		if (src.injectorready)
			var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
			I.dna = src.buffer2
			I.dnatype = src.buffer2type
			I.loc = src.loc
			I.name += " ([src.buffer2label])"
			if (src.buffer2iue) I.ue = src.buffer2owner //lazy haw haw
			src.temp_html = "Injector created."

			src.injectorready = 0
			spawn(300)
				src.injectorready = 1
		else
			src.temp_html = "Replicator not ready yet."

	if (href_list["b3injector"])
		if (src.injectorready)
			var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
			I.dna = src.buffer3
			I.dnatype = src.buffer3type
			I.loc = src.loc
			I.name += " ([src.buffer3label])"
			if (src.buffer3iue) I.ue = src.buffer3owner //lazy haw haw
			src.temp_html = "Injector created."

			src.injectorready = 0
			spawn(300)
				src.injectorready = 1
		else
			src.temp_html = "Replicator not ready yet."

	////////////////////////////////////////////////////////
	if (href_list["load_disk"])
		var/buffernum = text2num(href_list["load_disk"])
		if ((buffernum > 3) || (buffernum < 1))
			return
		if ((isnull(src.diskette)) || (!src.diskette.data) || (src.diskette.data == ""))
			return
		switch(buffernum)
			if(1)
				src.buffer1 = src.diskette.data
				src.buffer1type = src.diskette.data_type
				src.buffer1iue = src.diskette.ue
				src.buffer1owner = src.diskette.owner
			if(2)
				src.buffer2 = src.diskette.data
				src.buffer2type = src.diskette.data_type
				src.buffer2iue = src.diskette.ue
				src.buffer2owner = src.diskette.owner
			if(3)
				src.buffer3 = src.diskette.data
				src.buffer3type = src.diskette.data_type
				src.buffer3iue = src.diskette.ue
				src.buffer3owner = src.diskette.owner
		src.temp_html = "Data loaded."

	if (href_list["save_disk"])
		var/buffernum = text2num(href_list["save_disk"])
		if ((buffernum > 3) || (buffernum < 1))
			return
		if ((isnull(src.diskette)) || (src.diskette.read_only))
			return
		switch(buffernum)
			if(1)
				src.diskette.data = buffer1
				src.diskette.data_type = src.buffer1type
				src.diskette.ue = src.buffer1iue
				src.diskette.owner = src.buffer1owner
				src.diskette.name = "data disk - '[src.buffer1owner]'"
			if(2)
				src.diskette.data = buffer2
				src.diskette.data_type = src.buffer2type
				src.diskette.ue = src.buffer2iue
				src.diskette.owner = src.buffer2owner
				src.diskette.name = "data disk - '[src.buffer2owner]'"
			if(3)
				src.diskette.data = buffer3
				src.diskette.data_type = src.buffer3type
				src.diskette.ue = src.buffer3iue
				src.diskette.owner = src.buffer3owner
				src.diskette.name = "data disk - '[src.buffer3owner]'"
		src.temp_html = "Data saved."
	if (href_list["eject_disk"])
		if (!src.diskette)
			return
		src.diskette.loc = get_turf(src)
		src.diskette = null
	////////////////////////////////////////////////////////

	src.temp_html = temp_header_html
	switch(src.current_screen)
		if ("mainmenu")
			src.temp_html += "<h3>Main Menu</h3>"
			if (viable_occupant) //is there REALLY someone in there who can be modified?
				src.temp_html += text("<A href='?src=\ref[];screen=unimenu'>Modify Unique Identifier</A><br />", src)
				src.temp_html += text("<A href='?src=\ref[];screen=strucmenu'>Modify Structural Enzymes</A><br /><br />", src)
			else
				src.temp_html += "<span class='linkOff'>Modify Unique Identifier</span><br />"
				src.temp_html += "<span class='linkOff'>Modify Structural Enzymes</span><br /><br />"
			src.temp_html += text("<A href='?src=\ref[];screen=radsetmenu'>Radiation Emitter Settings</A><br /><br />", src)
			src.temp_html += text("<A href='?src=\ref[];screen=buffermenu'>Transfer Buffer</A><br /><br />", src)

		if ("unimenu")
			if(!viable_occupant)
				src.temp_html = text("No viable occupant detected.")
				popup.set_content(src.temp_html)
				popup.open()
			else
				src.temp_html = "<A href='?src=\ref[src];screen=mainmenu'><< Main Menu</A><br />"
				src.temp_html += "<h3>Modify Unique Identifier</h3>"
				src.temp_html += "<div align='center'>Unique Identifier:<br />[getblockstring(src.connected.occupant.dna.uni_identity,uniblock,subblock,3, src,1)]<br /><br />"
				src.temp_html += "Selected Block: <A href='?src=\ref[src];unimenuminus=1'><-</A> <B>[src.uniblock]</B> <A href='?src=\ref[src];unimenuplus=1'>-></A><br /><br />"
				src.temp_html += "Selected Sub-Block: <A href='?src=\ref[src];unimenusubminus=1'><-</A> <B>[src.subblock]</B> <A href='?src=\ref[src];unimenusubplus=1'>-></A><br /><br />"
				src.temp_html += "Selected Target: <A href='?src=\ref[src];unimenutargetminus=1'><-</A> <B>[src.unitargethex]</B> <A href='?src=\ref[src];unimenutargetplus=1'>-></A><br /><br />"
				src.temp_html += "<B>Modify Block</B><br />"
				src.temp_html += "<A href='?src=\ref[src];unipulse=1'>Irradiate</A></div>"

		if ("strucmenu")
			if(!viable_occupant)
				src.temp_html = text("No viable occupant detected.")
				popup.set_content(src.temp_html)
				popup.open()
			else
				src.temp_html = "<A href='?src=\ref[src];screen=mainmenu'><< Main Menu</A><br />"
				src.temp_html += "<h3>Modify Structural Enzymes</h3>"
				src.temp_html += "<div align='center'>Structural Enzymes: [getblockstring(src.connected.occupant.dna.struc_enzymes,strucblock,subblock,3,src,0)]<br /><br />"
				src.temp_html += "Selected Block: <A href='?src=\ref[src];strucmenuminus=1'><-</A> <B>[src.strucblock]</B> <A href='?src=\ref[src];strucmenuplus=1'>-></A><br /><br />"
				src.temp_html += "Selected Sub-Block: <A href='?src=\ref[src];strucmenusubminus=1'><-</A> <B>[src.subblock]</B> <A href='?src=\ref[src];strucmenusubplus=1'>-></A><br /><br />"
				src.temp_html += "<B>Modify Block</B><br />"
				src.temp_html += "<A href='?src=\ref[src];strucpulse=1'>Irradiate</A></div>"

		if ("radsetmenu")
			src.temp_html = "<A href='?src=\ref[src];screen=mainmenu'><< Main Menu</A><br />"
			src.temp_html += "<h3>Radiation Emitter Settings</h3>"
			if (viable_occupant)
				src.temp_html += text("<A href='?src=\ref[];genpulse=1'>Pulse Radiation</A>", src)
			else
				src.temp_html += "<span class='linkOff'>Pulse Radiation</span>"
			src.temp_html += "<br /><br />Radiation Duration: <A href='?src=\ref[src];radleminus=1'>-</A> <font color='green'><B>[src.radduration]</B></FONT> <A href='?src=\ref[src];radleplus=1'>+</A><br />"
			src.temp_html += "Radiation Intensity: <A href='?src=\ref[src];radinminus=1'>-</A> <font color='green'><B>[src.radstrength]</B></FONT> <A href='?src=\ref[src];radinplus=1'>+</A><br /><br />"

		if ("buffermenu")
			src.temp_html = "<A href='?src=\ref[src];screen=mainmenu'><< Main Menu</A><br />"
			src.temp_html += "<h3>Transfer Buffer</h3>"
			src.temp_html += "<h4>Buffer 1:</h4>"
			if (!(src.buffer1))
				src.temp_html += "<i>Buffer Empty</i><br />"
			else
				src.temp_html += text("Data: <font class='highlight'>[]</FONT><br />", src.buffer1)
				src.temp_html += text("By: <font class='highlight'>[]</FONT><br />", src.buffer1owner)
				src.temp_html += text("Label: <font class='highlight'>[]</FONT><br />", src.buffer1label)
			if (viable_occupant) src.temp_html += text("Save : <A href='?src=\ref[];b1addui=1'>UI</A> - <A href='?src=\ref[];b1adduiue=1'>UI+UE</A> - <A href='?src=\ref[];b1addse=1'>SE</A><br />", src, src, src)
			if (src.buffer1) src.temp_html += text("Transfer to: <A href='?src=\ref[];b1transfer=1'>Occupant</A> - <A href='?src=\ref[];b1injector=1'>Injector</A><br />", src, src)
			//if (src.buffer1) src.temp_html += text("<A href='?src=\ref[];b1iso=1'>Isolate Block</A><br />", src)
			if (src.buffer1) src.temp_html += "Disk: <A href='?src=\ref[src];save_disk=1'>Save To</a> | <A href='?src=\ref[src];load_disk=1'>Load From</a><br />"
			if (src.buffer1) src.temp_html += text("<A href='?src=\ref[];b1label=1'>Edit Label</A><br />", src)
			if (src.buffer1) src.temp_html += text("<A href='?src=\ref[];b1clear=1'>Clear Buffer</A><br /><br />", src)
			if (!src.buffer1) src.temp_html += "<br />"
			src.temp_html += "<h4>Buffer 2:</h4>"
			if (!(src.buffer2))
				src.temp_html += "<i>Buffer Empty</i><br />"
			else
				src.temp_html += text("Data: <font class='highlight'>[]</FONT><br />", src.buffer2)
				src.temp_html += text("By: <font class='highlight'>[]</FONT><br />", src.buffer2owner)
				src.temp_html += text("Label: <font class='highlight'>[]</FONT><br />", src.buffer2label)
			if (viable_occupant) src.temp_html += text("Save : <A href='?src=\ref[];b2addui=1'>UI</A> - <A href='?src=\ref[];b2adduiue=1'>UI+UE</A> - <A href='?src=\ref[];b2addse=1'>SE</A><br />", src, src, src)
			if (src.buffer2) src.temp_html += text("Transfer to: <A href='?src=\ref[];b2transfer=1'>Occupant</A> - <A href='?src=\ref[];b2injector=1'>Injector</A><br />", src, src)
			//if (src.buffer2) src.temp_html += text("<A href='?src=\ref[];b2iso=1'>Isolate Block</A><br />", src)
			if (src.buffer2) src.temp_html += "Disk: <A href='?src=\ref[src];save_disk=2'>Save To</a> | <A href='?src=\ref[src];load_disk=2'>Load From</a><br />"
			if (src.buffer2) src.temp_html += text("<A href='?src=\ref[];b2label=1'>Edit Label</A><br />", src)
			if (src.buffer2) src.temp_html += text("<A href='?src=\ref[];b2clear=1'>Clear Buffer</A><br /><br />", src)
			if (!src.buffer2) src.temp_html += "<br />"
			src.temp_html += "<h4>Buffer 3:</h4>"
			if (!(src.buffer3))
				src.temp_html += "<i>Buffer Empty</i><br />"
			else
				src.temp_html += text("Data: <font class='highlight'>[]</FONT><br />", src.buffer3)
				src.temp_html += text("By: <font class='highlight'>[]</FONT><br />", src.buffer3owner)
				src.temp_html += text("Label: <font class='highlight'>[]</FONT><br />", src.buffer3label)
			if (viable_occupant) src.temp_html += text("Save : <A href='?src=\ref[];b3addui=1'>UI</A> - <A href='?src=\ref[];b3adduiue=1'>UI+UE</A> - <A href='?src=\ref[];b3addse=1'>SE</A><br />", src, src, src)
			if (src.buffer3) src.temp_html += text("Transfer to: <A href='?src=\ref[];b3transfer=1'>Occupant</A> - <A href='?src=\ref[];b3injector=1'>Injector</A><br />", src, src)
			//if (src.buffer3) src.temp_html += text("<A href='?src=\ref[];b3iso=1'>Isolate Block</A><br />", src)
			if (src.buffer3) src.temp_html += "Disk: <A href='?src=\ref[src];save_disk=3'>Save To</a> | <A href='?src=\ref[src];load_disk=3'>Load From</a><br />"
			if (src.buffer3) src.temp_html += text("<A href='?src=\ref[];b3label=1'>Edit Label</A><br />", src)
			if (src.buffer3) src.temp_html += text("<A href='?src=\ref[];b3clear=1'>Clear Buffer</A><br /><br />", src)
			if (!src.buffer3) src.temp_html += "<br />"
	src.temp_html += temp_footer_html

	if(viable_occupant && !src.scanner_status_html && occupant) //is there REALLY someone in there?
		src.scanner_status_html = "<div class='line'><div class='statusLabel'>Health:</div><div class='progressBar'><div style='width: [occupant.health]%;' class='progressFill good'></div></div><div class='statusValue'>[occupant.health]%</div></div>"
		src.scanner_status_html += "<div class='line'><div class='statusLabel'>Radiation Level:</div><div class='progressBar'><div style='width: [occupant.radiation]%;' class='progressFill bad'></div></div><div class='statusValue'>[occupant.radiation]%</div></div>"
		if(human_occupant)
			var/rejuvenators = round(human_occupant.reagents.get_reagent_amount("inaprovaline") / REJUVENATORS_MAX * 100)
			src.scanner_status_html += "<div class='line'><div class='statusLabel'>Rejuvenators:</div><div class='progressBar'><div style='width: [rejuvenators]%;' class='progressFill highlight'></div></div><div class='statusValue'>[human_occupant.reagents.get_reagent_amount("inaprovaline")] units</div></div>"

		if (src.current_screen == "mainmenu")
			src.scanner_status_html += "<div class='line'><div class='statusLabel'>Unique Enzymes :</div><div class='statusValue'><span class='highlight'>[uppertext(occupant.dna.unique_enzymes)]</span></div></div>"
			src.scanner_status_html += "<div class='line'><div class='statusLabel'>Unique Identifier:</div><div class='statusValue'><span class='highlight'>[occupant.dna.uni_identity]</span></div></div>"
			src.scanner_status_html += "<div class='line'><div class='statusLabel'>Structural Enzymes:</div><div class='statusValue'><span class='highlight'>[occupant.dna.struc_enzymes]</span></div></div>"

	var/dat = "<h3>Scanner Status</h3>"

	var/occupant_status = "Scanner Unoccupied"
	if(occupant && occupant.dna) //is there REALLY someone in there?
		if (!istype(occupant,/mob/living/carbon/human))
			sleep(1)
		if(NOCLONE in occupant.mutations)
			occupant_status = "<span class='bad'>Invalid DNA structure</span>"
		else
			switch(occupant.stat) // obvious, see what their status is
				if(0)
					occupant_status = "<span class='good'>Conscious</span>"
				if(1)
					occupant_status = "<span class='average'>Unconscious</span>"
				else
					occupant_status = "<span class='bad'>DEAD</span>"

		occupant_status = "[occupant.name] => [occupant_status]<br />"

	dat += "<div class='statusDisplay'>[occupant_status][src.scanner_status_html]</div>"

	var/scanner_access_text = "Lock Scanner"
	if (src.connected.locked)
		scanner_access_text = "Unlock Scanner"

	dat += "<A href='?src=\ref[src];'>Scan</A> "

	if (occupant && occupant.dna)
		dat += "<A href='?src=\ref[src];locked=1'>[scanner_access_text]</A> "
		if (human_occupant)
			dat += "<A href='?src=\ref[src];rejuv=1'>Inject Rejuvenators</A><br />"
		else
			dat += "<span class='linkOff'>Inject Rejuvenators</span><br />"
	else
		dat += "<span class='linkOff'>[scanner_access_text]</span> "
		dat += "<span class='linkOff'>Inject Rejuvenators</span><br />"

	if (!isnull(src.diskette))
		dat += text("<A href='?src=\ref[];eject_disk=1'>Eject Disk</A><br />", src)

	dat += "<br />"

	if (src.temp_html)
		dat += src.temp_html

	popup.set_content(dat)
	popup.open()
/////////////////////////// DNA MACHINES

#undef REJUVENATORS_INJECT
#undef REJUVENATORS_MAX

-- GLOBALS: BigWigs, table

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Court of Stars Trash", 1571)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	104246, -- Duskwatch Guard
	111563, -- Duskwatch Guard
	104270, -- Guardian Construct
	104278, -- Felbound Enforcer
	104277, -- Legion Hound
	107435, -- Gerenth the Vile & Suspicious Noble
	105699, -- Mana Saber
	104273, -- Jazshariu
	104275, -- Imacu'tya
	104274, -- Baalgar the Watchful
	105715, -- Watchful Inquisitor
	104295, -- Blazing Imp
	105705, -- Bound Energy
	105704, -- Arcane Manifestation
	105703, -- Mana Wyrm
	104247, -- Duskwatch Arcanist
	112668, -- Infernal Imp
	108796, -- Arcanist Malrodi (Court of Stars: The Deceitful Student World Quest)
	108740, -- Velimar (Court of Stars: Bring Me the Eyes World Quest)
	106468, -- Ly'leth Lunastre
	107486, -- Chatty Rumormonger
	105729, -- Signal Lantern: Boat at the start
	105157, -- Arcane Power Conduit: Disables Constructs
	105117, -- Flask of the Solemn Night: Poisons first boss
	105160, -- Fel Orb: 10% Crit
	105831, -- Infernal Tome: -10% Dmg taken
	106024, -- Magical Lantern: +10% Dmg dealt
	105249, -- Nightshade Refreshments: +25% HP
	106108, -- Starlight Rose Brew: +HP & Mana reg
	105340, -- Umbral Bloom: +10% Haste
	106110, -- Waterlogged Scroll: +30% Movement speed
	108154 -- Arcane Keys
)

--------------------------------------------------------------------------------
-- Locals
--

local englishSpyFound = "I found the spy!"
local englishClueNames = {
	"Cape",
	"No Cape",
	"Pouch",
	"Potions",
	"Long Sleeves",
	"Short Sleeves",
	"Gloves",
	"No Gloves",
	"Male",
	"Female",
	"Light Vest",
	"Dark Vest",
	"No Potions",
	"Book",
}

local Manafang = false
local Guardian = false
local Imacutya = false
local Baalgar = false
local Inquisitor = false
local Jazshariu = false
local Felbound = false
local Mistress = false
local Gerenth = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.Guard = "Duskwatch Guard"
	L.Construct = "Guardian Construct"
	L.Enforcer = "Felbound Enforcer"
	L.Hound = "Legion Hound"
	L.Mistress = "Shadow Mistress"
	L.Gerenth = "Gerenth the Vile"
	L.ManaSaber = "Mana Saber"
	L.Jazshariu = "Jazshariu"
	L.Imacutya = "Imacutya"
	L.Baalgar = "Baalgar the Watchful"
	L.Inquisitor = "Watchful Inquisitor"
	L.BlazingImp = "Blazing Imp"
	L.Energy = "Bound Energy"
	L.Manifestation = "Arcane Manifestation"
	L.Wyrm = "Mana Wyrm"
	L.Arcanist = "Duskwatch Arcanist"
	L.InfernalImp = "Infernal Imp"
	L.Malrodi = "Arcanist Malrodi"
	L.Velimar = "Velimar"
	L.ArcaneKeys = "Arcane Keys"
	L.clues = "Clues"

	L.InfernalTome = "Infernal Tome"
	L.MagicalLantern = "Magical Lantern"
	L.NightshadeRefreshments = "Nightshade Refreshments"
	L.StarlightRoseBrew = "Starlight Rose Brew"
	L.UmbralBloom = "Umbral Bloom"
	L.WaterloggedScroll = "Waterlogged Scroll"
	L.BazaarGoods = "Bazaar Goods"
	L.LifesizedNightborneStatue = "Lifesized Nightborne Statue"
	L.DiscardedJunk = "Discarded Junk"
	L.WoundedNightborneCivilian = "Wounded Nightborne Civilian"

	L.announce_buff_items = "Announce buff items"
	L.announce_buff_items_desc = "Announces all available buff items around the dungeon and who is able to use them."
	L.announce_buff_items_icon = 211080

	L.available = "%s|cffffffff%s|r available" -- Context: item is available to use
	L.usableBy = "usable by %s" -- Context: item is usable by someone

	L.custom_on_use_buff_items = "Instantly use buff items"
	L.custom_on_use_buff_items_desc = "Enable this option to instantly use the buff items around the dungeon. This will not use items which aggro the guards before the second boss."
	L.custom_on_use_buff_items_icon = 211110

	L.spy_helper = "Spy Event Helper"
	L.spy_helper_desc = "Shows an InfoBox with all clues your group gathered about the spy. The clues will also be sent to your party members in chat."
	L.spy_helper_icon = 213213

	L.clueFound = "Clue found (%d/5): |cffffffff%s|r"
	L.spyFound = "Spy found by %s!"
	L.spyFoundChat = englishSpyFound
	L.spyFoundPattern = "Now now, let's not be hasty" -- Now now, let's not be hasty [player]. Why don't you follow me so we can talk about this in a more private setting...

	L.hints = englishClueNames

	-- Cape
	L["I heard the spy enjoys wearing capes."] = 1
	L["Someone mentioned the spy came in earlier wearing a cape."] = 1

	-- No Cape
	L["I heard that the spy left their cape in the palace before coming here."] = 2
	L["I heard the spy dislikes capes and refuses to wear one."] = 2

	-- Pouch
	L["A friend said the spy loves gold and a belt pouch filled with it."] = 3
	L["I heard the spy's belt pouch is filled with gold to show off extravagance."] = 3
	L["I heard the spy carries a magical pouch around at all times."] = 3
	L["I heard the spy's belt pouch is lined with fancy threading."] = 3

	-- Potions
	L["I heard the spy brought along some potions... just in case."] = 4
	L["I'm pretty sure the spy has potions at the belt."] = 4
	L["I heard the spy brought along potions, I wonder why?"] = 4
	L["I didn't tell you this... but the spy is masquerading as an alchemist and carrying potions at the belt."] = 4

	-- Long Sleeves
	L["I just barely caught a glimpse of the spy's long sleeves earlier in the evening."] = 5
	L["I heard the spy's outfit has long sleeves tonight."] = 5
	L["Someone said the spy is covering up their arms with long sleeves tonight."] = 5
	L["A friend of mine mentioned the spy has long sleeves on."] = 5

	-- Short Sleeves
	L["I heard the spy enjoys the cool air and is not wearing long sleeves tonight."] = 6
	L["A friend of mine said she saw the outfit the spy was wearing. It did not have long sleeves."] = 6
	L["Someone told me the spy hates wearing long sleeves."] = 6
	L["I heard the spy wears short sleeves to keep their arms unencumbered."] = 6

	-- Gloves
	L["I heard the spy always dons gloves."] = 7
	L["There's a rumor that the spy always wears gloves."] = 7
	L["Someone said the spy wears gloves to cover obvious scars."] = 7
	L["I heard the spy carefully hides their hands."] = 7

	-- No Gloves
	L["There's a rumor that the spy never has gloves on."] = 8
	L["I heard the spy dislikes wearing gloves."] = 8
	L["I heard the spy avoids having gloves on, in case some quick actions are needed."] = 8
	L["You know... I found an extra pair of gloves in the back room. The spy is likely to be bare handed somewhere around here."] = 8

	-- Male
	L["A guest said she saw him entering the manor alongside the Grand Magistrix."] = 9
	L["I heard somewhere that the spy isn't female."] = 9
	L["I heard the spy is here and he's very good looking."] = 9
	L["One of the musicians said he would not stop asking questions about the district."] = 9

	-- Female
	L["A guest saw both her and Elisande arrive together earlier."] = 10
	L["I hear some woman has been constantly asking about the district..."] = 10
	L["Someone's been saying that our new guest isn't male."] = 10
	L["They say that the spy is here and she's quite the sight to behold."] = 10

	-- Light Vest
	L["The spy definitely prefers the style of light colored vests."] = 11
	L["I heard that the spy is wearing a lighter vest to tonight's party."] = 11
	L["People are saying the spy is not wearing a darker vest tonight."] = 11

	-- Dark Vest
	L["I heard the spy's vest is a dark, rich shade this very night."] = 12
	L["The spy enjoys darker colored vests... like the night."] = 12
	L["Rumor has it the spy is avoiding light colored clothing to try and blend in more."] = 12
	L["The spy definitely prefers darker clothing."] = 12

	-- No Potions
	L["I heard the spy is not carrying any potions around."] = 13
	L["A musician told me she saw the spy throw away their last potion and no longer has any left."] = 13

	-- Book
	L["I heard the spy always has a book of written secrets at the belt."] = 14
	L["Rumor has is the spy loves to read and always carries around at least one book."] = 14
end

--------------------------------------------------------------------------------
-- Initialization
--
local matterMarker = mod:AddMarkerOption(true, "npc", 8, 209516, 8)
function mod:GetOptions()
	return {
		"announce_buff_items",
		"custom_on_use_buff_items",
		{"spy_helper", "INFOBOX"},
		209027, -- Quelling Strike (Duskwatch Guard)
		209033, -- Fortification (Duskwatch Guard)
		225100, -- Charging Station (Guardian Construct)
		209495, -- Charged Smash (Guardian Construct)
		209512, -- Disrupting Energy (Guardian Construct)
		209413, -- Suppress (Guardian Construct)
		211464, -- Fel Detonation (Felbound Enforcer)
		211391, -- Felblaze Puddle (Legion Hound)
		211473, -- Bewitch (Shadow Slash)
		211470, -- Bewitch (Shadow Mistress)
		214692, -- Shadow Bolt Volley (Gerenth the Vile)
		214688, -- Carrion Swarm (Gerenth the Vile)
		214690, -- Cripple (Gerenth the Vile)
		209516, -- Mana Fang (Mana Saber)
		207979, -- Shockwave (Jazshariu)
		209378, -- Whirling Blades (Imacu'tya)
		207980, -- Disintegration Beam (Baalgar the Watchful)
		211299, -- Searing Glare (Watchful Inquisitor)
		212784, -- Eye Storm (Watchful Inquisitor)
		211401, -- Drifting Embers (Blazing Imp)
		212031, -- Charged Blast (Bound Energy)
		209485, -- Drain Magic (Arcane Manifestation)
		209477, -- Wild Detonation (Mana Wyrm)
		209410, -- Nightfall Orb (Duskwatch Arcanist)
		209404, -- Seal Magic (Duskwatch Arcanist)
		224377, -- Drifting Embers (Infernal Imp)
		216110, -- Uncontrolled Blast (Arcanist Malrodi)
		216096, -- Wild Magic (Arcanist Malrodi)
		216000, -- Mighty Stomp (Velimar)
		216006, -- Shadowflame Breath (Velimar)
		214697, -- Picking Up (Arcane Keys)
	}, {
		["announce_buff_items"] = "general",
		[209027] = L.Guard,
		[225100] = L.Construct,
		[211464] = L.Enforcer,
		[211391] = L.Hound,
		[211473] = L.Mistress,		
		[211470] = L.Mistress,
		[214692] = L.Gerenth,
		[209516] = L.ManaSaber,
		[207979] = L.Jazshariu,
		[209378] = L.Imacutya,
		[207980] = L.Baalgar,
		[211299] = L.Inquisitor,
		[211401] = L.BlazingImp,
		[212031] = L.Energy,
		[209485] = L.Manifestation,
		[209477] = L.Wyrm,
		[209410] = L.Arcanist,
		[224377] = L.InfernalImp,
		[216110] = L.Malrodi,
		[216000] = L.Velimar,
		[214697] = L.ArcaneKeys,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	-- Charging Station, Shadow Bolt Volley, Carrion Swarm, Shockwave, Drain Magic, Wild Detonation, Nightfall Orb, Seal Magic, Fortification, Uncontrolled Blast, Wild Magic, Mighty Stomp, Shadowflame Breath, Bewitch
	self:Log("SPELL_CAST_START", "AlertCasts", 209485, 209477, 209410, 209404, 209033, 216110, 216096, 216000, 216006)
	self:Log("SPELL_CAST_START", "ChargingStation", 225100)
	-- Quelling Strike, Fel Detonation, Searing Glare, Eye Storm, Drifting Embers, Charged Blast, Suppress, Charged Smash, Drifting Embers
	self:Log("SPELL_CAST_START", "AlarmCasts", 209027, 211299, 211401, 212031, 209413, 209495, 224377)
	-- Felblaze Puddle, Disrupting Energy
	self:Log("SPELL_AURA_APPLIED", "PeriodicDamage", 211391, 209512)
	self:Log("SPELL_PERIODIC_DAMAGE", "PeriodicDamage", 211391, 209512)
	self:Log("SPELL_PERIODIC_MISSED", "PeriodicDamage", 211391, 209512)
	-- Dispellable stuff
	self:Log("SPELL_AURA_APPLIED", "Fortification", 209033)
	self:Log("SPELL_AURA_APPLIED", "SealMagic", 209404)
	self:Log("SPELL_AURA_APPLIED", "Suppress", 209413)
	--self:Log("SPELL_AURA_APPLIED", "SingleTargetDebuffs", 214690) -- Cripple
	self:Log("SPELL_AURA_REMOVED", "SingleTargetDebuffsRemoved", 209413, 214690) -- Suppress, Cripple
	--Carrion Swarm
	self:Log("SPELL_CAST_START", "CarrionSwarm", 214688)
	--Cripple
	self:Log("SPELL_CAST_START", "Cripple", 214690)
	--Shadow Bolt Volley
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 214692)
	-- Whirling Blades
	self:Log("SPELL_CAST_START", "WhirlingBlades", 209378)
	-- Disintegration Beam
	self:Log("SPELL_CAST_SUCCESS", "DisintegrationBeam", 207980)
	-- Eye Storm
	self:Log("SPELL_CAST_START", "EyeStorm", 212784)
	-- Jazshariu
	self:Log("SPELL_CAST_START", "Shockwave", 207979)
	-- Felbound Enforcer
	self:Log("SPELL_CAST_START", "FelDetonation", 211464)
	-- Bewitch
	self:Log("SPELL_CAST_START", "ShadowMistress", 211470)
	self:Log("SPELL_DAMAGE", "ShadowSlash", 211473)	
	-- Picking Up
	self:Log("SPELL_CAST_START", "PickingUp", 214697)
	self:Log("SPELL_CAST_SUCCESS", "PickingUpSuccess", 214697)

	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterMessage("BigWigs_BossComm")
	self:RegisterMessage("DBM_AddonMessage") -- Catch DBM clues
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	
	self:Log("SPELL_DAMAGE", "PullDamage", "*")
	self:Log("SPELL_PERIODIC_DAMAGE", "PullDamage", "*")
	self:Log("RANGE_DAMAGE", "PullDamage", "*")
	self:Log("SWING_DAMAGE", "PullDamage", "*")
	self:RegisterTargetEvents("ForPull")
	self:RegisterEvent("UNIT_COMBAT", "ForPull")
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", "ForPull")
	self:RegisterEvent("UNIT_HEALTH_FREQUENT", "ForPull")
	self:Death("Deaths", 105699, 104275, 104274, 105715, 104273, 104278, 104300, 107435)

	-- Purely because DBM, and maybe others, call CloseGossip. That is just sooooo useful.
	local frames = {GetFramesRegisteredForEvent("GOSSIP_SHOW")}
	for i = 1, #frames do
		frames[i]:UnregisterEvent("GOSSIP_SHOW")
	end
	self:RegisterEvent("GOSSIP_SHOW")
	for i = 1, #frames do
		frames[i]:RegisterEvent("GOSSIP_SHOW")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PullDamage(args)
	self:ScheduleTimer("ResetPull", 1)
	if (self:MobId(args.destGUID) == 105699 or self:MobId(args.sourceGUID) == 105699) and Manafang == false then
		self:CDBar(209516, 8.2)
		self:CastBar(209516, 16.4)
		Manafang = true
	elseif (self:MobId(args.destGUID) == 104270 or self:MobId(args.sourceGUID) == 104270) and Guardian == false then
		self:CDBar(225100, 7.5)
		Guardian = true
	elseif (self:MobId(args.destGUID) == 104275 or self:MobId(args.sourceGUID) == 104275) and Imacutya == false then
		self:CDBar(209378, 7.7)
		Imacutya = true
	elseif (self:MobId(args.destGUID) == 104274 or self:MobId(args.sourceGUID) == 104274) and Baalgar == false then
		self:CDBar(207980, 7.7)
		Baalgar = true
	elseif (self:MobId(args.destGUID) == 105715 or self:MobId(args.sourceGUID) == 105715) and Inquisitor == false then
		self:CDBar(212784, 9)
		self:CastBar(212784, 34)
		Inquisitor = true
	elseif (self:MobId(args.destGUID) == 104273 or self:MobId(args.sourceGUID) == 104273) and Jazshariu == false then
		self:CDBar(207979, 8.3)
		Jazshariu = true
	elseif (self:MobId(args.destGUID) == 104278 or self:MobId(args.sourceGUID) == 104278) and Felbound == false then
		self:CDBar(211464, 7.7)
		Felbound = true
	elseif (self:MobId(args.destGUID) == 104300 or self:MobId(args.sourceGUID) == 104300) and Mistress == false then
		self:CDBar(211470, 7.7)
		Mistress = true
	elseif (self:MobId(args.destGUID) == 107435 or self:MobId(args.sourceGUID) == 107435) and Gerenth == false then
		self:CDBar(214692, 14)
		self:CDBar(214688, 2)
		self:CDBar(214690, 8)
		Gerenth = true
	end
end

do
	local unitTable = {
		"target", "targettarget", "targettargettarget",
		"mouseover", "mouseovertarget", "mouseovertargettarget",
		"focus", "focustarget", "focustargettarget",
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
		"party1target", "party2target", "party3target", "party4target",
		"raid1target", "raid2target", "raid3target", "raid4target", "raid5target",
		"raid6target", "raid7target", "raid8target", "raid9target", "raid10target",
		"raid11target", "raid12target", "raid13target", "raid14target", "raid15target",
		"raid16target", "raid17target", "raid18target", "raid19target", "raid20target",
		"raid21target", "raid22target", "raid23target", "raid24target", "raid25target",
		"raid26target", "raid27target", "raid28target", "raid29target", "raid30target",
		"raid31target", "raid32target", "raid33target", "raid34target", "raid35target",
		"raid36target", "raid37target", "raid38target", "raid39target", "raid40target"
	}
	function mod:ForPull(event, unit, unitTarget, guid)
		InCombat = UnitAffectingCombat(unit)
		exists = UnitExists(unit)
		canAttack = UnitCanAttack("player", unit)
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		local guid = UnitGUID(unit)
		local unit = unitTable[i]
		if InCombat == true and exists == true and canAttack == true and hp > 90 then
			if self:MobId(guid) == 105699 and Manafang == false then
				self:CDBar(209516, 8.2)
				self:CastBar(209516, 16.4)
				Manafang = true
			elseif self:MobId(guid) == 104270 and Guardian == false then
				self:CDBar(225100, 7.5)
				Guardian = true
			elseif self:MobId(guid) == 104275 and Imacutya == false then
				self:CDBar(209378, 7.7)
				Imacutya = true
			elseif self:MobId(guid) == 104274 and Baalgar == false then
				self:CDBar(207980, 7.7)
				Baalgar = true
			elseif self:MobId(guid) == 105715 and Inquisitor == false then
				self:CDBar(212784, 9)
				self:CastBar(212784, 34)
				Inquisitor = true
			elseif self:MobId(guid) == 104273 and Jazshariu == false then
				self:CDBar(207979, 8.3)
				Jazshariu = true
			elseif self:MobId(guid) == 104278 and Felbound == false then
				self:CDBar(211464, 7.7)
				Felbound = true
			elseif self:MobId(guid) == 104300 and Mistress == false then
				self:CDBar(211470, 7.7)
				Mistress = true
			elseif self:MobId(guid) == 107435 and Gerenth == false then
				self:CDBar(214692, 14)
				self:CDBar(214688, 2)
				self:CDBar(214690, 8)
				Gerenth = true
			end
		end
	end
	function mod:ResetPull()
		if UnitAffectingCombat("player") == false and UnitAffectingCombat("party1") == false and UnitAffectingCombat("party2") == false and UnitAffectingCombat("party3") == false and UnitAffectingCombat("party4") == false and UnitAffectingCombat("raid1") == false and UnitAffectingCombat("raid2") == false and UnitAffectingCombat("raid3") == false and UnitAffectingCombat("raid4") == false and UnitAffectingCombat("raid5") == false then
			Manafang = false
			Imacutya = false
			Baalgar = false
			Inquisitor = false
			Jazshariu = false
			Felbound = false
			Mistress = false
			Gerenth = false
			Guardian = false
			self:StopBar(CL.cast:format(self:SpellName(209516)))
			self:StopBar(CL.cast:format(self:SpellName(212784)))
			self:StopBar(225100)
			self:StopBar(211470)
			self:StopBar(212784)
			self:StopBar(209516)
			self:StopBar(209378)
			self:StopBar(207980)
			self:StopBar(207979)
			self:StopBar(211464)
			self:StopBar(214692)
			self:StopBar(214688)
			self:StopBar(214690)
		end
	end
	function mod:Deaths(args)
		local mobId = self:MobId(args.destGUID)
		if mobId == 105699 then
			Manafang = false
		elseif mobId == 104270 then
			self:StopBar(225100)
			Guardian = false
		elseif mobId == 104275 then
			self:StopBar(209378)
			Imacutya = false
		elseif mobId == 104274 then
			self:StopBar(207980)
			Baalgar = false
		elseif mobId == 105715 then
			Inquisitor = false
		elseif mobId == 104273 then
			self:StopBar(207979)
			Jazshariu = false
		elseif mobId == 104278 then
			self:StopBar(211464)
			Felbound = false
		elseif mobId == 104300 then
			Mistress = false
		elseif mobId == 107435 then
			self:StopBar(214692)
			self:StopBar(214688)
			self:StopBar(214690)
			Gerenth = false
		end
	end
end

-- Mana Fang (Mana Saber)
do
	local prev = nil
	local preva = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellGUID, spellId)
		local t = GetTime()
		if spellId == 209515 and spellGUID ~= prev and t-preva > 6 then
			prev = spellGUID
			self:Message(209516, "Urgent", "Warning")
			self:CDBar(209516, 8.2)
			self:CastBar(209516, 16.4)
		elseif spellId == 209515 and spellGUID ~= prev and t-preva < 6 then
			prev = spellGUID
			self:Message(209516, "Urgent", "Warning")
		end
	end
end

do
	local autoTalk = {
		[107486] = true, -- Chatty Rumormonger
		[106468] = true, -- Ly'leth Lunastre
		[105729] = true, -- Signal Lantern: Boat at the start
	}

	local buffItems = {
		[105157] = { -- Arcane Power Conduit: Disables Constructs
			["name"] = 210466,
			["professions"] = {
				[136243] = 100, -- Engineering
			},
			["races"] = {
				["Gnome"] = true,
				["Goblin"] = true,
			},
		},
		[105117] = { -- Flask of the Solemn Night: Poisons first boss
			["name"] = 207815,
			["professions"] = {
				[136240] = 100, -- Alchemy
			},
			["classes"] = {
				["ROGUE"] = true,
			},
		},
		[105160] = { -- Fel Orb: 10% Crit
			["name"] = 208275,
			["classes"] = {
				["DEMONHUNTER"] = true,
				["WARLOCK"] = true,
				["PRIEST"] = true,
				["PALADIN"] = true,
			},
		},
		[105831] = { -- Infernal Tome: -10% Dmg taken
			["name"] = "InfernalTome",
			["classes"] = {
				["DEMONHUNTER"] = true,
				["PRIEST"] = true,
				["PALADIN"] = true,
			},
		},
		[106024] = { -- Magical Lantern: +10% Dmg dealt
			["name"] = "MagicalLantern",
			["classes"] = {
				["MAGE"] = true,
			},
			["professions"] = {
				[136244] = 100, -- Enchanting
			},
			["races"] = {
				["BloodElf"] = true,
				["NightElf"] = true,
			},
		},
		[105249] = { -- Nightshade Refreshments: +25% HP
			["name"] = "NightshadeRefreshments",
			["professions"] = {
				[133971] = 800, -- Cooking
				[136246] = 100, -- Herbalism
			},
			["races"] = {
				["Pandaren"] = true,
			},
		},
		[106108] = { -- Starlight Rose Brew: +HP & Mana reg
			["name"] = "StarlightRoseBrew",
			["classes"] = {
				["DEATHKNIGHT"] = true,
				["MONK"] = true,
			},
		},
		[105340] = { -- Umbral Bloom: +10% Haste
			["name"] = "UmbralBloom",
			["classes"] = {
				["DRUID"] = true,
			},
			["professions"] = {
				[136246] = 100, -- Herbalism
			}
		},
		[106110] = { -- Waterlogged Scroll: +30% Movement speed
			["name"] = "WaterloggedScroll",
			["classes"] = {
				["SHAMAN"] = true,
			},
			["professions"] = {
				[134366] = 100, -- Skinning
				[237171] = 100, -- Inscription
			}
		},
	}

	local buffs = {
		[105160] = 211081, -- Fel Orb
		[105831] = 211080, -- Infernal Tome
		[106024] = 211093, -- Magical Lantern
		[105249] = 211102, -- Nightshade Refreshments
		[106108] = 211071, -- Starlight Rose Brew
		[105340] = 211110, -- Umbral Bloom
		[106110] = 211084, -- Waterlogged Scroll
	}

	local guardItems = {
		[106018] = { -- Bazaar Goods
			["name"] = "BazaarGoods",
			["classes"] = {
				["ROGUE"] = true,
				["WARRIOR"] = true,
			},
			["professions"] = {
				[136247] = 100, -- Leatherworking
			},
		},
		[106113] = { -- Lifesized Nightborne Statue
			["name"] = "LifesizedNightborneStatue",
			["professions"] = {
				[134708] = 100, -- Mining
				[134071] = 100, -- Jewelcrafting
			},
		},
		[105215] = { -- Discarded Junk
			["name"] = "DiscardedJunk",
			["classes"] = {
				["HUNTER"] = true,
			},
			["professions"] = {
				[136241] = 100, -- Blacksmithing
			},
		},
		[106112] = { -- Wounded Nightborne Civilian
			["name"] = "WoundedNightborneCivilian",
			["roles"] = {
				["Healer"] = true,
			},
			["professions"] = {
				[135966] = 760, -- First Aid -- XXX Guess
				[136249] = 100, -- Tailoring
			},
		},
	}

	local professionCache = {}

	local raceIcons = {
		["Pandaren"] = "|T626190:0|t",
		["NightElf"] = "|T236449:0|t",
		["BloodElf"] = "|T236439:0|t",
		["Gnome"] = "|T236445:0|t",
		["Goblin"] = "|T632354:0|t",
	}

	local roleIcons = {
		["Healer"] = "|T337497:0:0:0:0:64:64:20:39:1:20|t",
	}

	local function getClassIcon(class)
		return ("|TInterface/Icons/classicon_%s:0|t"):format(strlower(class))
	end

	local function getIconById(id)
		return ("|T%d:0|t"):format(id)
	end

	local dbmClues = {
		["cape"] = 1,
		["no cape"] = 2,
		["pouch"] = 3,
		["potions"] = 4,
		["long sleeves"] = 5,
		["short sleeves"] = 6,
		["gloves"] = 7,
		["no gloves"] = 8,
		["male"] = 9,
		["female"] = 10,
		["light vest"] = 11,
		["dark vest"] = 12,
		["no potion"] = 13,
		["book"] = 14,
	}

	local knownClues, clueCount, timer = {}, 0, nil

	function mod:OnBossDisable()
		clueCount = 0
		timer = nil
		wipe(knownClues)
	end

	local function sendChatMessage(msg, english)
		if IsInGroup() then
			BigWigsLoader.SendChatMessage(english and ("[LittleWigs] %s / %s"):format(msg, english) or ("[LittleWigs] %s"):format(msg), IsInGroup(2) and "INSTANCE_CHAT" or "PARTY")
		end
	end

	local function addClue(self, clue)
		if clueCount == 0 then
			self:OpenInfo("spy_helper", L.clues)
		end
		if not knownClues[clue] then
			knownClues[clue] = true
			clueCount = clueCount + 1
			self:SetInfo("spy_helper", (clueCount*2)-1, L.hints[clue])
			self:Message("spy_helper", "Neutral", "Info", L.clueFound:format(clueCount, L.hints[clue]), false)
		end
	end

	function mod:DBM_AddonMessage(_, _, prefix, _, _, event, clue)
		if prefix == "M" and event == "CoS" and dbmClues[clue] then
			self:BigWigs_BossComm(nil, "clue", dbmClues[clue])
		end
	end

	local function printNew(locale, clue)
		timer = nil
		knownClues[clue] = true -- Throttle to only show once per new message
		if clue == GetGossipText() then -- Extra safety
			RaidNotice_AddMessage(RaidWarningFrame, "LittleWigs: Unknown clue detected, see chat for info.", {r=1,g=1,b=1})
			BigWigs:Print("LittleWigs has found an unknown clue, please report it on Discord or GitHub so we can add it and shorten the message.")
			BigWigs:Error(("|cffffff00TELL THE AUTHORS:|r New clue '%s' with '%s'"):format(clue, locale))
		end
	end

	local prev = 0
	function mod:GOSSIP_SHOW()
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end

		local mobId = self:MobId(UnitGUID("npc"))
		local spyEventHelper = self:GetOption("spy_helper") > 0
		if autoTalk[mobId] or buffItems[mobId] then
			if not GetGossipOptions() and mobId == 107486 then -- Chatty Rumormonger
				local clue = GetGossipText()
				local num = L[clue]
				if num then
					prev = GetTime()
					if spyEventHelper and not knownClues[num] then
						local text = L.hints[num]
						sendChatMessage(text, englishClueNames[num] ~= text and englishClueNames[num])
					end
					mod:Sync("clue", num)
				else
					-- GetTime: Sometimes it's 1st screen (chat) > 2nd screen (clue) > 1st screen (chat, no gossip selection) and would trigger this
					if spyEventHelper and not knownClues[clue] and (GetTime()-prev) > 2 then
						timer = self:ScheduleTimer(printNew, 2, GetLocale(), clue)
					end
				end
			end
			if (spyEventHelper and autoTalk[mobId]) or (self:GetOption("custom_on_use_buff_items") and buffItems[mobId]) then
				SelectGossipOption(1)
			end
		end
	end

	function mod:CHAT_MSG_MONSTER_SAY(_, msg, _, _, _, target)
		if msg:find(L.spyFoundPattern) and self:GetOption("spy_helper") > 0 then
			self:Message("spy_helper", "Positive", "Info", L.spyFound:format(self:ColorName(target)), false)
			self:CloseInfo("spy_helper")
			if target == self:UnitName("player") then
				sendChatMessage(L.spyFoundChat, englishSpyFound ~= L.spyFoundChat and englishSpyFound)
				SetRaidTarget("target", 8)
			else
				for unit in self:IterateGroup() do
					if UnitName(unit) == target then -- Normal UnitName since CHAT_MSG_MONSTER_SAY doesn't append servers to names
						SetRaidTarget(unit.."target", 8)
						break
					end
				end
			end
		end
	end

	local function announceUsable(self, id, item)
		self:Sync("itemAvailable", id)
		local players = {} -- who can use the item
		local icons = {}
		if item.professions then
			for profIcon, requiredSkill in pairs(item.professions) do
				if professionCache[profIcon] then
					for _,v in pairs(professionCache[profIcon]) do
						if v.skill >= requiredSkill then
							players[v.name] = true
						end
					end
				end
				icons[#icons+1] = getIconById(profIcon)
			end
		end
		if item.races then
			for race, _ in pairs(item.races) do
				for unit in self:IterateGroup() do
					local _, unitRace = UnitRace(unit)
					if unitRace == race then
						players[self:UnitName(unit)] = true
					end
				end
				icons[#icons+1] = raceIcons[race]
			end
		end
		if item.classes then
			for class, _ in pairs(item.classes) do
				for unit in self:IterateGroup() do
					local _, unitClass = UnitClass(unit)
					if unitClass == class then
						players[self:UnitName(unit)] = true
					end
				end
				icons[#icons+1] = getClassIcon(class)
			end
		end
		if item.roles then
			for role, _ in pairs(item.roles) do
				for unit in self:IterateGroup() do
					if self[role](self, unit) then
						players[self:UnitName(unit)] = true
					end
				end
				icons[#icons+1] = roleIcons[role]
			end
		end

		local name = type(item.name) == "number" and self:SpellName(item.name) or L[item.name]
		local message = (L.available):format(table.concat(icons, ""), name)

		if next(players) then
			local list = ""
			for player in pairs(players) do
				if UnitInParty(player) then -- don't announce players from previous groups
					list = list .. self:ColorName(player) .. ", "
				end
			end
			if list:len() > 0 then
				message = message .. " - ".. L.usableBy:format(list:sub(0, list:len()-2))
			end
		end

		self:Message("announce_buff_items", "Neutral", "Info", message, false)
	end

	local prevTable, usableTimer, lastProfessionUpdate = {}, nil, 0
	local function usableFound(self, id, item)
		if buffs[id] and self:UnitBuff("player", self:SpellName(buffs[id])) then -- there's no point in showing a message if we already have the buff
			return
		end

		local t = GetTime()
		if t-(prevTable[id] or 0) > 300 then
			prevTable[id] = t

			local delayAnnouncement = false
			if item.professions then
				if t-lastProfessionUpdate > 300 then
					lastProfessionUpdate = t
					self:Sync("getProfessions")
					delayAnnouncement = true
				end
			end
			if delayAnnouncement then
				usableTimer = self:ScheduleTimer(announceUsable, 0.3, self, id, item)
			else
				announceUsable(self, id, item)
			end
		end
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		local id = self:MobId(UnitGUID("mouseover"))
		local item = buffItems[id] or guardItems[id]
		if item then
			usableFound(self, id, item)
		end
	end

	function mod:BigWigs_BossComm(_, msg, data, sender)
		if msg == "clue" and self:GetOption("spy_helper") > 0 then
			local clue = tonumber(data)
			if clue and clue > 0 and clue <= #L.hints then
				addClue(self, clue)
			end
		elseif msg == "getProfessions" then
			local professions = {}
			for _,id in pairs({GetProfessions()}) do
				local _, icon, skill = GetProfessionInfo(id) -- name is localized, so use icon instead
				professions[icon] = skill
			end
			local profString = ""
			for k,v in pairs(professions) do
				profString = profString .. k .. ":" .. v .. "#"
			end
			self:Sync("professions", profString)
		elseif msg == "professions" then
			lastProfessionUpdate = GetTime()
			for icon, skill in data:gmatch("(%d+):(%d+)#") do
				icon = tonumber(icon)
				skill = tonumber(skill)
				if not professionCache[icon] then
					professionCache[icon] = {}
				end
				professionCache[icon][#professionCache[icon]+1] = {name=sender, skill=skill}
			end
		elseif msg == "itemAvailable" then
			local id = tonumber(data)
			local item = buffItems[id] or guardItems[id]
			if item then
				usableFound(self, id, item)
			end
		end
	end
end

local prevTable = {}
local function throttleMessages(key)
	local t = GetTime()
	if t-(prevTable[key] or 0) > 1.5 then
		prevTable[key] = t
		return false
	else
		return true
	end
end

function mod:AlertCasts(args)
	if throttleMessages(args.spellId) then return end
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
end

do
	local prev = 0
	function mod:ChargingStation(args)
		local t = GetTime()
		if t-prev > 7 then
			prev = t
			self:CDBar(args.spellId, 8)
		end
		self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	end
end

function mod:AlarmCasts(args)
	if throttleMessages(args.spellId) then return end
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
end

do
	local prev = 0
	function mod:PeriodicDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(args.spellId, "Personal", "Warning", CL.underyou:format(args.spellName))
			end
		end
	end
end

function mod:Fortification(args)
	if self:Dispeller("magic", true) and not UnitIsPlayer(args.destName) then -- mages can spellsteal it
		self:TargetMessage(args.spellId, args.destName, "Urgent", not throttleMessages(args.spellId) and "Alert", nil, nil, true)
	end
end

function mod:Suppress(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", not throttleMessages(args.spellId) and "Alert", nil, nil, self:Dispeller("magic"))
	self:TargetBar(args.spellId, 6, args.destName)
end

function mod:SingleTargetDebuffs(args)
	if self:Me(args.destGUID) or self:Dispeller("magic") then
		self:TargetMessage(args.spellId, args.destName, "Urgent", not throttleMessages(args.spellId) and "Alert", nil, nil, self:Dispeller("magic"))
		self:TargetBar(args.spellId, 8, args.destName)
	end
end

function mod:SingleTargetDebuffsRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

do
	local playerList = mod:NewTargetList()
	function mod:SealMagic(args)
		playerList[#playerList + 1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, args.destName, "Urgent", not throttleMessages(args.spellId) and "Alert", nil, nil, self:Dispeller("magic"))
		end
	end
end

function mod:WhirlingBlades(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 18)
end

function mod:DisintegrationBeam(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 13)
end

function mod:EyeStorm(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 25)
	self:CastBar(args.spellId, 50)
end

function mod:Shockwave(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 8.3)
end

function mod:FelDetonation(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 12)
end

function mod:ShadowMistress(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 18)
end

function mod:ShadowSlash(args)
	if self:Tank() then
			self:CDBar(args.spellId, 18)
	end
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 20.5)
end

function mod:Cripple(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 20.5)
end

function mod:CarrionSwarm(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 20.5)
end

do
	local prev = 0
	function mod:PickingUp(args)
		local t = GetTime()
		if t-prev > 10 then
			prev = t
			self:TargetMessage(args.spellId, args.sourceName, "Neutral", "Info")
		end
	end
end

do
	local prev = 0
	function mod:PickingUpSuccess(args)
		local t = GetTime()
		if t-prev > 10 then
			prev = t
			self:TargetMessage(args.spellId, args.sourceName, "Positive", "Long", args.destName)
		end
	end
end

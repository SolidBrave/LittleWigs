--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Karazhan Trash", 1651)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	114338, -- Mana Confluence
	115486, -- Erudite Slayer
	115484, -- Fel Bat
	115388, -- King
	115488, -- Infused Pyromancer
	115765, -- Abstract Nullifier
	114804, -- Spectral Charger
	114629, -- Spectral Retainer
	114544, -- Skeletal Usher
	114339, -- Barnes
	114542, -- Ghostly Philanthropist
	114632, -- Spectral Attendant
	114636, -- Phantom Guardsman
	114783, -- Reformed Maiden
	114796 -- Wholesome Hostess
)

--------------------------------------------------------------------------------
-- Locals
--

local FelBomb = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.confluence = "Mana Confluence"
	L.EruditeSlayer = "Erudite Slayer"
	L.FelBat = "Fel Bat"
	L.King = "King"
	L.InfusedPyromancer = "Infused Pyromancer"
	L.AbstractNullifier = "Abstract Nullifier"
	L.charger = "Spectral Charger"
	L.spectral = "Spectral Retainer"
	L.skeletalUsher = "Skeletal Usher"
	L.custom_on_autotalk = "Autotalk"
	L.custom_on_autotalk_desc = "Instantly selects Barnes' gossip option to start the Opera Hall encounter."
	L.attendant = "Spectral Attendant"
	L.hostess = "Wholesome Hostess"
	L.opera_hall_westfall_story_text = "Opera Hall: Westfall Story"
	L.opera_hall_westfall_story_trigger = "we meet two lovers" -- Tonight... we meet two lovers born on opposite sides of Sentinel Hill.
	L.opera_hall_beautiful_beast_story_text = "Opera Hall: Beautiful Beast"
	L.opera_hall_beautiful_beast_story_trigger = "a tale of romance and rage" -- Tonight... a tale of romance and rage, one which will prove once and for all if beaty is more than skin deep.
	L.opera_hall_wikket_story_text = "Opera Hall: Wikket"
	L.opera_hall_wikket_story_trigger = "Shut your jabber" -- Shut your jabber, drama man! The Monkey King got another plan!
	L.barnes = "Barnes"
	L.maiden = "Reformed Maiden"
	L.philanthropist = "Ghostly Philanthropist"
	L.guardsman = "Phantom Guardsman"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		228700, -- Arcane Barrage
		229608, -- Mighty Swing
		229622, -- Fel Breath
		229489, -- Royalty
		229468, -- Move Piece
		229618, -- Fel Bomb
		{230094, "SAY"}, -- Nullification
		{230083, "SAY"}, -- Nullification
		228603, -- Charge
		241828, -- Trampling Stomp
		{228280, "ICON", "SAY"}, -- Oath of Fealty
		227966, -- Flashlight
		"custom_on_autotalk", -- Barnes
		"warmup", -- Opera Hall event timer
		228279, -- Shadow Rejuvenation
		228575, -- Alluring Aura
		228625, -- Banshee Wail
		227999, -- Pennies from Heaven
		228528, -- Heartbreaker
		{228526, "SAY"}, -- Flirt
		241798, -- Kiss of Death
		241774  -- Shield Smash
	}, {
		[228700] = L.confluence,
		[229608] = L.EruditeSlayer,
		[229622] = L.FelBat,
		[229489] = L.King,
		[229618] = L.InfusedPyromancer,
		[230094] = L.AbstractNullifier,
		[228603] = L.charger,
		[228280] = L.spectral,
		[227966] = L.skeletalUsher,
		["custom_on_autotalk"] = "general",
		[228279] = L.attendant,
		[228575] = L.hostess,
		[227999] = L.philanthropist,
		[228528] = L.maiden,
		[241774] = L.guardsman
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Enable")
	self:Log("SPELL_CAST_START", "ArcaneBarrage", 228700)
	self:Log("SPELL_CAST_START", "MightySwing", 229608)
	self:Log("SPELL_CAST_START", "FelBreath", 229622)
	self:Log("SPELL_CAST_START", "Nullification", 230094)
	self:Log("SPELL_AURA_APPLIED", "NullificationApplied", 230083)
	self:Log("SPELL_AURA_APPLIED", "RoyaltyApplied", 229489)
	self:Log("SPELL_AURA_APPLIED", "MovePieceApplied", 229468)
	self:Log("SPELL_CAST_START", "Charge", 228603)
	self:Log("SPELL_CAST_START", "TramplingStomp", 241828)
	self:Log("SPELL_CAST_START", "OathofFealty", 228280)
	self:Log("SPELL_CAST_START", "Flashlight", 227966)
	self:Log("SPELL_CAST_START", "ShadowRejuvenation", 228279)
	self:Log("SPELL_CAST_START", "AlluringAura", 228575)
	self:Log("SPELL_CAST_START", "BansheeWail", 228625)
	self:Log("SPELL_CAST_START", "PenniesFromHeaven", 227999)
	self:Log("SPELL_CAST_START", "Heartbreaker", 228528)
	self:Log("SPELL_CAST_START", "Flirt", 228526)
	self:Log("SPELL_CAST_START", "KissofDeath", 241798)
	self:Log("SPELL_CAST_START", "ShieldSmash", 241774)
	self:Death("ChessDeath", 115401, 115402, 115406, 115395, 115407)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Warmup")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--King

function mod:ChessDeath(args)
	self:Message(229489, "Positive", "Info", CL.removed:format("Царственность"))
	self:CDBar(229489, 20)
end

function mod:RoyaltyApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
end

function mod:MovePieceApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm", nil, nil, true)
end

-- Mana Confluence
function mod:ArcaneBarrage(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
end

-- Abstract Nullifier
function mod:Nullification(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 15)
end

function mod:NullificationApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Bam")
	elseif not self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "None")
	end
end

-- Erudite Slayer
function mod:MightySwing(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CDBar(args.spellId, 12.3)
end

-- Fel Bat
function mod:FelBreath(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
end

-- Infused Pyromancer
do
	local prev = nil
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellGUID, spellId)
		if spellId == 229620 and spellGUID ~= prev and FelBomb == 0 then
			prev = spellGUID
			self:CDBar(229618, 29.1)
			FelBomb = 1
			self:Message(229618, "Important", "Long")
		elseif spellId == 229620 and spellGUID ~= prev and FelBomb == 1 then
			prev = spellGUID
			self:CastBar(229618, 29.1)
			FelBomb = 0
			self:Message(229618, "Important", "Long")
		end
	end
end

-- Spectral Charger

do
	local prev = 0
	function mod:Charge(args)
		local t = GetTime()
		if t-prev > 18 then
			prev = t
			self:Bar(args.spellId, 20)
		end
		self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
	end
end

do
	local prev = 0
	function mod:TramplingStomp(args)
		local t = GetTime()
		if t-prev > 15 then
			prev = t
			self:Bar(args.spellId, 17)
		end
		self:Message(args.spellId, "Important", self:Interrupter() and "Sonar", CL.casting:format(args.spellName))
	end
end

-- Spectral Retainer
do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(228280, name, "Personal", "Bam")
			self:Say(228280)
		elseif t-prev > 0.5 then
			prev = t
			self:TargetMessage(228280, name, "Personal", "Warning")
		end
	end
	function mod:OathofFealty(args)
		local t = GetTime()
		if t-prev > 30 then
			prev = t
			self:Bar(args.spellId, 32)
		end
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

-- Skeletal Usher
do
	local prev = 0
	function mod:Flashlight(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Attention", "Info")
		end
		self:Bar(args.spellId, 3)
	end
end

-- Barnes
function mod:GOSSIP_SHOW()
	if self:GetOption("custom_on_autotalk") and self:MobId(UnitGUID("npc")) == 114339 then
		if GetGossipOptions() then
			SelectGossipOption(1)
		end
	end
end

function mod:Warmup(_, msg)
	if msg:find(L.opera_hall_westfall_story_trigger, nil, true) then
		self:Bar("warmup", 42, L.opera_hall_westfall_story_text, "achievement_raid_karazhan")
	end

	if msg:find(L.opera_hall_beautiful_beast_story_trigger, nil, true) then
		self:Bar("warmup", 47, L.opera_hall_beautiful_beast_story_text, "achievement_raid_karazhan")
	end

	if msg:find(L.opera_hall_wikket_story_trigger, nil, true) then
		self:Bar("warmup", 70, L.opera_hall_wikket_story_text, "achievement_raid_karazhan")
	end
end

-- Spectral Attendant
function mod:ShadowRejuvenation(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
end

-- Wholesome Hostess
function mod:AlluringAura(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
end

function mod:BansheeWail(args)
	if bit.band(args.sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then -- these NPCs can be mind-controlled by DKs
		self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
	end
end

-- Ghostly Philanthropist
do
	local prev = 0
	function mod:PenniesFromHeaven(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
		end
	end
end

-- Reformed Maiden
function mod:Heartbreaker(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
end

do
	local prev = 0
	function mod:KissofDeath(args)
		local t = GetTime()
		if t-prev > 28 then
			prev = t
			self:CDBar(args.spellId, 30)
		end
		self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(args.spellName))
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(228526, name, "Personal", "Bam")
			self:Say(228526)
		elseif t-prev > 0.1 then
			prev = t
			self:TargetMessage(228526, name, "Personal", "Info")
		end
	end
	function mod:Flirt(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

-- Phantom Guardsman
do
	local prev = 0
	function mod:ShieldSmash(args)
		if bit.band(args.sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0 then -- these NPCs can be mind-controlled by DKs
			return
		end
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
		end
	end
end


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Black Rook Hold Trash", 1501)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	101839, -- Risen Companion
	98280, -- Risen Arcanist
	98243, -- Soul-torn Champion
	100485, -- Soul-torn Vanguard
	102094, -- Risen Swordsman
	98275, -- Risen Archer
	98691, -- Risen Scout
	98370, -- Ghostly Councilor
	98810, -- Wrathguard Bladelord
	102788 -- Felspite Dominator
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.companion = "Risen Companion"
	L.arcanist = "Risen Arcanist"
	L.champion = "Soul-torn Champion"
	L.swordsman = "Risen Swordsman"
	L.archer = "Risen Archer"
	L.scout = "Risen Scout"
	L.councilor = "Ghostly Councilor"
	L.WrathguardBladelord = "Wrathguard Bladelord"
	L.dominator = "Felspite Dominator"
	L.warmup_text = "Последние валуны !"
	L.warmup_trigger = "Ха"
	L.warmup_trigger2 = "Они"
	L.warmup_trigger3 = "МЫ"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		222397,
		"warmup",
		225963, -- Bloodthirsty Leap (Risen Companion)
		{200248, "SAY"}, -- Arcane Blitz (Risen Arcanist)
		200261, -- Bonebreaking Strike (Soul-torn Champion)
		197974, -- Bonecrushing Strike (Soul-torn Vanguard)
		214003, -- Coup de Grace (Risen Swordsman)
		200343, -- Arrow Barrage (Risen Archer)
		{193633, "SAY", "FLASH"}, -- Shoot (Risen Archer)
		200291, -- Knife Dance (Risen Scout)
		225573, -- Dark Mending (Ghostly Councilor)
		201139, -- Brutal Assault (Wrathguard Bladelord)
		8599,   -- Enrage
		203163, -- Sic Bats! (Felspite Dominator)
		227913  -- Felfrenzy (Felspite Dominator)
	}, {
		[225963] = L.companion,
		[200248] = L.arcanist,
		[200261] = L.champion,
		[214003] = L.swordsman,
		[200343] = L.archer,
		[200291] = L.scout,
		[225573] = L.councilor,
		[201139] = L.WrathguardBladelord,
		[203163] = L.dominator
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Enable")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Warmup")

	self:Log("SPELL_AURA_APPLIED", "BloodthirstyLeap", 225963)
	self:Log("SPELL_AURA_APPLIED", "ArcaneBlitz", 200248)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneBlitz", 200248)
	self:Log("SPELL_CAST_START", "ArcaneBlitzCast", 200248)
	self:Log("SPELL_CAST_START", "BonebreakingStrike", 200261, 197974) -- 197974 = Bonecrushing Strike
	self:Log("SPELL_CAST_START", "CoupdeGrace", 214003)
	self:Log("SPELL_CAST_START", "ArrowBarrage", 200343)
	self:Log("SPELL_CAST_START", "Shoot", 193633)
	self:Log("SPELL_CAST_START", "KnifeDance", 200291)
	self:Log("SPELL_CAST_START", "DarkMending", 225573)
	self:Log("SPELL_CAST_START", "BrutalAssault", 201139)
	self:Log("SPELL_AURA_APPLIED", "SicBats", 203163)
	self:Log("SPELL_CAST_START", "Felfrenzy", 227913)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 8599)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Warmup(_, msg)
	if msg:find(L.warmup_trigger, nil, true) then
		self:Message(222397, "Attention", "Warning", CL.casting:format("Катание валунов"))
	end

	if msg:find(L.warmup_trigger2, nil, true) then
		self:Bar("warmup", 6, L.warmup_text, "inv_stone_10")
		self:Message(222397, "Positive", "Info", CL.over:format("Катание валунов"))
	end

	if msg:find(L.warmup_trigger3, nil, true) then
		self:Bar("warmup", 14, L.warmup_text, "inv_stone_10")
		self:Message(222397, "Positive", "Info", CL.over:format("Катание валунов"))
		self:UnregisterEvent("CHAT_MSG_MONSTER_YELL", "Warmup")
	end
end

-- Risen Arcanist
function mod:ArcaneBlitz(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "red")
	self:PlaySound(args.spellId, "Info", args.destName)
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(200248, name, "Personal", "Banana Peel Slip")
			self:Say(200248)
		end
	end
	function mod:ArcaneBlitzCast(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

-- Soul-torn Champion, Soul-torn Vanguard
function mod:BonebreakingStrike(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
end

-- Risen Swordsman
function mod:CoupdeGrace(args)
	self:Message(args.spellId, "Important", "Alarm", CL.incoming:format(args.spellName))
end

-- Risen Archer
function mod:ArrowBarrage(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
end

-- Wrathguard Bladelord

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if t-prev > 38 then
			prev = t
			self:TargetMessage(201139, name, "Personal", "Warning")
			self:CDBar(201139, 20)
			self:CastBar(201139, 40)
		elseif t-prev > 0 then
			self:TargetMessage(201139, name, "Personal", "Warning")
		end
	end
	function mod:BrutalAssault(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

function mod:Enrage(args)
	self:Message(args.spellId, "Attention", "Info")
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(193633, name, "Personal", "Bam")
			self:Say(193633)
			self:CastBar(193633, 2)
		elseif not self:Me(guid) then
			self:TargetMessage(193633, name, "Personal", "None")
		end
	end
	function mod:Shoot(args)
		self:GetUnitTarget(printTarget, 0.1, args.sourceGUID)
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(200248, name, "Personal", "Banana Peel Slip")
			self:Say(200248)
		end
	end
	function mod:ArcaneBlitzCast(args)
		self:GetUnitTarget(printTarget, 0.1, args.sourceGUID)
	end
end

-- Risen Scout
function mod:KnifeDance(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 20)
end

-- Ghostly Councilor
function mod:DarkMending(args)
	self:Message(args.spellId, "Attention", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
end

-- Felspite Dominator
function mod:Felfrenzy(args)
	self:Message(args.spellId, "Attention", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
end

-- Risen Companion
function mod:BloodthirstyLeap(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 8)
	self:CastBar(args.spellId, 16)
end

do
	local prev = 0
	function mod:SicBats(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
		end
	end
end

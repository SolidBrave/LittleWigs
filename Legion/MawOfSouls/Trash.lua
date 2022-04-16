
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Maw of Souls Trash", 1492)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	97200, -- Seacursed Soulkeeper
	99188, -- Waterlogged Soul Guard
	97097, -- Helarjar Champion
	97182, -- Night Watch Mariner
	98919, -- Seacursed Swiftblade
	97365, -- Seacursed Mistmender
	99033, -- Helarjar Mistcaller
	97043, -- Seacursed Slaver
	97185, -- The Grimewalker
	99307 -- Skjal
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.soulkeeper = "Seacursed Soulkeeper"
	L.soulguard = "Waterlogged Soul Guard"
	L.champion = "Helarjar Champion"
	L.mariner = "Night Watch Mariner"
	L.swiftblade = "Seacursed Swiftblade"
	L.mistmender = "Seacursed Mistmender"
	L.mistcaller = "Helarjar Mistcaller"
	L.slaver = "Seacursed Slaver"
	L.TheGrimewalker = "The Grimewalker"
	L.skjal = "Skjal"
end

-- Initialization
--

function mod:GetOptions()
	return {
		{200208, "SAY"}, -- Brackwater Blast
		195031, -- Defiant Strike
		{194657, "SAY"}, -- Soul Siphon
		194442, -- Six Pound Barrel
		198405, -- Bone Chilling Scream
		192019, -- Lantern of Darkness
		194615, -- Sea Legs
		199514, -- Torrent of Souls
		199589, -- Whirlpool of Souls
		216197, -- Surging Waters
		194674, -- Barbed Spear
		194099, -- Bile Breath
		195293, -- Debilitating Shout
		{198324, "SAY", "FLASH"}, -- Give No Quarter
	}, {
		[200208] = L.soulkeeper,
		[194657] = L.soulguard,
		[198405] = L.champion,
		[192019] = L.mariner,
		[194615] = L.swiftblade,
		[199514] = L.mistmender,
		[199589] = L.mistcaller,
		[194674] = L.slaver,
		[194099] = L.TheGrimewalker,
		[195293] = L.skjal,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_CAST_START", "Casts", 199514, 199589, 216197)	-- Torrent of Souls, Whirlpool of Souls, Surging Waters
	self:Log("SPELL_CAST_START", "SoulSiphon", 194657)
	self:Log("SPELL_CAST_START", "SixPoundBarrel", 194442)
	self:Log("SPELL_CAST_START", "BileBreath", 194099)
	
	self:Log("SPELL_DAMAGE", "TorrentOfSouls", 199519)
	self:Log("SPELL_MISSED", "TorrentOfSouls", 199519)

	self:Log("SPELL_AURA_APPLIED", "BrackwaterBlastApplied", 200208)
	self:Log("SPELL_AURA_REMOVED", "BrackwaterBlastRemoved", 200208)
	self:Log("SPELL_CAST_START", "DefiantStrike", 195031)
	
	self:Log("SPELL_AURA_APPLIED", "GhostlyRage", 194663)
	self:Log("SPELL_CAST_START", "BoneChillingScream", 198405)
	
	self:Log("SPELL_CAST_START", "BarbedSpear", 194674)

	self:Log("SPELL_AURA_APPLIED", "SeaLegs", 194615)

	self:Log("SPELL_CAST_START", "LanternOfDarkness", 192019)

	self:Log("SPELL_CAST_START", "DebilitatingShout", 195293)
	--self:Log("SPELL_CAST_START", "GiveNoQuarter", 198324)
	--self:Log("SPELL_CAST_START", "GiveNoQuarter", 196885)
	self:Log("SPELL_CAST_SUCCESS", "GiveNoQuarter", 198324) -- the target-selecting instant cast (the real channeling cast is 196885)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prevTable = {}
	function mod:Casts(args)
		local t = GetTime()
		if t - (prevTable[args.spellId] or 0) > 1 then
			prevTable[args.spellId] = t
			self:Message(args.spellId, "Urgent", "Alarm")
		end
	end

	function mod:TorrentOfSouls(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t - (prevTable[args.spellId] or 0) > 1.5 then
				prevTable[args.spellId] = t

				local spellId = self:CheckOption(199514, "MESSAGE") and 199514 or 199589 -- both these spells do damage with 199519
				self:Message(spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
			end
		end
	end

	function mod:GhostlyRage(args)
		local t = GetTime()
		if t - (prevTable[args.spellId] or 0) > 1.5 then
			prevTable[args.spellId] = t
			self:Message(198405, "Attention", "Info", CL.soon:format(self:SpellName(5782))) -- Bone Chilling Scream, 5782 = "Fear"
			self:CDBar(198405, 6)
		end
	end

	function mod:BoneChillingScream(args)
		local t = GetTime()
		if t - (prevTable[args.spellId] or 0) > 1 then
			prevTable[args.spellId] = t
			self:Message(args.spellId, "Important", "Warning")
		end
	end

	function mod:SeaLegs(args)
		if self:MobId(args.destGUID) ~= 98919 then return end -- mages can spellsteal it
		-- for casters/hunters it's deflection, for melees it's just dodge chance
		if self:Ranged() or self:Dispeller("magic", true) then
			local t = GetTime()
			if t - (prevTable[args.spellId] or 0) > 1 then
				prevTable[args.spellId] = t
				self:Message(args.spellId, "Attention", "Alarm", CL.other:format(args.spellName, args.destName))
			end
		end
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if t-prev > 14 and self:Me(guid) then
			prev = t
			self:TargetMessage(194657, name, "Personal", "Bam")
			self:Say(194657)
			self:CDBar(194657, 17.5)
		elseif t-prev > 14 then
			prev = t
			self:TargetMessage(194657, name, "Urgent", "Alarm")
			self:CDBar(194657, 17.5)
		elseif t-prev > 0.1 and self:Me(guid) then
			self:Say(194657)
			self:TargetMessage(194657, name, "Personal", "Bam")
		elseif t-prev > 0.1 then
			self:TargetMessage(194657, name, "Urgent", "Alarm")
		end
	end
	function mod:SoulSiphon(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

do
	local prev = 0
	function mod:BarbedSpear(args)
		local t = GetTime()
		if t-prev > 15.5 then
			prev = t
			self:CDBar(194674, 8.5)
			self:CastBar(194674, 17)
		end
		self:Message(args.spellId, "Urgent", "Warning")
	end
end

do
	local prev = 0
	function mod:DefiantStrike(args)
		local t = GetTime()
		if t-prev > 22 then
			prev = t
			self:Bar(195031, 24)
		end
		self:Message(args.spellId, "Urgent", "Sonar")
	end
end

do
	local prev = 0
	function mod:SixPoundBarrel(args)
		local t = GetTime()
		if t-prev > 14 then
			prev = t
			self:Bar(194442, 17.5)
		end
		self:Message(194442, "Urgent", "Sonar")
	end
end

function mod:BileBreath(args)
	self:Message(args.spellId, "Urgent", "Sonar")
	self:CDBar(args.spellId, 15.7)
end

function mod:LanternOfDarkness(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CastBar(args.spellId, 7)
	self:CDBar(args.spellId, 14.6)
end

function mod:DebilitatingShout(args)
	self:CastBar(args.spellId, 12.5)
	self:Message(args.spellId, "Urgent", "Long")
end

function mod:GiveNoQuarter(args)
	self:CastBar(args.spellId, 20.5)
	self:Message(args.spellId, "Urgent", "Long")
end

function mod:GiveNoQuarter(args)
	self:CastBar(args.spellId, 20.5)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:TargetMessage(args.spellId, args.destName, "Important", "Warning")
	else
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true)
	end
end

function mod:BrackwaterBlastApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 3, nil, 2)
	end
	self:TargetMessage(args.spellId, args.destName, "Important", "Bam", nil, nil, self:Dispeller("magic"))
	self:TargetBar(args.spellId, 3, args.destName)
end

function mod:BrackwaterBlastRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(args.spellId, args.destName)
end

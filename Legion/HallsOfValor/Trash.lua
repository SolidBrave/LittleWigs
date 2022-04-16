
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Halls of Valor Trash", 1477)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	97081, -- King Bjorn
	95843, -- King Haldor
	97083, -- King Ranulf
	97084, -- King Tor
	96664, -- Valarjar Runecarver
	97202, -- Olmyr the Enlightened
	97219, -- Solsten
	95834, -- Valarjar Mystic
	95842, -- Valarjar Thundercaller
	97197, -- Valarjar Purifier
	101637, -- Valarjar Aspirant
	97068, -- Storm Drake
	99891, -- Storm Drake
	96640, -- Valarjar Marksman
	96934, -- Valarjar Trapper
	96574 -- Stormforged Sentinel
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_autotalk = "Autotalk"
	L.custom_on_autotalk_desc = "Instantly selects various gossip options around the dungeon."

	L.fourkings = "The Four Kings"
	L.runecarver = "Valarjar Runecarver"
	L.olmyr = "Olmyr the Enlightened"
	L.purifier = "Valarjar Purifier"
	L.thundercaller = "Valarjar Thundercaller"
	L.mystic = "Valarjar Mystic"
	L.aspirant = "Valarjar Aspirant"
	L.drake = "Storm Drake"
	L.marksman = "Valarjar Marksman"
	L.trapper = "Valarjar Trapper"
	L.sentinel = "Stormforged Sentinel"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_on_autotalk",
		192563, -- Cleansing Flames
		199726, -- Unruly Yell
		--199674, -- Wicked Dagger
		{199674, "SAY", "FLASH"},
		199652, -- Sever
		192158, -- Sanctify
		192288, -- Searing Light
		200901, -- Eye of the Storm
		191508, -- Blast of Light
		{198962, "SAY"}, -- Shattered rune
		{215430, "SAY", "FLASH", "PROXIMITY"}, -- Thunderstrike
		198931, -- Healing Light (replaced by Holy Radiance in mythic difficulty)
		198934, -- Rune of Healing
		215433, -- Holy Radiance
		198888, -- Lightning Breath
		199210, -- Penetrating Shot
		199341, -- Bear Trap
		210875, -- Charged Pulse
		{199805, "SAY"}, -- Crackle
		{198745, "DISPEL"}, -- Protective Light
	}, {
		["custom_on_autotalk"] = "general",
		[192563] = L.purifier,
		[199726] = L.fourkings,
		[199674] = L.fourkings,
		[199652] = L.fourkings,
		[198962] = L.runecarver,
		[192158] = L.olmyr,
		[200901] = L.solsten,
		[191508] = L.aspirant,
		[215430] = L.thundercaller,
		[198931] = L.mystic,
		[198888] = L.drake,
		[199210] = L.marksman,
		[199341] = L.trapper,
		[210875] = L.sentinel,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- Cleansing Flames, Unruly Yell, Sanctify, Blast of Light, Healing Light, Rune of Healing, Holy Radiance, Lightning Breath, Bear Trap, Charged Pulse
	self:Log("SPELL_CAST_START", "Casts", 192563, 191508, 198931, 198934, 215433, 199341, 210875)
	self:Log("SPELL_CAST_START", "LightningBreath", 198888)
	self:Log("SPELL_CAST_START", "PenetratingShot", 199210)
	self:Log("SPELL_CAST_START", "WickedDagger", 199674)
	self:Log("SPELL_CAST_START", "UnrulyYell", 199726)
	self:Log("SPELL_CAST_START", "Sever", 199652)
	
	self:Log("SPELL_CAST_START", "SearingLight", 192288)
	self:Log("SPELL_CAST_SUCCESS", "SanctifySuccess", 192158)
	self:Log("SPELL_CAST_SUCCESS", "EyeoftheStormSuccess", 200901)
	self:Log("SPELL_CAST_START", "EyeOfTheStormOrSanctify", 200901, 192158)
	--[[ Stormforged Sentinel ]]--
	self:Log("SPELL_CAST_START", "CrackleCast", 199805)
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 199818) -- Crackle
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 199818)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 199818)
	self:Log("SPELL_AURA_APPLIED", "ProtectiveShield", 198745)

	self:Log("SPELL_AURA_APPLIED", "Thunderstrike", 215430)
	self:Log("SPELL_AURA_REMOVED", "ThunderstrikeRemoved", 215430)
	
	self:Log("SPELL_CAST_START", "ValarjarRunecarver", 198962)

	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("GOSSIP_SHOW")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LightningBreath(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:CDBar(args.spellId, 15.9)
end

function mod:EyeOfTheStormOrSanctify(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:StopBar(192288)
end

function mod:SanctifySuccess(args)
	self:CDBar(args.spellId, 25.3)
	self:CDBar(192288, 7)
end

function mod:SearingLight(args)
	self:CDBar(args.spellId, 7)
	self:Message(args.spellId, "Urgent", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
end

function mod:EyeoftheStormSuccess(args)
	self:CDBar(args.spellId, 27.5)
end

function mod:Sever(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 12.5)
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(198962, name, "Personal", "Bam")
			self:Say(198962)
		elseif t-prev > 1.5 then
			prev = t
			self:TargetMessage(198962, name, "Info", "Alert")
		end
	end
	function mod:ValarjarRunecarver(args)
		self:GetUnitTarget(printTarget, 0.5, args.sourceGUID)
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(199674, name, "Personal", "Bam")
			self:Say(199674)
		elseif t-prev > 1.5 then
			prev = t
			self:TargetMessage(199674, name, "Info", "Alert")
		end
	end
	function mod:WickedDagger(args)
		self:CDBar(args.spellId, 13)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

function mod:UnrulyYell(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 20)
end

function mod:PenetratingShot(args)
	self:Message(199210, "Important", "Alarm")
end

do
	local prev = nil
	local preva = 0
	function mod:UNIT_SPELLCAST_START(_, _, _, _, spellGUID, spellId)
		local t = GetTime()
		if spellId == 199210 and spellGUID ~= prev and t-preva > 9 then
			prev = spellGUID
			preva = t
			self:Message(199210, "Important", "Long")
			self:CDBar(199210, 20)
		elseif spellId == 199210 and spellGUID ~= prev and t-preva > 0.1 then
			prev = spellGUID
			preva = t
			self:Message(199210, "Important", "Long")
			self:CastBar(199210, 20)
		end
	end
end

function mod:Casts(args)
	self:Message(args.spellId, "Important", "Alarm")
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Message(199805, "Urgent", "Warning", CL.you:format(self:SpellName(199805)))
			self:Say(199805)
		end
	end

	function mod:CrackleCast(args)
		self:GetUnitTarget(printTarget, 0.5, args.sourceGUID)
	end
end

function mod:ProtectiveShield(args)
	self:Message(args.spellId, "Attention", self:Dispeller("magic", true, args.spellId) and "Info", CL.on:format(self:SpellName(182405), args.sourceName)) -- Shield
end

function mod:Thunderstrike(args)
	if self:Me(args.destGUID) then
		local _, _, duration = self:UnitDebuff("player", args.spellId) -- Random lengths
		self:SayCountdown(215430, duration, nil, 3)
		self:Bar(215430, duration or 3)
		self:OpenProximity(215430, 8)
		self:Say(215430)
		self:Flash(215430)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Sonar")
	elseif not self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
	end
end

function mod:ThunderstrikeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(199805, "Personal", "Alert", CL.underyou:format(args.spellName))
			end
		end
	end
end

do
	local autoTalk = {
		[97081] = true, -- King Bjorn
		[95843] = true, -- King Haldor
		[97083] = true, -- King Ranulf
		[97084] = true, -- King Tor
	}

	function mod:GOSSIP_SHOW()
		local mobId = self:MobId(UnitGUID("npc"))
		if self:GetOption("custom_on_autotalk") and autoTalk[mobId] then
			if GetGossipOptions() then
				SelectGossipOption(1)
			end
		end
	end
end

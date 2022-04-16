
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Arcway Trash", 1516)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	98426, -- Unstable Ooze
	98425, -- Unstable Amalgamation
	98756, -- Arcane Anomaly
	105915, -- Nightborne Reclaimer
	106059, -- Warp Shade
	105952, -- Withered Manawraith
	98770, -- Wrathguard Felblade
	105651, -- Dreadborne Seer
	105617 -- Eredar Chaosbringer
)

--------------------------------------------------------------------------------
-- Locals
--

local list = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.unstable = "Unstable Ooze"
	L.unstable = "Unstable Amalgamation"
	L.anomaly = "Arcane Anomaly"
	L.nightborne = "Nightborne Reclaimer"
	L.shade = "Warp Shade"
	L.wraith = "Withered Manawraith"
	L.blade = "Wrathguard Felblade"
	L.seer = "Dreadborne Seer"
	L.chaosbringer = "Eredar Chaosbringer"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Unstable Ooze
		193938, -- Ooze Explosion

		-- Unstable Amalgamation
		193938, -- Ooze Explosion

		-- Arcane Anomaly
		211217, -- Arcane Slicer
		226206, -- Arcane Reconstitution

		-- Warp Shade
		211115, -- Phase Breach
		
		-- Nightborne Reclaimer
		211007, -- Eye of the Vortex

		-- Withered Manawraith
		210750, -- Collapsing Rift

		-- Wrathguard Felblade
		211745, -- Fel Strike
		
		-- Dreadborne Seer
		{211775, "ICON", "SAY"}, -- Eye of the Beast
		211771, -- Prophecies of Doom

		-- Eredar Chaosbringer
		226285, -- Demonic Ascension
		211632, -- Brand of the Legion
		211757, -- Portal: Argus
	}, {
		[193938] = L.unstable,
		[211217] = L.anomaly,
		[211115] = L.shade,
		[211007] = L.nightborne,
		[210750] = L.wraith,
		[211745] = L.blade,
		[211775] = L.seer,
		[226285] = L.chaosbringer,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- Arcane Anomaly
	self:Log("SPELL_CAST_START", "ArcaneSlicer", 211217)

	-- Arcane Anomaly and Warp Shade
	self:Log("SPELL_CAST_START", "ArcaneReconstitution", 226206)

	-- Warp Shade
	self:Log("SPELL_CAST_START", "PhaseBreach", 211115)
	
	-- Nightborne Reclaimer
	self:Log("SPELL_AURA_APPLIED", "EyeoftheVortexApplied", 211007)

	-- Withered Manawraith, Wrathguard Felblade
	self:Log("SPELL_AURA_APPLIED", "PeriodicDamage", 210750, 211745) -- Collapsing Rift, Fel Strike
	self:Log("SPELL_PERIODIC_DAMAGE", "PeriodicDamage", 210750, 211745)
	self:Log("SPELL_PERIODIC_MISSED", "PeriodicDamage", 210750, 211745)
	
	-- Dreadborne Seer
	self:Log("SPELL_CAST_START", "EyeoftheBeast", 211775)
	self:Log("SPELL_CAST_START", "PropheciesofDoom", 211771)

	-- Eredar Chaosbringer
	self:Log("SPELL_CAST_START", "BrandoftheLegion", 211632)
	self:Log("SPELL_CAST_START", "DemonicAscension", 226285)
	self:Log("SPELL_CAST_START", "PortalArgus", 211757)
	self:Log("SPELL_AURA_APPLIED", "DemonicAscensionApplied", 226285)
	self:Log("SPELL_DISPEL", "DemonicAscensionDispelled", "*")
	self:Log("SPELL_AURA_APPLIED", "BrandoftheLegionApplied", 211632)
	
	self:RegisterEvent("UNIT_SPELLCAST_START")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EyeoftheVortexApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Bam", nil, nil, true)
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(211775, name, "Personal", "Bam")
			self:Say(211775)
		elseif t-prev > 1.5 then
			prev = t
			self:TargetMessage(211775, name, "Attention", "Alert")
		end
	end
	function mod:EyeoftheBeast(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

function mod:PropheciesofDoom(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
end

-- Unstable Amalgamation

do
	local prev = nil
	local preva = 0
	function mod:UNIT_SPELLCAST_START(_, _, _, _, spellGUID, spellId)
		local t = GetTime()
		if spellId == 193938 and spellGUID ~= prev and t-preva > 10 then
			prev = spellGUID
			preva = t
			self:CDBar(193938, 13)
			self:CastBar(193938, 26)
			self:Message(193938, "Urgent", "Warning", CL.casting:format("Взрыв слизнюка"))
		elseif spellId == 193938 and spellGUID ~= prev and t-preva > 0 then
			prev = spellGUID
			self:Message(193938, "Urgent", "Warning", CL.casting:format("Взрыв слизнюка"))
		end
		if spellId == 211007 and t-preva > 18 and spellGUID ~= prev then
			prev = spellGUID
			preva = t
			self:CDBar(211007, 20)
			self:Message(211007, "Urgent", "Banana Peel Slip", CL.casting:format("Око урагана"))
		elseif spellId == 211007 and t-preva > 0 and spellGUID ~= prev then
			prev = spellGUID
			self:Message(211007, "Urgent", "Banana Peel Slip", CL.casting:format("Око урагана"))
		end
	end
end

-- Arcane Anomaly
function mod:ArcaneSlicer(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
end

-- Arcane Anomaly and Warp Shade
function mod:ArcaneReconstitution(args)
	self:Message(args.spellId, "Urgent", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
end

-- Warp Shade
function mod:PhaseBreach(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
end

-- Withered Manawraith, Wrathguard Felblade
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

-- Eredar Chaosbringer
function mod:BrandoftheLegion(args)
	if bit.band(args.sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then -- these NPCs can be mind-controlled by warlocks
		self:Message(args.spellId, "Attention", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
	end
end

function mod:BrandoftheLegionApplied(args)
	if self:Dispeller("magic", true) and not UnitIsPlayer(args.destName) then
		self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm", nil, nil, true)
	end
end

function mod:DemonicAscension(args)
	if bit.band(args.sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then -- these NPCs can be mind-controlled by warlocks
		self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	end
end

function mod:DemonicAscensionApplied(args)
	if not UnitIsPlayer(args.destName) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	end
end

function mod:DemonicAscensionDispelled(args)
	if args.extraSpellId == 226285 then
		self:Message(226285, "Positive", "Info", CL.removed_by:format(args.extraSpellName, self:ColorName(args.sourceName)))
	end
end

function mod:PortalArgus(args)
	self:Message(args.spellId, "Urgent", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
end
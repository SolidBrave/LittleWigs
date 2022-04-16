
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Opera Hall: Beautiful Beast", 1651, 1827)
if not mod then return end
mod:RegisterEnableMob(
	114328, -- Coogleston
	114329, -- Luminore
	114522, -- Mrs. Cauldrons
	114330  -- Babblet
)
mod.engageId = 1957 -- Same for every opera event. So it's basically useless.

--------------------------------------------------------------------------------
-- Locals
--

local addsKilled = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		228025, -- Heat Wave
		228019, -- Leftovers
		{228221, "SAY", "ICON"}, -- Severe Dusting
		{227985, "TANK_HEALER"}, -- Dent Armor
		227987, -- Dinner Bell!
		232153, -- Kara Kazham!
		228225, -- Sultry Heat
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "HeatWave", 228025)
	self:Log("SPELL_CAST_START", "Leftovers", 228019)
	self:Log("SPELL_AURA_APPLIED", "SevereDusting", 228221)
	self:Log("SPELL_AURA_REMOVED", "SevereDustingRemoved", 228221)
	self:Log("SPELL_AURA_REMOVED", "SpectralService", 232156)
	self:Log("SPELL_AURA_APPLIED", "DentArmor", 227985)
	self:Log("SPELL_AURA_REMOVED", "DentArmorRemoved", 227985)
	self:Log("SPELL_CAST_START", "DinnerBell", 227987)
	self:Log("SPELL_CAST_START", "KaraKazham", 232153)
	self:Log("SPELL_AURA_APPLIED", "SultryHeat", 228225)

	self:RegisterEvent("BOSS_KILL")

	self:Death("AddsKilled",
		114329, -- Luminore
		114522, -- Mrs. Cauldrons
		114330  -- Babblet
	)
end

function mod:OnEngage()
	addsKilled = 0
	self:Bar(228019, 7) -- Leftovers
	self:Bar(228025, 30) -- Heat Wave
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SultryHeat(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:HeatWave(args)
	self:Message(args.spellId, "Important", "Info")
	self:CDBar(args.spellId, 30)
	self:CastBar(args.spellId, 60)
end

function mod:Leftovers(args)
	self:Message(args.spellId, "Important", self:Interrupter() and "Alert")
	self:CDBar(args.spellId, 18)
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(228221, name, "Personal", "Bam")
			self:Say(228221)
		elseif t-prev > 1.5 then
			prev = t
			self:TargetMessage(228221, name, "Personal", "None")
		end
	end
	function mod:SevereDusting(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
		self:SecondaryIcon(228221, args.destName)
	end
end

function mod:SevereDustingRemoved(args)
	self:SecondaryIcon(228221, nil)
end

function mod:SpectralService(args)
	self:Message("stages", "Positive", "Long", CL.removed:format(args.spellName), args.spellId)
	self:Bar(232153, 2) -- Kara Kazham!
	self:Bar(227987, 13) -- Dinner Bell!
	self:Bar(227985, 8) -- Dent Armor
end

function mod:DentArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
	self:TargetBar(args.spellId, 8, args.destName)
end

function mod:DentArmorRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:DinnerBell(args)
	self:Message(args.spellId, "Attention", self:Interrupter() and "Alert")
	self:Bar(args.spellId, 20)
end

function mod:KaraKazham(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, 20)
end

function mod:AddsKilled(args)
	addsKilled = addsKilled + 1
	self:Message("stages", "Neutral", "Long", CL.mob_killed:format(args.destName, addsKilled, 3), false)

	if args.mobId == 114329 then -- Luminore
		self:StopBar(228025) -- Heat Wave
	elseif args.mobId == 114522 then -- Mrs. Cauldrons
		self:StopBar(228019) -- Leftovers
	elseif args.mobId == 114330 then -- Babblet
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1957 then
		self:Win()
	end
end

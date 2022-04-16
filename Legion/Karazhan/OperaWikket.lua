
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Opera Hall: Wikket", 1651, 1820)
if not mod then return end
mod:RegisterEnableMob(114251, 114284) -- Galindre, Elfyra
mod.engageId = 1957 -- Same for every opera event. So it's basically useless.

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		227447, -- Defy Gravity
		{227341, "ICON", "SAY"}, -- Flashy Bolt
		227410, -- Wondrous Radiance
		227776, -- Magic Magnificent
		227477, -- Summon Assistants
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_CAST_START", "DefyGravity", 227447)
	self:Log("SPELL_CAST_SUCCESS", "WondrousRadiance", 227410)
	self:Log("SPELL_CAST_START", "MagicMagnificent", 227776)
	self:Log("SPELL_CAST_START", "SummonAssistants", 227477)
	self:Log("SPELL_CAST_START", "FlashyBolt", 227341)
	self:Log("SPELL_CAST_SUCCESS", "FlashyBoltSuccess", 227341)
	self:Log("SPELL_INTERRUPT", "Interrupt", "*")
	

	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:Bar(227410, 8.5) -- Wondrous Radiance
	self:Bar(227447, 10.5) -- Defy Gravity
	self:Bar(227477, 32) -- Summon Assistants
	self:Bar(227776, 46.1) -- Magic Magnificent
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DefyGravity(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 17)
end

do	
	local prev = 0
	local function printTarget(self, name, player, guid)
		local t = GetTime()
		self:SecondaryIcon(227341, player)
		self:TargetMessage(227341, name, "Personal", "None", nil, nil, true)
	end

	function mod:FlashyBolt(args)
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:FlashyBoltSuccess(args)
	self:SecondaryIcon(227341)
end

function mod:Interrupt(args)
	if args.extraSpellId == 227341 then
		self:SecondaryIcon(227341)
	end
end

function mod:WondrousRadiance(args)
	self:Message(args.spellId, "Urgent", self:Tank() and "Warning")
	self:CDBar(args.spellId, 11)
end

function mod:MagicMagnificent(args)
	self:Message(args.spellId, "Urgent", "Omen: Aoogah!")
	self:CastBar(args.spellId, 5, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 46.1)
end

function mod:SummonAssistants(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 32.5)
end

function mod:BOSS_KILL(_, id)
	if id == 1957 then
		self:Win()
	end
end

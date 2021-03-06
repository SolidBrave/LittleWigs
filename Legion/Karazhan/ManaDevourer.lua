
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mana Devourer", 1651, 1818)
if not mod then return end
mod:RegisterEnableMob(114252)
mod.engageId = 1959

--------------------------------------------------------------------------------
-- Locals
--

local unstableManaOnMe = false

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		227618, -- Arcane Bomb
		227523, -- Energy Void
		227502, -- Unstable Mana
		227297, -- Coalesce Power
		227457, -- Energy Discharge
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_CAST_SUCCESS", "ArcaneBomb", 227618)
	self:Log("SPELL_CAST_SUCCESS", "EnergyVoid", 227523)
	self:Log("SPELL_AURA_APPLIED", "UnstableMana", 227502)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnstableMana", 227502)
	self:Log("SPELL_AURA_REMOVED", "UnstableManaRemoved", 227502)
	self:Log("SPELL_AURA_APPLIED", "CoalescePower", 227297)
	self:Log("SPELL_PERIODIC_DAMAGE", "EnergyVoidDamage", 227524)
	self:Log("SPELL_PERIODIC_MISSED", "EnergyVoidDamage", 227524)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Death("Win", 0)
end

function mod:OnEngage()
	unstableManaOnMe = false
	self:Bar(227457, 22) -- Energy Discharge
	self:Bar(227618, 7) -- Arcane Bomb
	self:Bar(227523, 14.5) -- Energy Void
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = nil
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellGUID, spellId)
		if spellId == 227457 and spellGUID ~= prev then
			prev = spellGUID
			self:CDBar(227457, 27) -- Energy Discharge
		end
	end
end

function mod:ArcaneBomb(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CDBar(args.spellId, 14.5)
end

function mod:EnergyVoid(args)
	self:Message(args.spellId, "Attention", "Info")
	self:Bar(args.spellId, 21.9)
end

function mod:UnstableMana(args)
	if self:Me(args.destGUID) then
		unstableManaOnMe = true
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Positive")
	end
end

function mod:UnstableManaRemoved(args)
	if self:Me(args.destGUID) then
		unstableManaOnMe = false
	end
end

function mod:CoalescePower(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:Bar(args.spellId, 30.3)
end

do
	local prev = 0
	function mod:EnergyVoidDamage(args)
		if self:Me(args.destGUID) and not unstableManaOnMe then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(227523, "Personal", "Alarm", CL.underyou:format(args.spellName))
			end
		end
	end
end


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ularogg Cragshaper", 1458, 1665)
if not mod then return end
mod:RegisterEnableMob(91004)
mod.engageId = 1791

--------------------------------------------------------------------------------
-- Locals
--

local totemsAlive = 0
local StanceCount = 0
local BellowCount = 0
local StrikeCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.totems = "Totems"
	L.bellow = "{193375} (Totems)" -- Bellow of the Deeps (Totems)
	L.bellow_desc = 193375
	L.bellow_icon = 193375
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		198564, -- Stance of the Mountain
		198496, -- Sunder
		198428, -- Strike of the Mountain
		"bellow",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "Sunder", 198496)
	self:Log("SPELL_CAST_START", "StrikeOfTheMountain", 198428)
	self:Log("SPELL_CAST_START", "BellowOfTheDeeps", 193375)
	self:Death("IntermissionTotemsDeath", 100818)
end

function mod:OnEngage()
	StrikeCount = 0
	BellowCount = 0
	StanceCount = 0
	self:Bar(198428, 18.5) -- Strike of the Mountain
	self:CDBar(198496, 7) -- Sunder
	self:CDBar(198564, self:Mythic() and 31 or 36.4) -- Stance of the Mountain
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 198509 then -- Stance of the Mountain
		totemsAlive = self:Normal() and 3 or 5
		StrikeCount = 0
		self:StopBar(198496) -- Sunder
		self:StopBar(198428) -- Strike of the Mountain
		self:StopBar(198564) -- Stance of the Mountain
		self:Message(198564, "Attention", "Long")
	end
end

function mod:StrikeOfTheMountain(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(198496, 4.5)
	if StanceCount == 0 then
		self:Bar(args.spellId, 18)
	elseif StanceCount == 1 then
		self:Bar(args.spellId, StrikeCount % 2 == 0 and 18 or 20.5)
	elseif StanceCount == 2 then
		self:Bar(args.spellId, StrikeCount % 2 == 0 and 20.5 or 18)
	elseif StanceCount == 3 then
		self:Bar(args.spellId, StrikeCount % 2 == 0 and 18 or 20.5)
	end
	StrikeCount = StrikeCount + 1
end

function mod:BellowOfTheDeeps(args)
	self:Message("bellow", "Urgent", "Info", CL.incoming:format(L.totems), args.spellId)
	self:CDBar(198496, 6.0) -- Sunder
	--self:CDBar(args.spellId, 29) -- pull:20.6, 44.9, 31.5, 31.5
end

function mod:Sunder(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 8.5)
end

function mod:IntermissionTotemsDeath()
	totemsAlive = totemsAlive - 1
	if totemsAlive == 0 and StanceCount == 0 then -- all of them fire UNIT_DIED
		self:CDBar(198564, self:Mythic() and 50.6 or 70.7) -- Stance of the Mountain
		self:Bar(198428, 3.8) -- Strike of the Mountain
		self:CDBar(198496, 8.8) -- Sunder
		StanceCount = StanceCount + 1
	elseif totemsAlive == 0 and StanceCount == 1 then -- all of them fire UNIT_DIED
		self:CDBar(198564, self:Mythic() and 51 or 70.7) -- Stance of the Mountain
		self:Bar(198428, 9.6) -- Strike of the Mountain
		self:CDBar(198496, 4.8) -- Sunder
		StanceCount = StanceCount + 1
	elseif totemsAlive == 0 and StanceCount == 2 then -- all of them fire UNIT_DIED
		self:CDBar(198564, self:Mythic() and 52.9 or 70.7) -- Stance of the Mountain
		self:Bar(198428, 17.7) -- Strike of the Mountain
		self:CDBar(198496, 3) -- Sunder
		StanceCount = StanceCount + 1
	elseif totemsAlive == 0 and StanceCount == 3 then -- all of them fire UNIT_DIED
		self:CDBar(198564, self:Mythic() and 50.6 or 70.7) -- Stance of the Mountain
		self:Bar(198428, 3.8) -- Strike of the Mountain
		self:CDBar(198496, 8.8) -- Sunder
		StanceCount = 1
	end
end

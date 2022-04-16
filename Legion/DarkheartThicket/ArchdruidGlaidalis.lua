
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Archdruid Glaidalis", 1466, 1654)
if not mod then return end
mod:RegisterEnableMob(96512)
mod.engageId = 1836

--------------------------------------------------------------------------------
-- Locals
--

local RampageCount = 1
local GrievousCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		198379, -- Primal Rampage
		198408, -- Nightfall
		{196376, "FLASH"}, -- Grievous Tear
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "PrimalRampage", 198379)

	self:Log("SPELL_AURA_APPLIED", "NightfallDamage", 198408)
	self:Log("SPELL_PERIODIC_DAMAGE", "NightfallDamage", 198408)
	self:Log("SPELL_PERIODIC_MISSED", "NightfallDamage", 198408)
	self:Log("SPELL_AURA_APPLIED", "GrievousTearApplied", 196376)
end

function mod:OnEngage()
	RampageCount = 1
	GrievousCount = 1
	self:CDBar(198379, 13.5) -- Primal Rampage
	self:CDBar(196376, 5) -- Grievous Tear
	self:CDBar(198408, 25) -- Nightfall
	self:ScheduleTimer("Nightfall", 0.2)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Nightfall()
	self:ScheduleTimer("Nightfall", 0.2)
	NightfallTimeLeft = self:BarTimeLeft(198408)
	if NightfallTimeLeft < 0.1 then
		self:CDBar(198408, 30) -- Nightfall
	end
end

function mod:PrimalRampage(args)
	if RampageCount == 1 then
		self:CDBar(198408, 12) -- Nightfall
	elseif RampageCount == 2 then
		self:CDBar(198408, 12.5) -- Nightfall
	elseif RampageCount == 3 then
		self:CDBar(198408, 14) -- Nightfall
	elseif RampageCount == 4 then
		self:CDBar(198408, 15) -- Nightfall
	elseif RampageCount == 5 then
		self:CDBar(198408, 16.5) -- Nightfall
	elseif RampageCount == 6 then
		self:CDBar(198408, 18.5) -- Nightfall
	elseif RampageCount == 7 then
		self:CDBar(198408, 25) -- Nightfall
	elseif RampageCount == 8 then
		self:CDBar(198408, 26) -- Nightfall
	elseif RampageCount == 9 then
		self:CDBar(198408, 28.5) -- Nightfall
	elseif RampageCount == 10 then
		self:CDBar(198408, 35) -- Nightfall
	elseif RampageCount == 11 then
		self:CDBar(198408, 6) -- Nightfall
		self:CDBar(196376, 7) -- Grievous Tear
		RampageCount = 1
	end
	self:Message(args.spellId, "Important", "Warning")
	self:CDBar(args.spellId, 28.7) -- pull:12.7, 30.3 / m pull:12.6, 31.6, 29.9, 27.9
	RampageCount = RampageCount + 1
end

do
	local prev = 0
	function mod:NightfallDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			end
		end
	end
end

do
	local prev = 0
	function mod:GrievousTearApplied(args)
		local t = GetTime()
		if t-prev > 10 then
			prev = t
			self:Bar(args.spellId, GrievousCount % 2 == 0 and 12.5 or 14.5)
			if GrievousCount == 1 then
				self:CDBar(196376, 13.5)
			end
			GrievousCount = GrievousCount + 1
		end
		self:TargetMessage(args.spellId, args.destName, "Attention")
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
		end
	end
end


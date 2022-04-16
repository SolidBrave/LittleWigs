
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fenryr", 1477, 1487)
if not mod then return end
mod:RegisterEnableMob(95674, 99868) -- Phase 1 Fenryr, Phase 2 Fenryr
mod.engageId = 1807

local LeapCount = 1
local RavenousLeapCount = 1
local RavenousLeapIconCount = 0
--------------------------------------------------------------------------------
-- Initialization
--
local RavenousLeapMarker = mod:AddMarkerOption(true, "player", 1, 197556, 1, 2, 3, 4, 5, 6) --Ravenous Leap
function mod:GetOptions()
	return {
		"stages",
		196543, -- Unnerving Howl
		{197556, "SAY", "PROXIMITY"}, -- Ravenous Leap
		RavenousLeapMarker,
		196512, -- Claw Frenzy
		{196838, "SAY", "ICON"}, -- Scent of Blood
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Stealth", 196567)
	self:Log("SPELL_CAST_START", "UnnervingHowl", 196543)
	self:Log("SPELL_AURA_APPLIED", "RavenousLeap", 197556)
	self:Log("SPELL_AURA_REMOVED", "RavenousLeapRemoved", 197556)
	self:Log("SPELL_CAST_SUCCESS", "ClawFrenzy", 196512)
	self:Log("SPELL_CAST_START", "ScentOfBlood", 196838)
	self:Log("SPELL_AURA_REMOVED", "ScentOfBloodRemoved", 196838)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	RavenousLeapCount = 1
	RavenousLeapIconCount = 0
	LeapCount = 1
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	self:CDBar(196543, 5.5) -- Unnerving Howl
	self:CDBar(196512, 10.7) -- Claw Frenzy
	self:CDBar(197556, 13.4) -- Ravenous Leap
	if PhaseCount == 2 then
		self:CDBar(197556, 15.1) -- Ravenous Leap
		self:CDBar(196838, 27.7) -- Scent of Blood
		self:CDBar(196512, 12.6) -- Claw Frenzy
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 197560 then
		self:Message(197556, "Attention", "Sonar", CL.count:format("Хищный прыжок", LeapCount))
		LeapCount = LeapCount + 1
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp <= 60 then
		PhaseCount = 2
		self:CDBar(197556, 15.1) -- Ravenous Leap
		self:CDBar(196838, 27.7) -- Scent of Blood
		self:CDBar(196512, 12.6) -- Claw Frenzy
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
	end
end

function mod:Stealth(args)
	self:Message("stages", "Neutral", nil, CL.stage:format(2), false)
	-- Prevent the module wiping when moving to phase 2 and ENCOUNTER_END fires.
	self:ScheduleTimer("Reboot", 0.5) -- Delay a little
	PhaseCount = 2
	self:StopBar(197556) -- Ravenous Leap
	self:StopBar(196838) -- Scent of Blood
	self:StopBar(196512) -- Claw Frenzy
end

function mod:UnnervingHowl(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 32)
end

do
	local list = mod:NewTargetList()
	function mod:RavenousLeap(args)
		--"pull:10.1, 36.0" p2
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Info", nil, nil, true)
			self:CDBar(args.spellId, 31)
			self:CastBar(args.spellId, 2.9)
		end
		if self:Me(args.destGUID) then
			self:OpenProximity(args.spellId, 10)
			self:Say(args.spellId)
		end
		self:CDBar(196512, 10.8)
		if self:GetOption(RavenousLeapMarker) then
			local icon = (RavenousLeapIconCount % 6) + 1
			SetRaidTarget(args.destName, icon)
			RavenousLeapIconCount = RavenousLeapIconCount + 1
		end
	end

	function mod:RavenousLeapRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
		if self:GetOption(RavenousLeapMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:ClawFrenzy(args)
	self:Message(args.spellId, "Important")
	self:CDBar(args.spellId, 9.7)
	LeapCount = 1
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(196838)
		end
		self:PrimaryIcon(196838, player)
		self:TargetMessage(196838, player, "Urgent", "Warning")
	end
	function mod:ScentOfBlood(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
		self:CDBar(args.spellId, 38)
		self:CDBar(196543, 20)
		self:CDBar(197556, 25)
		self:CDBar(196512, 17.72)
	end
	function mod:ScentOfBloodRemoved(args)
		self:PrimaryIcon(args.spellId)
		self:CDBar(196512, 8.72)
	end
end

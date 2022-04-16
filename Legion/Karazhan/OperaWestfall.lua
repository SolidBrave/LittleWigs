
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Opera Hall: Westfall Story", 1651, 1826)
if not mod then return end
mod:RegisterEnableMob(114261, 114260, 114265) -- Toe Knee, Mrrgria
mod.engageId = 1957 -- Same for every opera event. So it's basically useless.

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.warmup_text = "So ya wanna rumble, do ya?"
	L.warmup_trigger = "So ya wanna rumble, do ya?"
end
--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local list = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"warmup",
		"stages",
		227568, -- Burning Leg Sweep
		{227777, "PROXIMITY"}, -- Thunder Ritual
		227783, -- Wash Away
		{227325, "SAY"}, -- Poisonous Shank
		227480, -- Flame Gale
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Warmup")
	self:Log("SPELL_CAST_START", "BurningLegSweep", 227568)
	self:Log("SPELL_CAST_START", "ThunderRitual", 227777)
	self:Log("SPELL_AURA_APPLIED", "ThunderRitualApplied", 227777)
	self:Log("SPELL_AURA_REMOVED", "ThunderRitualRemoved", 227777)
	self:Log("SPELL_CAST_START", "WashAway", 227783)
	self:Log("SPELL_AURA_APPLIED", "PoisonousShankApplied", 227325)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameGale", 227480)
	self:Log("SPELL_PERIODIC_MISSED", "FlameGale", 227480)

	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	phase = 1
	self:Bar(227568, 8.5) -- Burning Leg Sweep
	self:Bar(227325, 5) -- Poisonous Shank
	self:Bar(227480, 23, L.warmup_text, "spell_fire_playingwithfire")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:RegisterEvent("UNIT_AURA")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Warmup(event, msg)
	if msg == L.warmup_trigger then
		self:Bar(227480, 30, L.warmup_text, "spell_fire_playingwithfire")
		self:Message(227480, "Attention", "Info")
	end
end

do	
	local prev = 0
	function mod:PoisonousShankApplied(args)
		local t = GetTime()
		if (self:Dispeller("poison") or self:Me(args.destGUID)) and t-prev > 7 then
			prev = t
			self:PlaySound(227325, "Bam")
			self:CDBar(227325, 10)
		elseif t-prev > 7 then
			prev = t
			self:CDBar(227325, 10)
		elseif (self:Dispeller("poison") or self:Me(args.destGUID)) and t-prev > 0.1 then
			prev = t
			self:PlaySound(227325, "Bam")
		end
	end
end

do
	local prev = 0
	function mod:FlameGale(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				self:Message(227480, "Personal", "Warning", CL.underyou:format(args.spellName))
			end
		end
	end
end

do
	local players = {}
	local UnitGUID = UnitGUID
	function mod:UNIT_AURA(_, unit)
		local PoisonousShank = self:UnitDebuff(unit, 227325)
		if PoisonousShank then
			local guid = UnitGUID(unit)
			if not players[guid] then
				players[guid] = true
				if unit == "player" then
					self:Say(227325)
				end
				list[#list+1] = self:UnitName(unit)
				self:TargetsMessage(227325, "green", list, 3)
			end
		elseif players[UnitGUID(unit)] then
			players[UnitGUID(unit)] = nil
		end
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	local foundMrrgria, foundToeKnee = nil, nil
	for i = 1, 5 do
		local guid = UnitGUID(("boss%d"):format(i))
		if guid  then
			local mobId = self:MobId(guid)
			if mobId == 114260 then -- Mrrgria
				foundMrrgria = true
			elseif mobId == 114261 then -- Toe Knee
				foundToeKnee = true
			end
		end
	end

	if foundMrrgria and phase == 1 then -- Mrrgria
		phase = 2
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
		self:StopBar(227568) -- Burning Leg Sweep
		self:Bar(227777, 8.5) -- Thunder Ritual
		self:Bar(227783, 15.5) -- Wash Away
	elseif foundToeKnee and phase == 2 then -- Toe Knee
		phase = 3
		self:Message("stages", "Neutral", "Long", CL.stage:format(3), false)
		self:Bar(227568, 8) -- Burning Leg Sweep
	end
end

function mod:BurningLegSweep(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:CDBar(args.spellId, 19)
end

function mod:ThunderRitual(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 17)
end

function mod:ThunderRitualApplied(args)
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 5)
		self:TargetBar(args.spellId, 5, args.destName)
	end
end

function mod:ThunderRitualRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:WashAway(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, 23)
end

function mod:BOSS_KILL(_, id)
	if id == 1957 then
		self:Win()
	end
end

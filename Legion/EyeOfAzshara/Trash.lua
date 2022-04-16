--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eye of Azshara Trash", 1456)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	91786, -- Gritslime Snail
	100216, -- Hatecoil Wrangler
	91783, -- Hatecoil Stormweaver
	91782, -- Hatecoil Crusher
	98173, -- Mystic Ssa'veh
	95861, -- Hatecoil Oracle
	91790, -- Mak'rana Siltwalker
	97173, -- Restless Tides
	97171, -- Hatecoil Arcanist
	100248, 100249, 100250, 98173 -- Ritualist Lesha
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.gritslime = "Gritslime Snail"
	L.wrangler = "Hatecoil Wrangler"
	L.stormweaver = "Hatecoil Stormweaver"
	L.crusher = "Hatecoil Crusher"
	L.oracle = "Hatecoil Oracle"
	L.siltwalker = "Mak'rana Siltwalker"
	L.tides = "Restless Tides"
	L.arcanist = "Hatecoil Arcanist"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		191797,  -- Winds
		--[[ Gritslime Snail ]]--
		195473, -- Abrasive Slime

		--[[ Hatecoil Wrangler ]]--
		225089, -- Lightning Prod

		--[[ Hatecoil Stormweaver & Mystic Ssa'veh ]]--
		196870, -- Storm
		195109, -- Arc Lightning

		--[[ Hatecoil Crusher ]]--
		195129, -- Thundering Stomp

		--[[ Hatecoil Oracle ]]--
		195046, -- Rejuvenating Waters

		--[[ Mak'rana Siltwalker ]]--
		196127, -- Spray Sand

		--[[ Restless Tides ]]--
		195284, -- Undertow

		--[[ Hatecoil Arcanist & Ritualist Lesha ]]--
		196027, -- Aqua Spout
		{197105, "SAY"}, -- Polymorph: Fish
		{192706, "SAY", "ICON"}, -- Arcane Bomb
	}, {
		[195473] = L.gritslime,
		[225089] = L.wrangler,
		[196870] = L.stormweaver,
		[195129] = L.crusher,
		[195046] = L.oracle,
		[196127] = L.siltwalker,
		[195284] = L.tides,
		[196027] = L.arcanist
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Log("SPELL_AURA_APPLIED", "Winds", 191797)
	self:Log("SPELL_CAST_START", "AbrasiveSlime", 195473)
	self:Log("SPELL_CAST_START", "LightningProd", 225089)
	self:Log("SPELL_CAST_START", "Storm", 196870)
	self:Log("SPELL_CAST_START", "ArcLightning", 195109)
	self:Log("SPELL_CAST_START", "ThunderingStomp", 195129)
	self:Log("SPELL_CAST_START", "RejuvenatingWaters", 195046)
	self:Log("SPELL_CAST_START", "SpraySand", 196127)
	self:Log("SPELL_CAST_START", "Undertow", 195284)
	self:Log("SPELL_CAST_START", "AquaSpout", 196027)
	self:Log("SPELL_AURA_APPLIED", "PolymorphFish", 197105)
	self:Log("SPELL_CAST_START", "PolymorphFishCast", 197105)
	self:Log("SPELL_CAST_START", "ArcaneBomb", 192706)
	self:Log("SPELL_AURA_APPLIED", "ArcaneBombApplied", 192706)
	self:Log("SPELL_AURA_REMOVED", "ArcaneBombRemoved", 192706)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Winds(args)
	if self:Me(args.destGUID) then
		self:Message(191797, "Attention", "Alarm")
		self:CDBar(191797, 90)
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if t-prev > 0.3 then
			prev = t
			self:TargetMessage(192706, name, "Attention", "Alarm")
		end
	end
	function mod:ArcaneBombApplied(args)
		local t = GetTime()
		self:PrimaryIcon(192706, args.destName)
		if self:Me(args.destGUID) then
			prev = t
			self:Say(args.spellId)
			self:TargetMessage(args.spellId, args.destName, "Personal", "Bam")
			local _, _, duration = self:UnitDebuff("player", args.spellId)
			self:SayCountdown(args.spellId, duration, nil, 5)
		end
	end
	function mod:ArcaneBombRemoved(args)
		self:PrimaryIcon(192706, nil)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:ArcaneBomb(args)
		local t = GetTime()
		if t-prev > 9 then
			prev = t
			self:CDBar(192706, 16)
		elseif t-prev > 0.3 then
			self:CastBar(192706, 16)
		end
	end
end

do
	local prev = 0
	function mod:PolymorphFishCast(args)
		self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
		local t = GetTime()
		if t-prev > 15 then
			prev = t
			self:CDBar(197105, 18)
		end
	end
end

-- Gritslime Snail
function mod:AbrasiveSlime(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 8) -- "Abrasive Slime"
	self:CastBar(195473, 16)
end

-- Hatecoil Wrangler
function mod:LightningProd(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
end

-- Hatecoil Stormweaver
function mod:Storm(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 18)
end

function mod:ArcLightning(args)
	self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(args.spellName))
end

-- Hatecoil Crusher
function mod:ThunderingStomp(args)
	self:Message(args.spellId, "Important", self:Interrupter() and "Warning" or "Info", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 19) -- "Thundering Stomp"
	self:CastBar(args.spellId, 38)
end

-- Hatecoil Oracle
function mod:RejuvenatingWaters(args)
	self:Message(args.spellId, "Attention", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
end

-- Mak'rana Siltwalker
function mod:SpraySand(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 19) -- "Spray Sand"
	self:CastBar(196127, 38)
end

-- Restless Tides
function mod:Undertow(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
end

-- Hatecoil Arcanist

do
	local prev = 0
	function mod:AquaSpout(args)
		self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(args.spellName))
		local t = GetTime()
		if t-prev > 16 then
			prev = t
			self:CDBar(196027, 16)
		elseif t-prev > 0.5 and t-prev < 17 then
			self:CastBar(196027, 16)
		end
	end
end

function mod:PolymorphFish(args)
	if self:Dispeller("magic") then
		self:TargetMessage(args.spellId, args.destName, "Attention", "Info", self:SpellName(118), nil, true) -- 118 is Polymorph, which is shorter than "Polymorph: Fish"
	elseif self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Attention", "Info", self:SpellName(118), nil, true)
		self:Say(args.spellId)
	end
end
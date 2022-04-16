
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Seat of the Triumvirate Trash", 1753)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	125836, -- Alleria Windrunner
	123743, -- Alleria Windrunner
	124171, -- Shadowguard Subjugator
	122404, -- Shadowguard Voidbender
	125860, 
	122571, -- Rift Warden
	122405, -- Shadowguard Conjurer
	122403, -- Shadowguard Champion
	122413, -- Shadowguard Riftstalker
	124947, -- Void Flayer
	122423 -- Grand Shadow-Weaver
)

--------------------------------------------------------------------------------
-- Locals
--

local RuinousStrike = 0
local WildSummon = 0
local StygianBlast = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_autotalk = "Autotalk"
	L.custom_on_autotalk_desc = "Instantly selects Alleria Winrunners gossip option."
	L.custom_on_autotalk_icon = "inv_bow_1h_artifactwindrunner_d_03"
	L.gossip_available = "Gossip available"
	L.alleria_gossip_trigger = "Follow me!" -- Allerias yell after the first boss is defeated
	
	L.warmup_text_2 = "Аллерия активна"
	L.warmup_trigger_5 = "За мной!"

	L.alleria = "Alleria Windrunner"
	L.subjugator = "Shadowguard Subjugator"
	L.ShadowguardChampion = "Shadowguard Champion"
	L.ShadowguardRiftstalker = "Shadowguard Riftstalker"
	L.voidbender = "Shadowguard Voidbender"
	L.conjurer = "Shadowguard Conjurer"
	L.weaver = "Grand Shadow-Weaver"
	L.VoidFlayer = "Void Flayer"
	L.RiftWarden = "Rift Warden"
end

--------------------------------------------------------------------------------
-- Initialization
--

local matterMarker = mod:AddMarkerOption(true, "npc", 8, 248227, 8) -- Unstable Dark Matter
function mod:GetOptions()
	return {
		"custom_on_autotalk",
		"warmup",
		{249081, "SAY"}, -- Suppression Field
		{246697, "SAY"}, -- Negating Brand
		{245510, "SAY"}, -- Corrupting Void
		{245522, "SAY"}, -- Entropic Mist
		{248133, "SAY"}, -- Stygian Blast
		245706, -- Ruinous Strike
		248304, -- Wild Summon
		249078, -- Void Diffusion
		{244916, "SAY"}, -- Void Lashing
		248227, -- Dark Matter
		matterMarker,
	}, {
		[249081] = L.subjugator,
		[248133] = L.RiftWarden,
		[245706] = L.ShadowguardChampion,
		[248304] = L.ShadowguardRiftstalker,
		[245510] = L.voidbender,
		[249078] = L.conjurer,
		[244916] = L.VoidFlayer,
		[248227] = L.weaver,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Enable")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Warmup")

	self:Log("SPELL_AURA_APPLIED", "PersonalAurasWithSay", 249081, 245510) -- Suppression Field, Corrupting Void
	self:Log("SPELL_CAST_START", "VoidDiffusionCast", 249078)
	self:Log("SPELL_CAST_START", "EntropicMist", 245522)
	self:Log("SPELL_CAST_START", "StygianBlast", 248133)
	self:Log("SPELL_CAST_START", "RuinousStrike", 245706)
	self:Log("SPELL_CAST_START", "WildSummon", 248304)
	self:Log("SPELL_AURA_APPLIED", "VoidLashing", 244916)
	self:Log("SPELL_CAST_START", "DarkMatterCast", 248227)
	self:Log("SPELL_CAST_START", "CollapseCast", 248228)
	self:Log("SPELL_CAST_START", "NegatingBrand", 246697)

	self:RegisterEvent("GOSSIP_SHOW")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidLashing(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Bite")
	else
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(245522, name, "Personal", "Bam")
			self:Say(245522)
		elseif t-prev > 0.1 then
			prev = t
			self:TargetMessage(245522, name, "Attention", "Alert")
		end
	end
	function mod:EntropicMist(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if t-prev > 0.5 then
			prev = t
			self:TargetMessage(248133, name, "Attention", "Alert")
		end
	end
	function mod:StygianBlast(args)
	self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	if StygianBlast == 0 then
		self:CDBar(args.spellId, 20)
		StygianBlast = 1
	elseif StygianBlast == 1 then
		self:CastBar(args.spellId, 20)
		StygianBlast = 0
	end
	end
end

function mod:WildSummon(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
	if WildSummon == 0 then
		self:CDBar(args.spellId, 23.5)
		WildSummon = 1
	elseif WildSummon == 1 then
		self:CastBar(args.spellId, 23.5)
		WildSummon = 0
	end	
end

function mod:RuinousStrike(args)
	self:Message(args.spellId, "Important", "Warning")
	if RuinousStrike == 0 then
		self:CDBar(args.spellId, 15.5)
		RuinousStrike = 1
	elseif RuinousStrike == 1 then
		self:CastBar(args.spellId, 15.5)
		RuinousStrike = 0
	end	
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		local t = GetTime()
		if self:Me(guid) then
			prev = t
			self:TargetMessage(246697, name, "Personal", "Bam")
			self:Say(246697)
		elseif t-prev > 0.1 then
			prev = t
			self:TargetMessage(246697, name, "Attention", "Alert")
		end
	end
	function mod:NegatingBrand(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.alleria_gossip_trigger then
		self:Bar("warmup", 45, L.gossip_available, L.custom_on_autotalk_icon)
	end
end

function mod:Warmup(event, msg)
	if msg == L.warmup_trigger_5 then
		self:Bar("warmup", 45, L.warmup_text_2, "inv_bow_1h_artifactwindrunner_d_03")
	end
end

function mod:PersonalAurasWithSay(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:Say(args.spellId)
	end
end

function mod:VoidDiffusionCast(args)
	self:Message(args.spellId, "Attention", self:Interrupter() and "Info", CL.casting:format(args.spellName))
end

function mod:DarkMatterCast(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	if self:GetOption(matterMarker) then
		self:RegisterTargetEvents("MarkMatter")
	end
end

function mod:MarkMatter(event, unit, guid)
	if self:MobId(guid) == 124964 then -- Unstable Dark Matter
		SetRaidTarget(unit, 8)
		self:UnregisterTargetEvents()
	end
end

function mod:CollapseCast(args)
	self:CastBar(248227, 4.9, args.spellId)
end


function mod:GOSSIP_SHOW()
	if self:GetOption("custom_on_autotalk") then
		if GetGossipOptions() then
			SelectGossipOption(1, "", true)
			SelectGossipOption(1)
		end
	end
	
	if self:GetOption("custom_on_autotalk") and self:MobId(UnitGUID("npc")) == (125836 or 123743) then
		if GetGossipOptions() then
			SelectGossipOption(1)
		end
	end
end

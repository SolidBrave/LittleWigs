
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("General Xakal", 1516, 1499)
if not mod then return end
mod:RegisterEnableMob(98206)
mod.engageId = 1828

--------------------------------------------------------------------------------
-- Locals
--

local WickedSlamCount = 0
local FelFissureCount = 0
local ShadowSlashCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.dread_felbat = -12489
	L.dread_felbat_icon = "inv_felbatmount"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		197776, -- Fel Fissure
		197810, -- Wicked Slam
		212030, -- Shadow Slash
		"dread_felbat", -- Dread Felbat / Bombardment
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FelFissure", 197776)
	self:Log("SPELL_CAST_START", "ShadowSlash", 212030)
	self:Log("SPELL_CAST_START", "WickedSlam", 197810)
end

function mod:OnEngage()
	WickedSlamCount = 1
	FelFissureCount = 1
	ShadowSlashCount = 1
	self:CDBar(197776, 6.2) -- Fel Fissure
	self:CDBar(212030, 13.5) -- Shadow Slash
	self:CDBar("dread_felbat", 20, L.dread_felbat, L.dread_felbat_icon) -- Dread Felbat
	self:ScheduleTimer("DreadFelbats", 20) -- starts at 20, bat comes down after ~5s, next set +32s
	self:CDBar(197810, 36.5, CL.count:format(self:SpellName(197810), WickedSlamCount)) -- Wicked Slam
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DreadFelbats(args)
	self:Message("dread_felbat", "Neutral", "Info", CL.soon:format(self:SpellName(L.dread_felbat)), false)
	self:CDBar("dread_felbat", 31.5, L.dread_felbat, L.dread_felbat_icon)
	self:ScheduleTimer("DreadFelbats", 31.5)
end


function mod:FelFissure(args)
	self:Message(args.spellId, "Attention")
	FelFissureCount = FelFissureCount + 1
	if FelFissureCount == 2 then
		self:CDBar(args.spellId, 22.97)
	elseif FelFissureCount == 3 then
		self:CDBar(args.spellId, 23.01)
	elseif FelFissureCount == 4 then
		self:CDBar(args.spellId, 23.07)
	else
		self:CDBar(args.spellId, 25.40)
	end
end

function mod:ShadowSlash(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	ShadowSlashCount = ShadowSlashCount + 1
	if ShadowSlashCount == 2 then
		self:CDBar(args.spellId, 30.35)
	else
		self:CDBar(args.spellId, 25.40)
	end
end

function mod:WickedSlam(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, WickedSlamCount))
	WickedSlamCount = WickedSlamCount + 1
	if WickedSlamCount == 2 then
		self:CDBar(args.spellId, 47.21, CL.count:format(args.spellName, WickedSlamCount))
	elseif WickedSlamCount == 3 then
		self:CDBar(args.spellId, 49.64, CL.count:format(args.spellName, WickedSlamCount))
	elseif WickedSlamCount == 3 then
		self:CDBar(args.spellId, 50.93, CL.count:format(args.spellName, WickedSlamCount))
	else
		self:CDBar(args.spellId, 50.79, CL.count:format(args.spellName, WickedSlamCount))
	end
end

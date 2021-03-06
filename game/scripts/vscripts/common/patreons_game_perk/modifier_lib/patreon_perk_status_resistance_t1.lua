patreon_perk_status_resistance_t1 = class({})
--------------------------------------------------------------------------------

function patreon_perk_status_resistance_t1:IsHidden()
	return false
end

--------------------------------------------------------------------------------
function patreon_perk_status_resistance_t1:GetTexture()
	return "perkIcons/patreon_perk_status_resistance_t0"
end

--------------------------------------------------------------------------------
function patreon_perk_status_resistance_t1:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function patreon_perk_status_resistance_t1:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_status_resistance_t1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_status_resistance_t1:GetModifierStatusResistanceStacking()
	return GetPerkValue(16, self, 1, 0)
end

--------------------------------------------------------------------------------
function GetPerkValue(const, modifier, levelCounter, bonusPerLevel)
	local heroLvl = modifier:GetParent():GetLevel()
	return math.floor(heroLvl/levelCounter)*bonusPerLevel+const
end
--------------------------------------------------------------------------------
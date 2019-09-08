Patreons = Patreons or {}
Patreons.playerSettings = Patreons.playerSettings or {}
for i=0,23 do
	if Patreons.playerSettings[i] == nil then
		Patreons.playerSettings[i] = {level = 0}
	else
		if Patreons.playerSettings[i].level == nil then
			Patreons.playerSettings[i] = {level = 0}
		end
	end
end

local colorNames = {
	White = Vector(255, 255, 255),
	Red = Vector(200, 0, 0),
	Green = Vector(0, 200, 0),
	Blue = Vector(0, 0, 200),
	Cyan = Vector(0, 200, 200),
	Yellow = Vector(200, 200, 0),
	Pink = Vector(200, 170, 185),
	Maroon = Vector(128, 0, 0),
	Brown = Vector(154, 99, 36),
	Olive = Vector(0, 128, 128),
	Teal = Vector(70, 153, 144),
	Navy = Vector(0, 0, 117),
	Black = Vector(0, 0, 0),
	Orange = Vector(245, 130, 49),
	Lime = Vector(191, 239, 69),
	Purple = Vector(145, 30, 180),
	Magenta = Vector(240, 50, 230),
	Grey = Vector(169, 169, 169),
	Apricot = Vector(255, 216, 177),
	Beige = Vector(255, 250, 200),
	Mint = Vector(170, 255, 195),
	Lavender = Vector(230, 190, 255),
}

function Patreons:GetPlayerSettings(playerId)
	return Patreons.playerSettings[playerId]
end

function Patreons:GetPlayerEmblemColor(playerId)
	return colorNames[Patreons:GetPlayerSettings(playerId).emblemColor]
end

function Patreons:SetPlayerSettings(playerId, settings)
	Patreons.playerSettings[playerId] = settings
	CustomNetTables:SetTableValue("game_state", "patreon_bonuses", Patreons.playerSettings)
end

function Patreons:GiveOnSpawnBonus(playerId)
	local hero = PlayerResource:GetSelectedHeroEntity(playerId)
	local patreonSettings = Patreons:GetPlayerSettings(playerId)

	if patreonSettings.level >= 1 then
		hero:AddNewModifier(hero, nil, "modifier_donator", { patron_level = patreonSettings.level })
	end

	if patreonSettings.level >= 1 and patreonSettings.bootsEnabled then
		if hero:HasItemInInventory("item_boots") then
			hero:ModifyGold(500, false, 0)
		else
			hero:AddItemByName("item_boots")
		end
	end
end

RegisterCustomEventListener("patreon_toggle_boots", function(data)
	local playerId = data.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(playerId)
	if not hero then return end

	local enabled = data.enabled == 1
	local playerBonuses = Patreons:GetPlayerSettings(playerId)
	if playerBonuses.bootsEnabled == enabled then return end

	playerBonuses.bootsEnabled = enabled
	Patreons:SetPlayerSettings(playerId, playerBonuses)
end)

RegisterCustomEventListener("patreon_update_emblem", function(args)
	local playerId = args.PlayerID
	if not colorNames[args.color] then return end

	local playerBonuses = Patreons:GetPlayerSettings(playerId)
	playerBonuses.emblemColor = args.color
	Patreons:SetPlayerSettings(playerId, playerBonuses)
end)

RegisterCustomEventListener("patreon_toggle_emblem", function(args)
	local playerId = args.PlayerID
	local playerBonuses = Patreons:GetPlayerSettings(playerId)
	playerBonuses.emblemEnabled = args.enabled == 1
	Patreons:SetPlayerSettings(playerId, playerBonuses)
end)

--- For anyone looking to make a sub-mod:
--- ! SEE: `gameNight - implementUno` for a simpler example on adding decks.
--- CATAN includes 'game pieces' rather than *just* cards - scroll to the bottom for more info on those.

local applyItemDetails = require "gameNight - applyItemDetails"

-- CARDS
--- CATAN RESOURCES DECK
local CatanResourceDeck = {}
CatanResourceDeck.types = {"Brick","Stone","Wood","Wheat","Sheep"}
CatanResourceDeck.cards = {}

for _,s in pairs(CatanResourceDeck.types) do for i=1, 19 do table.insert(CatanResourceDeck.cards, s) end end
applyItemDetails.addDeck("CatanResourceDeck", CatanResourceDeck.cards)

--- CATAN DEVELOPMENTS DECK
local CatanDevelopmentDeck = {}

--Five (5) Victory Point Cards (Chapel, Library, Market, Palace, University).
CatanDevelopmentDeck.cards = {"Chapel", "Library", "Market", "Palace", "University"}

--Fourteen (14) Knight Cards.
--Six (6) Progress Cards (2 x Monopoly, 2 x Road Building, 2 x Year of Plenty).
CatanDevelopmentDeck.types = {"Knight","Monopoly","Road Building","Year of Plenty"}
CatanDevelopmentDeck.count = {14,2,2,2}

for i,s in pairs(CatanDevelopmentDeck.types) do
    for ii=1, CatanDevelopmentDeck.count[i] do
        table.insert(CatanDevelopmentDeck.cards, s)
    end
end
applyItemDetails.addDeck("CatanDevelopmentDeck", CatanDevelopmentDeck.cards)


-- GAME PIECES / GAME BOARD
---First require this file so that the gamePieceAndBoardHandler module can be called on.
local gamePieceAndBoardHandler = require "gameNight - gamePieceAndBoardHandler"

---Register game pieces by type -- enables the system to display the items using custom textures found in:
--- `Item_InPlayTextures` and `Item_OutOfPlayTextures`
--- Note: In-Play defaults to Out of play textures. Out of play textures replaces the item's texture/icon.
gamePieceAndBoardHandler.registerTypes({
    "Base.CatanCityWhite", "Base.CatanSettlementWhite", "Base.CatanRoadWhite",
    "Base.CatanCityRed", "Base.CatanSettlementRed", "Base.CatanRoadRed",
    "Base.CatanCityBlue", "Base.CatanSettlementBlue", "Base.CatanRoadBlue",
    "Base.CatanCityOrange", "Base.CatanSettlementOrange", "Base.CatanRoadOrange",
    "Base.CatanRobber", "Base.CatanLongestRoad", "Base.CatanLargestArmy", "Base.CatanBoard",
    "Base.CatanPlayerCostsWhite", "Base.CatanPlayerCostsRed", "Base.CatanPlayerCostsOrange", "Base.CatanPlayerCostsBlue"})

---Register special cases for modifying parts of the item
--- For example, the board is registered to the game-system above - which turns it into a 'GamePiece'
--- This `special` case changes the category from `GamePiece` to `GameBoard`.
gamePieceAndBoardHandler.registerSpecial("Base.CatanBoard", { category = "GameBoard", textureSize = {768,676} })

gamePieceAndBoardHandler.registerSpecial("Base.CatanRoadWhite", {
    actions = { rotateRoad=true },
    shiftAction = "rotateRoad",
})

gamePieceAndBoardHandler.registerSpecial("Base.CatanRoadRed", {
    actions = { rotateRoad=true },
    shiftAction = "rotateRoad",
})

gamePieceAndBoardHandler.registerSpecial("Base.CatanRoadBlue", {
    actions = { rotateRoad=true },
    shiftAction = "rotateRoad",
})

gamePieceAndBoardHandler.registerSpecial("Base.CatanRoadOrange", {
    actions = { rotateRoad=true },
    shiftAction = "rotateRoad",
})


---Define new function under `gamePieceAndBoardHandler`
function gamePieceAndBoardHandler.rotateRoad(gamePiece, player)
    local current = gamePiece:getModData()["gameNight_altState"] or gamePiece:getType()

    if current == gamePiece:getType() then
        current = 2
    elseif current == gamePiece:getType()..2 then
        current = 3
    else
        current = nil
    end

    local state = gamePiece:getType()..(current or "")

    gamePieceAndBoardHandler.playSound(gamePiece, player)
    gamePieceAndBoardHandler.pickupAndPlaceGamePiece(player, gamePiece, {gamePieceAndBoardHandler.setModDataValue, gamePiece, "gameNight_altState", state})
end

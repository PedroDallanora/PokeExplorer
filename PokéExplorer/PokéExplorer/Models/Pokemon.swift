import Foundation

struct pokemonModel: Identifiable, Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [pokemonTypeSlot]
    let abilities: [pokemonAbilitySlot]
    let moves: [pokemonMoveSlot]
    let sprites: pokemonSprites
}

struct pokemonTypeSlot: Codable {
    let type: pokemonType
}

struct pokemonType: Codable {
    let name: String
}

struct pokemonAbilitySlot: Codable {
    let ability: pokemonAbility
}

struct pokemonAbility: Codable {
    let name: String
}

struct pokemonMoveSlot: Codable {
    let move: pokemonMove
}

struct pokemonMove: Codable {
    let name: String
}

struct pokemonSprites: Codable {
    let front_default: String?
}

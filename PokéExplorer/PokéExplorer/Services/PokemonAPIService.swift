import Foundation

struct PokemonListResponse: Codable {
    let results: [NamedAPIResource]
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

class PokemonAPIService {
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"

    func fetchGen1Pokemons(limit: Int, offset: Int) async throws -> [pokemonModel] {
        let url = URL(string: "\(baseURL)?limit=\(limit)&offset=\(offset)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        var pokemons: [pokemonModel] = []

        for resource in decoded.results {
            let details = try await fetchPokemon(by: resource.url)
            pokemons.append(details)
        }

        return pokemons
    }

    func fetchPokemon(by url: String) async throws -> pokemonModel {
        let url = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(pokemonModel.self, from: data)
    }
}

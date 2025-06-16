
import SwiftUI

struct PokemonItemView: View {
    let pokemon: pokemonModel
    let isFavorito: Bool
    let isLast: Bool
    let onAppearLast: () -> Void

    var body: some View {
        NavigationLink(destination: DetalhesPokemonView(pokemonURL: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)")) {
            PokemonCard(pokemon: pokemon, isFavorito: isFavorito)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isLast {
                onAppearLast()
            }
        }
    }
}


import SwiftUI

struct PokemonCard: View {
    let pokemon: pokemonModel
    let isFavorito: Bool

    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: pokemon.sprites.front_default ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .scaleEffect(1.2)
            }
            .frame(width: 100, height: 100)
            .background(Color.white)
            .cornerRadius(50)
            .shadow(radius: 4)
            .transition(.scale)

            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding()
        .background(isFavorito ? Color.red.opacity(0.2) : Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .transition(.opacity)
    }
}

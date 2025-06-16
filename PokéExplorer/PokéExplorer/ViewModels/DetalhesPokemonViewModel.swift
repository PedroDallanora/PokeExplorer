import SwiftUI
import Combine
import Foundation
import CoreData

@MainActor
class DetalhesPokemonViewModel: ObservableObject {
    @Published var pokemon: pokemonModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = PokemonAPIService()

    func carregarDetalhes(url: String) async {
        isLoading = true
        do {
            pokemon = try await service.fetchPokemon(by: url)
            errorMessage = nil
        } catch {
            errorMessage = "Erro ao carregar detalhes: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

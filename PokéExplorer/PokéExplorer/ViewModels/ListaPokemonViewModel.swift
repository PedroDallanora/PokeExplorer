import Foundation
import Combine

class ListaPokemonViewModel: ObservableObject {
    @Published var pokemons: [pokemonModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = PokemonAPIService()
    private var cancellables = Set<AnyCancellable>()

    private var currentOffset = 0
    private let limit = 10
    private let totalGen1 = 150

    var canLoadMore: Bool {
        return pokemons.count < totalGen1
    }

    func loadMorePokemons() async {
        guard !isLoading && canLoadMore else { return }
        isLoading = true
        errorMessage = nil

        do {
            let novosPokemons = try await service.fetchGen1Pokemons(limit: limit, offset: currentOffset)
            DispatchQueue.main.async {
                self.pokemons += novosPokemons
                self.currentOffset += self.limit
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erro ao carregar Pokémon: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    func reset() {
        pokemons = []
        currentOffset = 0
        errorMessage = nil
    }
}

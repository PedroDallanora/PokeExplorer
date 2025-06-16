import SwiftUI

struct ListaPokemonView: View {
    @StateObject private var viewModel = ListaPokemonViewModel()
    @State private var favoritos: [String] = []

    let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                header
                subtitle

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.pokemons.indices, id: \.self) { index in
                            let pokemon = viewModel.pokemons[index]
                            PokemonItemView(
                                pokemon: pokemon,
                                isFavorito: favoritos.contains(pokemon.name),
                                isLast: index == viewModel.pokemons.count - 1 && viewModel.canLoadMore,
                                onAppearLast: {
                                    Task {
                                        await viewModel.loadMorePokemons()
                                    }
                                }
                            )
                        }
                    }
                    .padding()

                    if viewModel.isLoading {
                        ProgressView("Carregando mais...")
                            .padding(.vertical)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
            .padding(.top)
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(AppColors.background.ignoresSafeArea())
        }
        .task {
            await viewModel.loadMorePokemons()

            if let usuario = AuthManager.shared.usuarioAtual() {
                let favoritosDoUsuario = FavoritoManager.shared.buscarFavoritos(de: usuario)
                favoritos = favoritosDoUsuario.map { $0.nome ?? "" }
            }
        }
    }

    private var header: some View {
        HStack {
            Text("PokéExplorer")
                .font(.largeTitle.bold())
                .foregroundColor(AppColors.primary)

            Spacer()

            NavigationLink(destination: FavoritosView()) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
        }
        .padding(.horizontal)
    }

    private var subtitle: some View {
        HStack {
            Text("Escolha seu Pokémon")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
}

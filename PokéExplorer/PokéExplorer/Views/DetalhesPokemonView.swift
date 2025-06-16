import SwiftUI

struct DetalhesPokemonView: View {
    @StateObject var viewModel = DetalhesPokemonViewModel()
    let pokemonURL: String
    @State private var favoritoAdicionado = false
    @State private var animarBotao = false
    @State private var animarImagem = false
    @Namespace private var animation

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Carregando...")
                        .scaleEffect(1.5)
                        .padding(.top)
                        .transition(.opacity)
                } else if let pokemon = viewModel.pokemon {
                    VStack(spacing: 16) {
                        
                        // Imagem animada
                        AsyncImage(url: URL(string: pokemon.sprites.front_default ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .transition(.opacity)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .shadow(radius: 8)
                                    .scaleEffect(animarImagem ? 1.1 : 0.8)
                                    .opacity(animarImagem ? 1 : 0)
                                    .animation(.easeOut(duration: 0.6), value: animarImagem)
                            default:
                                Image(systemName: "photo")
                            }
                        }

                        Text(pokemon.name.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.primary)

                        HStack(spacing: 16) {
                            Text("Altura: \(pokemon.height)")
                            Text("Peso: \(pokemon.weight)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        Text("Tipo(s): \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))")
                            .font(.headline)
                            .padding(.bottom, 8)

                        // Habilidades e Movimentos com fade-in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habilidades:")
                                .font(.headline)

                            ForEach(pokemon.abilities, id: \.ability.name) { habilidade in
                                Text("• \(habilidade.ability.name.capitalized)")
                                    .font(.subheadline)
                                    .opacity(animarImagem ? 1 : 0)
                                    .animation(.easeIn.delay(0.3), value: animarImagem)
                            }

                            Text("Movimentos:")
                                .font(.headline)
                                .padding(.top, 8)

                            ForEach(pokemon.moves.prefix(5), id: \.move.name) { movimento in
                                Text("• \(movimento.move.name.capitalized)")
                                    .font(.subheadline)
                                    .opacity(animarImagem ? 1 : 0)
                                    .animation(.easeIn.delay(0.4), value: animarImagem)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        // Botão favorito animado
                        Button(action: {
                            guard let usuario = AuthManager.shared.usuarioAtual(),
                                  let pokemon = viewModel.pokemon else {
                                print("❌ Nenhum usuário logado ou Pokémon nulo.")
                                return
                            }

                            withAnimation(.interpolatingSpring(stiffness: 180, damping: 8)) {
                                animarBotao = true
                            }

                            if favoritoAdicionado {
                                FavoritoManager.shared.remover(pokemon: pokemon.name, do: usuario)
                            } else {
                                FavoritoManager.shared.adicionar(pokemon: pokemon, para: usuario)
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                let favoritos = FavoritoManager.shared.buscarFavoritos(de: usuario)
                                withAnimation {
                                    favoritoAdicionado = favoritos.contains(where: { $0.nome == pokemon.name })
                                    animarBotao = false
                                }
                            }
                        }) {
                            Label(
                                favoritoAdicionado ? "Favoritado" : "Adicionar aos Favoritos",
                                systemImage: favoritoAdicionado ? "heart.fill" : "heart"
                            )
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(favoritoAdicionado ? .red : AppColors.accent)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .scaleEffect(animarBotao ? 1.15 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animarBotao)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .task {
            await viewModel.carregarDetalhes(url: pokemonURL)

            withAnimation {
                animarImagem = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let usuario = AuthManager.shared.usuarioAtual(),
                   let pokemon = viewModel.pokemon {
                    let favoritos = FavoritoManager.shared.buscarFavoritos(de: usuario)
                    favoritoAdicionado = favoritos.contains(where: { $0.nome == pokemon.name })
                }
            }
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

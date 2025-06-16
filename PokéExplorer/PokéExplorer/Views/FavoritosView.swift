import SwiftUI
import CoreData

struct FavoritosView: View {
    @StateObject private var viewModel = FavoritosViewModel()
    @Namespace private var animation
    let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Seus Favoritos")
                    .font(.largeTitle.bold())
                    .foregroundColor(AppColors.primary)
                    .padding(.top)

                if viewModel.favoritos.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .transition(.scale.combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: viewModel.favoritos.isEmpty)

                        Text("Nenhum Pokémon favoritado ainda.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.favoritos, id: \.self) { favorito in
                                NavigationLink(destination:
                                    DetalhesPokemonView(pokemonURL: "https://pokeapi.co/api/v2/pokemon/\(favorito.nome ?? "")")
                                        .transition(.opacity.combined(with: .scale))
                                ) {
                                    VStack(spacing: 12) {
                                        AsyncImage(url: URL(string: favorito.spriteURL ?? "")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.white)
                                        .cornerRadius(50)
                                        .shadow(radius: 4)
                                        .scaleEffect(1.05)
                                        .transition(.opacity.combined(with: .scale))
                                        .animation(.easeIn(duration: 0.3), value: viewModel.favoritos)

                                        Text(favorito.nome?.capitalized ?? "")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                    }
                                    .padding()
                                    .background(Color.red.opacity(0.2))
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                }
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .animation(.easeInOut(duration: 0.3), value: viewModel.favoritos)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favoritos")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.carregarFavoritos()
        }
        .background(AppColors.background.ignoresSafeArea())
    }
}

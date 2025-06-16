import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image("PokemonLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top)

                VStack(spacing: 8) {
                    Text("PokéExplorer")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primary)

                    Text("Entre com sua conta")
                        .font(AppFonts.subtitle)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Senha", text: $viewModel.senha)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    if let erro = viewModel.loginErro {
                        Text(erro)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button("Entrar") {
                        viewModel.autenticar()
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.accent)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    NavigationLink("Não tem conta? Cadastre-se", destination: CadastroView())
                        .font(.footnote)
                        .foregroundColor(.blue)
                }

                NavigationLink(destination: ListaPokemonView(), isActive: $viewModel.navegar) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Login")
            .onAppear {
                let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
                print("Core Data está em:", storeURL?.path ?? "caminho não encontrado")
            }
        }
    }
}

import SwiftUI

struct CadastroView: View {
    @StateObject private var viewModel = CadastroViewModel()

    var body: some View {
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

                Text("Crie sua conta")
                    .font(AppFonts.subtitle)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                TextField("Nome de usuário", text: $viewModel.nome)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

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

                SecureField("Confirme a senha", text: $viewModel.confirmacaoSenha)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if let erro = viewModel.erro {
                    Text(erro)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button("Cadastrar") {
                    viewModel.cadastrar()
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.accent)
                .foregroundColor(.white)
                .cornerRadius(10)

                NavigationLink(destination: LoginView(), isActive: $viewModel.sucesso) {
                    EmptyView()
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Cadastro")
    }
}

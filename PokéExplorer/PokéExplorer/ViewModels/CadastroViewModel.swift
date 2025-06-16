
import Foundation
import SwiftUI

class CadastroViewModel: ObservableObject {
    @Published var nome = ""
    @Published var email = ""
    @Published var senha = ""
    @Published var confirmacaoSenha = ""
    @Published var erro: String?
    @Published var sucesso: Bool = false

    func cadastrar() {
        guard !nome.isEmpty, !email.isEmpty, !senha.isEmpty, !confirmacaoSenha.isEmpty else {
            erro = "Todos os campos são obrigatórios."
            return
        }

        guard senha == confirmacaoSenha else {
            erro = "As senhas não coincidem."
            return
        }

        let sucessoCadastro = AuthManager.shared.cadastrarUsuario(nome: nome, email: email, senha: senha)

        if sucessoCadastro {
            erro = nil
            sucesso = true
        } else {
            erro = "Erro ao cadastrar. Tente novamente."
            sucesso = false
        }
    }
}

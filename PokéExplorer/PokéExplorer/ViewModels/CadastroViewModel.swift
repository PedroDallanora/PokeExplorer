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
        // Verifica campos obrigatórios
        guard !nome.isEmpty, !email.isEmpty, !senha.isEmpty, !confirmacaoSenha.isEmpty else {
            erro = "Todos os campos são obrigatórios."
            return
        }

        // Validação de e-mail com regex
        guard email.isEmailValido() else {
            erro = "O e-mail informado é inválido."
            return
        }

        // Validação de senha com critérios mínimos
        guard senha.isSenhaValida() else {
            erro = "A senha deve ter ao menos 8 caracteres, incluindo letra maiúscula, minúscula, número e caractere especial."
            return
        }

        // Verifica se as senhas coincidem
        guard senha == confirmacaoSenha else {
            erro = "As senhas não coincidem."
            return
        }

        // Tenta cadastrar com AuthManager
        let sucessoCadastro = AuthManager.shared.cadastrarUsuario(nome: nome, email: email, senha: senha)

        if sucessoCadastro {
            erro = nil
            sucesso = true
        } else {
            erro = "Já existe uma conta com esse e-mail."
            sucesso = false
        }
    }
}

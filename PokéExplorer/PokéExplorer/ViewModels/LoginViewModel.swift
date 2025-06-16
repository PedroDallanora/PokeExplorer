
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var senha = ""
    @Published var loginErro: String?
    @Published var usuarioLogado: Usuario?
    @Published var navegar = false

    func autenticar() {
        if let user = AuthManager.shared.autenticar(email: email, senha: senha) {
            usuarioLogado = user
            loginErro = nil
            navegar = true
        } else {
            loginErro = "Email ou senha inválidos."
            navegar = false
        }
    }
}

import CoreData
import CryptoKit
import Foundation

class AuthManager {
    static let shared = AuthManager()
    private let context = PersistenceController.shared.container.viewContext
    private let userDefaultsKey = "usuarioLogadoEmail"

    private func gerarHash(para senha: String) -> String {
        let data = Data(senha.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }

    func cadastrarUsuario(nome: String, email: String, senha: String) -> Bool {
        let usuario = Usuario(context: context)
        usuario.id = UUID()
        usuario.nomeDeUsuario = nome
        usuario.email = email
        usuario.senha = gerarHash(para: senha)

        do {
            try context.save()
            return true
        } catch {
            print("Erro ao salvar usuário: \(error)")
            return false
        }
    }

    func autenticar(email: String, senha: String) -> Usuario? {
        let senhaHash = gerarHash(para: senha)
        let fetch = NSFetchRequest<Usuario>(entityName: "Usuario")
        fetch.predicate = NSPredicate(format: "email == %@ AND senha == %@", email, senhaHash)

        if let usuario = try? context.fetch(fetch).first {
            UserDefaults.standard.set(email, forKey: userDefaultsKey) // Salva email como sessão
            return usuario
        } else {
            return nil
        }
    }

    func usuarioAtual() -> Usuario? {
        guard let email = UserDefaults.standard.string(forKey: userDefaultsKey) else {
            return nil
        }

        let fetch = NSFetchRequest<Usuario>(entityName: "Usuario")
        fetch.predicate = NSPredicate(format: "email == %@", email)

        return try? context.fetch(fetch).first
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}


import Foundation
import CoreData
import SwiftUI

class FavoritosViewModel: ObservableObject {
    @Published var favoritos: [Favorito] = []

    private let context = PersistenceController.shared.container.viewContext

    func carregarFavoritos() {
        guard let usuario = AuthManager.shared.usuarioAtual() else {
            favoritos = []
            return
        }

        let fetch = NSFetchRequest<Favorito>(entityName: "Favorito")
        fetch.predicate = NSPredicate(format: "usuario == %@", usuario)

        do {
            favoritos = try context.fetch(fetch)
        } catch {
            print("Erro ao buscar favoritos: \(error.localizedDescription)")
            favoritos = []
        }
    }
}

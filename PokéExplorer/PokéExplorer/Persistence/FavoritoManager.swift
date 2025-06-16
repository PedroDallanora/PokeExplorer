import CoreData
import Foundation

@MainActor
class FavoritoManager {
    static let shared = FavoritoManager()
    private let context = PersistenceController.shared.container.viewContext

    func adicionar(pokemon: pokemonModel, para usuario: Usuario) {
        let fetch = NSFetchRequest<Favorito>(entityName: "Favorito")
        fetch.predicate = NSPredicate(format: "nome == %@ AND usuario == %@", pokemon.name, usuario)

        do {
            let existentes = try context.fetch(fetch)
            guard existentes.isEmpty else {
                print("Já existe esse favorito.")
                return
            }

            let favorito = Favorito(context: context)
            favorito.id = UUID()
            favorito.nome = pokemon.name
            favorito.spriteURL = pokemon.sprites.front_default ?? ""
            favorito.usuario = usuario

            try context.save()
            print("Favorito '\(pokemon.name)' salvo com sucesso.")
        } catch {
            print("Erro ao adicionar favorito: \(error.localizedDescription)")
        }
    }

    func remover(pokemon: String, do usuario: Usuario) {
        let fetch = NSFetchRequest<Favorito>(entityName: "Favorito")
        fetch.predicate = NSPredicate(format: "nome == %@ AND usuario == %@", pokemon, usuario)

        do {
            let favoritos = try context.fetch(fetch)
            for favorito in favoritos {
                context.delete(favorito)
            }

            try context.save()
            print("Favorito '\(pokemon)' removido do banco com sucesso.")
        } catch {
            print("Erro ao remover favorito: \(error.localizedDescription)")
        }
    }

    func buscarFavoritos(de usuario: Usuario) -> [Favorito] {
        let fetch = NSFetchRequest<Favorito>(entityName: "Favorito")
        fetch.predicate = NSPredicate(format: "usuario == %@", usuario)

        do {
            return try context.fetch(fetch)
        } catch {
            print("Erro ao buscar favoritos: \(error.localizedDescription)")
            return []
        }
    }
}

import SwiftUI

@main
struct PokeExplorerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

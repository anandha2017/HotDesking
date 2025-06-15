import SwiftUI

@main
struct HotDeskingApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
        }
    }
}

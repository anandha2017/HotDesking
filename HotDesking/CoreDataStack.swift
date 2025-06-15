import Foundation
import CoreData

enum PersistenceError: Error {
    case initializationFailed(Error)
}

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "HotDesking")

        // Configure the persistent store description
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No persistent store description")
        }

        // Enable CloudKit features
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        // Load the persistent stores
        var loadError: Error?
        container.loadPersistentStores { _, error in
            if let error = error {
                loadError = error
                print("Core Data error: \(error)")
            }
        }

        if let error = loadError {
            // For development, we'll create an in-memory store if the persistent store fails
            print("Failed to load persistent store, creating in-memory store: \(error)")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]

            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to create in-memory store: \(error)")
                }
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func save() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}

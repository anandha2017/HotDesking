import Foundation
import Combine
import CoreData

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, Error>
    func register(email: String, password: String, name: String?) -> AnyPublisher<User, Error>
    func currentUser() -> User?
}

class AuthService: AuthServiceProtocol {
    private let context: NSManagedObjectContext
    private let keychainKey = "auth_password"
    private var user: User?

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        Future { promise in
            do {
                try KeychainService.save(key: self.keychainKey, data: Data(password.utf8))
                let request: NSFetchRequest<User> = User.fetchRequest()
                request.predicate = NSPredicate(format: "email == %@", email)
                if let found = try self.context.fetch(request).first {
                    self.user = found
                    promise(.success(found))
                } else {
                    promise(.failure(NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func register(email: String, password: String, name: String?) -> AnyPublisher<User, Error> {
        Future { promise in
            do {
                try KeychainService.save(key: self.keychainKey, data: Data(password.utf8))
                let user = User.create(email: email, name: name, role: "user", context: self.context)
                CoreDataStack.shared.save()
                self.user = user
                promise(.success(user))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func currentUser() -> User? { user }
}

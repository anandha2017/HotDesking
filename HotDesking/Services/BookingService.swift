import Foundation
import Combine
import CoreData

class BookingService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func book(desk: Desk, user: User, start: Date, end: Date) -> AnyPublisher<Booking, Error> {
        Future { promise in
            do {
                let booking = Booking.create(start: start, end: end, user: user, desk: desk, context: self.context)
                CoreDataStack.shared.save()
                promise(.success(booking))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func cancel(booking: Booking) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                self.context.delete(booking)
                CoreDataStack.shared.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func bookings(for user: User) -> AnyPublisher<[Booking], Error> {
        Future { promise in
            do {
                let request: NSFetchRequest<Booking> = Booking.fetchRequest()
                request.predicate = NSPredicate(format: "user == %@", user)
                let results = try self.context.fetch(request)
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

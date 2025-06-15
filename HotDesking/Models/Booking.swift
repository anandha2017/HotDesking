import Foundation
import CoreData

@objc(Booking)
public class Booking: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Booking> {
        return NSFetchRequest<Booking>(entityName: "Booking")
    }

    @NSManaged public var startTime: Date
    @NSManaged public var endTime: Date
    @NSManaged public var user: User
    @NSManaged public var desk: Desk
}

extension Booking {
    static func create(start: Date, end: Date, user: User, desk: Desk, context: NSManagedObjectContext) -> Booking {
        let booking = Booking(context: context)
        booking.startTime = start
        booking.endTime = end
        booking.user = user
        booking.desk = desk
        return booking
    }
}

import Foundation
import CoreData

@objc(Desk)
public class Desk: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Desk> {
        return NSFetchRequest<Desk>(entityName: "Desk")
    }

    @NSManaged public var identifier: String
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var amenities: String?
    @NSManaged public var status: String
    @NSManaged public var floor: Floor
    @NSManaged public var bookings: Set<Booking>?
}

extension Desk {
    static func create(identifier: String, x: Double, y: Double, amenities: String?, status: String, floor: Floor, context: NSManagedObjectContext) -> Desk {
        let desk = Desk(context: context)
        desk.identifier = identifier
        desk.x = x
        desk.y = y
        desk.amenities = amenities
        desk.status = status
        desk.floor = floor
        return desk
    }
}

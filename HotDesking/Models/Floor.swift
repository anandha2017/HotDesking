import Foundation
import CoreData

@objc(Floor)
public class Floor: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Floor> {
        return NSFetchRequest<Floor>(entityName: "Floor")
    }

    @NSManaged public var number: Int16
    @NSManaged public var layoutImage: Data?
    @NSManaged public var office: Office
    @NSManaged public var desks: Set<Desk>?
}

extension Floor {
    static func create(number: Int16, office: Office, layoutImage: Data?, context: NSManagedObjectContext) -> Floor {
        let floor = Floor(context: context)
        floor.number = number
        floor.office = office
        floor.layoutImage = layoutImage
        return floor
    }
}

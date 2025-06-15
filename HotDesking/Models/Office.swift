import Foundation
import CoreData
import CoreLocation

@objc(Office)
public class Office: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Office> {
        return NSFetchRequest<Office>(entityName: "Office")
    }

    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var floors: Set<Floor>?
}

extension Office {
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    static func create(name: String, latitude: Double, longitude: Double, context: NSManagedObjectContext) -> Office {
        let office = Office(context: context)
        office.name = name
        office.latitude = latitude
        office.longitude = longitude
        return office
    }
}

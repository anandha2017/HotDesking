import Foundation
import CoreData

class DataSeedingService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func seedDataIfNeeded() {
        // Check if data already exists
        let officeRequest: NSFetchRequest<Office> = Office.fetchRequest()

        do {
            let existingOffices = try context.fetch(officeRequest)
            if !existingOffices.isEmpty {
                return // Data already exists
            }

            // Create OSB offices
            let bangaloreOffice = Office.create(name: "OSB India Bangalore", latitude: 12.9716, longitude: 77.5946, context: context)
            let hyderabadOffice = Office.create(name: "OSB India Hyderabad", latitude: 17.3850, longitude: 78.4867, context: context)
            let chathamObservatoryOffice = Office.create(name: "OSB UK Chatham Observatory", latitude: 51.3789, longitude: 0.5208, context: context)
            let chathamOSBHouseOffice = Office.create(name: "OSB UK Chatham OSB House", latitude: 51.3789, longitude: 0.5208, context: context)
            let wolverhamptonOffice = Office.create(name: "OSB UK Wolverhampton Charter Court", latitude: 52.5833, longitude: -2.1333, context: context)

            // Create floors for Bangalore Office (8th, 9th, 10th)
            let bangaloreFloor8 = Floor.create(number: 8, office: bangaloreOffice, layoutImage: nil, context: context)
            let bangaloreFloor9 = Floor.create(number: 9, office: bangaloreOffice, layoutImage: nil, context: context)
            let bangaloreFloor10 = Floor.create(number: 10, office: bangaloreOffice, layoutImage: nil, context: context)

            // Create floors for Hyderabad Office (Ground, 2nd, 3rd)
            let hyderabadFloorG = Floor.create(number: 1, office: hyderabadOffice, layoutImage: nil, context: context)
            let hyderabadFloor2 = Floor.create(number: 2, office: hyderabadOffice, layoutImage: nil, context: context)
            let hyderabadFloor3 = Floor.create(number: 3, office: hyderabadOffice, layoutImage: nil, context: context)

            // Create floors for Chatham Observatory (Ground, 2nd, 3rd)
            let chathamObsFloorG = Floor.create(number: 1, office: chathamObservatoryOffice, layoutImage: nil, context: context)
            let chathamObsFloor2 = Floor.create(number: 2, office: chathamObservatoryOffice, layoutImage: nil, context: context)
            let chathamObsFloor3 = Floor.create(number: 3, office: chathamObservatoryOffice, layoutImage: nil, context: context)

            // Create floors for Chatham OSB House (Ground, 2nd, 3rd)
            let chathamOSBFloorG = Floor.create(number: 1, office: chathamOSBHouseOffice, layoutImage: nil, context: context)
            let chathamOSBFloor2 = Floor.create(number: 2, office: chathamOSBHouseOffice, layoutImage: nil, context: context)
            let chathamOSBFloor3 = Floor.create(number: 3, office: chathamOSBHouseOffice, layoutImage: nil, context: context)

            // Create floors for Wolverhampton (Ground, 2nd, 3rd)
            let wolverhamptonFloorG = Floor.create(number: 1, office: wolverhamptonOffice, layoutImage: nil, context: context)
            let wolverhamptonFloor2 = Floor.create(number: 2, office: wolverhamptonOffice, layoutImage: nil, context: context)
            let wolverhamptonFloor3 = Floor.create(number: 3, office: wolverhamptonOffice, layoutImage: nil, context: context)

            // Create desks for Bangalore 8th Floor
            for i in 1...15 {
                let amenities = i % 3 == 0 ? "Monitor, Keyboard, Phone" : (i % 2 == 0 ? "Monitor, Keyboard" : "Monitor")
                _ = Desk.create(
                    identifier: "BLR8-\(String(format: "%02d", i))",
                    x: Double(i * 40),
                    y: 100,
                    amenities: amenities,
                    status: "available",
                    floor: bangaloreFloor8,
                    context: context
                )
            }

            // Create desks for Bangalore 9th Floor
            for i in 1...18 {
                let amenities = i % 4 == 0 ? "Monitor, Keyboard, Phone, Webcam" : (i % 2 == 0 ? "Monitor, Keyboard" : "Monitor")
                _ = Desk.create(
                    identifier: "BLR9-\(String(format: "%02d", i))",
                    x: Double(i * 35),
                    y: 120,
                    amenities: amenities,
                    status: "available",
                    floor: bangaloreFloor9,
                    context: context
                )
            }

            // Create desks for Bangalore 10th Floor
            for i in 1...12 {
                let amenities = i % 3 == 0 ? "Monitor, Keyboard, Phone" : "Monitor"
                _ = Desk.create(
                    identifier: "BLR10-\(String(format: "%02d", i))",
                    x: Double(i * 45),
                    y: 140,
                    amenities: amenities,
                    status: "available",
                    floor: bangaloreFloor10,
                    context: context
                )
            }

            // Create desks for Hyderabad Ground Floor
            for i in 1...20 {
                let amenities = i % 3 == 0 ? "Monitor, Keyboard" : (i % 2 == 0 ? "Monitor" : nil)
                _ = Desk.create(
                    identifier: "HYD1-\(String(format: "%02d", i))",
                    x: Double(i * 30),
                    y: 80,
                    amenities: amenities,
                    status: "available",
                    floor: hyderabadFloorG,
                    context: context
                )
            }

            // Create desks for Hyderabad 2nd Floor
            for i in 1...16 {
                let amenities = i % 2 == 0 ? "Monitor, Keyboard, Phone" : "Monitor"
                _ = Desk.create(
                    identifier: "HYD2-\(String(format: "%02d", i))",
                    x: Double(i * 38),
                    y: 110,
                    amenities: amenities,
                    status: "available",
                    floor: hyderabadFloor2,
                    context: context
                )
            }

            // Create desks for Hyderabad 3rd Floor
            for i in 1...14 {
                let amenities = i % 3 == 0 ? "Monitor, Keyboard, Phone, Webcam" : "Monitor, Keyboard"
                _ = Desk.create(
                    identifier: "HYD3-\(String(format: "%02d", i))",
                    x: Double(i * 42),
                    y: 130,
                    amenities: amenities,
                    status: "available",
                    floor: hyderabadFloor3,
                    context: context
                )
            }

            // Create desks for UK offices (smaller desk counts per floor)
            let ukFloors = [
                (chathamObsFloorG, "CHO1"), (chathamObsFloor2, "CHO2"), (chathamObsFloor3, "CHO3"),
                (chathamOSBFloorG, "CHH1"), (chathamOSBFloor2, "CHH2"), (chathamOSBFloor3, "CHH3"),
                (wolverhamptonFloorG, "WOL1"), (wolverhamptonFloor2, "WOL2"), (wolverhamptonFloor3, "WOL3")
            ]

            for (floor, prefix) in ukFloors {
                for i in 1...10 {
                    let amenities = i % 3 == 0 ? "Monitor, Keyboard, Phone" : (i % 2 == 0 ? "Monitor, Keyboard" : "Monitor")
                    _ = Desk.create(
                        identifier: "\(prefix)-\(String(format: "%02d", i))",
                        x: Double(i * 50),
                        y: 100,
                        amenities: amenities,
                        status: "available",
                        floor: floor,
                        context: context
                    )
                }
            }

            CoreDataStack.shared.save()
            print("Sample data seeded successfully")

        } catch {
            print("Failed to seed data: \(error)")
        }
    }
}

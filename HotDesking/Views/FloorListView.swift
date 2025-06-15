import SwiftUI
import CoreData

struct FloorListView: View {
    let office: Office
    @FetchRequest var floors: FetchedResults<Floor>
    @EnvironmentObject var loginViewModel: LoginViewModel

    init(office: Office) {
        self.office = office
        _floors = FetchRequest(entity: Floor.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Floor.number, ascending: true)], predicate: NSPredicate(format: "office == %@", office))
    }

    var body: some View {
        List(floors, id: \.self) { floor in
                NavigationLink(destination: DeskListView(floor: floor).environmentObject(loginViewModel)) {
                Text("Floor \(floor.number)")
            }
        }
        .navigationTitle(office.name)
    }
}

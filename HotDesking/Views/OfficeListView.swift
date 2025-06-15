import SwiftUI
import CoreData

struct OfficeListView: View {
    @FetchRequest(entity: Office.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Office.name, ascending: true)])
    private var offices: FetchedResults<Office>
    @State private var selection: Office?

    var body: some View {
        NavigationStack {
            List(offices, id: \.self) { office in
                NavigationLink(destination: FloorListView(office: office)) {
                    Text(office.name)
                }
            }
            .navigationTitle("Offices")
        }
    }
}

import SwiftUI
import CoreData

struct OfficeListView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @FetchRequest(entity: Office.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Office.name, ascending: true)])
    private var offices: FetchedResults<Office>
    @State private var selection: Office?

    var body: some View {
        NavigationStack {
            List(offices, id: \.self) { office in
                NavigationLink(destination: FloorListView(office: office)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(office.name)
                            .font(.headline)
                        Text("Lat: \(office.latitude, specifier: "%.4f"), Lng: \(office.longitude, specifier: "%.4f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
            .navigationTitle("Select Office")
        }
    }
}

#Preview {
    OfficeListView()
        .environmentObject(LoginViewModel())
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}

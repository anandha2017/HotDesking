import SwiftUI
import CoreData

struct DeskListView: View {
    let floor: Floor
    @FetchRequest var desks: FetchedResults<Desk>
    @StateObject private var vm: DeskBookingViewModel

    init(floor: Floor) {
        self.floor = floor
        _desks = FetchRequest(entity: Desk.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Desk.identifier, ascending: true)], predicate: NSPredicate(format: "floor == %@", floor))
        _vm = StateObject(wrappedValue: DeskBookingViewModel(floor: floor))
    }

    var body: some View {
        List(desks, id: \.self) { desk in
            HStack {
                VStack(alignment: .leading) {
                    Text(desk.identifier)
                    Text(desk.amenities ?? "").font(.caption)
                }
                Spacer()
                Text(desk.status)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                vm.book(desk: desk)
            }
        }
        .navigationTitle("Floor \(floor.number)")
        .alert("Error", isPresented: Binding(get: { vm.error != nil }, set: { _ in vm.error = nil })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.error ?? "")
        }
    }
}

import SwiftUI
import CoreData

struct DeskListView: View {
    let floor: Floor
    @FetchRequest var desks: FetchedResults<Desk>
    @StateObject private var vm: DeskBookingViewModel
    @State private var showingBookingConfirmation = false
    @State private var selectedDesk: Desk?
    @EnvironmentObject var loginViewModel: LoginViewModel

    init(floor: Floor) {
        self.floor = floor
        _desks = FetchRequest(entity: Desk.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Desk.identifier, ascending: true)], predicate: NSPredicate(format: "floor == %@", floor))
        _vm = StateObject(wrappedValue: DeskBookingViewModel(floor: floor))
    }

    var body: some View {
        List(desks, id: \.self) { desk in
            DeskRowView(desk: desk) {
                selectedDesk = desk
                showingBookingConfirmation = true
            }
        }
        .navigationTitle("Floor \(floor.number)")
        .alert("Book Desk", isPresented: $showingBookingConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Book for 1 hour") {
                if let desk = selectedDesk, let user = loginViewModel.user {
                    vm.book(desk: desk, user: user)
                }
            }
        } message: {
            if let desk = selectedDesk {
                Text("Book desk \(desk.identifier) for 1 hour?")
            }
        }
        .alert("Error", isPresented: Binding(get: { vm.error != nil }, set: { _ in vm.error = nil })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.error ?? "")
        }
    }
}

struct DeskRowView: View {
    let desk: Desk
    let onTap: () -> Void

    var statusColor: Color {
        switch desk.status.lowercased() {
        case "available":
            return .green
        case "occupied":
            return .red
        case "reserved":
            return .orange
        default:
            return .gray
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(desk.identifier)
                    .font(.headline)

                if let amenities = desk.amenities, !amenities.isEmpty {
                    Text(amenities)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text("Position: (\(Int(desk.x)), \(Int(desk.y)))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)

                Text(desk.status.capitalized)
                    .font(.caption)
                    .foregroundColor(statusColor)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            if desk.status.lowercased() == "available" {
                onTap()
            }
        }
        .opacity(desk.status.lowercased() == "available" ? 1.0 : 0.6)
    }
}

#Preview {
    NavigationStack {
        DeskListView(floor: Floor())
    }
    .environment(\.managedObjectContext, CoreDataStack.shared.context)
}

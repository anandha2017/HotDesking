import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        TabView {
            OfficeListView()
                .environmentObject(loginViewModel)
                .tabItem {
                    Image(systemName: "building.2")
                    Text("Offices")
                }

            if let user = loginViewModel.user {
                BookingsListView(user: user)
                    .environmentObject(loginViewModel)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("My Bookings")
                    }
            }

            ProfileView()
                .environmentObject(loginViewModel)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let user = loginViewModel.user {
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)

                        VStack(spacing: 8) {
                            if let name = user.name, !name.isEmpty {
                                Text(name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if let role = user.role {
                                Text(role.capitalized)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.top, 40)

                    Spacer()

                    Button(action: {
                        loginViewModel.user = nil
                        loginViewModel.email = ""
                        loginViewModel.password = ""
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct BookingsListView: View {
    let user: User
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var bookingViewModel: BookingViewModel

    init(user: User) {
        self.user = user
        _bookingViewModel = StateObject(wrappedValue: BookingViewModel(user: user, bookingService: BookingService()))
    }

    var body: some View {
        NavigationStack {
            Group {
                if bookingViewModel.isLoading {
                    ProgressView("Loading bookings...")
                } else if bookingViewModel.bookings.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No bookings found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Book a desk to see your reservations here")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(bookingViewModel.bookings, id: \.self) { booking in
                            BookingRowView(booking: booking) {
                                bookingViewModel.cancel(booking: booking)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Bookings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        bookingViewModel.fetchBookings()
                    }
                }
            }
            .alert("Error", isPresented: Binding(get: { bookingViewModel.error != nil }, set: { _ in bookingViewModel.error = nil })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(bookingViewModel.error ?? "")
            }
        }
        .onAppear {
            bookingViewModel.fetchBookings()
        }
    }
}

struct BookingRowView: View {
    let booking: Booking
    let onCancel: () -> Void

    private var isUpcoming: Bool {
        booking.startTime > Date()
    }

    private var isActive: Bool {
        let now = Date()
        return booking.startTime <= now && booking.endTime > now
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.desk.identifier)
                        .font(.headline)

                    Text("Floor \(booking.desk.floor.number) - \(booking.desk.floor.office.name)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    if isActive {
                        Text("ACTIVE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                    } else if isUpcoming {
                        Text("UPCOMING")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .cornerRadius(4)
                    } else {
                        Text("PAST")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.gray)
                            .cornerRadius(4)
                    }
                }
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Start: \(booking.startTime, formatter: dateFormatter)")
                        .font(.caption)
                    Text("End: \(booking.endTime, formatter: dateFormatter)")
                        .font(.caption)
                }

                Spacer()

                if isUpcoming {
                    Button("Cancel") {
                        onCancel()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    MainTabView()
        .environmentObject(LoginViewModel())
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}

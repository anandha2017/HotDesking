import Foundation
import Combine

class BookingViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var isLoading: Bool = false
    @Published var error: String?

    private let bookingService: BookingService
    private let user: User
    private var cancellables = Set<AnyCancellable>()

    init(user: User, bookingService: BookingService = BookingService()) {
        self.user = user
        self.bookingService = bookingService
        fetchBookings()
    }

    func fetchBookings() {
        isLoading = true
        bookingService.bookings(for: user)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err.localizedDescription
                }
            } receiveValue: { bookings in
                self.bookings = bookings
            }
            .store(in: &cancellables)
    }

    func cancel(booking: Booking) {
        isLoading = true
        bookingService.cancel(booking: booking)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err.localizedDescription
                } else {
                    self.fetchBookings()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

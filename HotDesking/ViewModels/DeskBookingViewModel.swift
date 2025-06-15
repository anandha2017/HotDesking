import Foundation
import Combine

class DeskBookingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: String?
    private let bookingService: BookingService
    private let floor: Floor
    private var cancellables = Set<AnyCancellable>()

    init(floor: Floor, bookingService: BookingService = BookingService()) {
        self.floor = floor
        self.bookingService = bookingService
    }

    func book(desk: Desk) {
        guard let user = AuthService().currentUser() else {
            error = "No user"
            return
        }
        let start = Date()
        let end = Calendar.current.date(byAdding: .hour, value: 1, to: start) ?? start.addingTimeInterval(3600)
        isLoading = true
        bookingService.book(desk: desk, user: user, start: start, end: end)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err.localizedDescription
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

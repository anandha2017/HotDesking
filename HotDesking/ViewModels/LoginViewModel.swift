import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var user: User?

    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func login() {
        isLoading = true
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err.localizedDescription
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }

    func register(name: String?) {
        isLoading = true
        authService.register(email: email, password: password, name: name)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err.localizedDescription
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
}

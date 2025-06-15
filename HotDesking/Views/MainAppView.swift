import SwiftUI

struct MainAppView: View {
    @StateObject private var loginViewModel = LoginViewModel()

    var body: some View {
        Group {
            if loginViewModel.user != nil {
                MainTabView()
                    .environmentObject(loginViewModel)
            } else {
                LoginView()
                    .environmentObject(loginViewModel)
            }
        }
        .onAppear {
            // Seed sample data
            DataSeedingService().seedDataIfNeeded()

            // Check if user is already logged in
            if let currentUser = AuthService().currentUser() {
                loginViewModel.user = currentUser
            }
        }
    }
}

#Preview {
    MainAppView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}

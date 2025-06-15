import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var name: String = ""
    @State private var isRegister: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            if isRegister {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            if viewModel.isLoading {
                ProgressView()
            }
            if let error = viewModel.error {
                Text(error).foregroundColor(.red)
            }
            Button(isRegister ? "Register" : "Login") {
                isRegister ? viewModel.register(name: name) : viewModel.login()
            }
            Button(isRegister ? "Have an account?" : "Create account") {
                withAnimation { isRegister.toggle() }
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

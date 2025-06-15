import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State private var name: String = ""
    @State private var isRegister: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Hot Desking")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

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
                        .padding()
                }

                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }

                Button(action: {
                    isRegister ? viewModel.register(name: name) : viewModel.login()
                }) {
                    Text(isRegister ? "Register" : "Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)

                Button(isRegister ? "Have an account? Login" : "Create account") {
                    withAnimation {
                        isRegister.toggle()
                        viewModel.error = nil
                    }
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}

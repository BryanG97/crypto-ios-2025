import SwiftUI

struct SettingsView: View {
    
    @State var viewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        if let user = viewModel.user {
            userView(user: user)
        }else{
            loginForm()
                .alert(
                    viewModel.errorMessage,
                    isPresented: $viewModel.showError) {
                        Button("OK") {}
                    }
        }
        
    }
    
    @ViewBuilder
    func userView(user: User) -> some View {
        VStack {
            Text(user.id)
                .font(.headline)
            Text(user.email)
                .font(.subheadline)
            
            Button {
                viewModel.logout()
            } label: {
                Text("Logout")
            }
        }
    }
    
    @ViewBuilder
    func loginForm() -> some View {
        VStack {
            TextField("email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
            SecureField("pssword", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            
            Button {
                
                Task {
                    await viewModel.login()
                }
                
            } label: {
                Text("Login")
            }
            .padding(.vertical)
            
            Spacer()
        }
        .padding()
        
    }
    
}

#Preview{
    SettingsView()
}


import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var nav: NavigationCoordinator
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var vm = ProfileViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.35),
                    Color.black.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Profile")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 45)

                if vm.isLoading {
                    ProgressView()
                        .tint(.white)
                } else if let err = vm.errorMessage {
                    Text(err)
                        .foregroundColor(.red.opacity(0.85))
                } else if let user = vm.user {
                    UserComponent(user: user)

                    Divider().overlay(Color.white.opacity(0.15))

                    Button {
                        APIClient.shared.logout()
                        authVM.loggedIn = false
                        authVM.authToken = ""
                        authVM.userId = 0
                        nav.reset(to: .welcome)
                    } label: {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.85))
                            .cornerRadius(14)
                    }
                    .padding(.top, 8)
                } else {
                    Text("No profile loaded")
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }
            .padding(.horizontal, 25)
        }
        .navigationBarBackButtonHidden()
        .task { await vm.loadMe() }
    }
}



import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadMe() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: APIResponse<User> = try await APIClient.shared.get("/user")
            guard response.success, let data = response.data else {
                errorMessage = response.message
                user = nil
                return
            }
            user = data
        } catch {
            errorMessage = error.localizedDescription
            user = nil
        }
    }
}



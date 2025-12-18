//
//  MessageViewModel.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/15/25.
//

import Foundation


final class MessageViewModel: ObservableObject {
    
    @Published private(set) var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
    }
    
    // Return messages
    func getMessages() -> [Message] {
        messages
    }

    @MainActor
    func append(_ message: Message) {
        // avoid duplicates if server echoes back the same message id
        if let id = message.id, messages.contains(where: { $0.id == id }) {
            return
        }
        messages.append(message)
    }

    @MainActor
    func loadConversation(meId: Int, otherUserId: Int) async {
        guard meId > 0, otherUserId > 0 else {
            errorMessage = "Invalid user ids"
            messages = []
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: APIResponse<[Message]> =
                try await APIClient.shared.get("/messages/all/\(meId)/\(otherUserId)")
            guard response.success, let data = response.data else {
                errorMessage = response.message
                messages = []
                return
            }
            messages = data
        } catch {
            errorMessage = error.localizedDescription
            messages = []
        }
    }
}

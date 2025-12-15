//
//  MessageViewModel.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/15/25.
//

import Foundation
import SwiftUI


final class MessageViewModel: ObservableObject {
    
    @Published private(set) var messages: [Message] = []
    
    init() {
        loadMockMessages()
    }
    
    // Add new message
    func sendMessage(_ text: String, isMe: Bool = true) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let time = formattedTime()
        let message = Message(text: text, isMe: isMe, time: time)
        
        messages.append(message)
    }
    
    // Return messages
    func getMessages() -> [Message] {
        messages
    }
    
    // Mock data
    private func loadMockMessages() {
        messages = [
            Message(text: "Hey 👋", isMe: false, time: "09:41"),
            Message(text: "Hi! How are you?", isMe: true, time: "09:42"),
            Message(text: "I'm building Vynqtalk 😄", isMe: false, time: "09:43"),
            Message(text: "Nice, looks clean.", isMe: true, time: "09:44")
        ]
    }
    
    // Time formatter
    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

//
//  ChatScreen.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/10/25.
//

import SwiftUI


struct ChatScreen: View {
    
    // Mock messages (WhatsApp-like)
    let messages: [Message] = [
        Message(text: "Hey 👋", isMe: false, time: "09:41"),
        Message(text: "Hi! How are you?", isMe: true, time: "09:42"),
        Message(text: "I'm good, working on the app 😄", isMe: false, time: "09:43"),
        Message(text: "Nice, SwiftUI or React?", isMe: true, time: "09:44"),
        Message(text: "SwiftUI 🔥", isMe: false, time: "09:45"),
        Message(text: "Clean choice.", isMe: true, time: "09:46")
    ]
    
    var body: some View {
        ZStack {
            // Background
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
            
            VStack(spacing: 0) {
                
                // Header (WhatsApp-style)
                HStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white.opacity(0.9))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Alex")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Text("online")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.black.opacity(0.4))
                
                // Messages
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                }
                
                // Input bar (UI only)
                HStack(spacing: 12) {
                    TextField("Message", text: .constant(""))
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.blue.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding()
                .background(Color.black.opacity(0.5))
            }
        }
        .navigationBarBackButtonHidden()
    }
}

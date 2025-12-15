//
//  MessageBubble.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/15/25.
//
import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        message.isMe
                        ? Color.blue.opacity(0.85)
                        : Color.white.opacity(0.12)
                    )
                    .cornerRadius(14)
                
                Text(message.time)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal, 6)
            }
            .frame(maxWidth: 260, alignment: message.isMe ? .trailing : .leading)
            
            if !message.isMe {
                Spacer()
            }
        }
    }
}

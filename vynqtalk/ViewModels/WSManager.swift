//
//  WSManager.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/15/25.
//
//


import SwiftStomp
import SwiftUI

class WebSocketManager: ObservableObject, SwiftStompDelegate {

    private var swiftStomp: SwiftStomp!
    @Published var messages: [String] = []
    @Published var incomingMessage: Message?
    @Published var isConnected: Bool = false
    @Published var lastError: String?

    // Connect to the STOMP WebSocket
    func connect(token: String) {
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            lastError = "Missing token"
            return
        }

        guard let url = URL(string: "ws://10.12.73.3:8080/api/v2/ws?token=\(trimmed)") else {
            lastError = "Invalid WebSocket URL"
            print(lastError!)
            return
        }

        // Initialize SwiftStomp
        swiftStomp = SwiftStomp(host: url)
        swiftStomp.delegate = self

        // Attempt connection with headers
        do {
            swiftStomp.connect()
        } catch {
            lastError = "Failed to connect: \(error.localizedDescription)"
            print(lastError!)
        }
    }

    // Subscribe to topics
    func subscribeToMetrics() {
        guard isConnected else { return }
        swiftStomp.subscribe(to: "/topic/metrics")
    }

    func subscribeToOnlineUsers() {
        guard isConnected else { return }
        swiftStomp.subscribe(to: "/topic/onlineUsers")
    }

    func subscribeToPrivateMessages() {
        guard isConnected else { return }
        swiftStomp.subscribe(to: "/topic/messages")
    }

    // Send message
    func send(message: String) {
        guard isConnected else {
            print("Cannot send, not connected")
            return
        }
        swiftStomp.send(body: message, to: "/app/send")
    }

    func sendChatMessage(senderId: Int, receiverId: Int, content: String) {
        guard isConnected else {
            print("Cannot send, not connected")
            return
        }
        guard senderId > 0, receiverId > 0 else { return }
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let payload = ChatMessagePayload(
            senderId: senderId,
            receiverId: receiverId,
            content: trimmed,
            type: .text,
            fileName: nil
        )

        do {
            // send JSON payload to @MessageMapping("/chat.sendMessage") => /app/chat.sendMessage
            let bodyData = try JSONEncoder().encode(payload)
            let body = String(data: bodyData, encoding: .utf8) ?? ""
            swiftStomp.send(body: body, to: "/app/chat.sendMessage")
        } catch {
            print("Failed to encode chat payload:", error)
        }
    }

    // Disconnect
    func disconnect() {
        swiftStomp.disconnect()
    }

    // MARK: - SwiftStompDelegate

    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Connected to STOMP server")
        isConnected = true
        subscribeToMetrics()
        subscribeToOnlineUsers()
        subscribeToPrivateMessages()
    }

    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("Disconnected from STOMP server")
        isConnected = false
    }

    func onMessageReceived(swiftStomp: SwiftStomp,
                           message: Any?,
                           messageId: String,
                           destination: String,
                           headers: [String : String]) {
        if let msgString = message as? String {
            DispatchQueue.main.async {
                self.messages.append(msgString)

                // decode private chat messages
                if destination == "/topic/messages" {
                    do {
                        let data = Data(msgString.utf8)
                        let decoded = try APIClient.jsonDecoder.decode(WsResponse<Message>.self, from: data)
                        if decoded.success, let m = decoded.data {
                            self.incomingMessage = m
                        }
                    } catch {
                        // keep raw string in messages[] for debugging
                        print("WS decode error:", error)
                    }
                }
            }
        }
    }

    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("Receipt received: \(receiptId)")
    }

    func onError(swiftStomp: SwiftStomp,
                 briefDescription: String,
                 fullDescription: String?,
                 receiptId: String?,
                 type: StompErrorType) {
        lastError = briefDescription
        print("STOMP error: \(briefDescription)")
        if let full = fullDescription { print("Full: \(full)") }
    }

    func onPing() {
        print("Ping received from STOMP server")
    }
}

//
//  Message.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/15/25.
//
import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
    let time: String
}

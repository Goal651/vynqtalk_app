//
//  BackButton.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/10/25.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                Text("Back")
                    .font(.body)
            }
        }
        .foregroundColor(.white)
        .padding(.leading)
    }
}

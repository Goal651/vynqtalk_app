//
//  Modal.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/10/25.
//
import SwiftUI

struct ModalView: View {
    var title: String
    var description: String
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            // Blur layer only
            Color.clear
                .background(.black.opacity(0.4))
                .ignoresSafeArea()
                .onTapGesture {
                    onClose() // dismiss when tapping outside
                }

            // Centered modal card
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    onClose()
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.4), radius: 10, y: 4)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.85)) // modal card only
                    .shadow(color: .black.opacity(0.5), radius: 20, y: 10)
            )
            .padding(.horizontal, 40)
        }
    }
}

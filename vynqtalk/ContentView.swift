//
//  ContentView.swift
//  vynqtalk
//
//  Created by wigothehacker on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userVM:UserViewModel
    
    var body: some View {
        NavigationStack{
            WelcomeScreen()
        }
    }
}

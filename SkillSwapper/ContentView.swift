//
//  ContentView.swift
//  SkillSwapper
//
//  Created by Huy Ong on 8/8/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var user: User?
    
    init() {
        if let user = Auth.auth().currentUser {
            _user = State(wrappedValue: user)
        }
    }
  
    var body: some View {
        if user == nil {
            AuthenticationView(user: $user)
        } else {
           ProfileView(user: $user)
        }
    }
    
}


#Preview {
    ContentView()
}

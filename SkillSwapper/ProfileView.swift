//
//  ProfileView.swift
//  SkillSwapper
//
//  Created by Huy Ong on 8/8/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var username: String = ""
    @State private var userbio: String = ""
    @State private var location: String = ""
    @State private var website: String = ""
    @State private var dob: Date = .init()
    
    @Binding var user: User?
    
    private let fixWidth: CGFloat = 100
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("Name")
                            .bold()
                            .frame(width: fixWidth, alignment: .leading)
                        TextField("", text: $username)
                            .foregroundStyle(.blue)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top) {
                        Text("Bio")
                            .bold()
                            .frame(width: fixWidth, alignment: .leading)
                        TextField("", text: $userbio)
                            .foregroundStyle(.blue)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Location")
                            .bold()
                            .frame(width: fixWidth, alignment: .leading)
                        TextField("", text: $location)
                            .foregroundStyle(.blue)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Website")
                            .bold()
                            .frame(width: fixWidth, alignment: .leading)
                        TextField("", text: $website)
                            .foregroundStyle(.blue)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Bird date")
                            .bold()
                            .frame(width: fixWidth, alignment: .leading)
                        DatePicker("", selection: $dob, displayedComponents: .date)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        do {
                            try Auth.auth().signOut()
                            self.user = nil
                        } catch {
                            print("Failed to signout \(error)")
                        }
                    } label: {
                        Text("Sign out")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Profile")
            .padding()
            .background(Color.systemColor(.systemGray6))
            .onAppear(perform: fetchUserProfile)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        let data: [String: String] = [
                            "name": username,
                            "bio": userbio,
                            "location": location,
                            "website": website
                        ]
                        let uid = user!.uid
                        
                        Firestore.firestore()
                            .collection("users")
                            .document(uid)
                            .setData(data) { error in
                            if let error {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchUserProfile() {
        if let userID = user?.uid {
            Firestore.firestore().collection("users").document(userID).getDocument { snapshot, error in
                if let error {
                    print(error.localizedDescription)
                }
                
                guard let snapshot = snapshot, let data = snapshot.data() else { return }
                self.username = data["name"] as? String ?? ""
                self.userbio = data["bio"] as? String ?? ""
                self.location = data["location"] as? String ?? ""
                self.website = data["website"] as? String ?? ""
            }
        }
    }
}

#Preview {
    ProfileView(user: .constant(nil))
}

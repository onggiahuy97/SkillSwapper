//
//  ProfileView.swift
//  SkillSwapper
//
//  Created by Huy Ong on 8/8/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    @State private var username: String = "Huy Ong"
    @State private var userbio: String = "CS @SJSU"
    @State private var location: String = "San Jose, CA"
    @State private var website: String = "huyong.code.dev"
    @State private var dob: Date = .init()
    
    @Binding var user: User?
    
    private let fixWidth: CGFloat = 120
    
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
                    
                    HStack {
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
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        let data: [String: String] = [
                            "name": username,
                            "bio": userbio,
                            "location": location,
                            "website": website
                        ]
                        
                        do {
                            let encodedData = try JSONEncoder().encode(data)
                            let uid = user!.uid
                            Storage.storage().reference(withPath: "users").child(uid).putData(encodedData)
                            
                        } catch {
                            print("Error \(error)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(user: .constant(nil))
}

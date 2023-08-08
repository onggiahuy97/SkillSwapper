//
//  AuthenticationView.swift
//  SkillSwapper
//
//  Created by Huy Ong on 8/8/23.
//

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isNewAccount = false
    @State private var showAlert = false
    @State private var authError: AuthError?
    
    @Binding var user: User?
    
    enum AuthError {
        case emptyUsername, emptyPassword, confirmPasswordWrong
        case apiErrir(Error)
        
        var text: String {
            switch self {
            case .emptyUsername:
                return "Username is empty"
            case .emptyPassword:
                return "Password is empty"
            case .confirmPasswordWrong:
                return "Confirm password is not matched"
            case .apiErrir(let error):
                return error.localizedDescription
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(isNewAccount ? "Register" : "Login") to SwiftSwapper")
                    .bold()
                    .font(.title)
                
                VStack(spacing: 12) {
                    TextField("Username", text: $username)
                    Divider()
                    SecureField("Password", text: $password)
                    if isNewAccount {
                        Divider()
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                }
                .padding()
                .background(Color.systemColor(.white))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Toggle("New Account?", isOn: $isNewAccount)
                    .foregroundStyle(.secondary)
                
                Button {
                    isNewAccount ? performRegister() : performLogin()
                } label: {
                    Text(isNewAccount ? "Register" : "Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

            }
            .padding()
            .font(.headline)
            .animation(.default, value: isNewAccount)
            .textInputAutocapitalization(.never)

        }
        .frame(maxHeight: .infinity)
        .background(Color.bgLinearView)
        .ignoresSafeArea(.all, edges: .all)
        .alert(authError?.text ?? "", isPresented: $showAlert) {
            Button("Ok") {
                
            }
        }
    }
    
    private func performLogin() {
        guard isValid() else { return }
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error {
                handleError(type: .apiErrir(error))
            }
            
            self.user = result?.user
        }
    }
    
    private func performRegister() {
        guard isValid() else { return }
        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if let error {
                handleError(type: .apiErrir(error))
            }
            
            self.user = result?.user
        }
    }
    
    private func isValid() -> Bool {
        guard !username.isEmpty else {
            handleError(type: .emptyUsername)
            return false
        }
        
        guard !password.isEmpty else {
            handleError(type: .emptyPassword)
            return false
        }
        
        if isNewAccount && confirmPassword != password {
            handleError(type: .confirmPasswordWrong)
            return false
        }
        
        return true
    }
    
    private func handleError(type: AuthError) {
        switch type {
        case .confirmPasswordWrong:
            self.authError = AuthError.confirmPasswordWrong
        case .emptyPassword:
            self.authError = AuthError.emptyPassword
        case .emptyUsername:
            self.authError = AuthError.emptyUsername
        case .apiErrir(let error):
            self.authError = AuthError.apiErrir(error)
        }
        
        showAlert = true
    }
}

#Preview {
    AuthenticationView(user: .constant(nil))
}

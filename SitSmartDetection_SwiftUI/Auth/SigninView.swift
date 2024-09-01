//
//  LoginView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/14.
//

import SwiftUI
import FirebaseAuth

struct SigninView: View {
    @Binding var currentShowingView: authState
    @EnvironmentObject var authVM: AuthViewModel
    
    
    @AppStorage("uid") var userID: String = ""
    @State private var email: String = ""  //
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
    
    private func isValidPassword(_ password: String) -> Bool {
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special char
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        VStack(spacing:20) {
            // top background
            ZStack {
                CurvedBottomRectangle()
                    .fill(.accent)
                    .frame(width: UIScreen.main.bounds.width, height: 161)
                Image("AppIconVector").padding(.top)
            }.edgesIgnoringSafeArea(.top) // 忽略頂部安全區域
            // label about sign up
            Text("Sign In")
                .fontWeight(.bold)
                .font(.title)
                .foregroundStyle(.deepAccent)
            // signin form
            VStack(alignment: .leading){
                // Email textfield
                Text("Email Address").fontWeight(.bold).foregroundColor(.deepAccent)
                HStack {
                    Image(systemName: "mail")
                    TextField("Enter your email", text: $email).frame(minHeight: 25)
                    
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.sysYellow)
                )
                
                // Password
                Text("Password").fontWeight(.bold).foregroundColor(.deepAccent)
                HStack {
                    Image(systemName: "lock")
                    if showPassword {
                        TextField("Enter your password", text: $password).frame(minHeight: 25)
                            // fix the text field
                    } else {
                        SecureField("Enter your password", text: $password).frame(minHeight: 25)
                    }
                    
                    Spacer()
                    
                    ShowHideToggleButton(condition: $showPassword)
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.sysYellow)
                )
                // SignIn bottom
                Button {
                    print("SignIn buttom clicked!")
                    authVM.login(username: email, password: password)
                    
                    // TODO: action to sign in account on firebase
//                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                         if let error = error {
//                             // print(error)
//                             print(error.localizedDescription)
//                             return
//                         }
//                         
//                         if let authResult = authResult {
//                             print(authResult.user.uid)
//                             withAnimation {
//                                 userID = authResult.user.uid
//                             }
//                         }
//                     }

                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(.deepAccent)
                        )
                    
                }.padding(.vertical)
            }.frame(width:343)
            
            // google and facebook link to account
            
            
            // section to jump to the signup and forgot password view
            VStack {
                HStack {
                    Text("Don’t have an account?")
                    Button(action: {
                        // TODO: link to sign up view
                        withAnimation{
                            self.currentShowingView = .signup
                        }
                    }, label: {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.sysYellow)
                    })
                }
                Button(action: {
                    // TODO: link to forget password action
                }, label: {
                    Text("Forgot password")
                        .fontWeight(.bold)
                        .foregroundColor(.sysYellow)
                })
            }
    
            Spacer()
        }
        
    }
}


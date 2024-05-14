//
//  LoginView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/14.
//

import SwiftUI

struct SigninView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
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
                    TextField("Enter your email", text: $email)
                    
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
                        TextField("Enter your password", text: $password)
                    } else {
                        SecureField("Enter your password", text: $password)
                    }
                    
                    Spacer()
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        if showPassword{
                            Image(systemName: "eye.fill")
                                .foregroundColor(.gray)
                        }else{
                            Image(systemName: "eye.slash.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                // .frame(width:300, height: 50) // test
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.sysYellow)
                )
                // SignIn bottom
                Button {
                    // TODO: action to sign in account on firebase

                } label: {
                    Text("Sign In ")
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

#Preview {
    SigninView()
}

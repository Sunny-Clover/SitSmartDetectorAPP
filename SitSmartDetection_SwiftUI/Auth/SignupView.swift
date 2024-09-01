//
//  SignupView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/14.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @Binding var currentShowingView: authState
    @EnvironmentObject var authVM: AuthViewModel
    
    @AppStorage("uid") var userID: String = ""

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password_confirmation: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
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
            Text("Sign Up for free")
                .fontWeight(.bold)
                .font(.title)
                .foregroundStyle(.deepAccent)
            // signup form
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
                    if showPassword{
                        TextField("Enter your password", text: $password).frame(minHeight:25)
                    }else{
                        SecureField("Enter your password", text: $password).frame(minHeight:25)
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
                // Password confirmation
                Text("Password Confirmation").fontWeight(.bold).foregroundColor(.deepAccent)
                HStack {
                    Image(systemName: "lock")
                    if showConfirmPassword{
                        TextField("Confirm your password", text: $password_confirmation).frame(minHeight:25)
                    }else{
                        SecureField("Confirm your password", text: $password_confirmation).frame(minHeight:25)
                    }
                    
                    Spacer()
                    ShowHideToggleButton(condition: $showConfirmPassword)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.sysYellow)
                )
                
                // SignUp bottom
                Button {
                    // TODO: action to create account on firebase
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            userID = authResult.user.uid
                            
                        }
                    }
                } label: {
                    Text("Sign Up ")
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
            
            
            // section to jump to the signin view
            HStack {
                Text("Already have an account?")
                Button(action: {
                    // TODO: link to sign in view
                    withAnimation{
                        self.currentShowingView = .signin
                    }
                }){
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(.sysYellow)
                }
            }
            

            Spacer()
        }
        
    }
}


//struct SignupView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var currentViewShowing: String = "signup"
//        SignupView(currentShowingView: currentViewShowing)
//    }
//}


struct ShowHideToggleButton: View {
    @Binding var condition: Bool

    var body: some View {
        Button {
            condition.toggle()
        } label: {
            Image(systemName: condition ? "eye.fill" : "eye.slash.fill")
                .foregroundColor(.gray)
        }
    }
}

struct CurvedBottomRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 繪製直線部分
        path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // 起始點
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // 最上面的橫線
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 38)) // 預留曲線部分的高度

        // 繪製曲線部分
        let controlPoint1 = CGPoint(x: rect.midX+40, y: rect.maxY+10)
        let controlPoint2 = CGPoint(x: rect.midX-40, y: rect.maxY+10)
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY - 38), control1: controlPoint1, control2: controlPoint2)
        return path
    }
}

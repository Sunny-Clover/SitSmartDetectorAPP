//
//  ProfileView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/17.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("uid") var userID: String = ""
    var body: some View {
        VStack {
//            Text("Logged In! \nYour user id is \(userID)")
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    withAnimation {
                        userID = ""
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }) {
                // arrow.forward.square
                //
                // faRightFromBracket
//                Image(systemName: "rectangle.portrait.and.arrow.forward")
                Image(.faRightFromBracket)
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    ProfileView()
}

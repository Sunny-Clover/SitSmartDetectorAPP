//
//  AuthView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/14.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingState:authState = .signin
    
    var body: some View {
        Group {
            if showingState == .signin {
                SigninView(currentShowingView: $showingState)
                    .environmentObject(authVM)
                // .preferredColorScheme(.light)
            } else if showingState == .signup {
                SignupView(currentShowingView: $showingState)
                    .environmentObject(authVM)
                // .preferredColorScheme(.dark)
                //.transition(.move(edge: .bottom))
            } else {
                EmptyView()
            }
        }
        .onAppear {
            if showingState == .done {
                // back to contentView
                authVM.isAuthenticated = true
            }
        }
    }
}
enum authState {
    case signin
    case signup
    case done
}

//struct AuthView_Previews: PreviewProvider {
//    static var previews: some View {
////        AuthView(isAuthenticated:.constant(false))
////        AuthView()
//    }
//}

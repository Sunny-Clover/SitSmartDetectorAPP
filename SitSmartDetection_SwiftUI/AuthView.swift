//
//  AuthView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/14.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "signin" // signin or signup
        
    var body: some View {
        
        if(currentViewShowing == "signin") {
            SigninView(currentShowingView: $currentViewShowing)
                // .preferredColorScheme(.light)
        } else {
            SignupView(currentShowingView: $currentViewShowing)
                // .preferredColorScheme(.dark)
                //.transition(.move(edge: .bottom))
        }
  
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

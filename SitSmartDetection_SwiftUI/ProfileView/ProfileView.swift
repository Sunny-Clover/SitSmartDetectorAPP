//
//  ProfileView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/17.
//

import SwiftUI
import FirebaseAuth

struct profileStatics{
    let level:Int
    let Score:Int
    let ReachedGaol:Int
}

class ProfileViewModel: ObservableObject {
//    @Published var users: [User] = []
    @Published var statics: profileStatics = profileStatics(level: 2, Score: 89, ReachedGaol: 6)

}


struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @EnvironmentObject var authVM: AuthManager
    @EnvironmentObject var userVM: UserInfoViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Button
                HStack{
                    Spacer()
                    Button(action: {
                        authVM.logout()
                    }) {
                        Image(.faRightFromBracket)
                            .foregroundColor(.accent)
                    }.padding()
                }
                Group {
                    if let photoUrl = userVM.user?.photoUrl {
                        AvatarView(photoUrl: photoUrl)
                    } else {
                        Image("Sunny")
                    }
                }.frame(width: 65, height: 65)
                 .clipShape(Circle())
                 .overlay(
                    Circle().stroke(.accent, lineWidth: 3) // 使用 `overlay` 添加圓形邊框
                 )
                Text(userVM.user?.userName ?? "Error")
                    .foregroundColor(.profileAccent) // 設置文字顏色
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .padding() // 添加內邊距
                // Statics
                HStack (spacing:3){
                    VStack{
                        Text("\(userVM.user?.level ?? 1)")
                            .font(.system(size: 20, weight: .medium, design: .default))
                        Text("Level")
                            .font(.system(size: 14, weight: .medium, design: .default))
                    }.frame(width: 90)
                    VStack{
                        Text("\(userVM.getAllTimeScore())")
                            .font(.system(size: 20, weight: .medium, design: .default))
                        Text("Score")
                            .font(.system(size: 14, weight: .medium, design: .default))
                    }.frame(width: 90)
                    // TODO: Reached Goal暫時不要
//                    VStack{
//                        Text("\(viewModel.statics.ReachedGaol)")
//                            .font(.system(size: 20, weight: .medium, design: .default))
//                        Text("ReachedGoal")
//                            .font(.system(size: 14, weight: .medium, design: .default))
//                    }.frame(width: 90)
                }.foregroundColor(.profileAccent).padding(20)
                // Profile setting button
                NavigationLink(destination: ProfileSettingView()) {
                    HStack {
                        Image(systemName: "person.fill").resizable().frame(width:32, height: 32).padding(.leading, 10)
                        Text("Profile")
                            .font(.system(size: 24, weight: .medium, design: .default))
                            .padding() // 添加內邊距
                        Spacer()
                        Image(systemName: "chevron.right").font(.title2)
                    }
                    .padding()
                    .frame(width: 300, height: 64)
                    .background(Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(5)
                }

                // Custom setting button
                NavigationLink(destination: ProfileCustomizationView()) {
                    HStack {
                        Image(systemName: "gearshape.fill").resizable().frame(width:32, height: 32).padding(.leading, 10)
                        Text("Customization")
                            .font(.system(size: 24, weight: .medium, design: .default))
                            .padding() // 添加內邊距
                        Spacer()
                        Image(systemName: "chevron.right").font(.title2)
                    }
                    .padding()
                    .frame(width: 300, height: 64)
                    .background(Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(5)
                }
                Spacer()
            }
            .onAppear{
                userVM.fetchUserData()
            }
        }
    }
}


#Preview {
    ProfileView()
}

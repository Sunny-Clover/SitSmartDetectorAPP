//
//  ProfileSettingView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/23.
//

import SwiftUI

struct UserDataModel {
    var name: String
    var email: String
}

class SettingViewModel: ObservableObject {
    @Published var userData: UserDataModel
    
    init() {
        self.userData = UserDataModel(name: "Sunny", email: "t110590032@ntut.org.tw")
    }
}

struct ProfileSettingView: View {
    @State private var selectedGender: String = "Female"
    @ObservedObject var viewModel = SettingViewModel()
    
    var body: some View {
        VStack {
            Image("Avatar")
                .resizable()
                .frame(width: 65, height: 65)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.accentColor, lineWidth: 3)
                )
            
            Button(action: {
                // Button action
            }) {
                Text("Edit Picture").foregroundColor(Color(red: 149/255, green: 208/255, blue: 248/255))
            }
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                    Spacer()
                    TextField("Name", text: $viewModel.userData.name)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.profileAccent)
                }
                .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Text("Gender")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        RadioButtonField(id: "Male", label: "Male", isMarked: $selectedGender)
                        RadioButtonField(id: "Female", label: "Female", isMarked: $selectedGender)
                        RadioButtonField(id: "Other", label: "Other", isMarked: $selectedGender)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                    Spacer()
                    TextField("Email", text: $viewModel.userData.email)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.profileAccent)
                        .font(.body)
                        .bold()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            Spacer()
            
        }
        .navigationTitle("Profile Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Button action
                }) {
                    Text("Done").foregroundColor(.deepAccent)
                }
            }
        }
    }
}

struct RadioButtonField: View {
    let id: String
    let label: String
    @Binding var isMarked: String
    
    var body: some View {
        Button(action: {
            self.isMarked = self.id
        }) {
            HStack {
                Image(systemName: self.isMarked == self.id ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(self.isMarked == self.id ? Color(red: 0.2, green: 0.4, blue: 0.6) : .gray)
                Text(label)
                    .foregroundColor(.gray)
                    .font(.body)
            }
        }
        .foregroundColor(.white)
    }
}

#Preview {
    ProfileSettingView()
}

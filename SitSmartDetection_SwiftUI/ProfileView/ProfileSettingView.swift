//
//  ProfileSettingView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/23.
//

import SwiftUI
import Combine

struct UserDataModel {
    var name: String
    // TODO: should customize a enum data structure
    var gender: String
    var email: String
    var avatar: Image
}

class SettingViewModel: ObservableObject {
//    @Published var userData: UserDataModel
    @Published var user: UserResponse
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        self.userData = UserDataModel(name: "Sunny",gender: "Female", email: "t110590032@ntut.org.tw", avatar: Image("Sunny"))
        self.user = UserService.shared.userInfo ?? UserResponse(
            userID: 0,
            userName: "",
            email: "",
            firstName: "",
            lastName: "",
            gender: "",
            photoUrl: nil,
            postureAlertEnable: nil,
            postureAlertTime: nil,
            idleAlertEnable: nil,
            idleAlertTime: nil,
            allTimeScore: 0,
            totalPredictionCount: 0,
            totalDetectionTime: "",
            pr: 0,
            level: 0,
            levelProgress: 0
        )
    }
    func loadUserData() {
        guard let loadedUser = UserService.shared.userInfo else { return }
        self.user = loadedUser
    }

    func saveUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        // 建立 UserUpdate 資料
        let userUpdate = UserUpdate(
            firstName: user.firstName ?? "",
            lastName: user.lastName ?? "",
            gender: user.gender,
            photoUrl: user.photoUrl,
            postureAlertEnable: user.postureAlertEnable,
            postureAlertTime: user.postureAlertTime,
            idleAlertEnable: user.idleAlertEnable,
            idleAlertTime: user.idleAlertTime
        )
        
        // 將資料編碼為 JSON
        guard let bodyData = try? JSONEncoder().encode(userUpdate) else {
            completion(.failure(SSDError.encodingFailed))
            return
        }
        
        let endpoint = "\(Config.shared.baseURL)/users/me"
        
        // 發送 PATCH 請求
        APIManager.shared.performRequest(endpoint: endpoint, method: .PATCH, body: bodyData)
            .receive(on: DispatchQueue.main)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    print("saveUserData failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } receiveValue: { (updatedUser: UserResponse) in
                // 更新本地的 user 資料
                DispatchQueue.main.async {
                    UserService.shared.userInfo = updatedUser
                    self.user = updatedUser
                    completion(.success(()))
                }
            }
            .store(in: &self.cancellables)
    }
}

struct ProfileSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = SettingViewModel()
    @State private var selectedGender: String = "Female" // TODO: should be init by current gender in db
    @State private var showAlert = false
    @State private var alertMessage = ""

    let titleWidth:CGFloat = 90
    
    var body: some View {
        VStack {
            // TODO: 第一次加載後端的資料，之後如果有上傳新的照片，就要顯示上傳的，直到發出Done成功儲存到後端後，下次打開就會加載最新的大頭照出來了
            AvatarView(userID: viewModel.user.userID)
                .frame(width: 65, height: 65)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.accent, lineWidth: 3)
                )
            
            Button(action: {
                // Button action
                // TODO: Edit Picture function，Upload pic from phone, and should be save to backend when done button pressed
            }) {
                Text("Edit Picture").foregroundColor(Color(red: 149/255, green: 208/255, blue: 248/255))
            }
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("First Name")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                        .frame(width: titleWidth)
                    VStack {
                        TextField("First Name", text: Binding(
                            get: { viewModel.user.firstName ?? "" },
                            set: { viewModel.user.firstName = $0.isEmpty ? "" : $0 }
                        ))
                            .foregroundColor(.profileAccent)
                        Spacer()
                            .frame(height: 2)
                        Rectangle()
                            .frame(height: 1.5)
                            .foregroundColor(.deepAccent)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Last Name")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                        .frame(width: titleWidth)
                    VStack {
                        TextField("Last Name", text: Binding(
                            get: { viewModel.user.lastName ?? "" },
                            set: { viewModel.user.lastName = $0.isEmpty ? "" : $0 }
                        ))
                            .foregroundColor(.profileAccent)
                        Spacer()
                            .frame(height: 2)
                        Rectangle()
                            .frame(height: 1.5)
                            .foregroundColor(.deepAccent)
                    }
                }
                .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Text("Gender")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                        .frame(width: titleWidth)
                    VStack(alignment: .leading, spacing: 10) {
                        RadioButtonField(id: "Male", label: "Male", isMarked: $viewModel.user.gender)
                        RadioButtonField(id: "Female", label: "Female", isMarked: $viewModel.user.gender)
                        RadioButtonField(id: "Other", label: "Other", isMarked: $viewModel.user.gender)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.deepAccent)
                        .frame(width: titleWidth)
                    VStack {
                        TextField("Email", text: $viewModel.user.email)
                            .foregroundColor(.profileAccent)
                            .disabled(true)
                        Spacer()
                            .frame(height: 2)
                        Rectangle()
                            .frame(height: 1.5)
                            .foregroundColor(.deepAccent)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            Spacer()
            
        }
        .onAppear {
            viewModel.loadUserData()
        }
        .navigationTitle("Profile Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.saveUserData { result in
                        switch result {
                        case .success:
                            dismiss()
                        case .failure(let error):
                            alertMessage = "Failed to save data: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                }) {
                    Text("Done")
                        .foregroundColor(.deepAccent)
                        .bold()
                }.alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
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

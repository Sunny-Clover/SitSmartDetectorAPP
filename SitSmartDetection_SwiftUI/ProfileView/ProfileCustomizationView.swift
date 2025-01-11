//
//  ProfileCustomizationView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/23.
//

import SwiftUI
import Combine

class CustomizationViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var postureAlertEnable: Bool = false
    @Published var postureAlertMinutes: Int = 2
    @Published var postureAlertSeconds: Int = 30
    @Published var idleAlertEnable: Bool = false
    @Published var idleAlertMinutes: Int = 2
    @Published var idleAlertSeconds: Int = 30
    
    //@Published var goalPoints: Int = 85
    
    func loadUserData() {
        guard let loadedUser = UserService.shared.userInfo else { return }
        postureAlertEnable = loadedUser.postureAlertEnable ?? false
        idleAlertEnable = loadedUser.idleAlertEnable ?? false
        (idleAlertMinutes, idleAlertSeconds) = extractMinutesAndSeconds(from: loadedUser.idleAlertTime ?? "00:00:00") ?? (0, 0)
        (postureAlertMinutes, postureAlertSeconds) = extractMinutesAndSeconds(from: loadedUser.postureAlertTime ?? "00:00:00") ?? (0, 0)
    }

    func saveUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        
        let idleAlertTimeString = formatToTimeString(minutes: idleAlertMinutes, seconds: idleAlertSeconds)
        let postureAlertTimeString = formatToTimeString(minutes: postureAlertMinutes, seconds: postureAlertSeconds)
        
        let userUpdate = UserUpdate(
            firstName: nil,
            lastName: nil,
            gender: nil,
            photoUrl: nil,
            postureAlertEnable: postureAlertEnable,
            postureAlertTime: postureAlertEnable ? postureAlertTimeString : nil,
            idleAlertEnable: idleAlertEnable,
            idleAlertTime: idleAlertEnable ? idleAlertTimeString : nil
        )
        
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
                    print("saveCustomization failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } receiveValue: { (updatedUser: UserResponse) in
                DispatchQueue.main.async {
                    UserService.shared.userInfo = updatedUser
                    self.loadUserData()
                    completion(.success(()))
                }
            }
            .store(in: &self.cancellables)
    }
}

struct ProfileCustomizationView: View {
    @ObservedObject var viewModel = CustomizationViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Init UISegmentedControl's appearance
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 151/255, green: 181/255, blue: 198/255, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                // Posture alert time setting
                PostureAlert(viewModel: viewModel)

                Divider().padding()
                
                // idle alert
                VStack (alignment: .leading){
                    HStack {
                        VStack {
                            Image("chairIcon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .background(
                                    Circle()
                                        .fill(Color.deepAccent)
                                        .frame(width: 40, height: 40)
                                )
                                .padding()
                        }
                        VStack(alignment: .leading) {
                            Text("Idle Alert")
                                .foregroundColor(Color.deepAccent)
                                .font(.title2)
                                .bold()
                            Text("Time to alert when sitting too long.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Picker("Select Idle Alert Type", selection: $viewModel.idleAlertEnable) {
                        Text("Off").tag(false)
                        Text("On").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(red: 151/255, green: 181/255, blue: 198/255))
                    .cornerRadius(7)
                    .padding(.top)

                    if viewModel.idleAlertEnable {
                        HStack {
                            Picker(selection: $viewModel.idleAlertMinutes, label: Text("Minutes")) {
                                ForEach(0..<60) { i in
                                    Text("\(i)")
                                        .foregroundColor(Color.deepAccent)
                                        .tag(i)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            Text("min")
                                .bold()
                            
                            Picker(selection: $viewModel.idleAlertSeconds, label: Text("Seconds")) {
                                ForEach(0..<60) { i in
                                    Text("\(i)")
                                        .foregroundColor(Color.deepAccent)
                                        .tag(i)
                                    
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            Text("sec")
                                .bold()
                        }
                        .foregroundColor(Color.deepAccent)
                        .frame(height: 150)
                    }
                    
                }
                /*
                Divider()
                    .padding()
                
                VStack (alignment: .leading){
                    HStack {
                        Image(systemName: "flag.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.deepAccent)
                                    .frame(width: 40, height: 40)
                            )
                            .padding()
                        VStack(alignment: .leading) {
                            Text("Set Goal")
                                .foregroundColor(Color.deepAccent)
                                .font(.title2)
                                .bold()
                          
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        TextField("Goal Points", value: $viewModel.goalPoints, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 100)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        
                        Text("Points")
                            .font(.body)
                            .bold()
                            .padding(.leading)
                        Spacer()
                    }
                }
                */
                Spacer()
            }
            .onAppear {
                viewModel.loadUserData()
            }
            .navigationTitle("Customization")
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
            .padding()
        }
    }
}


struct ProfileCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileCustomizationView()
        }
    }
}


struct PostureAlert: View {
    @ObservedObject var viewModel: CustomizationViewModel
    @EnvironmentObject private var userInfoVM: UserInfoViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image("Sitting")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .background(
                            Circle()
                                .fill(Color.deepAccent)
                                .frame(width: 40, height: 40)
                        )
                        .padding()
                }
                VStack(alignment: .leading) {
                    Text("Posture Alert")
                        .foregroundColor(Color.deepAccent)
                        .font(.title2)
                        .bold()
                    Text("Time to alert when maintaining an incorrect posture.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Picker("Select Alert Type", selection: $viewModel.postureAlertEnable) {
                Text("off").tag(false)
                Text("On").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color(red: 151/255, green: 181/255, blue: 198/255))
            .cornerRadius(7)
            .padding(.top) // 只在頂部添加間距
            
            if viewModel.postureAlertEnable {
                HStack {
                    Picker(selection: $viewModel.postureAlertMinutes, label: Text("Minutes")) {
                        ForEach(0..<60) { i in
                            Text("\(i)")
                                .foregroundColor(Color.deepAccent)
                                .tag(i)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Text("min")
                        .bold()
                    
                    Picker(selection: $viewModel.postureAlertSeconds, label: Text("Seconds")) {
                        ForEach(0..<60) { i in
                            Text("\(i)")
                                .foregroundColor(Color.deepAccent)
                                .tag(i)
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Text("sec")
                        .bold()
                }
                .foregroundColor(Color.deepAccent)
                .frame(height: 150)
            }
        }
    }
}

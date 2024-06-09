//
//  ProfileCustomizationView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/23.
//

import SwiftUI
class CustomizationViewModel: ObservableObject {
    @Published var postureAlertMinutes: Int = 2
    @Published var postureAlertSeconds: Int = 30
    @Published var postureAlertType: String = "Instant"
    @Published var idleAlertEnabled: Bool = false
    @Published var idleAlertMinutes: Int = 2
    @Published var idleAlertSeconds: Int = 30
    
    @Published var goalPoints: Int = 85
}

struct ProfileCustomizationView: View {
    @ObservedObject var viewModel = CustomizationViewModel()
    
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
                    Picker("Select Idle Alert Type", selection: $viewModel.idleAlertEnabled) {
                        Text("Off").tag(false)
                        Text("On").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(red: 151/255, green: 181/255, blue: 198/255))
                    .cornerRadius(7)
                    .padding(.top)

                    if viewModel.idleAlertEnabled {
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
            .navigationTitle("Customization")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Button action
                    }) {
                        Text("Done")
                            .foregroundColor(.deepAccent)
                            .bold()
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
            
            Picker("Select Alert Type", selection: $viewModel.postureAlertType) {
                Text("Instant").tag("Instant")
                Text("Delay").tag("Delay")
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color(red: 151/255, green: 181/255, blue: 198/255))
            .cornerRadius(7)
            .padding(.top) // 只在頂部添加間距
            
            if viewModel.postureAlertType == "Delay" {
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

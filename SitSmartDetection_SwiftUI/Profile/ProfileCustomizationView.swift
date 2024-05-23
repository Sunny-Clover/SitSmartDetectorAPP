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
    @Published var idleAlertEnabled: Bool = true
    @Published var goalPoints: Int = 85
}

struct ProfileCustomizationView: View {
    @ObservedObject var viewModel = CustomizationViewModel()
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Image(systemName: "figure.stand")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Posture Alert")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
                Text("Time to alert when maintaining an incorrect posture.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
//                Picker("Select Alert Type", selection: $viewModel.alertType) {
//                    Text("Instant").tag("Instant")
//                    Text("Delay").tag("Delay")
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .background(Color(red: 151/255, green: 181/255, blue: 198/255))
//                .cornerRadius(7)
//                .padding()
                
                HStack {
                    Picker(selection: $viewModel.postureAlertMinutes, label: Text("Minutes")) {
                        ForEach(0..<60) { i in
                            Text("\(i)").tag(i)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Text("min")
                        .bold()
                    
                    Picker(selection: $viewModel.postureAlertSeconds, label: Text("Seconds")) {
                        ForEach(0..<60) { i in
                            Text("\(i)").tag(i)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Text("sec")
                        .bold()
                }
                .frame(height: 150)
                
                Divider()
                    .padding()
                
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Idle Alert")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
                Text("Time to alert when sitting over 20 minutes.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                CustomToggle(isOn: $viewModel.idleAlertEnabled)
                    .padding()
                
                Divider()
                    .padding()
                
                HStack {
                    Image(systemName: "flag")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Set Goal")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
                HStack {
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
                }
            }
            Spacer()
        }
        .navigationTitle("Customization")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Button action
                }) {
                    Text("Done").foregroundColor(.blue)
                }
            }
        }
        .padding()
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text("ON")
                .foregroundColor(isOn ? .white : .gray)
                .padding(.horizontal)
                .background(isOn ? Color.blue : Color.clear)
                .cornerRadius(15)
            
            Text("OFF")
                .foregroundColor(!isOn ? .white : .gray)
                .padding(.horizontal)
                .background(!isOn ? Color.blue : Color.clear)
                .cornerRadius(15)
        }
        .onTapGesture {
            isOn.toggle()
        }
        .padding(5)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
    }
}

struct ProfileCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileCustomizationView()
        }
    }
}


//
//  SittingStandardView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/22.
//

import SwiftUI

struct SittingStandardView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("SittingStandard")
                HStack {
//                    VStack{
//                        Text("1. \n\n\n 2. \n\n\n 3. \n\n\n 4. \n\n\n\n 5. \n\n\n 6. \n\n\n 7. \n\n 8. \n\n\n 9. \n\n\n 10. \n\n\n\n 11. \n\n ")
//                        Spacer()
//                    }
                    VStack {
                        
                        HStack {
                            Spacer()
                            Text("Sit directly in front of your keyboard and computer screen. \n\n Adjust the monitor to be 18 to 24 inches from your eyes, with a slight downward gaze.\n\n  Ensure legs fit under the desk with feet flat on the floor; use a footrest if necessary. \n\n  Set chair height so thighs are parallel to the floor, knees at about 90 degrees, slightly below hips. \n\n  Work surface should allow elbows to maintain a 90-degree angle. \n\n  Sit upright, keeping the natural curve of your back. \n\n Ensure proper lower back support. \n\n  Keep shoulders relaxed and avoid slumping forward. \n\n  Relax your wrists in a neutral position without bending up or down. \n\n  Take regular breaks for stretching and walking every 30 minutes, alternating between different muscle group activities. \n\n  Give your eyes regular breaks by closing them briefly, looking at a distant object, and blinking frequently.")
                            Spacer()
                        }
                    }
                }
                Spacer()
                Text("Source: https://videocast.nih.gov/pdf/wlc062210.pdf")
            }
        }
        .navigationTitle("PROPER ERGONIMICS IN THE WORKPLACE")
    }
}
    
#Preview {
    SittingStandardView()
}

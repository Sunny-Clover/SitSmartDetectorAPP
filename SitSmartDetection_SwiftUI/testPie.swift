//
//  testPie.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/6/13.
//

import SwiftUI
import Charts

struct testPie: View {
    private var coffeeSales = [
        (name: "Americano", count: 120),
        (name: "Cappuccino", count: 234),
        (name: "Espresso", count: 62),
        (name: "Latte", count: 625),
        (name: "Mocha", count: 320),
        (name: "Affogato", count: 50)
    ]
    @State private var selectedCount: Int?
    
    var body: some View {
        VStack {
            Chart {
                ForEach(coffeeSales, id: \.name) { coffee in

                    SectorMark(
                        angle: .value("Cup", coffee.count)
                    )
                    .foregroundStyle(by: .value("Type", coffee.name))
                }
            }
            .frame(height: 500)
            .chartAngleSelection(value: $selectedCount)
            .onChange(of: selectedCount) { oldValue, newValue in
                if let newValue {
                    print(newValue)
                }
            }
        }
    }
}

#Preview {
    testPie()
}

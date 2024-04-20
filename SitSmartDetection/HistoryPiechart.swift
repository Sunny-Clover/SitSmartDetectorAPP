//
//  piechart.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/20.
//

import SwiftUI
import Charts

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let revenue: Double
}

struct HistoryPiechart: View {
    @State private var products: [Product] = [
        .init(title: "Annual", revenue: 0.7),
        .init(title: "Monthly", revenue: 0.2),
        .init(title: "Lifetime", revenue: 0.1)
    ]
    
    var body: some View {
        Chart(products) { product in
            SectorMark(
                angle: .value(
                    Text(verbatim: product.title),
                    product.revenue
                )
            )
            .foregroundStyle(
                by: .value(
                    Text(verbatim: product.title),
                    product.title
                )
            )
        }
    }
}

//
//  HomeView_PieChart.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/14.
//

import SwiftUI
import Charts

struct HomeView_PieChart: View {
    var data: [PieDataSeries]
    var StatCard_Width = UIScreen.main.bounds.width * 0.44
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "chart.pie.fill")
                    .foregroundStyle(.white)
                Text("Total Time")
                    .foregroundStyle(.white)
                    .bold()
            }
            HStack(){
                legend
                Spacer()
                Chart {
                    ForEach(data) { series in
                        ForEach(series.ratios, id: \.self) { ratioGroup in
                            ForEach(ratioGroup, id: \.id) { ratioData in
                                SectorMark(
                                    angle: .value(ratioData.title, ratioData.ratio),
                                    innerRadius: .ratio(0.6),
                                    angularInset: 8
                                )
                                .foregroundStyle(ratioData.color)
                            }
                        }
                    }
                }
                .frame(width: StatCard_Width * 0.3)
            }
        }
    }
    
    private var legend: some View {
        let uniqueRatios = data.flatMap { $0.ratios.flatMap { $0 } }.uniqued(by: \.title)
        return VStack(alignment: .leading) {
            Text("662.5 hr")
                .foregroundStyle(.white)
                .font(.system(size: 20))
            ForEach(uniqueRatios, id: \.id) { ratioData in
                HStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(ratioData.color) // ensure Color conforms to ShapeStyle
                        .frame(width: 8, height: 8)
                    Text(ratioData.title)
                        .foregroundColor(.white)
                        .font(.system(size: 8))
                }
            }
        }
//        .padding(.horizontal)
    }
}

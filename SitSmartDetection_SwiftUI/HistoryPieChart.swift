//
//  HistoryPieChart.swift
//  SitSmartDetection
//

import SwiftUI
import Charts

struct RatioData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let day: Date
    let ratio: Int
    let uiColor: UIColor
    var color: Color {
        Color(uiColor)
    }
}

struct PieDataSeries: Identifiable {
    let id = UUID()
    let title: String
    var ratios: [[RatioData]]
    
}

struct PieChart: Identifiable {
    let id = UUID()
    var data: [PieDataSeries]
    var timeUnit: Calendar.Component
}

struct HistoryPieChart: View {
    @Binding var pieChart: PieChart
    @State private var angleValue: Int?
    @State private var selectedSector: String?
    @State private var selectedRatioData: RatioData? = nil
    
    var body: some View {
        VStack(spacing: 25) {
            if pieChart.data.isEmpty || pieChart.data.allSatisfy({ $0.ratios.isEmpty }) {
                Spacer()
                Text("No data available")
                    .foregroundColor(.gray)
                    .font(.title)
            } else {
                ForEach(pieChart.data) { series in
                    let aggregatedRatios = aggregateRatios(for: pieChart.timeUnit, ratios: series.ratios)
                    if aggregatedRatios.isEmpty {
                        Text("No data available for \(series.title)")
                            .foregroundColor(.gray)
                            .font(.title)
                    } else {
                        Chart {
                            ForEach(aggregatedRatios, id: \.id) { ratioData in
                                SectorMark(
                                    angle: .value(ratioData.title, ratioData.ratio),
                                    angularInset: 4
                                )
                                .foregroundStyle(ratioData.color)
                                .opacity(selectedSector == nil ? 1.0 : (selectedSector == ratioData.title ? 1.0 : 0.5))
                                .annotation(position: .overlay) {
                                    let totalRatios = pieChart.data.flatMap { $0.ratios }.flatMap { $0 }
                                    let totalRatio = totalRatios.reduce(0) { $0 + $1.ratio }
                                    let percentage = Double(ratioData.ratio) / Double(totalRatio) * 100
                                    if totalRatio > 0 && percentage > 0{
                                        Text(String(format: "%.f%%", percentage))
                                            .font(.system(size: 18))
                                            .foregroundStyle(.white)
                                    }
                                }
                                //            .chartAngleSelection(value: $angleValue)
                                //            .onChange(of: angleValue) { oldValue, newValue in
                                //                if let newValue {
                                //                    selectedSector = findSelectedSector(value: newValue)
                                //                } else {
                                //                    selectedSector = nil
                                //                }
                                //            }
                            }
                        }
                        .frame(height: 180)
                        .shadow(radius: 5)
                    }
                }
                legend
            }
        }
    }

    
    private func findSelectedSector(value: Int) -> String? {
        var accumulatedRatio = 0

        // 展平所有的 RatioData
        let allRatios = pieChart.data.flatMap { $0.ratios }.flatMap { $0 }

        // 找到符合條件的 RatioData
        let selectedData = allRatios.first { ratioData in
            accumulatedRatio += ratioData.ratio
            return value <= accumulatedRatio
        }
        
        selectedRatioData = selectedData
        
        return selectedRatioData?.title
    }

    private var legend: some View {
        let uniqueRatios = pieChart.data.flatMap { $0.ratios.flatMap { $0 } }.uniqued(by: \.title)
        return HStack(alignment: .center, spacing: 15) {
            ForEach(uniqueRatios, id: \.id) { ratioData in
                HStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(ratioData.color)
                        .frame(width: 20, height: 20)
                    Text(ratioData.title)
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func aggregateRatios(for timeUnit: Calendar.Component, ratios: [[RatioData]]) -> [RatioData] {
        let calendar = Calendar.current
        var aggregatedRatiosDict: [String: RatioData] = [:]
        
        for ratioGroup in ratios {
            for ratioData in ratioGroup {
                let date = calendar.dateInterval(of: timeUnit, for: ratioData.day)?.start ?? calendar.startOfDay(for: ratioData.day)
                let key = "\(ratioData.title)-\(date)"
                
                if let existingRatioData = aggregatedRatiosDict[key] {
                    let newRatio = existingRatioData.ratio + ratioData.ratio
                    aggregatedRatiosDict[key] = RatioData(
                        title: ratioData.title,
                        day: date,
                        ratio: newRatio,
                        uiColor: ratioData.uiColor
                    )
                } else {
                    aggregatedRatiosDict[key] = RatioData(
                        title: ratioData.title,
                        day: date,
                        ratio: ratioData.ratio,
                        uiColor: ratioData.uiColor
                    )
                }
            }
        }
        
        let result = Array(aggregatedRatiosDict.values).sorted { $0.day < $1.day }
        
        // 打印結果以進行調試
        print("aggregatedRatios:")
        print(result)
        print("~~~~~~~~~~~~~~~~~~~")
        
        return result
    }
}

extension Array where Element: Identifiable {
    func uniqued<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

extension Array where Element == RatioData {
    func groupedBy(_ component: Calendar.Component) -> [Date: [RatioData]] {
        let calendar = Calendar.current
        let groupedDictionary = Dictionary(grouping: self) { (element) -> Date in
            let date = calendar.startOfDay(for: element.day)
            return calendar.dateInterval(of: component, for: date)?.start ?? date
        }
        return groupedDictionary
    }
}

//#Preview {
////    HistoryPieChart(pieChart: PieChart(data: initNoneFilteredPieChartData.filter { $0.title == "Head" }, timeUnit: .year))
//    HistoryPieChart(pieChart: PieChart(data: test, timeUnit: .year))
//}

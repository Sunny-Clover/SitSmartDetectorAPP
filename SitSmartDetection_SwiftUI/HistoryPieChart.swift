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
    let ratio: Double
    let uiColor: UIColor
    var color: Color {
        Color(uiColor)
    }
}

struct PieDataSeries: Identifiable {
    let id = UUID()
    let title: String
    let ratios: [[RatioData]]
}

struct PieChart: Identifiable {
    let id = UUID()
    var data: [PieDataSeries]
    var timeUnit: Calendar.Component
}

struct HistoryPieChart: View {
    let pieChart: PieChart
    @State private var angleValue: Double?
    @State private var selectedRatioData: RatioData? = nil

    var body: some View {
        VStack(spacing: 25) {
            Chart {
                ForEach(pieChart.data) { series in
                    ForEach(aggregateRatios(for: pieChart.timeUnit, ratios: series.ratios), id: \.id) { ratioData in
                        SectorMark(
                            angle: .value(ratioData.title, ratioData.ratio),
                            innerRadius: .ratio(0.6),
                            angularInset: 8
                        )
                        .foregroundStyle(ratioData.color)
                        .opacity(selectedRatioData == nil || selectedRatioData?.id == ratioData.id ? 1.0 : 0.3)
                    }
                }
            }
            .frame(height: 180)
            .shadow(radius: 5)
            .chartAngleSelection(value: $angleValue)
            .chartBackground { _ in
                Group {
                    if let selectedRatioData = selectedRatioData {
                        VStack {
                            Text("\(selectedRatioData.ratio, specifier: "%.2f")%")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(selectedRatioData.title)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    } else {
                        Text("Select a category")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                    }
                }
            }
            .onChange(of: angleValue) { _, _ in
                withAnimation {
                    selectedRatioData = findSelectedRatioData(from: angleValue)
                }
            }

            // Legend for the pie chart
            legend
        }
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
                let date = calendar.startOfDay(for: ratioData.day)
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

        return Array(aggregatedRatiosDict.values).sorted { $0.day < $1.day }
    }

    private func findSelectedRatioData(from angle: Double?) -> RatioData? {
        guard let angle = angle else { return nil }
        var cumulativeRatio: Double = 0.0
        let totalRatio = pieChart.data.flatMap { $0.ratios.flatMap { $0 } }.reduce(0) { $0 + $1.ratio }

        for series in pieChart.data {
            for ratioGroup in series.ratios {
                for ratio in ratioGroup {
                    let ratioPercentage = ratio.ratio / totalRatio
                    cumulativeRatio += ratioPercentage
                    if cumulativeRatio >= angle {
                        return ratio
                    }
                }
            }
        }
        return nil
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

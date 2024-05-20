//
//  piechart.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/20.
//
//
//import SwiftUI
//import Charts
//
//struct Product: Identifiable {
//    let id = UUID()
//    let title: String
//    let revenue: Double
//    let day: Date
//    let uiColor: UIColor  // Storing UIColor if necessary
//    var color: Color {  // Computed property to convert UIColor to Color
//        Color(uiColor)
//    }
//}
//
//
//struct HistoryPieChart: View {
//    var products: [Product]
//    var timeUnit: Calendar.Component
//    @State private var angleValue: Double?
//    @State private var sltProduct: Product? = nil
//
////    // 公共方法修改 sltProduct
////    func resetSelection() {
////        withAnimation {
////            sltProduct = nil
////        }
////        if let sltProduct{
////            print("not nil")
////        }else{
////            print("nil")
////        }
////    }
//
//    var body: some View {
////        VStack {
//            Chart(products) { product in
//                SectorMark(
//                    angle: .value(Text(verbatim: product.title), product.revenue),
//                    innerRadius: .ratio(0.6),
//                    angularInset: 8
//                )
//                .foregroundStyle(product.color)
////                .opacity(sltProduct?.id == product.id ? 1.0 : 0.3)
//                .opacity(sltProduct == nil || sltProduct?.id == product.id ? 1.0 : 0.3)
//            }
//            .chartAngleSelection(value: $angleValue)
//            .chartBackground { _ in
//                Group {
//                    if let sltProduct = sltProduct {
//                        VStack {
//                            Text(String(format: "%.2f", sltProduct.revenue * 100) + "%")
//                                .foregroundColor(.primary)
//                            Text(sltProduct.title)
//                                .foregroundColor(.secondary)
//                                .font(.system(size: 12))
//                        }
//                    } else {
//                        Text("Select")
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//
//
//            // 手動創建圖例
//            HStack {
//                ForEach(products) { product in
//                    HStack {
//                        Color(product.uiColor)
//                            .frame(width: 20, height: 20)
//                            .cornerRadius(5)
//                        Text(product.title)
//                            .foregroundColor(.secondary)
//                            .font(.system(size: 12))
//                    }
//                }
//            }
////            .padding(.top)
////        }
//
//        .onChange(of: angleValue, initial: false){ old,new in
//            withAnimation {
//                if let product = findSltProduct() {
//                    if product.id == sltProduct?.id {
//                        // 点击已被选中的元素时取消选择
//                        sltProduct = nil
//                    }else{
//                        sltProduct = product //新點的
//                    }
//                }
//            }
//            if let new{
//                print(new)
//            }
//        }
////        .padding(.vertical, 50)
//    }
//
//    private func findSltProduct() -> Product? {
//        guard let slt = angleValue else { return nil }
//
//        var sum = 0.0
//        // 若 angleValue 小于第一个 item.power ，则表示选择的是图表中首张“大饼”！
//        var sltProduct = products.first
//        for item in products {
//            sum += item.revenue
//            // 试探正确选中的饼图元素
//            if sum >= slt {
//                sltProduct = item
//                break
//            }
//        }
//        return sltProduct
//    }
//
//
//}



import SwiftUI
import Charts

struct RatioData: Identifiable {
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
    let ratios: [RatioData]
}

struct HistoryPieChart: View {
    var data: [PieDataSeries]
    var timeUnit: Calendar.Component
    @State private var angleValue: Double?
    @State private var selectedRatioData: RatioData? = nil
    
    var body: some View {
        VStack(spacing: 25){
            HStack {
                Text("Accuracy Distribution")
                    .foregroundStyle(Color.gray)
                    .bold()
                Spacer()
            }
            Chart {
                ForEach(aggregateData()) { series in
                    ForEach(series.ratios, id: \.id) { ratioData in
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
            .frame(height: 200)
            .shadow(radius: 5)
            .chartAngleSelection(value: $angleValue)
            .chartBackground { _ in
                Group {
                    if let selectedRatioData = selectedRatioData {
                        VStack {
                            //                        Text(selectedRatioData.title)
                            Text("\(selectedRatioData.ratio, specifier: "%.2f")%")
                                .font(.headline)
                                .foregroundColor(.primary)
                            //                        Text("Ratio: \(selectedRatioData.ratio, specifier: "%.2f")%")
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
        let uniqueRatios = data.flatMap { $0.ratios }.uniqued(by: \.title)
        return HStack(alignment: .center, spacing: 15) {
            ForEach(uniqueRatios, id: \.id) { ratioData in
                HStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(ratioData.color) // ensure Color conforms to ShapeStyle
                        .frame(width: 20, height: 20)
                    Text(ratioData.title)
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(.horizontal)
    }

    private func aggregateData() -> [PieDataSeries] {
        let calendar = Calendar.current
        var aggregatedData = [Date: [RatioData]]()

        for series in data {
            for ratio in series.ratios {
                let startDate: Date
                switch timeUnit {
                case .day:
                    startDate = calendar.startOfDay(for: ratio.day) // 按天聚合，即每天的数据独立处理
                default:
                    startDate = calendar.dateInterval(of: timeUnit, for: ratio.day)?.start ?? ratio.day
                }
                aggregatedData[startDate, default: []].append(ratio)
            }
        }

        return aggregatedData.map { date, ratios in
            PieDataSeries(
                title: "Aggregated for \(date.formatted())",
                ratios: ratios
            )
        }
    }

//    private func aggregateData() -> [PieDataSeries] {
//          let calendar = Calendar.current
//          var aggregatedData = [Date: [RatioData]]()
//
//          for series in data {
//              for ratio in series.ratios {
//                  let startDate = calendar.dateInterval(of: timeUnit, for: ratio.day)?.start ?? ratio.day
//                  aggregatedData[startDate, default: []].append(ratio)
//              }
//          }
//
//          return aggregatedData.map { date, ratios in
//              PieDataSeries(
//                  title: "Aggregated for \(date.formatted())",
//                  ratios: ratios
//  //                color: Color(uiColor: UIColor.systemBlue)  // Use a default system color or derive as needed
//              )
//          }
//      }

    private func findSelectedRatioData(from angle: Double?) -> RatioData? {
        guard let angle = angle else { return nil }
        var cumulativeRatio: Double = 0.0
        let totalRatio = data.flatMap { $0.ratios }.reduce(0) { $0 + $1.ratio }

        for series in data {
            for ratio in series.ratios {
                let ratioPercentage = ratio.ratio / totalRatio
                cumulativeRatio += ratioPercentage
                if cumulativeRatio >= angle {
                    return ratio
                }
            }
        }
        return nil
    }

//    private func findSelectedRatioData(from angle: Double?) -> RatioData? {
//        guard let angle = angle else { return nil }
//        let total = data.flatMap { $0.ratios }.reduce(0) { $0 + $1.ratio }
//        var cumulative = 0.0
//
//        for series in data {
//            for ratio in series.ratios {
//                cumulative += ratio.ratio
//                if cumulative / total >= angle {
//                    return ratio
//                }
//            }
//        }
//        return nil
//    }
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

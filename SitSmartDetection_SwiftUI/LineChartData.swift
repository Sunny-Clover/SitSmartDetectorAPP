import Foundation

var lineChartDataDummy: [DataSeries] = [
    DataSeries(title: "Head", scores: [
        // 2021 Data
        ScoreData(day: Date(timeIntervalSince1970: 1610668800), score: 45.65), // 2021-01-15
        ScoreData(day: Date(timeIntervalSince1970: 1623715200), score: 73.90), // 2021-06-15
        ScoreData(day: Date(timeIntervalSince1970: 1639526400), score: 63.44), // 2021-12-15
        // 2022 Data
        ScoreData(day: Date(timeIntervalSince1970: 1642204800), score: 7.18),  // 2022-01-15
        ScoreData(day: Date(timeIntervalSince1970: 1655251200), score: 26.11), // 2022-06-15
        ScoreData(day: Date(timeIntervalSince1970: 1671062400), score: 38.04), // 2022-12-15
        // 2023 Data
        ScoreData(day: Date(timeIntervalSince1970: 1673740800), score: 80.40), // 2023-01-15
        ScoreData(day: Date(timeIntervalSince1970: 1686787200), score: 53.15), // 2023-06-15
        ScoreData(day: Date(timeIntervalSince1970: 1702598400), score: 11.52), // 2023-12-15
        // 2024 Data
        ScoreData(day: Date(timeIntervalSince1970: 1705286400), score: 13.94), // 2024-01-15
        ScoreData(day: Date(timeIntervalSince1970: 1707964800), score: 90.14), // 2024-02-15
        ScoreData(day: Date(timeIntervalSince1970: 1710556800), score: 87.20), // 2024-03-15
        ScoreData(day: Date(timeIntervalSince1970: 1713235200), score: 3.48),  // 2024-04-15
        ScoreData(day: Date(timeIntervalSince1970: 1715827200), score: 38.09), // 2024-05-15
        ScoreData(day: Date(timeIntervalSince1970: 1718061157), score: 42.56), // 2024-06-10
        ScoreData(day: Date(timeIntervalSince1970: 1718147557), score: 55.47), // 2024-06-11
        ScoreData(day: Date(timeIntervalSince1970: 1718233957), score: 9.55),  // 2024-06-12
        ScoreData(day: Date(timeIntervalSince1970: 1718320357), score: 93.00)  // 2024-06-13
    ]),
    // Repeat similar blocks for "Neck", "Shoulder", "Back", and "Leg"
    DataSeries(title: "Neck", scores: [
        // 2021 Data
        ScoreData(day: Date(timeIntervalSince1970: 1610668800), score: 29.28),
        ScoreData(day: Date(timeIntervalSince1970: 1623715200), score: 51.74),
        ScoreData(day: Date(timeIntervalSince1970: 1639526400), score: 33.37),
        // 2022 Data
        ScoreData(day: Date(timeIntervalSince1970: 1642204800), score: 64.22),
        ScoreData(day: Date(timeIntervalSince1970: 1655251200), score: 86.31),
        ScoreData(day: Date(timeIntervalSince1970: 1671062400), score: 68.85),
        // 2023 Data
        ScoreData(day: Date(timeIntervalSince1970: 1673740800), score: 93.88),
        ScoreData(day: Date(timeIntervalSince1970: 1686787200), score: 7.61),
        ScoreData(day: Date(timeIntervalSince1970: 1702598400), score: 60.27),
        // 2024 Data
        ScoreData(day: Date(timeIntervalSince1970: 1705286400), score: 60.93),
        ScoreData(day: Date(timeIntervalSince1970: 1707964800), score: 0.19),
        ScoreData(day: Date(timeIntervalSince1970: 1710556800), score: 75.12),
        ScoreData(day: Date(timeIntervalSince1970: 1713235200), score: 41.59),
        ScoreData(day: Date(timeIntervalSince1970: 1715827200), score: 14.40),
        ScoreData(day: Date(timeIntervalSince1970: 1718061157), score: 21.33),
        ScoreData(day: Date(timeIntervalSince1970: 1718147557), score: 95.07),
        ScoreData(day: Date(timeIntervalSince1970: 1718233957), score: 73.20),
        ScoreData(day: Date(timeIntervalSince1970: 1718320357), score: 59.87)
    ]),
    DataSeries(title: "Shoulder", scores: [
        // 2021 Data
        ScoreData(day: Date(timeIntervalSince1970: 1610668800), score: 77.44),
        ScoreData(day: Date(timeIntervalSince1970: 1623715200), score: 29.16),
        ScoreData(day: Date(timeIntervalSince1970: 1639526400), score: 82.92),
        // 2022 Data
        ScoreData(day: Date(timeIntervalSince1970: 1642204800), score: 14.75),
        ScoreData(day: Date(timeIntervalSince1970: 1655251200), score: 97.34),
        ScoreData(day: Date(timeIntervalSince1970: 1671062400), score: 8.84),
        // 2023 Data
        ScoreData(day: Date(timeIntervalSince1970: 1673740800), score: 12.95),
        ScoreData(day: Date(timeIntervalSince1970: 1686787200), score: 47.41),
        ScoreData(day: Date(timeIntervalSince1970: 1702598400), score: 67.33),
        // 2024 Data
        ScoreData(day: Date(timeIntervalSince1970: 1705286400), score: 88.73),
        ScoreData(day: Date(timeIntervalSince1970: 1707964800), score: 92.96),
        ScoreData(day: Date(timeIntervalSince1970: 1710556800), score: 28.35),
        ScoreData(day: Date(timeIntervalSince1970: 1713235200), score: 16.06),
        ScoreData(day: Date(timeIntervalSince1970: 1715827200), score: 82.80),
        ScoreData(day: Date(timeIntervalSince1970: 1718061157), score: 97.59),
        ScoreData(day: Date(timeIntervalSince1970: 1718147557), score: 95.07),
        ScoreData(day: Date(timeIntervalSince1970: 1718233957), score: 73.20),
        ScoreData(day: Date(timeIntervalSince1970: 1718320357), score: 59.87)
    ]),
    DataSeries(title: "Back", scores: [
        // 2021 Data
        ScoreData(day: Date(timeIntervalSince1970: 1610668800), score: 89.69),
        ScoreData(day: Date(timeIntervalSince1970: 1623715200), score: 12.77),
        ScoreData(day: Date(timeIntervalSince1970: 1639526400), score: 73.82),
        // 2022 Data
        ScoreData(day: Date(timeIntervalSince1970: 1642204800), score: 98.27),
        ScoreData(day: Date(timeIntervalSince1970: 1655251200), score: 89.50),
        ScoreData(day: Date(timeIntervalSince1970: 1671062400), score: 34.68),
        // 2023 Data
        ScoreData(day: Date(timeIntervalSince1970: 1673740800), score: 98.57),
        ScoreData(day: Date(timeIntervalSince1970: 1686787200), score: 70.86),
        ScoreData(day: Date(timeIntervalSince1970: 1702598400), score: 50.80),
        // 2024 Data
        ScoreData(day: Date(timeIntervalSince1970: 1705286400), score: 33.20),
        ScoreData(day: Date(timeIntervalSince1970: 1707964800), score: 23.98),
        ScoreData(day: Date(timeIntervalSince1970: 1710556800), score: 76.10),
        ScoreData(day: Date(timeIntervalSince1970: 1713235200), score: 44.16),
        ScoreData(day: Date(timeIntervalSince1970: 1715827200), score: 16.38),
        ScoreData(day: Date(timeIntervalSince1970: 1718061157), score: 86.04),
        ScoreData(day: Date(timeIntervalSince1970: 1718147557), score: 95.07),
        ScoreData(day: Date(timeIntervalSince1970: 1718233957), score: 73.20),
        ScoreData(day: Date(timeIntervalSince1970: 1718320357), score: 59.87)
    ]),
    DataSeries(title: "Leg", scores: [
        // 2021 Data
        ScoreData(day: Date(timeIntervalSince1970: 1610668800), score: 70.54),
        ScoreData(day: Date(timeIntervalSince1970: 1623715200), score: 42.69),
        ScoreData(day: Date(timeIntervalSince1970: 1639526400), score: 3.96),
        // 2022 Data
        ScoreData(day: Date(timeIntervalSince1970: 1642204800), score: 72.64),
        ScoreData(day: Date(timeIntervalSince1970: 1655251200), score: 38.84),
        ScoreData(day: Date(timeIntervalSince1970: 1671062400), score: 5.11),
        // 2023 Data
        ScoreData(day: Date(timeIntervalSince1970: 1673740800), score: 16.44),
        ScoreData(day: Date(timeIntervalSince1970: 1686787200), score: 92.60),
        ScoreData(day: Date(timeIntervalSince1970: 1702598400), score: 86.44),
        // 2024 Data
        ScoreData(day: Date(timeIntervalSince1970: 1705286400), score: 49.75),
        ScoreData(day: Date(timeIntervalSince1970: 1707964800), score: 76.55),
        ScoreData(day: Date(timeIntervalSince1970: 1710556800), score: 46.12),
        ScoreData(day: Date(timeIntervalSince1970: 1713235200), score: 29.97),
        ScoreData(day: Date(timeIntervalSince1970: 1715827200), score: 63.75),
        ScoreData(day: Date(timeIntervalSince1970: 1718061157), score: 6.91),
        ScoreData(day: Date(timeIntervalSince1970: 1718147557), score: 95.07),
        ScoreData(day: Date(timeIntervalSince1970: 1718233957), score: 73.20),
        ScoreData(day: Date(timeIntervalSince1970: 1718320357), score: 59.87)
    ])
]

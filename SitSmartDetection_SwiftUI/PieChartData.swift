import SwiftUI

var home_allPartPieChartData: [PieDataSeries] = [
    PieDataSeries(title: "init", ratios: [
        [
            RatioData(
                title: "All Correct",
                day: Date(timeIntervalSince1970: 1711309674.574878),
                ratio: 60,
                uiColor: UIColor(Color(red: 0.966, green: 0.887, blue: 0.496))
            ),
            RatioData(
                title: "Partially Correct",
                day: Date(timeIntervalSince1970: 1711396074.574878),
                ratio: 40,
                uiColor: UIColor(Color(red: 1.0, green: 0.792, blue: 0.831))
            )
        ]
    ])
]

var allPartPieChartData: [PieDataSeries] = [
    PieDataSeries(title: "init", ratios: [
        [
            RatioData(
                title: "All Correct",
                day: Date(timeIntervalSince1970: 1711309674.574878),
                ratio: 60,
                uiColor: UIColor(Color(red: 0.549, green: 0.875, blue: 0.841))
            ),
            RatioData(
                title: "Partially Correct",
                day: Date(timeIntervalSince1970: 1711396074.574878),
                ratio: 40,
                uiColor: UIColor(Color(red: 0.940, green: 0.503, blue: 0.502))
            ),
            RatioData(
                title: "None",
                day: Date(timeIntervalSince1970: 1711396074.574878),
                ratio: 0,
                uiColor: UIColor(Color(red: 0.930, green: 0.3, blue: 0.542))
            )
        ],
        [
            RatioData(
                title: "All Correct",
                day: Date(timeIntervalSince1970: 1711309674.574878),
                ratio: 60,
                uiColor: UIColor(Color(red: 0.549, green: 0.875, blue: 0.841))
            ),
            RatioData(
                title: "Partially Correct",
                day: Date(timeIntervalSince1970: 1711396074.574878),
                ratio: 30,
                uiColor: UIColor(Color(red: 0.940, green: 0.503, blue: 0.502))
            ),
            RatioData(
                title: "None",
                day: Date(timeIntervalSince1970: 1711396074.574878),
                ratio: 10,
                uiColor: UIColor(Color(red: 0.930, green: 0.3, blue: 0.542))
            )
        ]
    ])
]

//var initNoneFilteredPieChartData: [PieDataSeries] = [
//    PieDataSeries(title: "Back", ratios: [
//        [
//            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
//            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
//            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
//        ],
//        [
//            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
//            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
//            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
//        ]
//    ]),
//    PieDataSeries(title: "Leg", ratios: [
//        [
//            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
//            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
//        ]
//    ]),
//    PieDataSeries(title: "Head", ratios: [
//        [
//            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
//            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
//            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
//        ]
//    ]),
//    PieDataSeries(title: "Neck", ratios: [
//        [
//            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
//            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
//        ]
//    ]),
//    PieDataSeries(title: "Shoulder", ratios: [
//        [
//            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
//            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
//            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
//        ]
//    ])
//]

var test: [PieDataSeries] = [
    PieDataSeries(title: "Head", ratios: [
        [RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
         RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 45, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
         RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 34, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 17, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
         RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 25, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
         RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1711312187.574123), ratio: 61, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ]
    ])
]


var initNoneFilteredPieChartData: [PieDataSeries] = [
    PieDataSeries(title: "Back", ratios: [
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1610668800), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1610668800), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1610668800), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1623715200), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1623715200), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1623715200), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1639526400), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1639526400), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1639526400), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1642204800), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1642204800), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1642204800), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1655251200), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1655251200), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1655251200), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1671062400), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1671062400), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1671062400), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1673740800), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1673740800), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1673740800), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1686787200), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1686787200), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1686787200), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1702598400), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1702598400), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1702598400), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1705286400), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1705286400), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1705286400), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1707964800), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1707964800), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1707964800), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1710556800), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1710556800), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1710556800), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1713235200), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1713235200), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1713235200), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1715827200), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1715827200), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1715827200), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1718061157), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718061157), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718061157), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1718147557), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718147557), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718147557), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1718233957), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718233957), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718233957), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Backward", day: Date(timeIntervalSince1970: 1718320357), ratio: 65, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718320357), ratio: 30, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718320357), ratio: 5, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ]
    ]),

    // Repeat similar blocks for "Leg", "Head", "Neck", "Shoulder"

    PieDataSeries(title: "Leg", ratios: [
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1610668800), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1610668800), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1623715200), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1623715200), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1639526400), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1639526400), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1642204800), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1642204800), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1655251200), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1655251200), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1671062400), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1671062400), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1673740800), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1673740800), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1686787200), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1686787200), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1702598400), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1702598400), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1705286400), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1705286400), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1707964800), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1707964800), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1710556800), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1710556800), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1713235200), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1713235200), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1715827200), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1715827200), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1718061157), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1718061157), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1718147557), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1718147557), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1718233957), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1718233957), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Ankle-on-knee", day: Date(timeIntervalSince1970: 1718320357), ratio: 41, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Flat", day: Date(timeIntervalSince1970: 1718320357), ratio: 43, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ]
    ]),
    PieDataSeries(title: "Head", ratios: [
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1610668800), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1610668800), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1610668800), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1623715200), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1623715200), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1623715200), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1639526400), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1639526400), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1639526400), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1642204800), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1642204800), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1642204800), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1655251200), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1655251200), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1655251200), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1671062400), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1671062400), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1671062400), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1673740800), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1673740800), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1673740800), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1686787200), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1686787200), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1686787200), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1702598400), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1702598400), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1702598400), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1705286400), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1705286400), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1705286400), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1707964800), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1707964800), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1707964800), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1710556800), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1710556800), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1710556800), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1713235200), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1713235200), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1713235200), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1715827200), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1715827200), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1715827200), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1718061157), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718061157), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1718061157), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1718147557), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718147557), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1718147557), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1718233957), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718233957), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1718233957), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ],
        [
            RatioData(title: "Bowed", day: Date(timeIntervalSince1970: 1718320357), ratio: 21, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718320357), ratio: 45, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Tilt Back", day: Date(timeIntervalSince1970: 1718320357), ratio: 34, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
        ]
    ]),
    PieDataSeries(title: "Neck", ratios: [
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1610668800), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1610668800), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1623715200), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1623715200), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1639526400), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1639526400), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1642204800), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1642204800), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1655251200), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1655251200), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1671062400), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1671062400), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1673740800), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1673740800), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1686787200), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1686787200), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1702598400), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1702598400), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1705286400), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1705286400), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1707964800), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1707964800), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1710556800), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1710556800), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1713235200), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1713235200), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1715827200), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1715827200), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718061157), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718061157), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718147557), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718147557), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718233957), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718233957), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ],
        [
            RatioData(title: "Forward", day: Date(timeIntervalSince1970: 1718320357), ratio: 7, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718320357), ratio: 93, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ]
    ]),
    PieDataSeries(title: "Shoulder", ratios: [
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1610668800), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1610668800), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1610668800), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1623715200), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1623715200), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1623715200), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1639526400), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1639526400), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1639526400), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1642204800), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1642204800), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1642204800), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1655251200), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1655251200), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1655251200), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1671062400), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1671062400), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1671062400), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1673740800), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1673740800), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1673740800), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1686787200), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1686787200), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1686787200), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1702598400), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1702598400), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1702598400), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1705286400), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1705286400), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1705286400), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1707964800), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1707964800), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1707964800), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1710556800), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1710556800), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1710556800), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1713235200), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1713235200), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1713235200), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1715827200), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1715827200), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1715827200), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1718061157), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718061157), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1718061157), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1718147557), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718147557), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1718147557), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1718233957), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718233957), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1718233957), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ],
        [
            RatioData(title: "Hunched", day: Date(timeIntervalSince1970: 1718320357), ratio: 25, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: Date(timeIntervalSince1970: 1718320357), ratio: 22, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Shrug", day: Date(timeIntervalSince1970: 1718320357), ratio: 53, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ]
    ])
    ]






//
//  HistoryViewController.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/18.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet var timeSegment: UISegmentedControl!
    @IBOutlet var time: UILabel!
    @IBOutlet var bodyPartsButton: [UIButton]!
    @IBOutlet var partName: UILabel!
    
    var selectTime = 0
    
    // Make the calendar a lazy property so it is not initialized until it's actually accessed
    lazy var calendar: Calendar = {
        return Calendar.current
    }()
    
    // Define the time properties as lazy to ensure they are not accessed until needed
    lazy var currentYear: Int = calendar.component(.year, from: Date())
    lazy var currentMonth: Int = calendar.component(.month, from: Date())
    lazy var currentWeek: Int = calendar.component(.weekday, from: Date())
    lazy var currentDay: Int = calendar.component(.day, from: Date())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        timeSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)

        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5929065347, green: 0.7093592286, blue: 0.7758761048, alpha: 1)]
        timeSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        time.text = "\(currentYear)"
    }

    @IBAction func touchTimeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            time.text = "\(currentYear)"
        case 1:
            time.text = "\(currentMonth)"
        case 2:
            time.text = "\(currentWeek)"
        case 3:
            time.text = "\(currentDay)"
        default:
            break
        }
        selectTime = sender.selectedSegmentIndex
    }
    
    @IBAction func touchReduce(_ sender: UIButton) {
        if let timeText = time.text, let currentTime = Int(timeText) {
                let newTime = max(currentTime - 1, 1) // 减去1但不小於0
                time.text = "\(newTime)"
        } else {
            print("Time label is not a valid number")
        }
    }
    @IBAction func touchAdd(_ sender: UIButton) {
        var currentWhich = 0
        switch selectTime{
        case 0:
            currentWhich = currentYear
        case 1:
            currentWhich = currentMonth
        case 2:
            currentWhich = currentWeek
        case 3:
            currentWhich = currentDay
        default:
            break
        }
        
        if let timeText = time.text, let currentTime = Int(timeText) {
            let newTime = currentTime + 1  // Attempt to add 1 to the current time
            if newTime <= currentWhich {
                time.text = "\(newTime)"       // Update the label with the new time
            } else {
                print("The year cannot exceed the current year.")
                 time.text = "\(currentWhich)"
            }
        } else {
            print("Time label is not a valid number")
        }
    }
    
    @IBAction func touchBodyParts(_ sender: UIButton) {
        if let touchIndex = bodyPartsButton.firstIndex(of: sender){
            for index in bodyPartsButton.indices{
                if index != touchIndex{
                    if let color = bodyPartsButton[index].backgroundColor {
                        let components = color.cgColor.components
                        if let red = components?[0], let green = components?[1], let blue = components?[2]{
                            bodyPartsButton[index].backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.2)
                        }
                    }else{
                        print("no bgcolor")
                    }
                }else if index == touchIndex{
                    if let color = bodyPartsButton[index].backgroundColor {
                        let components = color.cgColor.components
                        if let red = components?[0], let green = components?[1], let blue = components?[2]{
                            bodyPartsButton[index].backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
                        }
                    }
                }
                print(index)
            }
            print("touch", touchIndex)
            let part = ["Head", "Neck", "Shoulder", "Back", "Leg"]
            partName.text = part[touchIndex] + " Part"
        }else{
            print("not in the collection")
        }
    }

}

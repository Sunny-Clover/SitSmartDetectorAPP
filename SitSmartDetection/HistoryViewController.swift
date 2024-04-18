//
//  HistoryViewController.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/18.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        // 设置未选中状态的文字颜色
//        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        timeSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
       
//        // 设置选中状态的文字颜色
//        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5929065347, green: 0.7093592286, blue: 0.7758761048, alpha: 1)]
//        timeSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    @IBOutlet var containerViews: [UIView]!
    @IBOutlet var timeSegment: UISegmentedControl!
    @IBOutlet var time: UILabel!
    @IBOutlet var bodyPartsButton: [UIButton]!
    @IBOutlet var partName: UILabel!
    
    @IBAction func touchTimeSegment(_ sender: UISegmentedControl) {
//        for containerView in containerViews {
//              containerView.isHidden = true
//        }
        containerViews.forEach {
               $0.isHidden = true
            }
       containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    
    @IBAction func touchReduce(_ sender: UIButton) {
        if let timeText = time.text, let currentTime = Int(timeText) {
                let newTime = max(currentTime - 1, 0) // 减去1但不小於0
                time.text = "\(newTime)"
        } else {
            print("Time label is not a valid number")
        }
    }
    
    @IBAction func touchAdd(_ sender: UIButton) {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        if let timeText = time.text, let currentTime = Int(timeText) {
            let newTime = currentTime + 1  // Attempt to add 1 to the current time
            if newTime <= currentYear {
                time.text = "\(newTime)"       // Update the label with the new time
            } else {
                print("The year cannot exceed the current year.")
                 time.text = "\(currentYear)"
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

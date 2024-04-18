//
//  DetectionReport_ViewController.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/18.
//

import UIKit

class DetectionReport_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    }
    
    
    @IBOutlet var partName: UILabel!
    @IBOutlet var betterThan: UILabel!
    
    @IBOutlet var bodyPartsButtons: [UIButton]!
    
    @IBAction func touchBodayParts(_ sender: UIButton) {
        if let touchIndex = bodyPartsButtons.firstIndex(of: sender){
            for index in bodyPartsButtons.indices{
                if index != touchIndex{
                    if let color = bodyPartsButtons[index].backgroundColor {
                        let components = color.cgColor.components
                        if let red = components?[0], let green = components?[1], let blue = components?[2]{
                            bodyPartsButtons[index].backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.2)
                        }
                    }else{
                        print("no bgcolor")
                    }
                }else if index == touchIndex{
                    if let color = bodyPartsButtons[index].backgroundColor {
                        let components = color.cgColor.components
                        if let red = components?[0], let green = components?[1], let blue = components?[2]{
                            bodyPartsButtons[index].backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
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

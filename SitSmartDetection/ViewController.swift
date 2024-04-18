//
//  ViewController.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/16.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    }

    
    @IBOutlet var bodyPartsButton: [UIButton]!
    @IBOutlet weak var partDistribution: UILabel!
    @IBOutlet weak var partName: UILabel!
    
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
            partDistribution.text = part[touchIndex] + " Part Accuracy Distribution"
        }else{
            print("not in the collection")
        }
    }
}

//
//  History_year_ViewController.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/18.
//

import UIKit

class HistoryYear_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        year.text = "\(currentYear)"
    }
    
    @IBOutlet var year: UILabel!
    
    

}

//
//  AppInfo_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 21/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import BmoViewPager

class AppInfo_ViewController: UIViewController {

    @IBOutlet weak var version_lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "1.0"
               print("\n this is version Number :\(versionNumber)\n")
     
        let x = (versionNumber) as? String
        version_lbl.text = "Version " + x!
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//
//  PrivacyPolicyController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 10/19/18.
//  Copyright © 2018 Fahad Inco. All rights reserved.
//

import UIKit

class PrivacyPolicyController: UIViewController {
    
    @IBOutlet weak var personalInformation_lbl: UILabel!
    @IBOutlet weak var howToUse_lbl: UILabel!
    @IBOutlet weak var linkToThird_lbl: UILabel!
    @IBOutlet weak var changes_lbl: UILabel!
    @IBOutlet weak var generalData_lbl: UILabel!
    @IBOutlet weak var contactUs_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       personalInformation_lbl.attributedText = NSAttributedString(string: "1. What personal information do we collect?", attributes:
        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        howToUse_lbl.attributedText = NSAttributedString(string: "2. How do we use your data?", attributes:
               [.underlineStyle: NSUnderlineStyle.single.rawValue])
               
        linkToThird_lbl.attributedText = NSAttributedString(string: "3.0 Link to Third-Party Websites", attributes:
               [.underlineStyle: NSUnderlineStyle.single.rawValue])
               
        changes_lbl.attributedText = NSAttributedString(string: "4.0 Changes in Privacy Policy", attributes:
               [.underlineStyle: NSUnderlineStyle.single.rawValue])
               
        generalData_lbl.attributedText = NSAttributedString(string: "5.0 General Data Protection Regulation (GDPR)", attributes:
               [.underlineStyle: NSUnderlineStyle.single.rawValue])
               
        contactUs_lbl.attributedText = NSAttributedString(string: "6.0 Contact Us", attributes:
        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        self.title = "Privacy Policy"
        
        
    }
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

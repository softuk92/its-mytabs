//
//  SuccessVC.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 30/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit

class SuccessVC: UIViewController {

    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var successTitle: UILabel!
    @IBOutlet weak var successSubtitle: UILabel!
    
    var titleStr: String?
    var subtitleStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let titleStr = titleStr {
            successTitle.text = titleStr
        }
        if let subtitleStr = subtitleStr {
            successSubtitle.text = subtitleStr
        }
        
    }
    
    @IBAction func mainBtnAct (_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }

}

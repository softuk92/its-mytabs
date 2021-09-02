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
    var btnTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let titleStr = titleStr {
            successTitle.text = titleStr
        }
        if let subtitleStr = subtitleStr {
            successSubtitle.text = subtitleStr
        }
        
        if btnTitle == "Dashboard" {
            mainBtn.setTitle("Dashboard", for: .normal)
        }
        
    }
    
    @IBAction func mainBtnAct(_ sender: Any) {
        if btnTitle == "Dashboard" {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        }
        NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }

}

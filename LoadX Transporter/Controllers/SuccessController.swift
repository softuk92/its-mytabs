//
//  SuccessController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 4/20/18.
//  Copyright © 2018 Fahad Inco. All rights reserved.
//

import UIKit

class SuccessController: UIViewController {
    
    @IBOutlet weak var mainBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainBtn.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func login_action(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            // Fallback on earlier versions
        }
                   
    }
    
    @IBAction func dashboard_action(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
    self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func goToBookedRoutes(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
        vc?.postData()
        vc?.selectedIndex = 0
    self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}


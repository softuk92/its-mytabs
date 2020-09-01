//
//  SuccessController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 4/20/18.
//  Copyright © 2018 Fahad Inco. All rights reserved.
//

import UIKit

class SuccessController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func login_action(_ sender: Any) {
         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                   self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func dashboard_action(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
    self.navigationController?.pushViewController(vc!, animated: true)
    }
}


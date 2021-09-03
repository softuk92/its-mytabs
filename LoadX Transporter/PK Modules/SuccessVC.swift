//
//  SuccessVC.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 30/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class SuccessVC: UIViewController {

    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var successTitle: UILabel!
    @IBOutlet weak var successSubtitle: UILabel!
    
    var titleStr: String?
    var subtitleStr: String?
    var btnTitle: String = ""
    var phoneNumber: String?
    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        if btnTitle == "Dashboard" && phoneNumber == nil {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        }
        
        if btnTitle == "Dashboard" && phoneNumber != nil {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        }
        NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func userLogin() {
        SVProgressHUD.show(withStatus: "Signing In...")
        if phoneNumber != nil {
            AuthAPIs.login(phone: phoneNumber ?? "", password: "12345") { (data, json, error) in
                guard let jsonData = json, error == nil else { SVProgressHUD.dismiss(); showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self); return }
                SVProgressHUD.dismiss()
                let result = jsonData[0]["result"].stringValue
                let message = jsonData[0]["message"].stringValue
                if result == "false" {
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let userType = jsonData[0]["user_type"].stringValue
                    if userType == "driver" {
                    user_type = jsonData[0]["user_type"].stringValue
                    user_id = jsonData[0]["user_id"].stringValue
                    user_email = jsonData[0]["user_email"].stringValue
                    user_name = jsonData[0]["user_name"].stringValue
                    user_phone = jsonData[0]["user_phone"].stringValue
                    user_image = jsonData[0]["user_image"].stringValue
                        isLoadxDriver = jsonData[0]["is_loadx_driver"].stringValue
                        
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(user_id, forKey: "user_id")
                    userDefaults.set(user_name, forKey: "user_name")
                    userDefaults.set(user_email, forKey: "user_email")
                    userDefaults.set("12345", forKey: "userPass")
                    userDefaults.set(user_phone, forKey: "user_phone")
                    userDefaults.set(user_image, forKey: "user_image")
                    userDefaults.set(user_type, forKey: "user_type")
                        userDefaults.set(isLoadxDriver, forKey: "isLoadxDriver")
                    userDefaults.set(true, forKey: "userLoggedIn")
                    userDefaults.synchronize()
                  
                        self.AppDelegate.moveToHome()
            }
                }
                }
        }
    }

}

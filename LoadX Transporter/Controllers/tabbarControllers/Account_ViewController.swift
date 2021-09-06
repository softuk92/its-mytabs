//
//  Account_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 04/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn

//@available(iOS 13.0, *)
class Account_ViewController: UIViewController {

    @IBOutlet var popUpView: UIView!
    
    @IBOutlet weak var logo_popupView: UIView!
    
    
    
    let manager = FBSDKLoginManager()
    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let sb = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func EditProfile_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "Edit_profile_ViewController") as? Edit_profile_ViewController
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func document_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "Document_ViewController") as? Document_ViewController
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func userReview_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "ManageReviews") as? ManageReviews
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func bankDetailScene(_ sender: Any) {
        if let bankVC = UIStoryboard.init(name: "BankDetails", bundle: nil).instantiateViewController(withIdentifier: "AddBankDetailsViewController") as? AddBankDetailsViewController {
            self.navigationController?.pushViewController(bankVC, animated: true)
        }
        
    }
    
    @IBAction func logOut_action(_ sender: Any) {

        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.layer.borderColor = UIColor.gray.cgColor
            self.popUpView.layer.borderWidth = 1
            self.popUpView.layer.cornerRadius = 18
//            self.tableView.alpha = 0.5
        self.logo_popupView.clipsToBounds = true
        self.logo_popupView.layer.cornerRadius = 18
        self.logo_popupView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
                           
            self.view.addSubview(self.popUpView)
            self.popUpView.center = self.view.center
            
//            if self.switchCheck == true {
//                self.popUpView.backgroundColor = UIColor.darkGray
//                self.popup_lable.textColor = UIColor.white
//                self.popup_yes_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
//                self.popup_yes_btn.setTitleColor(.white, for: .normal)
//                self.popup_no_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
//                self.popup_no_btn.setTitleColor(.white, for: .normal)
//            }else{
//                
//            }
        })
    }
    
    @IBAction func yes_action(_ sender: Any) {
         let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "userLoggedIn")
            userDefaults.removeObject(forKey: "user_id")
            userDefaults.removeObject(forKey: "user_name")
            userDefaults.removeObject(forKey: "user_email")
            userDefaults.removeObject(forKey: "userPass")
            userDefaults.removeObject(forKey: "user_phone")
            userDefaults.removeObject(forKey: "user_image")
            userDefaults.removeObject(forKey: "user_type")
            userDefaults.synchronize()
            user_id = nil
            user_name = nil
            user_email = nil
            GIDSignIn.sharedInstance().signOut()
            
            self.manager.logOut()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
        //            let showVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        //            self.window?.rootViewController = showVC
        //            self.window?.makeKeyAndVisible()
        //            self.dismiss(animated: true, completion: {
        //                UIApplication.shared.keyWindow?.rootViewController = showVC
        //            })
        self.AppDelegate.moveToLogInVC()
    }
    @IBAction func noBtn_action(_ sender: Any) {
          self.popUpView.removeFromSuperview()
    }
}

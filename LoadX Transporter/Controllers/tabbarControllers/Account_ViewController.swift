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
        showAlertView(question: "Are you sure you want to log out?")
    }

    func showAlertView(question: String) {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = R.image.logout_popup_icon()
        aView.imageView.tintColor = R.color.mehroonColor()
        aView.question.text = question
        aView.ensure.text = ""
        aView.sendPaymentLinkHeight.constant = 0
        
        aView.yesCall = {[weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            let userDefaults = UserDefaults.standard
               userDefaults.set(false, forKey: "userLoggedIn")
               userDefaults.removeObject(forKey: "user_id")
               userDefaults.removeObject(forKey: "user_name")
               userDefaults.removeObject(forKey: "user_email")
               userDefaults.removeObject(forKey: "userPass")
               userDefaults.removeObject(forKey: "user_phone")
               userDefaults.removeObject(forKey: "user_image")
               userDefaults.removeObject(forKey: "user_type")
            userDefaults.removeObject(forKey: "is_comp_driver")
            userDefaults.removeObject(forKey: "isLoadxDriver")

            userDefaults.synchronize()
               user_id = nil
               user_name = nil
               user_email = nil
               GIDSignIn.sharedInstance().signOut()
               
               self.manager.logOut()
               FBSDKAccessToken.setCurrent(nil)
               FBSDKProfile.setCurrent(nil)
           self.AppDelegate.moveToLogInVC()
        }
        
        aView.noCall = { (_) in
            aView.removeFromSuperview()
        }
        
        self.view.addSubview(aView)
    }
}

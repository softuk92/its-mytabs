//
//  ForgotPasswordViewControllerPk.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 30/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForgetPasswordControllerPk: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var sendRequest: UIButton!
    @IBOutlet weak var signUp_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUp_action(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterViewControllerPk") as? RegisterViewControllerPk
           self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        forgetPassword()
    }
    
    func forgetPassword() {
        SVProgressHUD.show(withStatus: "Sending details...")
        if self.phoneNumber.text != "" {
            let forgetPassword_URL = main_URL+"api/forgetPasswordReset"
            let parameters : Parameters = ["phone" : self.phoneNumber.text!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(forgetPassword_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("login jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        
                        if result == "false" && message == "All fields are required." {
                            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            
                            let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "SuccessVC") as? SuccessVC
                        self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Error \(response.result.error!)")
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error!", message: "Please enter your email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}



//
//  ForgetPasswordController.swift
//  CTSmove
//
//  Created by Fahad Baigh on 3/31/18.
//  Copyright © 2018 Fahad Inco. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForgetPasswordController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sendRequest: UIButton!
    @IBOutlet weak var signUp_btn: UIButton!
    
//    let yourAttributes: [NSAttributedString.Key: Any] = [
//        .font: UIFont.init(name: "Montserrat-Light", size: 17)!,
//         .foregroundColor: UIColor.systemBlue,
//         .underlineStyle: NSUnderlineStyle.single.rawValue]

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "Forget Password"
       // let attributeString = NSMutableAttributedString(string: "Sign Up", attributes: yourAttributes)
                    
          //     signUp_btn.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func RememberPass_action(_ sender: Any) {

    self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func signUp_action(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
           self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        forgetPassword()
    }
    
    func forgetPassword() {
        SVProgressHUD.show(withStatus: "Sending details...")
        if self.email.text != "" {
            let forgetPassword_URL = main_URL+"api/forgetPasswordReset"
            let parameters : Parameters = ["email" : self.email.text!]
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
                            let alert = UIAlertController(title: "Alert", message: "Email is incorrect.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgetPass_SuccessController") as? SuccessController
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


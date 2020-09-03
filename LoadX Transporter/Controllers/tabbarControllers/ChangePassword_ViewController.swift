//
//  ChangePassword_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 12/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import IBAnimatable
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ChangePassword_ViewController: UIViewController {

    @IBOutlet weak var old_password_txt: AnimatableTextField!
    @IBOutlet weak var new_password_txt: AnimatableTextField!
    @IBOutlet weak var confrom_password_text: AnimatableTextField!
    @IBOutlet weak var oldPass_btn: UIButton!
    @IBOutlet weak var newPass_btn: UIButton!
    @IBOutlet weak var confromPass_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userPassword = UserDefaults.standard.value(forKey: "userPass") as? String {
        old_password_txt.text = userPassword
        }
        
    }
    @IBAction func oldPassword_hideaction(_ sender: Any) {
        if old_password_txt.isSecureTextEntry == true {
        oldPass_btn.setBackgroundImage(UIImage(named: "password_Hide"), for: .normal)
        old_password_txt.isSecureTextEntry = false
        } else {
        oldPass_btn.setBackgroundImage(UIImage(named: "password_unHide"), for: .normal)
        old_password_txt.isSecureTextEntry = true
        }
    }
    @IBAction func new_pass_hideAction(_ sender: Any) {
        if new_password_txt.isSecureTextEntry == true {
        newPass_btn.setBackgroundImage(UIImage(named: "password_Hide"), for: .normal)
        new_password_txt.isSecureTextEntry = false
        } else {
        newPass_btn.setBackgroundImage(UIImage(named: "password_unHide"), for: .normal)
        new_password_txt.isSecureTextEntry = true
        }
    }
    @IBAction func repeatNewpass_action(_ sender: Any) {
        if confrom_password_text.isSecureTextEntry == true {
        confromPass_btn.setBackgroundImage(UIImage(named: "password_Hide"), for: .normal)
        confrom_password_text.isSecureTextEntry = false
        } else {
        confromPass_btn.setBackgroundImage(UIImage(named: "password_unHide"), for: .normal)
        confrom_password_text.isSecureTextEntry = true
        }
    }
    
    @IBAction func updatePassword_action(_ sender: Any) {
        updatePassword()
    }
    
    func updatePassword() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if self.old_password_txt.text != "" && self.new_password_txt.text != "" && self.confrom_password_text.text != "" {
        if self.new_password_txt.text == self.confrom_password_text.text {
            let updatePaswordData_URL = main_URL+"api/transporterUpdatePasswordData"
            let parameters : Parameters = ["password" : self.new_password_txt.text!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updatePaswordData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Password jsonData is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                        if result == "1" {
                            SVProgressHUD.showSuccess(withStatus: "Password Updated Successfully")
                            self.old_password_txt.text = self.new_password_txt.text
                            self.new_password_txt.text = ""
                            self.confrom_password_text.text = ""
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
            let alert = UIAlertController(title: "Alert", message: "Passwords do not match", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }else{
             SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert", message: "Please Enter all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func oldPassword_action(_ sender: Any) {
    }
    @IBAction func NewPassword_hideBtn_action(_ sender: Any) {
    }
    @IBAction func RepeatNewPass_action(_ sender: Any) {
    }
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

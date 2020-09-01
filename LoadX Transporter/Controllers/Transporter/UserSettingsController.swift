//
//  UserSetting.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 4/29/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import IBAnimatable
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleMaps
import GooglePlaces

class UserSettingsController: UIViewController {
    
    @IBOutlet weak var fullName: AnimatableTextField!
    @IBOutlet weak var email: AnimatableTextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    var emailNotification = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Account Settings"
        showProfile()
    }
    
    func showProfile() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let editProfileData_URL = main_URL+"api/getTransporterProfileDetail"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(editProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("edit Profile jsonData is \(jsonData)")
                        self.fullName.text = jsonData[0]["user_name"].stringValue
                        self.email.text = jsonData[0]["user_email"].stringValue
                        let emailNotif = jsonData[0]["email_notification"].stringValue
                        if emailNotif == "0" {
                            self.notificationSwitch.isOn = true
                        } else {
                            self.notificationSwitch.isOn = false
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
            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deactivateAccount(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Deactivate!", message: "Are you sure, you want to deactivate your account?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.deactiveAccountFunc()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func deactiveAccountFunc() {
        SVProgressHUD.show(withStatus: "Deactivating...")
        if user_id != nil {
            let updateProfile_URL = main_URL+"api/UserDeactiveAccount"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateProfile_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        if result == "1" {
                            let storyboardVC = UIStoryboard(name: "Main", bundle: nil)
                            let showVC = storyboardVC.instantiateViewController(withIdentifier: "homeScreen") as! UINavigationController
                            self.present(showVC, animated: true, completion: nil)
                            
                        } else {
                            SVProgressHUD.showError(withStatus: message)
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
            
        }
    }
    
    @IBAction func updateEmailNotification(_ sender: Any) {
        if notificationSwitch.isOn {
            emailNotification = "ON"
            emailNotificationFunc()
        } else {
            emailNotification = "OFF"
            emailNotificationFunc()
        }
    }
    
    func emailNotificationFunc() {
       
    SVProgressHUD.show(withStatus: "Updatig settings...")
    if user_id != nil {
    let emailNotification_URL = main_URL+"api/UserNotificationSettingUpdate"
        let parameters : Parameters = ["user_id" : user_id!, "emailNotification" : emailNotification]
    if Connectivity.isConnectedToInternet() {
    Alamofire.request(emailNotification_URL, method : .post, parameters : parameters).responseJSON {
    response in
    if response.result.isSuccess {
    SVProgressHUD.dismiss()
    
    let jsonData : JSON = JSON(response.result.value!)
    print("email notification jsonData is \(jsonData)")
        let result = jsonData[0]["result"].stringValue
        let message = jsonData[0]["message"].stringValue
        if result == "1" {
            SVProgressHUD.showSuccess(withStatus: message)
        } else {
            SVProgressHUD.showError(withStatus: message)
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
    
    }
    } else {
    SVProgressHUD.dismiss()
    
    }
    }

}


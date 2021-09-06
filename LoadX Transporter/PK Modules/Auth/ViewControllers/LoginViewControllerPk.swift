//
//  LoginViewControllerPk.swift
//  LoadX Transporter
//
//  Created by Muhammad Fahad Baig on 13/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginViewControllerPk: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forget_btn: UIButton! // textcolor 404040
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var signUp_btn: UIButton!
    @IBOutlet weak var updateView: UIView!
    
    let date = Date()
    let calendar = Calendar.current
    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        checkForUpdate()
        
//        phoneNumber.text = "03125656256"
//        password.text = "12345"
    }
    
    func checkForUpdate() {
        let components = calendar.dateComponents(
            [.year, .month, .day], from: date)
    
        let month = components.month
        let day = components.day
        
        if (month == 4 && day! <= 30) || (month == 5 && day! < 30) {
            
            
        } else {
            DispatchQueue.global().async {
                do {
                let update = try self.isUpdateAvailable()
                    DispatchQueue.main.async {
                        if update == true {
                                self.updateView.isHidden = false
                        } else {
                            self.updateView.isHidden = true
                        }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
    }
        
    //MARK: - Version Update Func
   /***************************************************************/

        func isUpdateAvailable() throws -> Bool {
    
            guard let info = Bundle.main.infoDictionary,
                let currentVersion = info["CFBundleShortVersionString"] as? String,
                let identifier = info["CFBundleIdentifier"] as? String,
                let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                    throw VersionError.invalidBundleInfo
            }
    
    
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                throw VersionError.invalidResponse
            }
            if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                print("previous version is \(version) && current version is \(currentVersion)")
                let  DeviceCurrentVersion = Float(currentVersion) ?? 0.0
                let  appStoreVersion = Float(version) ?? 0.0
    
                return DeviceCurrentVersion > appStoreVersion
    //            return version != currentVersion
            }
            throw VersionError.invalidResponse
        }

    @IBAction func logIn(_ sender: Any) {
        userLogin()
    }
    
    func userLogin() {
        SVProgressHUD.show(withStatus: "Signing In...")
        if phoneNumber.text != "" && password.text != "" {
            AuthAPIs.login(phone: phoneNumber.text ?? "", password: password.text ?? "") { (data, json, error) in
                guard let jsonData = json, error == nil else { SVProgressHUD.dismiss(); showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self); return }
                print("json userData \(jsonData)")
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
                    userDefaults.set(self.password.text ?? "", forKey: "userPass")
                    userDefaults.set(user_phone, forKey: "user_phone")
                    userDefaults.set(user_image, forKey: "user_image")
                    userDefaults.set(user_type, forKey: "user_type")
                        userDefaults.set(isLoadxDriver, forKey: "isLoadxDriver")
                    userDefaults.set(true, forKey: "userLoggedIn")
                    userDefaults.synchronize()
                        
                    let accountTitle = jsonData[0]["account_title"].string ?? ""
                        let accountIban = jsonData[0]["account_iban"].string ?? ""
                        let bankName = jsonData[0]["bank_name"].string ?? ""
                        let branchCode = jsonData[0]["branch_code"].string ?? "" 
                  
                        AppUtility.shared.bankMO = BankMO.init(accountTitle: accountTitle, accountIban: accountIban, bankName: bankName, branchCode: branchCode)
                        self.AppDelegate.moveToHome()
            }
                }
                }
        }
    }
        
    @IBAction func signUp_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewControllerPk") as! RegisterViewControllerPk
              self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forget_pass_action(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordControllerPk") as! ForgetPasswordControllerPk
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updateApp(_ sender: Any) {
        rateApp { (sucess) in
            print(sucess)
        }
    }
    
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1458875857?mt=8") else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

}

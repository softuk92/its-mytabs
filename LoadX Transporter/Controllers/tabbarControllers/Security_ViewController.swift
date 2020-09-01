//
//  Security_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 04/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class Security_ViewController: UIViewController {

    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var logo_popupView: UIView!
    
    let storyboardVC = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func DeactiviteAccount_action(_ sender: Any) {
   
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
            })
    
    }
    @IBAction func noBtn_action(_ sender: Any) {
         self.popUpView.removeFromSuperview()
    }
    @IBAction func yesBtn_action(_ sender: Any) {
         deactiveAccountFunc()
    }
    
    @IBAction func changePassword_action(_ sender: Any) {
        
        let showVC = storyboardVC.instantiateViewController(withIdentifier: "ChangePassword_ViewController") as! ChangePassword_ViewController
        self.navigationController?.pushViewController(showVC, animated: true)
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
                            let showVC = self.storyboardVC.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
            let alert = UIAlertController(title: "Error", message: "Please enter your username", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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

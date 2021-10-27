//
//  BookedJobsFunctions.swift
//  LoadX Transporter
//
//  Created by CTS Move on 18/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import SDWebImage
import DropDown
import IBAnimatable
import GoogleMaps
import GooglePlaces
import CoreLocation

extension SearchBookedJobs {
    func bookedJobFunc() {
        SVProgressHUD.show(withStatus: "Please wait...")
        if user_id != nil && del_id != nil && user_email != nil {
            let forgetPassword_URL = main_URL+"api/GetBookedJob"
            let parameters : Parameters = ["user_id" : user_id!, "user_email" : user_email!, "del_id" : del_id!]
            Alamofire.request(forgetPassword_URL, method : .post, parameters : parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    
                    let jsonData : JSON = JSON(response.result.value!)
                    print("booked job jsonData is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                    let message = jsonData[0]["message"].stringValue
                    
                    if result == "false" && message == "All fields are required." {
                        self.present(showAlert(title: "Alert", message: "Email is incorrect."), animated: true, completion: nil)
                    } else {
                        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
                        self.blurView?.effect = blurEffect
                        
                        for subview in self.view.subviews {
                            if subview is UIVisualEffectView {
                                subview.removeFromSuperview()
                            }
                        }
                        self.popUpView.removeFromSuperview()
                        self.popUpView2.removeFromSuperview()
//                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "jobBooked_successController") as? SuccessController
//                        vc?.goToBookedJobs = true
//                        self.navigationController?.pushViewController(vc!, animated: true)
                        self.tabBarController?.selectedIndex = 0
                    }
                } else {
                    SVProgressHUD.dismiss()
                    self.present(showAlert(title: "Alert", message: response.error?.localizedDescription ?? ""), animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            self.present(showAlert(title: "Error!", message: "Please enter your email address"), animated: true, completion: nil)
        }
    }
    
    func bookedJobFunc2() {
        SVProgressHUD.show(withStatus: "Please wait...")
        if user_id != nil && del_id != nil && user_email != nil && unique_id.text != "" {
            let forgetPassword_URL = main_URL+"api/GetBookedJob"
            let parameters : Parameters = ["user_id" : user_id!, "user_email" : user_email!, "del_id" : del_id!, "uniq_id" : self.unique_id.text!]
            Alamofire.request(forgetPassword_URL, method : .post, parameters : parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    
                    let jsonData : JSON = JSON(response.result.value!)
                    print("booked job jsonData is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                    let message = jsonData[0]["message"].stringValue
                    
                    if result == "0" || message == "All fields are required." {
                        self.present(showAlert(title: "Alert", message: message), animated: true, completion: nil)
                    } else {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "jobBooked_successController") as? SuccessController
                        vc?.goToBookedJobs = true
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                } else {
                    SVProgressHUD.dismiss()
                    self.present(showAlert(title: "Alert", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            self.present(showAlert(title: "Error!", message: "Please enter unique id..."), animated: true, completion: nil)
        }
    }
}

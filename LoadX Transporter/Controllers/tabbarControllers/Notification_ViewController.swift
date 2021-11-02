//
//  Notification_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 04/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import RxSwift

class Notification_ViewController: UIViewController {
   
    @IBOutlet weak var emailSwitch_btn: UISwitch!
    @IBOutlet weak var mobileSwitch_btn: UISwitch!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var emailSwitch: CustomUISwitch!
    @IBOutlet weak var mobile_switch: CustomUISwitch!
    
    @IBOutlet weak var email_popupView_lbl: UILabel!
    @IBOutlet weak var mobile_popup_lbl: UILabel!
    
    @IBOutlet var email_popupView: UIView!
    @IBOutlet var mobilePopup_view: UIView!
    @IBOutlet weak var innerview_popup: UIView!
    @IBOutlet weak var innerview_popup1: UIView!
    
    var emailNotification = UserDefaults.standard.string(forKey: "emailSwitch")
    var mobileNotification = UserDefaults.standard.string(forKey: "MobileSwitch")
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.innerview_popup.clipsToBounds = true
        self.innerview_popup.layer.cornerRadius = 18
        self.innerview_popup.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
       
        self.innerview_popup1.clipsToBounds = true
        self.innerview_popup1.layer.cornerRadius = 18
        self.innerview_popup1.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        emailSwitch_btn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                    
        mobileSwitch_btn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        emailSwitch.configureGesture()
        mobile_switch.configureGesture()
        
        if UserDefaults.standard.bool(forKey: "emailSwitch") == true {
            emailSwitch.switchState.accept(true)
        }else{
            emailSwitch.switchState.accept(false)
        }
        
        if UserDefaults.standard.bool(forKey: "MobileSwitch") == true {
            mobile_switch.switchState.accept(true)
        }else{
            mobile_switch.switchState.accept(false)
        }
        
        emailSwitch.switchState.skip(1).subscribe(onNext: {[weak self] (value) in
            guard let self = self else { return }
            if value {
                UserDefaults.standard.set(value, forKey: "emailSwitch")
                self.emailNotificationFunc()
                //setObject
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.email_popupView.layer.borderColor = UIColor.gray.cgColor
//                    self.email_popupView.layer.borderWidth = 1
//                    self.email_popupView.layer.cornerRadius = 18
//                    self.mainView.alpha = 0.5
//                    self.email_popupView_lbl.text = "Do you want to enable email notifications?"
//                    self.view.addSubview(self.email_popupView)
//                    self.email_popupView.center = self.view.center
//                })
            } else {
                UserDefaults.standard.set(value, forKey: "emailSwitch")
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.email_popupView.layer.borderColor = UIColor.gray.cgColor
//                    self.email_popupView.layer.borderWidth = 1
//                    self.email_popupView.layer.cornerRadius = 18
//                    self.mainView.alpha = 0.5
//                    self.email_popupView_lbl.text = "Do you want to disable email notifications?"
//                    self.view.addSubview(self.email_popupView)
//                    self.email_popupView.center = self.view.center
//                })
            }
        }).disposed(by: disposeBag)
        
        mobile_switch.switchState.skip(1).subscribe(onNext: {[weak self] (value) in
            guard let self = self else { return }
            if value {
                UserDefaults.standard.set(value, forKey: "MobileSwitch")
                   
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.mobilePopup_view.layer.borderColor = UIColor.gray.cgColor
//                    self.mobilePopup_view.layer.borderWidth = 1
//                    self.mobilePopup_view.layer.cornerRadius = 18
//                    self.mainView.alpha = 0.5
//                    self.mobile_popup_lbl.text = "Do you want to enable mobile notifications?"
//                    self.view.addSubview(self.mobilePopup_view)
//                    self.mobilePopup_view.center = self.view.center
//                        })
                }else{
                UserDefaults.standard.set(value, forKey: "MobileSwitch")
                       
//                UIView.animate(withDuration: 0.3, animations: {
//                           self.mobilePopup_view.layer.borderColor = UIColor.gray.cgColor
//                           self.mobilePopup_view.layer.borderWidth = 1
//                           self.mobilePopup_view.layer.cornerRadius = 18
//                           self.mainView.alpha = 0.5
//                           self.mobile_popup_lbl.text = "Do you want to disable mobile notifications?"
//                           self.view.addSubview(self.mobilePopup_view)
//                           self.mobilePopup_view.center = self.view.center
//                       })
                   }
        }).disposed(by: disposeBag)
        
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }

   @IBAction func email_btn(_ sender: Any) {
//    if self.emailSwitch.curState == .L {
//            emailNotification = "ON"
//            UserDefaults.standard.set(emailNotification, forKey: "emailSwitch") //setObject
//             UIView.animate(withDuration: 0.3, animations: {
//                        self.email_popupView.layer.borderColor = UIColor.gray.cgColor
//                        self.email_popupView.layer.borderWidth = 1
//                        self.email_popupView.layer.cornerRadius = 18
//                        self.mainView.alpha = 0.5
//                self.email_popupView_lbl.text = "Do you want to enable email notification?"
//                        self.view.addSubview(self.email_popupView)
//                        self.email_popupView.center = self.view.center
//             })
//
//        }else{
//            emailNotification = "OFF"
//            UserDefaults.standard.set(emailNotification, forKey: "emailSwitch")
//            UIView.animate(withDuration: 0.3, animations: {
//                self.email_popupView.layer.borderColor = UIColor.gray.cgColor
//                self.email_popupView.layer.borderWidth = 1
//                self.email_popupView.layer.cornerRadius = 18
//                self.mainView.alpha = 0.5
//                self.email_popupView_lbl.text = "Do you want to disable email notification?"
//                self.view.addSubview(self.email_popupView)
//                self.email_popupView.center = self.view.center
//            })
//
//        }
    }
    
    @IBAction func mobileNotification_action(_ sender: Any) {
//        if self.mobile_switch.curState == .L {
//            mobileNotification = "ON"
//             UserDefaults.standard.set(mobileNotification, forKey: "MobileSwitch")
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.mobilePopup_view.layer.borderColor = UIColor.gray.cgColor
//                self.mobilePopup_view.layer.borderWidth = 1
//                self.mobilePopup_view.layer.cornerRadius = 18
//                self.mainView.alpha = 0.5
//                self.mobile_popup_lbl.text = "Do you want to enable mobile notification?"
//                self.view.addSubview(self.mobilePopup_view)
//                self.mobilePopup_view.center = self.view.center
//                    })
//
//            }else{
//             mobileNotification = "OFF"
//             UserDefaults.standard.set(mobileNotification, forKey: "MobileSwitch")
//
//            UIView.animate(withDuration: 0.3, animations: {
//                       self.mobilePopup_view.layer.borderColor = UIColor.gray.cgColor
//                       self.mobilePopup_view.layer.borderWidth = 1
//                       self.mobilePopup_view.layer.cornerRadius = 18
//                       self.mainView.alpha = 0.5
//                       self.mobile_popup_lbl.text = "Do you want to disable mobile notification?"
//                       self.view.addSubview(self.mobilePopup_view)
//                       self.mobilePopup_view.center = self.view.center
//                   })
//               }
    }
    
    @IBAction func emailPopup_yesAction(_ sender: Any) {
            emailNotificationFunc()
            self.mainView.alpha = 1
            self.email_popupView.removeFromSuperview()
    }
    @IBAction func emailPopup_no(_ sender: Any) {
            self.mainView.alpha = 1
            self.email_popupView.removeFromSuperview()
    }
    
    @IBAction func mobilePopup_no(_ sender: Any) {
            self.mainView.alpha = 1
            self.mobilePopup_view.removeFromSuperview()
    }
    
    @IBAction func mobilePopup_yes(_ sender: Any) {
        self.mainView.alpha = 1
        self.mobilePopup_view.removeFromSuperview()
        
        let alert = UIAlertController(title: "", message: "Mobile notification updated.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func emailNotificationFunc() {
        SVProgressHUD.show(withStatus: "Please wait...")
        if user_id != nil {
            let updateNotification_URL = main_URL+"api/UserNotificationSettingUpdate"
            let parameters : Parameters = ["user_id" : user_id!, "emailNotification" : emailNotification ?? ""]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateNotification_URL, method : .post, parameters : parameters).responseString {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        //let message = jsonData[0]["message"].stringValue
//                        if result == "1" {
                            let alert = UIAlertController(title: "", message: "Email notification updated.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
//                        } else {
//                            SVProgressHUD.showError(withStatus: "Email Notification Not Updated!")
//                        }
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
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
}
//extension Notification_ViewController: LabelSwitchDelegate{
//
//       func switchChangToState(sender: LabelSwitch) {
//        if sender == emailSwitch  {
//        if sender.curState == .L {
//
//        print("left state........ this is notificatin  (ON State)")
//        self.emailSwitch.circleColor = .init(hexString: "#039846")
//        self.emailSwitch.layer.borderWidth = 0.5
//        self.emailSwitch.layer.borderColor = UIColor.gray.cgColor
////                 self.emailSwitch.backgroundColor = .init(hexString: "#296013")
//            email_btn(sender)
//
//    }else{
//
//                   print("Right side ........ this is notificatin  (Off State)")
////                   self.emailSwitch.backgroundColor = .green
//                   self.emailSwitch.circleColor = .init(hexString: "#AAAAAA")
//                   self.emailSwitch.layer.borderWidth = 0.5
//                   self.emailSwitch.layer.borderColor = UIColor.gray.cgColor
//                    email_btn(sender)
//             emailSwitch_btn.isOn = false
//           }
//
//        }else {
//            if sender.curState == .L {
//                         print("MObile notification off state going to ON state")
//                self.mobile_switch.circleColor = .init(hexString: "#039846")
//        //                 self.mobile_switch.backgroundColor = .init(hexString: "#296013")
//
//                mobileNotification_action(sender)
//            }else{
//                         print("left state((on state) going to OFF state")
//        //                 self.mobile_switch.backgroundColor = .green
//                self.mobile_switch.circleColor = .init(hexString: "#AAAAAA")
//                self.mobile_switch.layer.borderWidth = 0.5
//                self.mobile_switch.layer.borderColor = UIColor.gray.cgColor
//                mobileNotification_action(sender)
//                mobileSwitch_btn.isOn = false
//            }
//        }
//    }
//
//}

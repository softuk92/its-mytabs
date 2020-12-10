//
//  jobCancel_ViewController.swift
//  LoadX Transporter
//
//  Created by AIR BOOK on 15/08/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import KMPlaceholderTextView
import RxSwift

class jobCancel_ViewController: UIViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var jobCancelReason1: UILabel!
    @IBOutlet weak var jobCancelReason2: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var jb_id: String?
    var lr_id: String?
    var isCancel: Bool = true
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.cornerRadius = 20
        self.textView.isEditable = true
        
        backBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        checkStatus()
    }
    
    func checkStatus() {
        if isCancel {
            textView.placeholder = "Please let us know the reason for canceling the job"
            jobCancelReason1.text = "Job Cancel Reason"
            jobCancelReason2.text = "Job Cancel Reason"
        } else {
            textView.placeholder = "Please let us know the reason for canceling the route"
            jobCancelReason1.text = "Route Cancel Reason"
            jobCancelReason2.text = "Route Cancel Reason"
        }
    }
    @IBAction func submit_action(_ sender: Any) {
        if isCancel {
        deleteBtn()
        } else {
            cancelRoute()
        }
    }
    
        func deleteBtn() {
            guard !textView.text.isEmpty else { return self.present(showAlert(title: "Alert", message: "Please enter cancel reason"), animated: true, completion: nil)}
            SVProgressHUD.show(withStatus: "Cancelling Job...")
//            if user_id != nil && jb_id != nil && !textView.text.isEmpty {
                let updateBid_URL = main_URL+"api/transporterCancelJobData"
            let parameters : Parameters = ["jb_id" : jb_id!, "user_id" : user_id!, "reason_to_cancel" : textView.text!]
                if Connectivity.isConnectedToInternet() {
                    Alamofire.request(updateBid_URL, method : .post, parameters : parameters).responseJSON {
                        response in
                        if response.result.isSuccess {
                            SVProgressHUD.dismiss()
                            
                            let jsonData : JSON = JSON(response.result.value!)
                            print("cancelling job jsonData is \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            let message = jsonData[0]["message"].stringValue
                            if result == "1" {
    //                            self.performSegue(withIdentifier: "cancel", sender: self)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "cancelledJob") as! SuccessController
                                       self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
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
//            } else {
//                SVProgressHUD.dismiss()
//                let alert = UIAlertController(title: "Error!", message: "Please enter Reason of cancellation", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
        }
    
    func cancelRoute() {
        guard textView.text != "" else { return self.present(showAlert(title: "Alert", message: "Please enter cancel reason"), animated: true, completion: nil)}
        APIManager.apiPost(serviceName: "api/cancelRoute", parameters: ["lr_id" : lr_id ?? "", "user_id" : user_id!, "reason_to_cancel" : textView.text!]) { (data, json, error) in
            if error != nil {
                
            }
            let result = json?[0]["result"].stringValue
            let message = json?[0]["message"].stringValue
            if result == "1" {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RouteCancelled") as? SuccessController {
                       self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

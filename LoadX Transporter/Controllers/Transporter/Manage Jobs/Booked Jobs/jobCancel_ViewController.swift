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

class jobCancel_ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var jb_id: Int?
    var user_id: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.cornerRadius = 20
        self.textView.isEditable = true
        
        // Do any additional setup after loading the view.
    }
    @IBAction func submit_action(_ sender: Any) {
        deleteBtn()
    }
    
        func deleteBtn() {
            SVProgressHUD.show(withStatus: "Cancelling Job...")
            if user_id != nil && jb_id != nil && textView.text != "" {
                let updateBid_URL = main_URL+"api/transporterCancelJobData"
                let parameters : Parameters = ["jb_id" : jb_id!, "user_id" : user_id!, "reason_to_cancel" : textView.text]
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
                let alert = UIAlertController(title: "Error!", message: "Please enter Reason of cancellation", preferredStyle: UIAlertController.Style.alert)
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

        //
//  ReportAProblem.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/4/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable
import DropDown

class ReportAProblem: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var selectCategory: AnimatableTextField!
    @IBOutlet weak var categoryDropDown: UIView!
    @IBOutlet weak var job_id: AnimatableTextField!
    @IBOutlet weak var problem: AnimatableTextView!
    @IBOutlet weak var jobId_View: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var jobID_height: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    var categoryDataSource = ["Account Update", "Issue With Job Payment", "Issue With Job", "Report User", "Security Settings", "Others"]
    let dropDown1 = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.isHidden = true
        innerView.layer.cornerRadius = 15
        tableView.register(UINib(nibName: "DropDownViewCell", bundle: nil) , forCellReuseIdentifier: "DropDownViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.jobID_height.constant = 0
        self.title = "Need Any Help?"
        self.jobId_View.isHidden = true
        selectCategory.delegate = self
    
        problem.delegate = self
//        problem.text = "Please let us know the problem you face in detail..."
//        problem.textColor = UIColor.lightGray
//
        //DarkMode()
    }
    
    func DarkMode(){
        if switchCheck == true {
        self.selectCategory.backgroundColor = UIColor(hexString: "252A2D")
        self.job_id.backgroundColor = UIColor(hexString: "252A2D")
        self.problem.backgroundColor = UIColor(hexString: "252A2D")
        self.selectCategory.textColor = UIColor.white
        self.job_id.textColor = UIColor.white
        self.problem.textColor = UIColor.white
        
        dropDown1.backgroundColor = UIColor.black
        dropDown1.textColor = UIColor.white
        
        submitBtn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        
        arrowImage.image = UIImage(named: "arrowupDark")
        }else{
            
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if problem.textColor == UIColor.lightGray {
            problem.text = nil
            problem.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if problem.text.isEmpty {
            problem.text = "Please let us know the problem you face in detail..."
            problem.textColor = UIColor.lightGray
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectCategory {
            self.blurView.isHidden = false
            view.endEditing(true)
        }
    }
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        reportAProblemFunc()
    }
    
    func reportAProblemFunc() {
        SVProgressHUD.show(withStatus: "...")
        if self.selectCategory.text != "" && self.problem.text != "" {
            let reportProblem_URL = main_URL+"api/transporterAddReportAProblemData"
            let parameters : Parameters = ["category" : self.selectCategory.text!, "pdescription" : self.problem.text!, "userid" : user_id!, "jobid" : self.job_id.text!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(reportProblem_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("report problem jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        if result == "1" {
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "query") as? SuccessController
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
            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension ReportAProblem: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.blurView.isHidden = true
        self.selectCategory.text = categoryDataSource[indexPath.row]
        if indexPath.row == 1 || indexPath.row == 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.jobId_View.isHidden = false
                self.jobID_height.constant = 100
                
                let alert = UIAlertController(title: "", message: "You can find your Job ID on job detail page.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.job_id.becomeFirstResponder()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.jobId_View.isHidden = true
                self.jobID_height.constant = 0
                self.problem.becomeFirstResponder()
//                self.job_id.becomeFirstResponder()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
        
extension ReportAProblem: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownViewCell") as! DropDownViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        cell.label.text = categoryDataSource[indexPath.row]
        
        return cell
    }
    
}

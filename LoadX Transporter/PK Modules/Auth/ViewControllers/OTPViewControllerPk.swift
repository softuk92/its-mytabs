//
//  OTPViewControllerPk.swift
//  LoadX Transporter
//
//  Created by Muhammad Fahad Baig on 13/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import SVProgressHUD
import IBAnimatable
import GoogleMaps
import GooglePlaces
import SKPhotoBrowser
import MobileCoreServices
import OTPFieldView

class OTPViewControllerPk: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var sentToNumber: UILabel!
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    
    var otpNumber: String?
    var dismissCallBack: ((Bool) -> Void)?
    var phoneNumber: String?
    var otpEntered: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "OTP"
        setupOtpView()
        
        if let phoneNumber = phoneNumber {
            sentToNumber.text = "Sent to \(phoneNumber)"
        }
    }
    
    func setupOtpView(){
            self.otpTextFieldView.fieldsCount = 4
            self.otpTextFieldView.fieldBorderWidth = 1
            self.otpTextFieldView.defaultBorderColor = UIColor.black
            self.otpTextFieldView.filledBorderColor = UIColor.black
            self.otpTextFieldView.displayType = .square
            self.otpTextFieldView.fieldSize = 60
            self.otpTextFieldView.separatorSpace = 20
            self.otpTextFieldView.shouldAllowIntermediateEditing = false
            self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
        }
    
    @IBAction func submitAct(_ sender: Any) {
        if otpEntered == otpNumber {
            self.dismiss(animated: true) { [weak self] in
                self?.dismissCallBack?(true)
            }
        }
    }
    
    @IBAction func resendCode(_ sender: Any) {
        registerForOTP()
    }
    
    //register function
    func registerForOTP() {
        
        APIManager.apiPost(serviceName: "api/userRegisterAPI", parameters: ["user_number": phoneNumber ?? ""]) { [weak self] (data, json, error) in
            guard error == nil else {showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self!); return }
            guard let self = self else { return }
            
            self.otpNumber = json?[0]["OTP"].stringValue
            showSuccessAlert(question: "OTP Sent Successfully", viewController: self)
        }
    }
    
}

extension OTPViewControllerPk: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        otpEntered = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return false
    }
    
    
}

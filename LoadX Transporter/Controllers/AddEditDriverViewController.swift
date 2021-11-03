//
//  AddEditDriverViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 20/09/2021.
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
import Reusable
class AddEditDriverViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = R.storyboard.manageTransporter()
    
    
    @IBOutlet weak var fullName: AnimatableTextField!
    @IBOutlet weak var email_address: AnimatableTextField!
    @IBOutlet weak var phone_no: AnimatableTextField!
    @IBOutlet weak var van_type: AnimatableTextField!
    @IBOutlet weak var vehicle_reg_no: AnimatableTextField!
    @IBOutlet weak var cnicFrontimage: UIImageView!
    @IBOutlet weak var cnicBackimage: UIImageView!
    
    @IBOutlet weak var cnicFrontBtn: UIButton!
    @IBOutlet weak var cnicBackBtn: UIButton!
    @IBOutlet weak var Registration_btn: UIButton!
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var vehiclesListView: UIView!
    @IBOutlet weak var innerVehiclesListView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!

    var transporterId: String?
    
    var list : [VehiclesMO] = []
    var imageSelector: ImageSelector!
    var cnicImageSelection : Int?
    var driver: ManageDriver?
    var driverDetail:DriverDetail?
    var refreshData: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign Up"
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundView = nil
        tableview.backgroundColor = UIColor.clear
        
        innerVehiclesListView.layer.cornerRadius = 10
        
        AppUtility.shared.getVehiclesList { [weak self] (result) in
            switch result {
            case .success(let vehicles):
                self?.list = vehicles
                self?.tableview.reloadData()
            case .failure(_):
                return
            }
        }
        
        cnicFrontBtn.clipsToBounds = true
        cnicFrontBtn.layer.cornerRadius = 10
        cnicFrontBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cnicBackBtn.clipsToBounds = true
        cnicBackBtn.layer.cornerRadius = 10
        cnicBackBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        imageSelector = ImageSelector()
        imageSelector.delegate = self
        
        var title = ""
        if let driver = driver {
             title = "Update"
            self.titleLabel.text = "Edit Transporter"
            self.setDriver(detail: driver)
            self.fetchTransporterData(model: driver)
            
        }
        else {
             title = "Add Transporter"
            self.titleLabel.text = "Add Transporter"
        }
        self.Registration_btn.setTitle(title, for: .normal)
        
        
    }
    
    
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
        vehiclesListView.isHidden = true
    }
    
    @IBAction private func btnShowPop(_ sender : UIButton) {
        vehiclesListView.isHidden = false
    }
   
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Select Vehicle Drop Down
    /***************************************************************/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == van_type {
            
            self.van_type.rightImage = UIImage(named: "ArrowUp")
            self.view.endEditing(true)
        }
        view.endEditing(true)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phone_no {
            guard let textFieldText = phone_no.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 11
            
        }else{
            
            guard let textFieldText = vehicle_reg_no.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 7
            
        }
    }
    
    
    @IBAction func register_now_btn(_ sender: Any) {
        
        if fullName.text == "" {
            fullName.attributedPlaceholder = NSAttributedString(string: "Please enter full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
  
        if self.phone_no.text == "" || phone_no.text?.count != 11 || (self.phone_no.text?.hasPrefix("0")) != true {
            
            phone_no.attributedPlaceholder = NSAttributedString(string: "Please enter 11 digit number start with 0 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            
        }

        if self.van_type.text == "" {
            van_type.attributedPlaceholder = NSAttributedString(string: "Enter Van Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // SVProgressHUD.showError(withStatus: "Please Enter Van Type ")
        }
        if self.vehicle_reg_no.text == "" {
            vehicle_reg_no.attributedPlaceholder = NSAttributedString(string: "Enter Vehicle Reg.No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // SVProgressHUD.showError(withStatus: "Please Enter Vehicle Reg Number ")
        }
        if fullName.text != "" && phone_no.text != "" && van_type.text != "" && vehicle_reg_no.text != "" {
            if self.driver == nil{
                registerForOTP()
            }
            else {
                self.updateTransporter(detail: self.driverDetail!)
            }
            
        }
        
    }
    
    @IBAction func cnicFrontAct(_ sender: Any) {
        cnicImageSelection = 1
        imageSelector.showOptions(viewController: self)
    }
    
    @IBAction func cnicBackAct(_ sender: Any) {
        cnicImageSelection = 2
        imageSelector.showOptions(viewController: self)
    }
    
    func fetchTransporterData(model: ManageDriver)  {
        let params : Parameters = ["driver_id": model.userID]
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/editTransporterDetail", parameters: params) {[weak self] data,json,error in
            guard let self = self, let data = data else {return}
            let decodedModel = try? JSONDecoder().decode([DriverDetail].self, from: data)
            if let detail = decodedModel?.first {
                self.setDriverDetail(detail: detail)
                self.driverDetail = detail
            }
           
            SVProgressHUD.dismiss()
        }
    }
    func setDriverDetail(detail: DriverDetail) {
        self.fullName.text = detail.userName
        self.email_address.text = detail.userEmail
        self.phone_no.text = detail.userPhone
        self.van_type.text = detail.vanType
        self.vehicle_reg_no.text = detail.truckRegestration
        let cnicFront = main_URL+"public/assets/documents/"+detail.cnicFront
        let cnicBack = main_URL+"public/assets/documents/"+detail.cnicBack
        cnicFrontimage.sd_setImage(with: URL(string: cnicFront), placeholderImage: R.image.signUp_image_upload(), options: .continueInBackground, completed: nil)
        cnicBackimage.sd_setImage(with: URL(string: cnicBack), placeholderImage: R.image.signUp_image_upload(), options: .continueInBackground, completed: nil)
    }
    
    func setDriver(detail: ManageDriver) {
        self.fullName.text = detail.userName.capitalized
        self.email_address.text = detail.userEmail
        self.phone_no.text = detail.userPhone
        self.van_type.text = detail.vanType
        
    }
   // func showDriver(drivir)
    //register function
    func registerForOTP() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/userRegisterAPI", parameters: ["user_number": self.phone_no.text!]) { [weak self] (data, json, error) in
            SVProgressHUD.dismiss()
            guard error == nil else {showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self!); return }
            guard let self = self else { return }
            
            let OtpNumber = json?[0]["OTP"].stringValue
            let registeredUser = json?[0]["register_user"].stringValue
            
            if registeredUser == "0" {
                let vc = OTPViewControllerPk.instantiate()
                vc.otpNumber = OtpNumber
                vc.phoneNumber = self.phone_no.text
                vc.dismissCallBack = { [weak self] (isOTPEntered) in
                    if isOTPEntered{
                        self?.registerTransporter()
                    }
                }
                self.present(vc, animated: true, completion: nil)
            } else {
                showAlert(title: "", message: "User already registered.", viewController: self)
            }
        }
    }
    
    
    
    func registerTransporter() {
        guard let cnicFrontImg = cnicFrontimage.image, let cnicBackImg = cnicBackimage.image else { return }
        let companyId = user_id ?? "-1"
        let parameters = ["company_id":companyId, "tname" : self.fullName.text!, "temail" : self.email_address.text ?? "", "tphone" : self.phone_no.text!, "vantype" : self.van_type.text!, "registration-number" : self.vehicle_reg_no.text!]
        
        SVProgressHUD.show()
        var input = [MultipartData]()
        if let cnicFrontImageData = cnicFrontImg.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 0.5) {
            input.append(MultipartData.init(data: cnicFrontImageData, paramName: "cnic_front", fileName: "cnicFrontImg.jpeg"))
        }
        if let cnicBackImageData = cnicBackImg.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 0.5) {
            input.append(MultipartData.init(data: cnicBackImageData, paramName: "cnic_back", fileName: "cnicBackImg.jpeg"))
        }
        
        APIManager.apiPostMultipart(serviceName: "api/addNewCompanyDriver", parameters: parameters, multipartImages: input) { (data, json, error, progress) in
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error!.localizedDescription, viewController: self)
            }
            if progress != nil {
                SVProgressHUD.showProgress(Float(progress ?? 0), status: "Registering...")
            } else {
                SVProgressHUD.dismiss()
            }
            
            guard let json = json else { return }
            let result = json[0]["result"].stringValue
            let message = json[0]["message"].stringValue
            
            if result == "true" || result == "1" {
                self.refreshData?()
                self.navigationController?.popViewController(animated: true)
             
            } else {
                showAlert(title: "Alert", message: message, viewController: self)
            }
        }
    }
    
    
    func updateTransporter(detail: DriverDetail) {
        guard let cnicFrontImg = cnicFrontimage.image, let cnicBackImg = cnicBackimage.image else { return }
        
        let parameters = ["tname" : self.fullName.text!, "temail" : self.email_address.text ?? "", "tphone" : self.phone_no.text!, "vantype" : self.van_type.text!, "registration-number" : self.vehicle_reg_no.text!, "is_number_verified" : "1", "t_id":detail.userID, "company_id":user_id!]

        SVProgressHUD.show()
        var input = [MultipartData]()
        if let cnicFrontImageData = cnicFrontImg.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 0.5) {
            input.append(MultipartData.init(data: cnicFrontImageData, paramName: "cnic_front", fileName: "cnicFrontImg.jpeg"))
        }
        if let cnicBackImageData = cnicBackImg.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 0.5) {
            input.append(MultipartData.init(data: cnicBackImageData, paramName: "cnic_back", fileName: "cnicBackImg.jpeg"))
        }
        
        APIManager.apiPostMultipart(serviceName: "api/updateTransporterDetailData", parameters: parameters, multipartImages: input) { (data, json, error, progress) in
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error!.localizedDescription, viewController: self)
            }
            if progress != nil {
                SVProgressHUD.showProgress(Float(progress ?? 0), status: "Registering...")
            } else {
                SVProgressHUD.dismiss()
            }
            
            guard let json = json else { return }
            let result = json[0]["result"].stringValue
            let message = json[0]["message"].stringValue
            
            if result == "true" {
                self.refreshData?()
                self.navigationController?.popViewController(animated: true)
            } else {
                showAlert(title: "Alert", message: message, viewController: self)
            }
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func login_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


//MARK: UITableViewDelegate
extension AddEditDriverViewController: UITableViewDataSource , UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobNatureCell", for: indexPath) as? JobNatureCell
        cell?.layer.cornerRadius = 10
        cell?.backgroundColor = UIColor.clear
        cell?.backgroundView = nil
        cell?.lblJobNature.text = self.list[indexPath.row].vehicle_name
        if indexPath.row == 11 {
            cell?.bottomLineView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedValue = list[indexPath.row].vehicle_name
        self.van_type.text = selectedValue
        vehiclesListView.isHidden = true
    }
    
}

extension AddEditDriverViewController: ImageSelectorDelegate {
    
    func imageSelector(didSelectImage image: UIImage?, imgName: String?) {
        if cnicImageSelection == 1 {
            cnicFrontimage.image = image
        } else if cnicImageSelection == 2 {
            cnicBackimage.image = image
        }
    }
    
}

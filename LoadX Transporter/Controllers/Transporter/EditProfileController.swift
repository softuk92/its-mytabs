//
//  EditProfileController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/25/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable
import DropDown
import GoogleMaps
import GooglePlaces
import SDWebImage
import SKPhotoBrowser
import MobileCoreServices

var urlDocument: URL?

class EditProfileController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var parent_view: UIView!
    @IBOutlet weak var fullName: AnimatableTextField!
    @IBOutlet weak var email_address: AnimatableTextField!
    @IBOutlet weak var phone_no: AnimatableTextField!
    @IBOutlet weak var address: AnimatableTextField!
    @IBOutlet weak var van_type: AnimatableTextField!
    @IBOutlet weak var vanType_dropView: UIView!
    @IBOutlet weak var reg_no: AnimatableTextField!
    @IBOutlet weak var about_me: UITextView!
    @IBOutlet weak var current_password: AnimatableTextField!
    @IBOutlet weak var new_password: AnimatableTextField!
    @IBOutlet weak var repeat_new_password: AnimatableTextField!
    @IBOutlet weak var dl_status: UILabel!
    @IBOutlet weak var ic_status: UILabel!
    @IBOutlet weak var licenseDocument: UILabel!
    @IBOutlet weak var insuranceDocument: UILabel!
    @IBOutlet weak var scroolView: UIScrollView!
    
    @IBOutlet weak var myAccount_lbl: UILabel!
    @IBOutlet weak var myaccount_icon: UIImageView!
    @IBOutlet weak var password_icon: UIImageView!
    @IBOutlet weak var password_lbl: UILabel!
    @IBOutlet weak var update_image_icon: UIImageView!
    @IBOutlet weak var update_image_Lbl: UILabel!
    @IBOutlet weak var upadte_Doc_icon: UIImageView!
    @IBOutlet weak var update_doc_lbl: UILabel!
   
    @IBOutlet weak var logo_view: UIView!
    @IBOutlet weak var update_info: UIButton!
    @IBOutlet weak var update_paasword: UIButton!
    @IBOutlet weak var update_documnt: UIButton!
    @IBOutlet weak var update_image: UIButton!
    @IBOutlet weak var contentHight: NSLayoutConstraint!
   
    let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
      
    
    let list = ["Small Van",
    "Medium Van",
    "Large Van",
    "Luton Van",
    "Rubbish Removal Truck",
    "3.5 Ton Vehicle Recovery Truck",
    "7.5 Ton Vehicle Recovery Truck",
    "7.5 Ton Truck",
    "Container Truck",
    "Other"]
    let dropDown1 = DropDown()
    let picker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    private var selectionCategory : Int?
    private var imagePicked = 0
    private var imageData1 : Data?
    private var imageData2 : Data?
    private var imageOne = 0
    private var imageTwo = 0
    private var insurancePicked : Int?
    private var licensePicked : Int?
    var images1 = [SKPhoto]()
    var images2 = [SKPhoto]()
    var docData1 : Data?
    var fileName1 : String?
    var docData2 : Data?
    var fileName2 : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        profileDetail()
            
        email_address.isUserInteractionEnabled = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        van_type.delegate = self
        dropDown1.anchorView = vanType_dropView
        dropDown1.backgroundColor = UIColor.white
        dropDown1.dataSource = list
        
        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.van_type.text = item
            self.reg_no.becomeFirstResponder()
        }
        dropDown1.direction = .bottom
        dropDown1.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
        
        about_me.delegate = self
        about_me.text = "About me"
        about_me.textColor = UIColor.lightGray
    }
    
    func edit_darkMode(){
            if switchCheck == true {
               self.parent_view.backgroundColor = UIColor(hexString: "191D20")
               self.logo_view.backgroundColor = UIColor(hexString: "212528")
               self.fullName.backgroundColor = UIColor(hexString: "252A2D")
               self.email_address.backgroundColor = UIColor(hexString: "252A2D")
               self.phone_no.backgroundColor = UIColor(hexString: "252A2D")
               self.address.backgroundColor = UIColor(hexString: "252A2D")
               self.van_type.backgroundColor = UIColor(hexString: "252A2D")
               self.reg_no.backgroundColor = UIColor(hexString: "252A2D")
               self.about_me.backgroundColor = UIColor(hexString: "252A2D")
                about_me.text = "About me"
                       about_me.textColor = UIColor.lightGray
               self.fullName.textColor = UIColor.white
               self.email_address.textColor = UIColor.white
               self.phone_no.textColor = UIColor.white
               self.address.textColor = UIColor.white
               self.van_type.textColor = UIColor.white
               self.reg_no.textColor = UIColor.white
//               self.about_me.textColor = UIColor.white
               self.dl_status.textColor = UIColor.white
               self.ic_status.textColor = UIColor.white
                
                self.myaccount_icon.image = UIImage(named: "userIconDark")
                self.password_icon.image = UIImage(named: "secuityDark")
                self.upadte_Doc_icon.image = UIImage(named: "uploadDocumentsDark")
                self.update_image_icon.image = UIImage(named: "vanImagesDark")
                self.myAccount_lbl.textColor = UIColor.white
                self.password_lbl.textColor = UIColor.white
                self.update_doc_lbl.textColor = UIColor.white
                self.update_image_Lbl.textColor = UIColor.white
                
               dropDown1.backgroundColor = UIColor.black
               dropDown1.textColor = UIColor.white
               
                update_info.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
               update_paasword.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
               update_documnt.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
               update_image.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
               update_info.setTitleColor(.white, for: .normal)
               update_paasword.setTitleColor(.white, for: .normal)
               update_documnt.setTitleColor(.white, for: .normal)
               update_image.setTitleColor(.white, for: .normal)
            }else{
                about_me.text = "About me"
                about_me.textColor = UIColor.lightGray
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        edit_darkMode()
        self.contentHight.constant = 1200
    }
    
    @IBAction func image1Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images1)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func image2Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images1)
        browser.initializePageIndex(1)
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func image3Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images2)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func image4Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images2)
        browser.initializePageIndex(1)
        present(browser, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         about_me.text = nil
        if about_me.textColor == UIColor.lightGray {
            about_me.text = nil
            if switchCheck == true{
            about_me.textColor = UIColor.white
            }else{
                about_me.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if about_me.text.isEmpty {
            
            about_me.text = "About me"
            about_me.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Select Vehicle Drop Down
    /***************************************************************/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == van_type {
            dropDown1.show()
            self.view.endEditing(true)
        }
    }

    //MARK: - Pickuplocation for UITEXTFIELD
    /***************************************************************/
    
    
    @IBAction func address_btn(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "UK"
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func profileDetail() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let bookedJobs_URL = main_URL+"api/getTransporterProfileDetail"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("transporter Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
//            self.fullName.text = jsonData[0]["user_name"].stringValue
                       
                        if result != "0" {
                        
                        let icStatus = jsonData[0]["ic_status"].stringValue
                        let dlStatus = jsonData[0]["dl_status"].stringValue
                        self.fullName.text = jsonData[0]["user_name"].stringValue
                        self.email_address.text = jsonData[0]["user_email"].stringValue
                            if icStatus == "pending" {
                                self.ic_status.text = "Status: Pending"
                            } else if icStatus == "Approved" {
                                self.ic_status.text = "Status: Approved"
                            } else if icStatus == "Reject" {
                                self.ic_status.text = "Status: Rejected"
                            } else if icStatus == "" {
                                self.ic_status.isHidden = true
                            }
                        
                            if dlStatus == "pending" {
                                self.dl_status.text = "Status: Pending"
                            } else if dlStatus == "Approved" {
                                self.dl_status.text = "Status: Approved"
                            } else if dlStatus == "Reject" {
                                self.dl_status.text = "Status: Rejected"
                            } else if dlStatus == "" {
                                self.dl_status.isHidden = true
                            }
                        
                        self.phone_no.text = jsonData[0]["user_phone"].stringValue
                        self.address.text = jsonData[0]["user_address"].stringValue
                        let vanType = jsonData[0]["van_type"].stringValue
                            if vanType != "" {
                                if vanType == "SWB Van" {
                                    self.van_type.text = "Small Van"
                                } else if vanType == "MWB Van" {
                                    self.van_type.text = "Medium Van"
                                } else if vanType == "LWB Van" {
                                    self.van_type.text = "Large Van"
                                } else {
                                    self.van_type.text = vanType
                                }
                            } else {
                                
                            }
                        self.reg_no.text = jsonData[0]["truck_registration"].stringValue
                        self.about_me.text = jsonData[0]["about_me"].stringValue
                        
                        self.current_password.text = jsonData[0]["user_password"].stringValue
                        }
                        let image1 = jsonData[0]["user_image_url"].stringValue
                        let image2 = jsonData[0]["van_img"].stringValue
                        let image3 = jsonData[0]["copy_insurance"].stringValue
                        let image4 = jsonData[0]["copy_driving_license"].stringValue
                        
                        if image3 == "" && image4 == "" {
                            self.ic_status.isHidden = true
                            self.dl_status.isHidden = true
                        }
                        
                        if image1 != "" {
                                    let urlString = main_URL+"public/assets/user_profile_image/"+image1
                                    if let url = URL(string: urlString) {
                                        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                            //                        print(received, expected)
                                        }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                            if let imageCell = imageReceived {
                                                self.myImage1.image = imageCell
                                                let photo1 = SKPhoto.photoWithImage(imageCell)
                                                self.images1.append(photo1)
                                            }
                                        }
                                    }
                                } else {
                                    let photo1 = SKPhoto.photoWithImage(self.myImage1.image!)
                                    self.images1.append(photo1)
                        }
                                
                                if image2 != "" {
                                    let urlString = main_URL+"public/assets/user_profile_image/"+image2
                                    if let url = URL(string: urlString) {
                                        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                            //                        print(received, expected)
                                        }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                            if let imageCell = imageReceived {
                                                
                                                self.myImage2.image = imageCell
                                                let photo2 = SKPhoto.photoWithImage(imageCell)
                                                self.images1.append(photo2)
                                            }
                                        }
                                    }
                                } else {
                                    let photo2 = SKPhoto.photoWithImage(self.myImage2.image!)
                                    self.images1.append(photo2)
                        }
                        
                        if image3 != "" {
                            let urlString = main_URL+"public/assets/documents/"+image3
                            if let url = URL(string: urlString) {
                                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                    //                        print(received, expected)
                                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                    if let imageCell = imageReceived {
                                        
                                        self.insuranceImage.image = imageCell
                                        let photo3 = SKPhoto.photoWithImage(imageCell)
                                        self.images2.append(photo3)
                                    }
                                }
                            }
                        } else {
                            let photo3 = SKPhoto.photoWithImage(self.insuranceImage.image!)
                            self.images2.append(photo3)
                        }
                        
                        if image4 != "" {
                            let urlString = main_URL+"public/assets/documents/"+image4
                            if let url = URL(string: urlString) {
                                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                    //                        print(received, expected)
                                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                    if let imageCell = imageReceived {
                                        
                                        self.licenseImage.image = imageCell
                                        let photo4 = SKPhoto.photoWithImage(imageCell)
                                        self.images2.append(photo4)
                                    }
                                }
                            }
                        } else {
                            let photo4 = SKPhoto.photoWithImage(self.licenseImage.image!)
                            self.images2.append(photo4)
                        }
                        
                        if self.about_me.text == "" {
                            self.about_me.delegate = self
                            self.about_me.toolbarPlaceholder = "About me..."
                            self.about_me.textColor = UIColor.lightGray
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
            let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    //MARK: - validation of email and username
          /***************************************************************/
          
    func isValidEmail1(testStr:String) -> Bool {
                
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        }
    
    public func validateName(name: String) ->Bool {
       // Length be 18 characters max and 3 characters minimum, you can always modify.
       let nameRegex = "^[A-Za-z]{3,25}$"
       let trimmedString = name.trimmingCharacters(in: .whitespaces)
       let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
       let isValidateName = validateName.evaluate(with: trimmedString)
       return isValidateName
    }
    //MARK: - Upload Profile Data
       /***************************************************************/
       
    @IBAction func updateProfileData(_ sender: Any) {
        
        let isValidateName = validateName(name: fullName.text!)
              
              let temp = self.email_address.text!
              let x = isValidEmail1(testStr: temp)
              
                  if (isValidateName == false) {
                      SVProgressHUD.showError(withStatus: "Enter atleast 3 character UserName & with no Digits")
                      fullName.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                     
                  }else if  x == false {
                  SVProgressHUD.showError(withStatus: "Please Enter Correct email Address")
                                 
                  email_address.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                  
              } else if self.phone_no.text == "" || phone_no.text?.count != 11 && (phone_no.text?.hasPrefix("0"))!{
                  phone_no.attributedPlaceholder = NSAttributedString(string: "Please Enter 11 digit Number start with 0 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                   SVProgressHUD.showError(withStatus: "Please Enter 11 digit Number start with 0 ")
              }else if self.address.text == "" {
                  address.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                   SVProgressHUD.showError(withStatus: "Please Enter Address ")
              }else if self.van_type.text == "" {
                  van_type.attributedPlaceholder = NSAttributedString(string: "Enter Van Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                   SVProgressHUD.showError(withStatus: "Please Enter Van Type ")
              }else if self.reg_no.text == "" {
                  reg_no.attributedPlaceholder = NSAttributedString(string: "Vehicle Reg. No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                   SVProgressHUD.showError(withStatus: "Please Enter Vehicle Reg Number ")
              }else{
                 updateprofileData()
              }

    }
    
    func updateprofileData() {
        SVProgressHUD.show(withStatus: "Getting details...")
        
        if self.fullName.text != "" && self.phone_no.text != "" {
            let updateProfileData_URL = main_URL+"api/transporterUpdateProfileData"
            let parameters : Parameters = ["tname" : self.fullName.text!, "tphone" : self.phone_no.text!, "taddress" : self.address.text!, "vantype" : self.van_type.text!, "registration-number" : self.reg_no.text!, "user_id" : user_id!, "aboutme" : self.about_me.text!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Profle Data jsonData is \(jsonData)")
                      let result = jsonData[0]["result"].stringValue
                        if result == "1" {
                            SVProgressHUD.showSuccess(withStatus: "Profile updated successfully.")
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
    
    //MARK: - Upload password
    /***************************************************************/
    
    @IBAction func updatePassword(_ sender: Any) {
        updatePassword()
    }
    
    func updatePassword() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if self.new_password.text != "" && self.repeat_new_password.text != "" {
        if self.new_password.text == self.repeat_new_password.text {
            let updatePaswordData_URL = main_URL+"api/transporterUpdatePasswordData"
            let parameters : Parameters = ["password" : self.new_password.text!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updatePaswordData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Password jsonData is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                        if result == "1" {
                            SVProgressHUD.showSuccess(withStatus: "Password Updated Successfully")
                            self.current_password.text = self.new_password.text
                            self.new_password.text = ""
                            self.repeat_new_password.text = ""
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
            let alert = UIAlertController(title: "Alert", message: "Passwords do not match", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }else{
             SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert", message: "Please Enter the Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Update images
    //MARK: - Select image function
    /***************************************************************/
    @IBOutlet weak var myImage1: UIImageView!
    @IBOutlet weak var myImage2: UIImageView!
    @IBOutlet weak var licenseImage: UIImageView!
    @IBOutlet weak var insuranceImage: UIImageView!
    
    @IBAction func selectImage1(_ sender: UIButton) {
        imagePick(sender: sender.tag)
    }
    
    @IBAction func selectImage2(_ sender: UIButton) {
        imagePick(sender: sender.tag)
    }
    
    @IBAction func selectImage3(_ sender: UIButton) {
        imagePickWithDocument(sender: sender.tag)
    }
    
    @IBAction func selectImage4(_ sender: UIButton) {
        imagePickWithDocument2(sender: sender.tag)
    }
    
    func imagePickWithDocument(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.insurancePicked = 1
                self.imagePicked = sender
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.insurancePicked = 1
            self.imagePicked = sender
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
//        let documentAction = UIAlertAction(title: "Document", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.insurancePicked = 2
//            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//            importMenu.delegate = self
//            importMenu.modalPresentationStyle = .formSheet
//            self.present(importMenu, animated: true, completion: nil)
//        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
//        optionMenu.addAction(documentAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 800, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickWithDocument2(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicked = sender
                self.licensePicked = 1
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender
            self.licensePicked = 1
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
//        let documentAction = UIAlertAction(title: "Document", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.licensePicked = 2
//            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//            importMenu.delegate = self
//            importMenu.modalPresentationStyle = .formSheet
//            self.present(importMenu, animated: true, completion: nil)
//        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
//        optionMenu.addAction(documentAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 800, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePick(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        //2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("option 1 pressed")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicked = sender
                //self.imageOne = sender.tag
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender
            //self.imageOne = sender.tag
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 800, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let packedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if imagePicked == 1 {
            self.myImage1.image = packedImage
            self.imageOne = 1
        } else if imagePicked == 2 {
            self.myImage2.image = packedImage
            self.imageTwo = 2
        } else if imagePicked == 3 {
            self.insuranceImage.image = packedImage
            self.imageOne = 3
        } else if imagePicked == 4 {
            self.licenseImage.image = packedImage
            self.imageTwo = 4
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func updateDocumentsBtn(_ sender: Any) {
        if imageOne == 3 && imageTwo == 4 {
        if insurancePicked == 1 {
        updateDocuments()
        } else if insurancePicked == 2 {
            DispatchQueue.main.async(execute: {
                self.p_uploadDocument(self.docData2!, filename: self.fileName2!, name: "insuranceimage")
            })
        }
        
        if licensePicked == 1 {
          updateDocuments()
        } else if licensePicked == 2 {
            DispatchQueue.main.async(execute: {
                self.p_uploadDocument(self.docData1!, filename: self.fileName1!, name: "lisenceimage")
            })
        }
        
    } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please select updated images", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateDocuments() {
        let documents_URL = main_URL+"api/transporterUpdatePicture"
        if self.insurancePicked == 1 || licensePicked == 1 {
            self.ic_status.isHidden = false
            self.dl_status.isHidden = false
        }
        
        if user_id != nil && self.insurancePicked == 1 || self.licensePicked == 1 {
            
            let parameters = ["userid" : user_id!]
            SVProgressHUD.show(withStatus: "Updating documents...")
             
            if imageOne == 3 {
                var image1 = insuranceImage.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
            }
            if imageTwo == 4 {
                var image2 = licenseImage.image
                image2 = image2?.resizeWithWidth(width: 500)
                imageData2 = image2?.jpegData(compressionQuality: 0.2)
            }
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if self.imageOne == 3 {
                    multipartFormData.append(self.imageData1!, withName: "insuranceimage", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                    self.imageOne = 0
                }
                if self.imageTwo == 4 {
                    multipartFormData.append(self.imageData2!, withName: "lisenceimage", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                    self.imageTwo = 0
                }
            }, to:documents_URL)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        if response.result.value != nil {
                            print(response.request!)  // original URL request
                            print(response.response!) // URL response
                            print(response.data!)     // server data
                            print(response.result)   // result of response serialization
                            let jsonData : JSON = JSON(response.result.value!)
                            print("JSON: \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            SVProgressHUD.dismiss()
                            if result != "0" {
                            SVProgressHUD.showSuccess(withStatus: "Documents updated successfully")
                                self.dl_status.text = "Status: Pending"
                                self.ic_status.text = "Status: Pending"
                            } else {
                                let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            print("Error \(response.result.error!)")
                            let alert = UIAlertController(title: "Error", message: "Network Error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error!", message: "Connection error! Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
        }else{
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please select updated images", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Functions for UIDocumentpicker
    /***************************************************************/
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL
        print(cico)
        self.downloadfile(URL: cico as NSURL)
    }
    
    fileprivate func downloadfile(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                // Success
                let statusCode = response?.mimeType
                print("Success: \(String(describing: statusCode))")
                if self.licensePicked == 2 {
                    self.docData1 = data
                    self.fileName1 = URL.lastPathComponent
                }
                
                if self.insurancePicked == 2 {
                    self.docData2 = data
                    self.fileName2 = URL.lastPathComponent
                }
                
                
                urlDocument = URL as URL
//                print("URL is \(urlDocument!)")
//                print("document data is \(self.docData!)")
//                print("file name is \(self.fileName!)")
                DispatchQueue.main.async {
                    if self.insurancePicked == 2 {
                        self.insuranceDocument.isHidden = false
                        self.insuranceDocument.text = self.fileName2
                    }
                    if self.licensePicked == 2 {
                        self.licenseDocument.isHidden = false
                        self.licenseDocument.text = self.fileName1
                    }
                }
                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error!.localizedDescription)
            }
        })
        task.resume()
    }
    
    fileprivate func p_uploadDocument(_ file: Data,filename : String, name : String) {
        SVProgressHUD.show()
        let parameters = ["userid" : user_id!]
        let fileData = file
        let URL2 = try! URLRequest(url: main_URL+"api/transporterUpdatePicture", method: .post)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(fileData as Data, withName: name, fileName: filename, mimeType: "text/plain")
            
            
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, with: URL2 , encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    SVProgressHUD.dismiss()
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        //self.delegate?.showSuccessAlert()
                        print(response.result)   // result of response serialization
                        //                        self.showSuccesAlert()
                        //self.removeImage("frame", fileExtension: "txt")
                        if response.result.value != nil {
                            print(response.request!)  // original URL request
                            print(response.response!) // URL response
                            print(response.data!)     // server data
                            let jsonData : JSON = JSON(response.result.value!)
                            print("JSON: \(jsonData)")
                            
                            let result = jsonData[0]["result"].stringValue
                            SVProgressHUD.dismiss()
                            if result != "0" {
                                SVProgressHUD.showSuccess(withStatus: "Documents updated successfully")
                                if self.licensePicked == 2 {
                                self.dl_status.text = "Status: Pending"
                                }
                                if self.insurancePicked == 2 {
                                self.ic_status.text = "Status: Pending"
                                }
                            } else {
                                let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                    }
                }
            case .failure(let encodingError):
                // error handling
                print("error is \(encodingError)")
                SVProgressHUD.dismiss()
            }
        }
        )
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        if insurancePicked == 2 {
            insurancePicked = nil
        }
        if licensePicked == 2 {
            licensePicked = nil
        }
    }

    @IBAction func updateImagesBtn(_ sender: Any) {
        if imageOne == 1 && imageTwo == 2 {
        updateImages()
        }else{
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please select updated images", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateImages() {
        let PostJob_URL = main_URL+"api/transporterUpdatePicture"
        if user_id != nil && self.myImage1.image != UIImage(named: "notfound") && self.myImage2.image != UIImage(named: "notfound") {
            let parameters = ["userid" : user_id!]
            SVProgressHUD.show(withStatus: "Updating Pictures...")
            
            if imageOne == 1 {
                var image1 = myImage1.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
            }
            if imageTwo == 2 {
                var image2 = myImage2.image
                image2 = image2?.resizeWithWidth(width: 500)
                imageData2 = image2?.jpegData(compressionQuality: 0.2)
            }
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if self.imageOne == 1 {
                    multipartFormData.append(self.imageData1!, withName: "profilepic", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                    self.imageOne = 0
                }
                if self.imageTwo == 2 {
                    multipartFormData.append(self.imageData2!, withName: "vanimage", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                    self.imageTwo = 0
                }
            }, to:PostJob_URL)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        if response.result.value != nil {
                            print(response.request!)  // original URL request
                            print(response.response!) // URL response
                            print(response.data!)     // server data
                            print(response.result)   // result of response serialization
                            let jsonData : JSON = JSON(response.result.value!)
                            print("JSON: \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            SVProgressHUD.dismiss()
                            if result != "0" {
                                SVProgressHUD.showSuccess(withStatus: "Pictures updated successfully")
                            } else {
                                let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            print("Error \(response.result.error!)")
                            let alert = UIAlertController(title: "Error", message: "Network Error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error!", message: "Connection error! Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please select updated images", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension EditProfileController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        dismiss(animated: true, completion: nil)
        self.address.text = place.formattedAddress
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension String {
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

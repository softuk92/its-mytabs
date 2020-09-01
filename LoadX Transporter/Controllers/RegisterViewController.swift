//
//  RegisterViewController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
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


class RegisterViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var logo_view: UIView!
    @IBOutlet weak var fullName: AnimatableTextField!
    @IBOutlet weak var email_address: AnimatableTextField!
    @IBOutlet weak var phone_no: AnimatableTextField!
    @IBOutlet weak var address: AnimatableTextField!
    @IBOutlet weak var van_type: AnimatableTextField!
    @IBOutlet weak var vehicle_reg_no: AnimatableTextField!
    @IBOutlet weak var van_type_drop: UIView!
    @IBOutlet weak var licenseImage: UIImageView!
    @IBOutlet weak var insuranceImage: UIImageView!
    
    @IBOutlet weak var license_btn: UIButton!
    @IBOutlet weak var insurance_btn: UIButton!
    @IBOutlet weak var Registration_btn: UIButton!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fullName_img: UIImageView!
    @IBOutlet weak var email_address_img: UIImageView!
    @IBOutlet weak var phone_img: UIImageView!
    @IBOutlet weak var address_img: UIImageView!
    @IBOutlet weak var vehicle_RegNo_img: UIImageView!
    
    @IBOutlet weak var viewOfPop: UIView!
    let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    @IBOutlet weak var tableview: UITableView!
    //let list = ["Small Van", "Medium Van", "Large Van", "Luton Van","Rubbish Removal Truck", "7.5 Truck", "Vehicle Recovery Truck", "Container Truck", "Other"]
    
    var list = ["Car","Small Van",
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
    var docData1 : Data?
    var fileName1 : String?
    var docData2 : Data?
    var fileName2 : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Sign Up"
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
//        van_type.delegate = self
        address.delegate = self
        vehicle_reg_no.delegate = self
        phone_no.delegate = self
      
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
    //        dropDown1.anchorView = van_type_drop
    //
    //        dropDown1.dataSource = list
    //        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
    //            print("Selected item: \(item) at index: \(index)")
    //            self.van_type.text = item
    //             self.van_type.rightImage = UIImage(named: "arrowDown_new")
    //            self.vehicle_reg_no.becomeFirstResponder()
    //        }
    //
    //        dropDown1.direction = .bottom
    //        dropDown1.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
    //        dropDown1.width = 135
        
        if #available(iOS 13.0, *) {
            DropDown.appearance().textColor = UIColor.label
        } else {
            DropDown.appearance().textColor = UIColor.black
        }
        DropDown.appearance().selectedTextColor = UIColor.red
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 10)
        DropDown.appearance().backgroundColor = UIColor(named: "Background_color")
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 30
        DropDown.appearance().setupCornerRadius(10)
        
    }
  
      @IBAction private func btnCross_Pressed(_ sender : UIButton) {
    //        HomeViewController
            self.viewOfPop.isHidden = true

        }
        
        @IBAction private func btnShowPop(_ sender : UIButton) {
            //        HomeViewController
            self.viewOfPop.isHidden = false
            
        }
        
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
    
    //MARK: - Select Vehicle Drop Down
    /***************************************************************/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == van_type {
            dropDown1.show()
            self.van_type.rightImage = UIImage(named: "ArrowUp")
            self.view.endEditing(true)
        }else{
            print("this is did select textflied ")
        }
    }
    
    //MARK: - Pickuplocation for UITEXTFIELD
    /***************************************************************/
    
    
    @IBAction func address_btn(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark   {
               // self.traitCollection.userInterfaceStyle == .dark
              autocompleteController.primaryTextColor = UIColor.white
              autocompleteController.secondaryTextColor = UIColor.lightGray
              autocompleteController.tableCellSeparatorColor = UIColor.lightGray
              autocompleteController.tableCellBackgroundColor = UIColor.darkGray
           } else {
              autocompleteController.primaryTextColor = UIColor.black
              autocompleteController.secondaryTextColor = UIColor.lightGray
              autocompleteController.tableCellSeparatorColor = UIColor.lightGray
              autocompleteController.tableCellBackgroundColor = UIColor.white
           }
        }
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        filter.country = "UK"
        
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    public func validateName(name: String) ->Bool {
             // Length be 3 characters minimum, you can always modify.
         
             let nameRegex = "^[A-Za-z]{3,25}$"
             let trimmedString = name.trimmingCharacters(in: .whitespaces)
             let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
             let isValidateName = validateName.evaluate(with: trimmedString)
             return isValidateName
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
       let isValidateName = validateName(name: fullName.text!)
        
        let temp = self.email_address.text!
        let x = isValidEmail1(testStr: temp)
        
            if (isValidateName == false) {
              //  SVProgressHUD.showError(withStatus: "Enter atleast 3 character UserName & with no Digits")
                fullName.placeholderText = "Enter Full Name"
                //fullName.font = UIFont(name: "Montserrat-Light", size: 10)
//                fullName_img.image = UIImage(named: "errorIcon")
                fullName.placeholderColor = UIColor.red
            }else if  x == false {
          //  SVProgressHUD.showError(withStatus: "Please Enter Correct email Address")
                           
            email_address.text = "Enter Full Email Address"
              email_address.textColor = UIColor.red
            
        } else if self.phone_no.text == "" || phone_no.text?.count != 11 || (self.phone_no.text?.hasPrefix("0")) == false {
                
            phone_no.text =  "Contact Phone No"
               phone_no.textColor =  UIColor.red
           //  SVProgressHUD.showError(withStatus: "Please Enter 11 digit Number start with 0 ")
                
            }else if self.address.text == "" {
            address.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
           //  SVProgressHUD.showError(withStatus: "Please Enter Address ")
        }else if self.van_type.text == "" {
            van_type.attributedPlaceholder = NSAttributedString(string: "Enter Van Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // SVProgressHUD.showError(withStatus: "Please Enter Van Type ")
        }else if self.vehicle_reg_no.text == "" {
            vehicle_reg_no.attributedPlaceholder = NSAttributedString(string: "Enter Vehicle Reg.No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // SVProgressHUD.showError(withStatus: "Please Enter Vehicle Reg Number ")
        }else{
            registerTransporter()
        }
        
//       else if phone_no.text != "" {
//        if  {
//
//        } else {
//        phone_no.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//
//        }
//        }
    }
    
    //register function
    func registerTransporter() {
        
        SVProgressHUD.show(withStatus: "Registering...")
        if imageOne == 1 && imageTwo == 2 {
        if self.fullName.text != "" && self.phone_no.text != "" && self.email_address.text != "" && self.address.text != "" && self.van_type.text != "" && self.vehicle_reg_no.text != "" {
            let registerTransporter_URL = main_URL+"api/registerdriver"
            
            let parameters = ["tname" : self.fullName.text!, "temail" : self.email_address.text!, "tphone" : self.phone_no.text!, "taddress" : self.address.text!, "vantype" : self.van_type.text!, "registration-number" : self.vehicle_reg_no.text!]
            
            if imageOne == 1 {
                var image1 = licenseImage.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
                imageOne = 0
            }
            if imageTwo == 2 {
                var image2 = insuranceImage.image
                image2 = image2?.resizeWithWidth(width: 500)
                imageData2 = image2?.jpegData(compressionQuality: 0.2)
                imageTwo = 0
            }
            if Connectivity.isConnectedToInternet() {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    }
                    
                    if self.licensePicked == 1 {
                        multipartFormData.append(self.imageData1!, withName: "driving-license", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                        
                    } else if self.licensePicked == 2 {
                        multipartFormData.append(self.docData1!, withName: "driving-license", fileName: self.fileName1!, mimeType: "text/plain")
                    }
                    
                    if self.insurancePicked == 1 {
                        multipartFormData.append(self.imageData2!, withName: "insurance-copy", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                        
                    } else if self.insurancePicked == 2 {
                        multipartFormData.append(self.docData2!, withName: "insurance-copy", fileName: self.fileName2!, mimeType: "text/plain")
                    }
                }, to:registerTransporter_URL)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseString { response in
                            if response.result.value != nil {
                                print(response.request!)  // original URL request
                                print(response.response!) // URL response
                                print(response.data!)     // server data
                                print(response.result)   // result of response serialization
                                let jsonData : JSON = JSON(response.result.value!)
                                print("JSON: \(jsonData)")
                                let result = jsonData[0]["result"].stringValue
                                let message = jsonData[0]["message"].stringValue
                                SVProgressHUD.dismiss()
                                if result == "false" {
                                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    self.performSegue(withIdentifier: "register", sender: self)
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
            let alert = UIAlertController(title: "Error!", message: "Check your internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "All fields are required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please upload your driving license and insurance copy", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func licenseBtn(_ sender: UIButton) {
   
        imagePickWithDocument2(sender: sender.tag)
    
    }
    
    @IBAction func insuranceBtn(_ sender: UIButton) {
   
        imagePickWithDocument(sender: sender.tag)
        
    }
    
    
    func imagePickWithDocument(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.insurancePicked = 1
                self.imagePicked = sender
                self.imagePicked = 2
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
            self.imagePicked = 2
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
                self.imagePicked = 1
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
            self.imagePicked = 1
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let packedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if imagePicked == 1 {
            self.licenseImage.image = packedImage
            self.imageOne = 1
        } else if imagePicked == 2 {
            self.insuranceImage.image = packedImage
            self.imageTwo = 2
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
//                self.docData = data
//                self.fileName = URL.lastPathComponent
                urlDocument = URL as URL
//                print("URL is \(urlDocument!)")
//                print("document data is \(self.docData!)")
//                print("file name is \(self.fileName!)")
                DispatchQueue.main.async {
                    if self.insurancePicked == 2 {
//                        self.insuranceDocument.isHidden = false
//                        self.insuranceDocument.text = self.fileName
                    }
                    if self.licensePicked == 2 {
//                        self.licenseDocument.isHidden = false
//                        self.licenseDocument.text = self.fileName
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
    @available(iOS 13.0, *)
    @IBAction func login_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func isValidEmail1(testStr:String) -> Bool {
  
           print("validate emilId: \(testStr)")
              let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
              let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
              return result
       }
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension RegisterViewController: GMSAutocompleteViewControllerDelegate {
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

//MARK: UITableViewDelegate
extension RegisterViewController: UITableViewDataSource , UITableViewDelegate  {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobNatureCell", for: indexPath) as? JobNatureCell
            cell?.lblJobNature.text = self.list[indexPath.row]
            return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
            let selectedValue = self.list[indexPath.row]
            self.van_type.text = selectedValue
            viewOfPop.isHidden = true
        
    }
}

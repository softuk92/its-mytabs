//
//  PostJob.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/28/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import SVProgressHUD
import DropDown
import IBAnimatable
import IQKeyboardManagerSwift
import AVFoundation

class PostJob: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UISearchBarDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    //MARK: - Initialization of Variables
    /***************************************************************/
    let picker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    var imagePicked = 0
    var locationPicked = 0
    var lat_pickup = ""
    var lng_pickup = ""
    var lat_dropoff = ""
    var lng_dropoff = ""
    var distanceKM  = ""
    var categoryList = ["Antiques & Special Care Items", "Bikes & Motorcycles", "Boats","Boxes", "Business & Industrial Goods", "Food & Agriculture", "Freight", "Furniture & General Items", "Machine & Vehicle Parts", "Manpower Assistance","Moving Home", "Office Relocation", "Parcels & Packaged Items","Passenger", "Pets & Livestock", "Piano Moving", "Plant & Heavy Equipment","Vehicle Transportation", "Waste Removal", "Other"]
    var movingFromDrop = ["Curbside", "Basement", "Ground Floor", "1st Floor", "2nd Floor", "3rd Floor", "Above 3rd Floor"]
    var movingToDrop = ["Basement", "Ground Floor", "1st Floor", "2nd Floor", "3rd Floor", "Above 3rd Floor"]
    var timeSlotDrop = ["08-AM To 10-AM", "10-AM To 12-PM", "12-PM To 02-PM", "02-PM To 04-PM", "04-PM To 06-PM", "06-PM To 08-PM", "08-PM To 10-PM", "10-PM To 12-AM", "12-AM To 02-AM", "02-AM To 04-AM", "04-AM To 08-AM"]
    let PostJob_URL = main_URL+"api/postjobdata"
    var imageData1 : Data?
    var imageData2 : Data?
    var imageData3 : Data?
    var menuShowing = false
    var imageOne = 0
    var imageTwo = 0
    var imageThree = 0
    let dropDown1 = DropDown()
    let dropDown2 = DropDown()
    let dropDown3 = DropDown()
    let dropDown4 = DropDown()
    let rightView1 = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
    let imageView1 = UIImageView(frame: CGRect(x: 73, y: 10, width: 20, height: 20))
    
    @IBOutlet weak var selectCategory: AnimatableTextField!
    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var moving_item: UITextField!
    @IBOutlet weak var movingFrom: AnimatableTextField!
    @IBOutlet weak var movingFromView: UIView!
    @IBOutlet weak var movingTo: AnimatableTextField!
    @IBOutlet weak var movingToView: UIView!
    @IBOutlet weak var detailedDescription: UITextView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var dropOff: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var externalView: UIView!
    @IBOutlet weak var time_slot: AnimatableTextField!
    @IBOutlet weak var time_slotDrop: UIView!
    @IBOutlet weak var user_name: AnimatableTextField!
    @IBOutlet weak var user_phone: AnimatableTextField!
    @IBOutlet weak var postJobBtn: AnimatableButton!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkbox: VKCheckbox!
    @IBOutlet weak var user_address: AnimatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Post Your Job"
        
        //        imageView1.contentMode = .scaleAspectFit
        //        imageView1.image = UIImage(named: "openinghours (1)")
        //        rightView1.addSubview(imageView1)
        //
        //        time_slot.rightView = rightView1
        //        time_slot.rightViewMode = .always
//        self.dropDownView.isHidden = true
//        self.heightConstraint.constant = 82
//        self.scrollView.isScrollEnabled = false
        self.navigationItem.backBarButtonItem?.title = "Back"
        detailedDescription.delegate = self
        detailedDescription.text = "Detailed Description About Job"
        detailedDescription.textColor = UIColor.lightGray
        self.dropDownView.isHidden = true
        self.heightConstraint.constant = 50
        createDatePicker()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        pickupLocation.delegate = self
        dropOff.delegate = self
        time_slot.delegate = self
        email.delegate = self
        movingFrom.delegate = self
        movingTo.delegate = self
        dateField.delegate = self
        selectCategory.delegate = self
        
        dropDown1.backgroundColor = UIColor.white
        dropDown1.anchorView = time_slotDrop
        dropDown1.dataSource = timeSlotDrop
        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.time_slot.text = item
            self.time_slotDrop.isHidden = true
            self.detailedDescription.becomeFirstResponder()
        }
        dropDown1.direction = .bottom
        dropDown1.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
        
        dropDown2.anchorView = selectCategoryView
        dropDown2.backgroundColor = UIColor.white
        dropDown2.dataSource = categoryList
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectCategory.text = item
            self.selectCategoryView.isHidden = true
            self.moving_item.becomeFirstResponder()
        }
        dropDown2.direction  = .bottom
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown2.anchorView?.plainView.bounds.height)!)
        
        dropDown3.anchorView = movingFromView
        dropDown3.backgroundColor = UIColor.white
        dropDown3.dataSource = movingFromDrop
        dropDown3.selectionAction = { [unowned self] (index: Int, item: String) in
            self.movingFrom.text = item
            self.movingFromView.isHidden = true
            self.detailedDescription.becomeFirstResponder()
        }
        dropDown3.direction  = .bottom
        dropDown3.bottomOffset = CGPoint(x: 0, y:(dropDown3.anchorView?.plainView.bounds.height)!)
        
        dropDown4.anchorView = movingToView
        dropDown4.backgroundColor = UIColor.white
        dropDown4.dataSource = movingToDrop
        dropDown4.selectionAction = { [unowned self] (index: Int, item: String) in
            self.movingTo.text = item
            self.movingToView.isHidden = true
            self.detailedDescription.becomeFirstResponder()
        }
        dropDown4.direction  = .bottom
        dropDown4.bottomOffset = CGPoint(x: 0, y:(dropDown4.anchorView?.plainView.bounds.height)!)
    
//        checkbox.checkboxValueChangedBlock = {
//            isOn in
//            if self.checkbox.isOn() {
//                self.dropDownFunc()
//            } else {
//                self.dropDownFunc()
//            }
//        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == time_slot {
            dropDown1.show()
            time_slot.endEditing(true)
            view.endEditing(true)
            IQKeyboardManager.shared.resignFirstResponder()
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == selectCategory {
            dropDown2.show()
            selectCategory.endEditing(true)
            view.endEditing(true)
            IQKeyboardManager.shared.resignFirstResponder()
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == movingFrom {
            dropDown3.show()
            movingFrom.endEditing(true)
            view.endEditing(true)
            IQKeyboardManager.shared.resignFirstResponder()
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == movingTo {
            dropDown4.show()
            movingTo.endEditing(true)
            view.endEditing(true)
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
            IQKeyboardManager.shared.resignFirstResponder()
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == user_name {
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == email {
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == user_phone {
            scrollView.shouldIgnoreScrollingAdjustment = true
        } else if textField == user_address {
            scrollView.shouldIgnoreScrollingAdjustment = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailedDescription.textColor == UIColor.lightGray {
            detailedDescription.text = nil
            detailedDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if detailedDescription.text.isEmpty {
            detailedDescription.text = "Detailed Description About Job"
            detailedDescription.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func checkBoxBtn(_ sender: VKCheckbox) {
        self.dropDownFunc()
    }
    
    @IBAction func dropDownMenu(_ sender: UIButton) {
        self.dropDownFunc()
    }
    
    func dropDownFunc() {
        if menuShowing == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.dropDownView.isHidden = false
                self.heightConstraint.constant = 200
                self.menuShowing = true
                self.checkbox.setOn(true)
                self.view.layoutIfNeeded()
            })
        } else if menuShowing == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.dropDownView.isHidden = true
                self.heightConstraint.constant = 50
                self.menuShowing = false
                self.checkbox.setOn(false)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //MARK: - Select image function
    /***************************************************************/
    @IBOutlet weak var myImage1: UIImageView!
    @IBOutlet weak var myImage2: UIImageView!
    @IBOutlet weak var myImage3: UIImageView!
    
    @IBAction func selectImage1(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("option 1 pressed")
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                    self.imagePicked = sender.tag
                    self.imageOne = sender.tag
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    print("Camera Not Available")
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        print("access allowed")
                        //access allowed
                    } else {
                        print("acccess denied")
                        let alert = UIAlertController(title: "Alert!", message: "Please allow access to camera from settings", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //access denied
                    }
                })
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender.tag
            self.imageOne = sender.tag
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
    
    @IBAction func selectImage2(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("option 1 pressed")
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                    self.imagePicked = sender.tag
                    self.imageTwo = sender.tag
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    print("Camera Not Available")
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        print("access allowed")
                        //access allowed
                    } else {
                        print("acccess denied")
                        let alert = UIAlertController(title: "Alert!", message: "Please allow access to camera from settings", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //access denied
                    }
                })
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender.tag
            self.imageTwo = sender.tag
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
    
    @IBAction func selectImage3(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("option 1 pressed")
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                    self.imagePicked = sender.tag
                    self.imageThree = sender.tag
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    print("Camera Not Available")
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        print("access allowed")
                        //access allowed
                    } else {
                        print("acccess denied")
                        let alert = UIAlertController(title: "Alert!", message: "Please allow access to camera from settings", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //access denied
                    }
                })
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender.tag
            self.imageThree = sender.tag
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
        } else if imagePicked == 2 {
            self.myImage2.image = packedImage
        } else if imagePicked == 3 {
            self.myImage3.image = packedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    //MARK: - Function for UIDatepicker
    /***************************************************************/
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    //MARK: - Pickuplocation for UITEXTFIELD
    /***************************************************************/
    
    @IBAction func pickupLocationButton(_ sender: UITextField) {
    
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        locationPicked = sender.tag
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func dropOffLocation(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        locationPicked = sender.tag
        present(autocompleteController, animated: true, completion: nil)
    }
    
    //MARK: - Calculating Distance by Latitude and Longitude in Kilometers
    /***************************************************************/
    func deg2rad(deg:Double) -> Double {
        return deg * .pi / 180
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / .pi
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    @IBAction func getYourQuotes(_ sender: UIButton) {
        if pickupLocation.text != dropOff.text {
            if selectCategory.text != "" {
                if moving_item.text == "" {
                    moving_item.attributedPlaceholder = NSAttributedString(string: "Please enter Your Email ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
                if pickupLocation.text == "" {
                    pickupLocation.attributedPlaceholder = NSAttributedString(string: "Please enter Pickup Location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
                if dropOff.text == "" {
                    dropOff.attributedPlaceholder = NSAttributedString(string: "Please enter Drop Off Location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
                if dateField.text == "" {
                    dateField.attributedPlaceholder = NSAttributedString(string: "Please enter Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
                if email.text == "" {
                    email.attributedPlaceholder = NSAttributedString(string: "Please enter Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
                if user_name.text == "" {
                    user_name.attributedPlaceholder = NSAttributedString(string: "Enter User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
                if user_phone.text == "" {
                    user_phone.attributedPlaceholder = NSAttributedString(string: "Enter Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
        
                if moving_item.text != "" && pickupLocation.text != "" && dropOff.text != "" && lat_pickup != "" && lng_pickup != "" && lat_dropoff != "" && lng_dropoff != "" && detailedDescription.text != "" && dateField.text != "" && distanceKM != "" && email.text != "" && user_name.text != "" && user_phone.text != "" {
                    SVProgressHUD.show(withStatus: "Please wait...")
                    let parameters = ["moving_item" : moving_item.text!, "pick_up" : pickupLocation.text!, "drop_off" : dropOff.text!, "lat_pickup" : lat_pickup, "lng_pickup" : lng_pickup, "lat_dropoff" : lat_dropoff, "lng_dropoff" : lng_dropoff, "description" : detailedDescription.text!, "email" : email.text!, "date" : dateField.text!, "distance" : distanceKM, "timeslot" : self.time_slot.text!, "user_name" : self.user_name.text!, "user_phone" : self.user_phone.text!, "user_address" : self.user_address.text!, "moving_from" : self.movingFrom.text!, "moving_to" : self.movingTo.text!, "add_type" : self.selectCategory.text!]
                    
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
                    if imageThree == 3 {
                        var image3 = myImage3.image
                        image3 = image3?.resizeWithWidth(width: 500)
                        imageData3 = image3?.jpegData(compressionQuality: 0.2)
                    }
                    
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        for (key, value) in parameters {
                            multipartFormData.append(value.data(using: .utf8)!, withName: key)
                        }
                        if self.imageOne == 1 {
                            multipartFormData.append(self.imageData1!, withName: "image1", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                            self.imageOne = 0
                        }
                        if self.imageTwo == 2 {
                            multipartFormData.append(self.imageData2!, withName: "image2", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                            self.imageTwo = 0
                        }
                        if self.imageThree == 3 {
                            multipartFormData.append(self.imageData3!, withName: "image3", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                            self.imageThree = 0
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
                                        self.performSegue(withIdentifier: "success", sender: self)
                                    } else {
                                        let alert = UIAlertController(title: "Error", message: "Email Already Exist", preferredStyle: UIAlertController.Style.alert)
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
                            print(encodingError)
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Error", message: "Connection error! Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
                else {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Alert", message: "Please fill out necessary fields", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Alert", message: "Please select category", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert", message: "Pick-up and Drop-off Locations cannot be same", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension PostJob: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if locationPicked == 1 {
            print("Place name: \(place.name)")
            print(lat_pickup)
            print(lng_pickup)
            dismiss(animated: true, completion: nil)
            pickupLocation.text = place.formattedAddress
            lat_pickup = String(place.coordinate.latitude)
            lng_pickup = String(place.coordinate.longitude)
        }
        else if locationPicked == 2 {
            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            dropOff.text = place.formattedAddress
            lat_dropoff = String(place.coordinate.latitude)
            lng_dropoff = String(place.coordinate.longitude)
            print(lat_dropoff)
            print(lng_dropoff)
            print(distance(lat1: Double((lat_pickup as NSString).doubleValue), lon1: Double((lng_pickup as NSString).doubleValue), lat2: Double((lat_dropoff as NSString).doubleValue), lon2: Double((lng_dropoff as NSString).doubleValue), unit: "K"), "Kilometers")
            print(distance(lat1: Double((lat_pickup as NSString).doubleValue), lon1: Double((lng_pickup as NSString).doubleValue), lat2: Double((lat_dropoff as NSString).doubleValue), lon2: Double((lng_dropoff as NSString).doubleValue), unit: "M"), "Miles")
            distanceKM = String(describing: distance(lat1: Double((lat_pickup as NSString).doubleValue), lon1: Double((lng_pickup as NSString).doubleValue), lat2: Double((lat_dropoff as NSString).doubleValue), lon2: Double((lng_dropoff as NSString).doubleValue), unit: "M"))
        }
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

extension UIImage {
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

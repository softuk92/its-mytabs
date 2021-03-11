//
//  Document_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 10/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import SKPhotoBrowser

class Document_ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    
    @IBOutlet weak var license_img: UIImageView!
    
    @IBOutlet weak var insurance_img: UIImageView!
    @IBOutlet weak var van_img: UIImageView!
    @IBOutlet weak var dl_status: UILabel!
    @IBOutlet weak var ic_status: UILabel!
    
    var imagePicker = UIImagePickerController()
    private var imagePicked = 0
    private var imageData1 : Data?
    private var imageData2 : Data?
    private var imageData3 : Data?
    private var imageOne: Int?
    private var imageTwo: Int?
    private var imageThree : Int?
    private var insurancePicked : Int?
    private var licensePicked : Int?
    private var VanImagePicked : Int?
    var images1 = [SKPhoto]()
    var images2 = [SKPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        profileDetail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_action(_ sender: Any) {
         self.navigationController!.popViewController(animated: true)
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
      
    func imagePick(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
   
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("option 1 pressed")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicked = 3
                self.VanImagePicked = 1
                //self.imageOne = sender.tag
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = 3
            self.VanImagePicked = 1
            //self.imageOne = sender.tag
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
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
    func imagePickWithDocument(sender: Int) {
           let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)

           let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
               (alert: UIAlertAction!) -> Void in
               if UIImagePickerController.isSourceTypeAvailable(.camera) {
                   self.imagePicker.sourceType = .camera
                   self.insurancePicked = 1
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
               self.imagePicked = 2
               self.present(self.imagePicker, animated: true, completion: nil)
           })
           
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
                self.imagePicked = 1
               self.licensePicked = 1
               self.present(self.imagePicker, animated: true, completion: nil)
           })
           
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
            self.license_img.image = packedImage
            self.imageOne = 1
            imagePicked = 0
        } else if imagePicked == 2 {
            self.insurance_img.image = packedImage
            self.imageTwo = 2
            imagePicked = 0
        } else if imagePicked == 3 {
            self.van_img.image = packedImage
            self.imageThree = 1
            imagePicked = 0
        }
        
        dismiss(animated: true)
    }
    
    
    @IBAction func updateDocument_action(_ sender: Any) {
        SVProgressHUD.show()
        if imageOne == 1 || imageTwo == 2 || imageThree == 1 {
        if insurancePicked == 1 || licensePicked == 1 || VanImagePicked == 1 {
        updateDocuments()
        }else{
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please select updated images", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
//        else if insurancePicked == 2 {
//            DispatchQueue.main.async(execute: {
//                self.p_uploadDocument(self.docData2!, filename: self.fileName2!, name: "insuranceimage")
//            })
//        }
        
       
//        else if licensePicked == 2 {
//            DispatchQueue.main.async(execute: {
//                self.p_uploadDocument(self.docData1!, filename: self.fileName1!, name: "lisenceimage")
//            })
//        }
        
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
        
        if user_id != nil && self.insurancePicked == 1 || self.licensePicked == 1 || VanImagePicked == 1  {
            
            let parameters = ["userid" : user_id!]
            SVProgressHUD.show(withStatus: "Updating documents...")
             
            if imageOne == 1 {
                var image1 = license_img.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
            }
            if imageTwo == 2 {
                var image2 = insurance_img.image
                image2 = image2?.resizeWithWidth(width: 500)
                imageData2 = image2?.jpegData(compressionQuality: 0.2)
            }
            if imageThree == 1 {
                var image2 = van_img.image
                image2 = image2?.resizeWithWidth(width: 500)
                imageData3 = image2?.jpegData(compressionQuality: 0.2)
            }
                       
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if self.imageOne == 1 {
                    multipartFormData.append(self.imageData1!, withName: "lisenceimage", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                    self.imageOne = 0
                }
                if self.imageTwo == 2 {
                    multipartFormData.append(self.imageData2!, withName: "insuranceimage", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                    self.imageTwo = 0
                }
                if self.imageThree == 1 {
                    multipartFormData.append(self.imageData3!, withName: "vanimage", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                    self.imageThree = 0
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
//                            print(response.request!)  // original URL request
//                            print(response.response!) // URL response
//                            print(response.data!)     // server data
//                            print(response.result)   // result of response serialization
                            let jsonData : JSON = JSON(response.result.value!)
                            print("image upload JSON: \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            SVProgressHUD.dismiss()
                            if result != "0" {
                            SVProgressHUD.showSuccess(withStatus: "Documents updated successfully")
                                self.dl_status.text = "Pending"
                                self.ic_status.text = "Pending"
                            } else {
                                let alert = UIAlertController(title: "Error", message: "Cannot Updated", preferredStyle: UIAlertController.Style.alert)
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

        func profileDetail() {
            SVProgressHUD.show(withStatus: "Getting details...")
            if user_id != nil {
                let transpoterProfile_URL = main_URL+"api/getTransporterProfileDetail"
                let parameters : Parameters = ["user_id" : user_id!]
                if Connectivity.isConnectedToInternet() {
                    Alamofire.request(transpoterProfile_URL, method : .post, parameters : parameters).responseJSON {
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
//                            self.fullName.text = jsonData[0]["user_name"].stringValue
//                            self.email_address.text = jsonData[0]["user_email"].stringValue
                                if icStatus == "pending" {
                                    self.ic_status.text = "Pending"
                                } else if icStatus == "Approved" {
                                    self.ic_status.text = "Approved"
                                } else if icStatus == "Reject" {
                                    self.ic_status.text = "Rejected"
                                } else if icStatus == "" {
                                    self.ic_status.isHidden = true
                                }
                            
                                if dlStatus == "pending" {
                                    self.dl_status.text = "Pending"
                                } else if dlStatus == "Approved" {
                                    self.dl_status.text = "Approved"
                                } else if dlStatus == "Reject" {
                                    self.dl_status.text = "Rejected"
                                } else if dlStatus == "" {
                                    self.dl_status.isHidden = true
                                }
                            
                         /*   self.phone_no.text = jsonData[0]["user_phone"].stringValue
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
                            }*/
//                            let image1 = jsonData[0]["user_image_url"].stringValue
                            let image2 = jsonData[0]["van_img"].stringValue
                            let image3 = jsonData[0]["copy_insurance"].stringValue
                            let image4 = jsonData[0]["copy_driving_license"].stringValue
                            
                            if image3 == "" && image4 == "" {
                                self.ic_status.isHidden = true
                                self.dl_status.isHidden = true
                            }
                            
                           /* if image1 != "" {
                                        let urlString = main_URL+"assets/user_profile_image/"+image1
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
                            }*/
                                    
                                    if image2 != "" {
                                        let urlString = main_URL+"public/assets/user_profile_image/"+image2
                                        if let url = URL(string: urlString) {
                                            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                                //                        print(received, expected)
                                            }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                                if let imageCell = imageReceived {
                                                    
                                                    self.van_img.image = imageCell
//                                                    self.imageThree = 1
                                                    
                                                    let photo2 = SKPhoto.photoWithImage(imageCell)
                                                    self.images1.append(photo2)
                                                }
                                            }
                                        }
                                    } else {
                                        let photo2 = SKPhoto.photoWithImage(self.van_img.image!)
                                        self.images1.append(photo2)
                            }
                            
                            if image3 != "" {
                                let urlString = main_URL+"public/assets/documents/"+image3
                                if let url = URL(string: urlString) {
                                    SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                        //                        print(received, expected)
                                    }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                        if let imageCell = imageReceived {
                                            
                                            self.insurance_img.image = imageCell
//                                            self.imageTwo = 2
                                            let photo3 = SKPhoto.photoWithImage(imageCell)
                                            self.images2.append(photo3)
                                        }
                                    }
                                }
                            } else {
                                let photo3 = SKPhoto.photoWithImage(self.insurance_img.image!)
                                self.images2.append(photo3)
                            }
                            
                            if image4 != "" {
                                let urlString = main_URL+"public/assets/documents/"+image4
                                if let url = URL(string: urlString) {
                                    SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                        //                        print(received, expected)
                                    }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                        if let imageCell = imageReceived {
                                            
                                            self.license_img.image = imageCell
//                                            self.imageOne = 1
                                            let photo4 = SKPhoto.photoWithImage(imageCell)
                                            self.images2.append(photo4)
                                        }
                                    }
                                }
                            } else {
                                let photo4 = SKPhoto.photoWithImage(self.license_img.image!)
                                self.images2.append(photo4)
                            }
                            
                        } else {
                            SVProgressHUD.dismiss()
//                            self.present(showAlert(title: "Error", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
                        }
                    }
                 else {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
                }else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
}
}

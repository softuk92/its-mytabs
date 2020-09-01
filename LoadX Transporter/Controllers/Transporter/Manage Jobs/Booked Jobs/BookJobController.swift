//
//  BookJobController.swift
//  CTS Move Transporter
//
//  Created by CTS Move on 08/08/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable
import SwiftSignatureView
import MapKit
import CoreLocation

class BookJobController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SwiftSignatureViewDelegate, CLLocationManagerDelegate {
   
    
  
    var User_location = CLLocationManager()
    
    @IBOutlet weak var myImage1: UIImageView!
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var uploadProofOutlet: UIStackView!
    @IBOutlet weak var selectImageOutlet: UIButton!
    @IBOutlet weak var updateOutlet: UIButton!
    @IBOutlet weak var yes_btn: UIButton!
    @IBOutlet weak var no_btn: UIButton!
    @IBOutlet weak var receiverName_icon: UIImageView!
    
    @IBOutlet weak var info_view: UIView!
    @IBOutlet weak var signatureView: SwiftSignatureView!
    @IBOutlet weak var signature_Image: UIImageView!
    
    @IBOutlet weak var ref_no_lbl: UILabel!
    @IBOutlet weak var contact_name_lbl: UILabel!
    @IBOutlet weak var contact_no_lbl: UILabel!
    
    var ref_no: String?
    var contact_no: String?
    var contactName: String?
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    var imagePicker = UIImagePickerController()
    private var imagePicked = 0
    private var signature_imagePicked = 0
    private var imageData1 : Data?
    private var imageData2 : Data?
    
    var lat : String?
    var long: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signature_Image.isHidden = true
        
        self.signatureView.layer.cornerRadius = 5
        self.info_view.layer.cornerRadius = 5
        info_view.layer.shadowColor = UIColor.black.cgColor
        info_view.layer.shadowOffset = CGSize(width: 2, height: 2)
        info_view.layer.shadowOpacity = 0.4
        info_view.layer.shadowRadius = 4.0
        
        
        self.signatureView.delegate = self
        
            User_location.requestAlwaysAuthorization()
            User_location.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
                   User_location.delegate = self
                   User_location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                   User_location.startUpdatingLocation()
               }
//        self.title = "Confirm Job Complete?"
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: self.receiverName.frame.height))
//        receiverName.leftView = paddingView
//        receiverName.leftViewMode = UITextField.ViewMode.always
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
//        myImage1.isHidden = true
//        receiverName.isHidden = true
//        uploadProofOutlet.isHidden = true
//        selectImageOutlet.isHidden = true
//        updateOutlet.isHidden = true
       
   
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
           print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = String(locValue.latitude)
        self.long = String(locValue.longitude)
       }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ref_no_lbl.text = ref_no
        self.contact_name_lbl.text = contactName
        self.contact_no_lbl.text = contact_no
    }
    @IBAction func clear_btn(_ sender: Any) {
        signatureView.clear()
    }
    
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
          
      }
      
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan: UIPanGestureRecognizer) {
          
      }

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectimage(_ sender: UIButton) {
        imagePick(sender: sender.tag)
    }
    
    func imagePick(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        //2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicked = sender
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender
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
        }
        
        dismiss(animated: true)
    } 
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        self.signature_Image.isHidden = false
        self.signature_Image.image = signatureView.getCroppedSignature()
        
        if self.signature_Image.image != nil {
            signature_imagePicked = 1
        }
        
        completeJobData()
    }
    
    func completeJobData() {
        SVProgressHUD.show(withStatus: "Completing Job...")
        if user_id != nil && jb_id != nil && receiverName.text != "" {
            let updateBid_URL = main_URL+"api/transporterCompleteJobData"
            let parameters = ["jb_id" : jb_id!, "user_id" : user_id!, "receivername" : self.receiverName.text!, "del_lat" : lat, "del_long": long]
           
            if imagePicked == 1 {
                var image1 = myImage1.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
            }
            if signature_imagePicked == 1 {
                var image2 = signature_Image.image
                image2 = image2?.resizeWithWidth(width: 500)
                imageData2 = image2?.jpegData(compressionQuality: 0.2)
            }
            Alamofire.upload(multipartFormData: {
                (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value!.data(using: .utf8)!, withName: key)
                }
                if self.imagePicked == 1 {
                    multipartFormData.append(self.imageData1!, withName: "delprofimg", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                }
                if self.signature_imagePicked == 1 {
                    multipartFormData.append(self.imageData2!, withName: "del_signature_img", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                }
            }, to:updateBid_URL)
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
                            let message = jsonData[0]["message"].stringValue
                            SVProgressHUD.dismiss()
                            if result == "1" {
                      //          self.performSegue(withIdentifier: "complete", sender: self)
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "completedJob") as? SuccessController
                         
                            self.navigationController?.pushViewController(vc!, animated: true)
                            } else {
                                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
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
            let alert = UIAlertController(title: "Alert!", message: "Please enter receiver name / upload proof image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

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
    @IBOutlet weak var jobIdName: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var uploadDeliveryProof: UILabel!
    @IBOutlet weak var receiverSignatureLabel: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    
    var ref_no: String?
    var contact_no: String?
    var contactName: String?
    var receiverN: String?
    var isRoute: Bool = false
    var lrhJobId = ""
    var lrID = ""
    var lrhId = ""
    var jobId: String?
    
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
        
        signatureView.layer.cornerRadius = 5
        signatureView.layer.borderWidth = 1
        signatureView.layer.borderColor = UIColor.black.cgColor
        
        signature_Image.layer.cornerRadius = 5
        signature_Image.layer.borderWidth = 1
        signature_Image.layer.borderColor = UIColor.black.cgColor
        
        info_view.layer.cornerRadius = 5
//        info_view.layer.shadowColor = UIColor.black.cgColor
//        info_view.layer.shadowOffset = CGSize(width: 2, height: 2)
//        info_view.layer.shadowOpacity = 0.4
//        info_view.layer.shadowRadius = 4.0
        
        signatureView.delegate = self
        
        updateOutlet.setTitle(string.submit, for: .normal)
        uploadDeliveryProof.text = string.uploadDeliveryProof
        receiverSignatureLabel.text = string.receiverSignature
        clearBtn.contentHorizontalAlignment = Config.shared.currentLanguage.value == .en ? .right : .left
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
        if isRoute {
        self.topLabel.text = "Stop Complete Proof"
        self.jobIdName.text = "Route ID"
        }
        self.ref_no_lbl.text = ref_no
        self.contact_name_lbl.text = contactName?.uppercased()
        self.contact_no_lbl.text = contact_no
        if let receiver = receiverN, receiver != "" {
            receiverName.text = receiver.uppercased()
        }
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
//        self.signature_Image.isHidden = false
        self.signature_Image.image = signatureView.getCroppedSignature()
        
        if self.signature_Image.image != nil {
            signature_imagePicked = 1
        }
        if isRoute {
        completeJobData(url: main_URL+"api/completeRouteFromDashboard")
        } else {
        completeJobData(url: main_URL+"api/transporterCompleteJobData")
        }
    }
    
    func completeJobData(url: String) {
        SVProgressHUD.show(withStatus: "Completing Job...")
        if user_id != nil && receiverName.text != "" {
//            let updateBid_URL = main_URL+"api/transporterCompleteJobData"
            var params = [String: Optional<String>]()
            if isRoute {
                params = ["user_id" : user_id!, "lrh_job_id" : lrhJobId, "lr_id" : lrID, "receivername" : self.receiverName.text!]
            } else {
                guard let jobId = jobId else { return }
                params = ["jb_id" : jobId, "user_id" : user_id!, "receivername" : self.receiverName.text!, "del_lat" : lat ?? "0.0", "del_long": long ?? "0.0"]
            }
           
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
                for (key, value) in params {
                    multipartFormData.append(value!.data(using: .utf8)!, withName: key)
                }
                if self.imagePicked == 1 {
                    multipartFormData.append(self.imageData1!, withName: "delprofimg", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                }
                if self.signature_imagePicked == 1 {
                    multipartFormData.append(self.imageData2!, withName: "del_signature_img", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
                }
            }, to:url)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        if response.result.value != nil {
                            let jsonData : JSON = JSON(response.result.value!)
                            print("JSON: \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            let message = jsonData[0]["message"].stringValue
                            SVProgressHUD.dismiss()
                            if result == "1" {
                      //          self.performSegue(withIdentifier: "complete", sender: self)
                                if self.isRoute {
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteCompleted") as? SuccessController
                                 
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                } else {
                                    
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "completedJob") as? SuccessController
                         
                            self.navigationController?.pushViewController(vc!, animated: true)
                                }
                            } else {
                                self.present(showAlert(title: "Error", message: message), animated: true, completion: nil)
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            self.present(showAlert(title: "Error", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                    SVProgressHUD.dismiss()
                    self.present(showAlert(title: "Error", message: encodingError.localizedDescription), animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            self.present(showAlert(title: "Alert", message: "Please enter receiver name / upload proof image"), animated: true, completion: nil)
        }
    }
    
}

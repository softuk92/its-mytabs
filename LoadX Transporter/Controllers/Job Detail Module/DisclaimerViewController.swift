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

class DisclaimerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SwiftSignatureViewDelegate, CLLocationManagerDelegate {
   
    
  
    var User_location = CLLocationManager()
    
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var signatureView: SwiftSignatureView!
    @IBOutlet weak var signature_Image: UIImageView!
    
    var jobId: String?
    var customerName: String?
    private var signature_imagePicked = 0
    private var imageData1 : Data?
    private var imageData2 : Data?
    var parentVC: JobPickupDropoffViewController?
    var isPickup: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signature_Image.isHidden = true
        
        self.signatureView.layer.cornerRadius = 5
        
        self.signatureView.delegate = self
        
        dateLabel.text = "Date: \(Date().string(format: "dd-MMMM-yyyy", timezone: .current))"
        setDisclaimerText()
    }
    
    func setDisclaimerText() {
        if let customerName = customerName {
            receiverName.text = customerName
        }
        disclaimerLabel.text = "Disclaimer \n\nWe are contracted to deliver your goods as entrusted to us as per our Standard Terms & Conditions. \n\nAny additional work, such as moving items in or around the property, disassembling/reassembling items or furniture, removing/refitting doors (for ease of access), \("squeezing") large items through narrows doors/corridors, etc is undertaken at your own risk, and we are under no obligation to carry out such work, upon your insistence, we have agreed to carry out this work, which is contrary to our Standard Terms & Conditions. \n\nAny damage caused to furniture, doors, walls or property under these circumstances is your sole responsibility and neither the Transporter nor LoadX can be held responsible for such damage."
    }
    
    @IBAction func clear_btn(_ sender: Any) {
        signatureView.clear()
    }
    
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
          
      }
      
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan: UIPanGestureRecognizer) {
          
      }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtn(_ sender: Any) {

        self.signature_Image.image = signatureView.getCroppedSignature()
        
        if self.signature_Image.image != nil {
            signature_imagePicked = 1
        }
        
        dislaimerAct(url: main_URL+"api/disclaimerAPI")
        
    }
    
    func dislaimerAct(url: String) {
        SVProgressHUD.show()
        if receiverName.text != "" {

            var params = [String: Optional<String>]()
            
                guard let jobId = jobId else { return }
                params = ["jb_id" : jobId, "disclaimer_customer_name" : self.receiverName.text!]
           
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
               
                if self.signature_imagePicked == 1 {
                    multipartFormData.append(self.imageData2!, withName: "disclaimer_image", fileName: "swift_file2.jpeg", mimeType: "image/jpeg")
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
                                
                                if self.isPickup {
                                UserDefaults.standard.setValue(true, forKey: self.jobId!+"pickup")
                                } else {
                                UserDefaults.standard.setValue(true, forKey: self.jobId!+"dropoff")
                                }
                                if let vc = UIStoryboard.init(name: "JobDetail", bundle: nil).instantiateViewController(withIdentifier: "JobSuccessController") as? JobSuccessController {
                                    vc.modalPresentationStyle = .fullScreen
                                    vc.buttonText = "Back to Job"
                                    vc.ensureText = "Disclaimer has been submitted."
                                    self.dismiss(animated: true) { [weak self] in
                                        guard let self = self else { return }
                                        self.parentVC?.present(vc, animated: true, completion: nil)
                                    }
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

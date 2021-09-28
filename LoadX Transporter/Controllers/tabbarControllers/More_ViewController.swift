//
//  More_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 03/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import SKPhotoBrowser
import GoogleSignIn
import Cosmos
import LabelSwitch
import RxSwift

//@available(iOS 13.0, *)
class More_ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var feedback_stars: UILabel!
    @IBOutlet weak var manageDriverView: UIView!
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var reachUsView: UIView!
    @IBOutlet weak var affiliatedWithView: UIView!
    
    
    let sb = UIStoryboard(name: "Main", bundle: nil)
    var images = [SKPhoto]()
    let picker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    private var imagePicked = 0
    let tapRec = UITapGestureRecognizer()
    private var imageThree = 0
    private var imageData3 : Data?
    private var disposeBag = DisposeBag()
    @IBOutlet weak var themeSwitch: UISwitch!
   
    @IBOutlet weak var lableSwitch: CustomUISwitch!
    @IBOutlet weak var noFeedbackView: UIView!
     
    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        imageProfile.isUserInteractionEnabled = true
        imageProfile.makeRounded()
        imageProfile.setRounded()
        //       dashboradUpdateImage()
        profileDetail()
        
        // Make switch be triggered by tapping on any position in the switch
        //        self.lableSwitch.fullSizeTapEnabled = true
        
        // Set the delegate to inform when the switch was triggered
        //        self.lableSwitch.delegate = self
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                print("Dark mode")
            }
            else {
                print("Light mode")
            }
            
            if UserDefaults.standard.bool(forKey: "dark") == true || UITraitCollection.current.userInterfaceStyle == .dark {
                self.lableSwitch.switchState.accept(true)
            } else {
                self.lableSwitch.switchState.accept(false)
            }
            
            lableSwitch.configureGesture()
            lableSwitch.switchState.skip(1).subscribe(onNext: { (value) in
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = value ? .dark : .light
                    UserDefaults.standard.set(value, forKey: "dark")
                }
            }).disposed(by: disposeBag)
        }
        if user_type == TransportationCompany {
            manageDriverView.isHidden = false
        }
        else{
            manageDriverView.isHidden = true
        }
        
        availabilityView.isHidden = isCompanyDriver == "1"
        statisticsView.isHidden = isCompanyDriver == "1"
        reachUsView.isHidden = isCompanyDriver == "1"
        affiliatedWithView.isHidden = !(isCompanyDriver == "1")
    }
    
        @IBAction func userProfileBtn(_ sender: Any) {
           transporter_id = user_id
            tapGesture()
        }
    
    @IBAction func showManageTransporter(_ sender: Any) {
        let vc = ManageTransporterViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapGesture(){
            let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("option 1 pressed")
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                    self.imagePicked = 1
                    //self.imageOne = sender.tag
                    self.present(self.imagePicker, animated: true, completion: nil)
                   
                } else {
                    print("Camera Not Available")
                }
            })
            
            let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicked = 1
                //self.imageOne = sender.tag
                self.present(self.imagePicker, animated: true, completion: nil)
                
            })
            
            let View = UIAlertAction(title: "View Photo", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let browser = SKPhotoBrowser(photos: self.images)
                browser.initializePageIndex(0)
                self.present(browser, animated: true, completion: nil)
            })
           
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            optionMenu.addAction(View)
            optionMenu.addAction(cameraAction)
            optionMenu.addAction(photoAction)
            optionMenu.addAction(cancelAction)
            optionMenu.popoverPresentationController?.sourceView = self.view;
            optionMenu.popoverPresentationController?.sourceRect =  CGRect(x: 0, y: 50, width: 1.0, height: 1.0)
           
            self.present(optionMenu, animated: true, completion: nil)
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let packedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if imagePicked == 1 {
            self.imageProfile.image = packedImage
            self.imageProfile.contentMode = .scaleToFill
            self.imageThree = 1
            self.dashboradUpdateImage()
        }
        
        dismiss(animated: true)
    }
    
    func dashboradUpdateImage(){
        
        let documents_URL = main_URL+"api/transporterUpdatePicture"
        let parameters = ["userid" : user_id!]
        SVProgressHUD.show(withStatus: "Updating documents...")
           
        if imageThree == 1 {
            var image2 = imageProfile.image
            image2 = image2?.resizeWithWidth(width: 500)
            imageData3 = image2?.jpegData(compressionQuality: 0.2)
                 }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                       }
            if self.imageThree == 1 {
                multipartFormData.append(self.imageData3!,  withName: "profilepic", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
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
//                        print(response.request!)  // original URL request
//                        print(response.response!) // URL response
//                        print(response.data!)     // server data
//                        print(response.result)   // result of response serialization
                        let jsonData : JSON = JSON(response.result.value!)
                        print("image upload JSON: \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        SVProgressHUD.dismiss()
                        if result != "0" {
                        SVProgressHUD.showSuccess(withStatus: "Documents updated successfully")
                       
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
    }

    
    @IBAction func account_action(_ sender: Any) {
         let showVC = sb.instantiateViewController(withIdentifier: "Account_ViewController") as? Account_ViewController
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func security_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "Security_ViewController") as? Security_ViewController
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func satistics_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "satistics_ViewController") as? satistics_ViewController
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func notification_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "Notification_ViewController") as? Notification_ViewController
    self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func reachUs_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "Reach_Us_ViewController") as? Reach_Us_ViewController
    self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func help_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "Help_ViewController") as? Help_ViewController
    self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func availabilityTap(_ sender: Any) {
        let sb = UIStoryboard(name: "TransporterAvailability", bundle: nil)
        let showVC = sb.instantiateViewController(withIdentifier: "TransporterAvailabilityViewController") as? TransporterAvailabilityViewController
       self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func invite_transporter_action(_ sender: Any) {
       
        let textToShare = "Hey, I've been using the LoadX Transporter App to pick up jobs whenever I want.\n The LoadX Transporter App has loads of different jobs in your area all available to accept, click the link below to download the app and sign up for free! \n https://play.google.com/store/apps/details?id=com.ctsmoveuk.transporter"

            let   appId = "id1458875857?mt=8"
           if let myWebsite = URL(string : "itms-apps://itunes.apple.com/app/" + appId) {//Enter link to your app here
               let objectsToShare = [textToShare, myWebsite] as [Any]
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

               self.present(activityVC, animated: true, completion: nil)

        }
    }
    
    @IBAction func affiliatedWithAct(sender: Any) {
        let sb = UIStoryboard(name: "Affiliated", bundle: nil)
        let showVC = sb.instantiateViewController(withIdentifier: "AffiliatedWithViewController") as? AffiliatedWithViewController
       self.navigationController?.pushViewController(showVC!, animated: true)
    }

    
        func profileDetail() {
    //        SVProgressHUD.show(withStatus: "Getting profile image...")
            if user_id != nil {
                let bookedJobs_URL = main_URL+"api/transporterPublicProfile"
                let parameters : Parameters = ["user_id" : user_id!]
                if Connectivity.isConnectedToInternet() {
                    Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON {
                        response in
                        if response.result.isSuccess {
    //                        SVProgressHUD.dismiss()
                            
                            let jsonData : JSON = JSON(response.result.value!)
                            print("transporter Profile jsonData is \(jsonData)")
                            
                            let result = jsonData[0]["result"].stringValue
                            if result != "0"{
                                self.userName.text = jsonData[0]["user_name"].stringValue.capitalized
                            
                            let image1 = jsonData[0]["user_image_url"].stringValue
                          
                            if image1 != "" {
                                let urlString = main_URL+"public/assets/user_profile_image/"+image1
                                if let url = URL(string: urlString) {
                                    SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                        //print(received, expected)
                                    }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                        if let imageCell = imageReceived {
                                            self.imageProfile.image = imageCell
                                            self.imageProfile.contentMode = .scaleAspectFill
                                            
                                            let photo1 = SKPhoto.photoWithImage(imageCell)
                                            self.images.append(photo1)
                                          
                                        }
                                    }
                                }
                            }
                            let feedbackStars = jsonData[0]["avgfdbck"].stringValue
                            if feedbackStars == "null" || feedbackStars == "0" {
                                self.noFeedbackView.isHidden = false
                                self.feedback_stars.text = "null"
                                self.feedback_stars.isHidden  = true
                                self.cosmosView.isHidden = true
                                self.cosmosView.rating = 0.0
                            } else {
                                self.feedback_stars.isHidden  = false
                                self.cosmosView.isHidden = false
                                self.noFeedbackView.isHidden = true
                                self.feedback_stars.text = String(format: "%.1f", Double(feedbackStars) ?? 0.0)
                                self.cosmosView.rating = Double(feedbackStars) ?? 0.0
                                }
                            }else{
                                SVProgressHUD.dismiss()
                                if let name = UserDefaults.standard.string(forKey: "user_name") {
                                    self.userName.text = name
                                }
                                print("Error \(String(describing: response.result.error))")
//                                let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
    //                        SVProgressHUD.dismiss()
                          
                            print("Error \(String(describing: response.result.error))")
                            let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription ?? "Please Check your internet connection", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                   
                    let alert = UIAlertController(title: "Alert", message: "Please Check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
    //            SVProgressHUD.dismiss()
//                let alert = UIAlertController(title: "Alert", message: "Please Check your internet connection", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            }
        }
}
//extension More_ViewController: LabelSwitchDelegate {
//
//    func switchChangToState(sender: LabelSwitch) {
//        if sender.curState == .L {
//          print("left state((on state)")
//
//            self.lableSwitch.backgroundColor = .none
//            self.lableSwitch.circleColor = .init(hexString: "#AAAAAA")
//            self.lableSwitch.layer.borderWidth = 0.5
//            self.lableSwitch.layer.borderColor = UIColor.gray.cgColor
//            UIApplication.shared.windows.forEach { window in
//                if #available(iOS 13.0, *) {
//                    if UserDefaults.standard.bool(forKey: "dark") == false {
//                    window.overrideUserInterfaceStyle = .dark
//                    UserDefaults.standard.set(true, forKey: "dark")
//                    }
//                }
//
//            }
//
//        }else{
//             print("Right state((off state)")
//            self.lableSwitch.circleColor = .init(hexString: "#039846")
//                      self.lableSwitch.backgroundColor = .init(hexString: "#296013")
//                      UIApplication.shared.windows.forEach { window in
//                             if #available(iOS 13.0, *) {
//                                if UserDefaults.standard.bool(forKey: "dark") == true {
//                                 window.overrideUserInterfaceStyle = .light
//                                UserDefaults.standard.set(false, forKey: "dark")
//                                }
//                             }
//                         }
//        }
//    }
//}


extension UIImageView {

func makeRounded() {

    self.layer.borderWidth = 1
    self.layer.masksToBounds = false
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.cornerRadius = self.frame.height / 2
    self.clipsToBounds = true
    }
    func setRounded() {
        let radius = self.frame.width / 2
             self.layer.cornerRadius = radius
             self.layer.masksToBounds = true
          }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

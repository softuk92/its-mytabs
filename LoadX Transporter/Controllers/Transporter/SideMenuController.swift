//
//  PersonalSideMenuController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 10/15/18.
//  Copyright © 2018 Fahad Inco. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleSignIn
import AVFoundation
import SDWebImage
import SKPhotoBrowser

class SideMenuController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var userImage_view: UIView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var loadxPartner_lbl: UILabel!
    
    @IBOutlet weak var sperator_line: UIView!
    @IBOutlet weak var dashboard_view: UIView!
    @IBOutlet weak var dashboard_img: UIImageView!
    @IBOutlet weak var dashboard_btn: UIButton!
    
    @IBOutlet weak var review_view: UIView!
    @IBOutlet weak var review_btn: UIButton!
    @IBOutlet weak var review_img: UIImageView!
    
    @IBOutlet weak var searchJob_view: UIView!
    @IBOutlet weak var searchJob_btn: UIButton!
    @IBOutlet weak var search_img: UIImageView!
    
    @IBOutlet weak var viewAllQueris_view: UIView!
    @IBOutlet weak var viewAllQuery_btn: UIButton!
    @IBOutlet weak var viewAllqueries_img: UIImageView!
    
    @IBOutlet weak var editProfile_view: UIView!
    @IBOutlet weak var editProfile_btn: UIButton!
    @IBOutlet weak var editProfile_img: UIImageView!
    
    @IBOutlet weak var report_view: UIView!
    @IBOutlet weak var report_btn: UIButton!
    @IBOutlet weak var report_img: UIImageView!
    
    @IBOutlet weak var payment_view: UIView!
    @IBOutlet weak var payment_btn: UIButton!
    @IBOutlet weak var payment_img: UIImageView!
    
    @IBOutlet weak var contact_view: UIView!
    @IBOutlet weak var contact_btn: UIButton!
    @IBOutlet weak var contact_img: UIImageView!
    
    @IBOutlet weak var faq_view: UIView!
    @IBOutlet weak var faq_btn: UIButton!
    @IBOutlet weak var faq_img: UIImageView!
    
    @IBOutlet weak var terms_view: UIView!
    @IBOutlet weak var term_btn: UIButton!
    @IBOutlet weak var term_img: UIImageView!
    
    @IBOutlet weak var policy_view: UIView!
    @IBOutlet weak var policy_btn: UIButton!
    @IBOutlet weak var policy_img: UIImageView!
    
    @IBOutlet weak var rate_view: UIView!
    @IBOutlet weak var rate_btn: UIButton!
    @IBOutlet weak var rate_img: UIImageView!
    
    @IBOutlet weak var setting_view: UIView!
    @IBOutlet weak var setting_btn: UIButton!
    @IBOutlet weak var setting_img: UIImageView!
    
    @IBOutlet weak var logout_view: UIView!
    @IBOutlet weak var logout_btn: UIButton!
    @IBOutlet weak var logout_img: UIImageView!
    @IBOutlet weak var seperator_line_PaymentHistory: UIView!
    
     var images = [SKPhoto]()
    let picker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    private var imagePicked = 0
    let userDefaults = UserDefaults.standard
    let manager = FBSDKLoginManager()
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    let tapRec = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameUser = user_name?.capitalized
        userName.text = nameUser ?? ""
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            print("already authorized")
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    print("access allowed")
                    //access allowed
                } else {
                    print("already authorized")
                    //access denied
                }
            })
        }
        
        imageProfile.isUserInteractionEnabled = true

        profileDetail()
        DarkMode()
    }
    
        func DarkMode(){
            if switchCheck == true {
                tableview.backgroundColor = UIColor.black
               userImage_view.backgroundColor = UIColor.darkGray
                sperator_line.backgroundColor = UIColor.white
                seperator_line_PaymentHistory.backgroundColor = UIColor.white
                loadxPartner_lbl.textColor = UIColor.white
                userName.textColor = UIColor.white
                dashboard_view.backgroundColor = UIColor.darkGray
                dashboard_img.image = UIImage(named: "dashboradDark")
               // dashboard_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                dashboard_btn.setTitleColor(.white, for: .normal)
                
                review_view.backgroundColor = UIColor.darkGray
                
                review_img.image = UIImage(named: "reviewDark")
                //.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                review_btn.setTitleColor(.white, for: .normal)
                
                searchJob_view.backgroundColor = UIColor.darkGray
                
                search_img.image = UIImage(named: "searchDark")
    //            searchJob_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                searchJob_btn.setTitleColor(.white, for: .normal)
                viewAllQueris_view.backgroundColor = UIColor.darkGray
                viewAllqueries_img.image = UIImage(named: "qureyDark")
                //viewAllQuery_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                viewAllQuery_btn.setTitleColor(.white, for: .normal)
                editProfile_view.backgroundColor = UIColor.darkGray
                editProfile_img.image = UIImage(named: "editDark")
               // editProfile_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                editProfile_btn.setTitleColor(.white, for: .normal)
                report_view.backgroundColor = UIColor.darkGray
                report_img.image = UIImage(named: "reportDark")
               // report_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                report_btn.setTitleColor(.white, for: .normal)
                payment_view.backgroundColor = UIColor.darkGray
                payment_img.image = UIImage(named: "cashDark")
                //payment_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                payment_btn.setTitleColor(.white, for: .normal)
                contact_view.backgroundColor = UIColor.darkGray
                contact_img.image = UIImage(named: "contactDark")
                //contact_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                contact_btn.setTitleColor(.white, for: .normal)
                faq_view.backgroundColor = UIColor.darkGray
                faq_img.image = UIImage(named: "faqsDark")
                //faq_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                faq_btn.setTitleColor(.white, for: .normal)
                terms_view.backgroundColor = UIColor.darkGray
                term_img.image = UIImage(named: "termDark")
                //term_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                term_btn.setTitleColor(.white, for: .normal)
                policy_view.backgroundColor = UIColor.darkGray
                policy_img.image = UIImage(named: "privcyDark")
               // policy_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                policy_btn.setTitleColor(.white, for: .normal)
                rate_view.backgroundColor = UIColor.darkGray
                rate_img.image = UIImage(named: "rateUsDark")
                //rate_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                rate_btn.setTitleColor(.white, for: .normal)
                setting_view.backgroundColor = UIColor.darkGray
                setting_img.image = UIImage(named: "settingDark")
                //setting_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                setting_btn.setTitleColor(.white, for: .normal)
                logout_view.backgroundColor = UIColor.darkGray
                logout_img.image = UIImage(named: "logoutDark")
                //logout_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                logout_btn.setTitleColor(.white, for: .normal)
            }else{
                sperator_line.isHidden = true
                seperator_line_PaymentHistory.isHidden = true
            }
        }


    
    @IBAction func userProfile(_ sender: Any) {
        transporter_id = user_id
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func userProfileBtn(_ sender: Any) {
       transporter_id = user_id
        tapGesture()
    }
    
    @IBAction func userProfile_btn(_ sender: UIButton) {
//        imagePick(sender: sender.tag)
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
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 800, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let packedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if imagePicked == 1 {
            self.imageProfile.image = packedImage
             self.dashboradUpdateImage()
        }
        
        dismiss(animated: true)
    }
    
    func profileDetail() {
//        SVProgressHUD.show(withStatus: "Getting profile image...")
        if user_id != nil {
            let bookedJobs_URL = main_URL+"api/getTransporterProfileDetail"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
//                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("transporter Profile jsonData is \(jsonData)")
                        self.userName.text = jsonData[0]["user_name"].stringValue
                        
                        let image1 = jsonData[0]["user_image_url"].stringValue
                      
                        if image1 != "" {
                            let urlString = main_URL+"public/assets/user_profile_image/"+image1
                            if let url = URL(string: urlString) {
                                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                    //print(received, expected)
                                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                    if let imageCell = imageReceived {
                                        self.imageProfile.image = imageCell
                                        self.imageProfile.contentMode = .scaleAspectFit
                                        
                                        let photo1 = SKPhoto.photoWithImage(imageCell)
                                        
                                        self.images.append(photo1)
                                        
                                       
                                    }
                                }
                            }
                        }
                        
                    } else {
//                        SVProgressHUD.dismiss()
                        
                    }
                }
            } else {
//                SVProgressHUD.dismiss()
            }
        } else {
//            SVProgressHUD.dismiss()
            
        }
    }

    func dashboradUpdateImage(){
//        api/transporterUpdatePicture
//        profilepic
//        userid
        
    }
    
    @IBAction func loggedOut(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "Sign Out", message: "Do You Want to Sign Out?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "userLoggedIn")
            userDefaults.removeObject(forKey: "user_id")
            userDefaults.removeObject(forKey: "user_name")
            userDefaults.removeObject(forKey: "user_email")
            userDefaults.removeObject(forKey: "userPass")
            userDefaults.removeObject(forKey: "user_phone")
            userDefaults.removeObject(forKey: "user_image")
            userDefaults.removeObject(forKey: "user_type")
            userDefaults.synchronize()
            user_id = nil
            user_name = nil
            user_email = nil
            GIDSignIn.sharedInstance().signOut()
            
            self.manager.logOut()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            let showVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            
            self.dismiss(animated: true, completion: {
                UIApplication.shared.keyWindow?.rootViewController = showVC
            })
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func dashboardBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func terms(_ sender: Any) {
        termsAndConditions(appId: "terms-and-conditions") { (success) in
            print("Privacy Policy \(success)")
        }
    }
    
    func termsAndConditions(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "http://www.ctsmove.com/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    
    @IBAction func privacyPolicyBtn(_ sender: Any) {
        privacyPolicy(appId: "privacy-policy") { (success) in
            print("Privacy Policy \(success)")
        }
    }
    
    func privacyPolicy(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "https://www.ctsmove.com/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    @IBAction func rateUsBtn(_ sender: Any) {
        rateApp(appId: "id1458875857?mt=8") { (success) in
            print("Rateapp \(success)")
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        let refreshAlert = UIAlertController(title: "Rate LoadX ", message: "Please Rate our app at App Store", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Rate", style: .default, handler: { (action: UIAlertAction!) in
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}

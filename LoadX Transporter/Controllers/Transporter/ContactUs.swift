//
//  ContactUs.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/4/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable
import GooglePlaces
import GoogleMaps

class ContactUs: UIViewController {

    @IBOutlet weak var parent_view: UIView!
    @IBOutlet weak var fullName: AnimatableTextField!
    @IBOutlet weak var email_addres: AnimatableTextField!
    @IBOutlet weak var phone: AnimatableTextField!
    @IBOutlet weak var subject: AnimatableTextField!
    @IBOutlet weak var message: AnimatableTextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var website_link_btn: UIButton!
    
    @IBOutlet weak var anyQuestion_lbl: UILabel!
    @IBOutlet weak var phone_btn: UIButton!
    @IBOutlet weak var addressDetial_lbl: UILabel!
   
    @IBOutlet weak var facebook_btn: UIButton!
    @IBOutlet weak var tweeter_btn: UIButton!
    @IBOutlet weak var youtube_btn: UIButton!
    
    @IBOutlet weak var fullName_icon: UIImageView!
    @IBOutlet weak var email_icon: UIImageView!
    @IBOutlet weak var phone_icon: UIImageView!
    @IBOutlet weak var subject_icon: UIImageView!
    @IBOutlet weak var submit_btn: AnimatableButton!
    
    var phoneNumber: String?
   let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
   
    let yourAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
        NSAttributedString.Key.foregroundColor : UIColor.blue,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributeString = NSMutableAttributedString(string: "info@loadx.co.uk",
                                                        attributes: yourAttributes)
        website_link_btn.setAttributedTitle(attributeString, for: .normal)
        
        self.title = "Contact Us"
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.5680904,longitude: -0.2410402, zoom: 10)
        mapView.animate(to: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:  51.5680904, longitude: -0.2410402)
        marker.title = "LoadX Ltd"
        marker.map = mapView
        
//        let camera = GMSCameraPosition.camera(withLatitude: 51.5680904,longitude: -0.2410402, zoom: 10.0)
//         mapView.animate(to: camera)
//               mapView.camera = camera
//               let marker = GMSMarker()
//               marker.position = CLLocationCoordinate2D(latitude:  51.5680904, longitude: -0.2410402)
//               marker.title = "LoadX Ltd"
//               marker.map = mapView
        
        
        if user_name != nil {
        fullName.text = user_name
        }
        if user_email != nil {
        email_addres.text = user_email
        }
        if user_phone != nil {
        phone.text = user_phone
        }
        get_contact_no()
        edit_darkMode()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    func edit_darkMode(){
               if switchCheck == true {
                  self.parent_view.backgroundColor = UIColor(hexString: "191D20")
                  self.fullName.backgroundColor = UIColor(hexString: "252A2D")
                  self.email_addres.backgroundColor = UIColor(hexString: "252A2D")
                  self.phone.backgroundColor = UIColor(hexString: "252A2D")
                  self.subject.backgroundColor = UIColor(hexString: "252A2D")
                  self.message.backgroundColor = UIColor(hexString: "252A2D")
                    
                  self.fullName.textColor = UIColor.white
                  self.email_addres.textColor = UIColor.white
                  self.phone.textColor = UIColor.white
                  self.subject.textColor = UIColor.white
                  self.message.textColor = UIColor.white
                 
                   self.fullName_icon.image = UIImage(named: "fullNameDark")
                   self.email_icon.image = UIImage(named: "emailAddressDark")
                   self.phone_icon.image = UIImage(named: "phoneNumberDark")
                   self.subject_icon.image = UIImage(named: "subjectDark")
                   self.address_lbl.textColor = UIColor.white
                   self.addressDetial_lbl.textColor = UIColor.white
                   self.anyQuestion_lbl.textColor = UIColor.white
                   
                 submit_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                 submit_btn.setTitleColor(.white, for: .normal)
                 
               website_link_btn.setTitleColor(.white, for: .normal)
                
                phone_btn.setTitleColor(.white, for: .normal)
                
                facebook_btn.setBackgroundImage(UIImage(named: "facebookDark"), for: .normal)
                tweeter_btn.setBackgroundImage(UIImage(named: "twitterDark"), for: .normal)
                youtube_btn.setBackgroundImage(UIImage(named: "youtubeDarkA"), for: .normal)
                
                
                let yourAttributes : [NSAttributedString.Key: Any] = [
                       NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
                       NSAttributedString.Key.foregroundColor : UIColor.white,
                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
                
                let attributeString = NSMutableAttributedString(string: "info@loadx.co.uk", attributes: yourAttributes)
                website_link_btn.setAttributedTitle(attributeString, for: .normal)
        }
    }
    func get_contact_no(){
        SVProgressHUD.show(withStatus: "Please wait...")
        let url = main_URL+"api/get_phone_no"
        
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(url, method : .get, parameters : nil).responseJSON {
                response in
                if  response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    let jsonData : JSON = JSON(response.result.value!)
                    print("Contact Number is :.......\(jsonData)")
                    
                    let show_phone_num = jsonData[0]["phone_no"].string
                    print(show_phone_num!)
                    self.phone_btn.setTitle("Phone: \(show_phone_num!) (9am to 9pm)", for: .normal)
                  
                    self.phoneNumber = jsonData[0]["phone_w_code"].string
                    print(self.phoneNumber!)
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: "Contact Number Api not working", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func submit(_ sender: Any) {
        contactUsFunc()
    }
    
    func contactUsFunc() {
        SVProgressHUD.show(withStatus: "...")
        if self.fullName.text != "" && self.email_addres.text != "" && phone.text != "" && self.subject.text != "" && self.message.text != "" {
            let login_URL = main_URL+"api/sendContactUsQuery"
            let parameters : Parameters = ["name" : self.fullName.text!, "email" : self.email_addres.text!, "phone" : self.phone.text!, "subject" : self.subject.text!, "comments" : self.message.text!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(login_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("contact us jsonData is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                    
                        if result != "0" {
                            self.performSegue(withIdentifier: "send", sender: self)
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

    @IBAction func fbLike(_ sender: UIButton) {
        
        let fbURLWeb: URL = URL(string: "https://www.facebook.com/loadxuk/")!
        let fbID: URL = URL(string: "fb://profile/1828931140763856")!
        
        if(UIApplication.shared.canOpenURL(fbID)) {
            UIApplication.shared.open(fbID, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(fbURLWeb, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func youtubeLike(_ sender: UIButton) {
        
        let youURLWeb: URL = URL(string: "https://www.youtube.com/channel/UCVedSDaBt6rfCo6_z44klOA/")!
        let youID: URL = URL(string: "youtube://ctsmove/UCVedSDaBt6rfCo6_z44klOA")!
        
        if(UIApplication.shared.canOpenURL(youID)) {
            UIApplication.shared.open(youID, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(youURLWeb, options: [:], completionHandler: nil)
        }
        
        
    }
    
    @IBAction func twitterLike(_ sender: UIButton) {
        
        let twitterURLWeb: URL = URL(string: "https://twitter.com/loadxuk")!
        let twitterID: URL = URL(string: "twitter://cts_move/854031450823327744")!
        
        if(UIApplication.shared.canOpenURL(twitterID)) {
            UIApplication.shared.open(twitterID, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(twitterURLWeb, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func googlePlus(_ sender: Any) {
        
        let twitterID: URL = URL(string: "https://plus.google.com/104983973428693380863")!
        
        if(UIApplication.shared.canOpenURL(twitterID)) {
            UIApplication.shared.open(twitterID, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(twitterID, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func callUs(_ sender: UIButton) {
        if let url = URL(string: "tel://\(self.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    @IBAction func openEmail(_ sender: Any) {
        
        let email = "info@loadx.co.uk"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}


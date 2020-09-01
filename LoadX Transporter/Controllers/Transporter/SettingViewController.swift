
import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SettingViewController: UIViewController {

    @IBOutlet weak var theme_lbl: UILabel!
    @IBOutlet weak var darkMode_lbl: UILabel!
    @IBOutlet weak var notification_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var accountSetting_lbl: UILabel!
    @IBOutlet weak var deactive_lbl: UILabel!
    @IBOutlet weak var about_lbl: UILabel!
    @IBOutlet weak var version_name_lbl: UILabel!
    @IBOutlet weak var lastUpdate_lbl: UILabel!
    @IBOutlet weak var comingSoon_lbl: UILabel!
    
    @IBOutlet weak var account_deactivate_lbl: UILabel!
    @IBOutlet weak var version_lbl: UILabel!
    @IBOutlet weak var updated_date_lbl: UILabel!
    
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var theme_view: UIView!
    @IBOutlet weak var notification_view: UIView!
    @IBOutlet weak var account_view: UIView!
    @IBOutlet weak var about_view: UIView!
   
    @IBOutlet weak var darkMode_view: UIView!
    @IBOutlet weak var email_View: UIView!
    @IBOutlet weak var phone_view: UIView!
    @IBOutlet weak var deactivate_view: UIView!
    @IBOutlet weak var version_view: UIView!
    @IBOutlet weak var update_view: UIView!
    @IBOutlet weak var emailSwitch_btn: UISwitch!
    @IBOutlet weak var darkMode_switchBtn: UISwitch!
    @IBOutlet weak var account_deactive_switch: UISwitch!
    
    var emailNotification = ""
    var DarkModeCheck : Bool = false
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account Settings"
        // Do any additional setup after loading the view.

        darkMode_view.layer.cornerRadius = 8
        darkMode_view.layer.borderWidth = 0.1
        
        email_View.layer.cornerRadius = 8
        email_View.layer.borderWidth = 0.1
        
        phone_view.layer.cornerRadius = 8
        phone_view.layer.borderWidth = 0.1
        
        deactivate_view.layer.cornerRadius = 8
        deactivate_view.layer.borderWidth = 0.1
        
        version_view.layer.cornerRadius = 8
        version_view.layer.borderWidth = 0.1
        
        update_view.layer.cornerRadius = 8
        update_view.layer.borderWidth = 0.1
        
        showProfile()
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "1.0"
        print("\n this is version Number :\(versionNumber)\n")
        version_lbl.text = (versionNumber) as? String
        updated_date_lbl.text = "12-Jan-2020"
        
       // let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
      //  account_deactivate_lbl.isUserInteractionEnabled = true
       // account_deactivate_lbl.addGestureRecognizer(tap)
    
        if switchCheck == false{
            darkMode_switchBtn.isOn = false
        }else{
            darkMode_switchBtn.isOn = true
            darkMode()
        }
    }
    
    @IBAction func darkMode_switchBtn(_ sender: Any) {
       
        darkMode()
    }
    @IBAction func accountDeactive_Switch(_ sender: Any) {
        if account_deactive_switch.isOn == true {
            tapFunction()
        }else{
            
        }
    }
    
    func darkMode()  {
        if darkMode_switchBtn.isOn == true {
             DarkModeCheck = true
             UserDefaults.standard.set(DarkModeCheck, forKey: "mySwitch")
             theme_lbl.textColor = UIColor.white
            theme_lbl.backgroundColor = UIColor(hexString: "252A2D")
             darkMode_lbl.textColor = UIColor.white
             notification_lbl.textColor = UIColor.white
            notification_lbl.backgroundColor = UIColor(hexString: "252A2D")
             email_lbl.textColor = UIColor.white
             phone_lbl.textColor = UIColor.white
             comingSoon_lbl.textColor = UIColor.white
             accountSetting_lbl.textColor = UIColor.white
            accountSetting_lbl.backgroundColor = UIColor(hexString: "252A2D")
             deactive_lbl.textColor = UIColor.white
             about_lbl.textColor = UIColor.white
            about_lbl.backgroundColor = UIColor(hexString: "252A2D")
             version_lbl.textColor = UIColor.white
             version_name_lbl.textColor = UIColor.white
             lastUpdate_lbl.textColor = UIColor.white
             account_deactivate_lbl.textColor = UIColor.white
             updated_date_lbl.textColor = UIColor.white
            
            self.darkMode_view.backgroundColor = UIColor(hexString: "252A2D")
            self.email_View.backgroundColor = UIColor(hexString: "252A2D")
            self.deactivate_view.backgroundColor = UIColor(hexString: "252A2D")
            self.version_view.backgroundColor = UIColor(hexString: "252A2D")
            self.update_view.backgroundColor = UIColor(hexString: "252A2D")
            self.phone_view.backgroundColor = UIColor(hexString: "252A2D")
            self.background_view.backgroundColor = UIColor.black
            self.theme_view.backgroundColor = UIColor.black
            self.notification_view.backgroundColor = UIColor.black
            self.account_view.backgroundColor = UIColor.black
            self.about_view.backgroundColor = UIColor.black
           
        }else{
            DarkModeCheck = false
             UserDefaults.standard.set(DarkModeCheck, forKey: "mySwitch")
            
             theme_lbl.textColor = UIColor.black
            theme_lbl.backgroundColor = UIColor(hexString: "252A2D")
             darkMode_lbl.textColor = UIColor.black
             notification_lbl.textColor = UIColor.black
             email_lbl.textColor = UIColor.black
             phone_lbl.textColor = UIColor.black
             comingSoon_lbl.textColor = UIColor.black
             accountSetting_lbl.textColor = UIColor.black
             deactive_lbl.textColor = UIColor.black
             about_lbl.textColor = UIColor.black
             version_lbl.textColor = UIColor.black
             version_name_lbl.textColor = UIColor.black
             lastUpdate_lbl.textColor = UIColor.black
             account_deactivate_lbl.textColor = UIColor.black
             updated_date_lbl.textColor = UIColor.black
            
            theme_lbl.backgroundColor = UIColor.init(hexString: "FFD400")
            accountSetting_lbl.backgroundColor = UIColor.init(hexString: "FFD400")
            about_lbl.backgroundColor = UIColor.init(hexString: "FFD400")
            notification_lbl.backgroundColor = UIColor.init(hexString: "FFD400")
            self.darkMode_view.backgroundColor = UIColor.white
            self.email_View.backgroundColor = UIColor.white
            self.deactivate_view.backgroundColor = UIColor.white
            self.version_view.backgroundColor = UIColor.white
            self.update_view.backgroundColor = UIColor.white
            self.background_view.backgroundColor = UIColor.white
            self.theme_view.backgroundColor = UIColor.white
            self.notification_view.backgroundColor = UIColor.white
            self.account_view.backgroundColor = UIColor.white
            self.about_view.backgroundColor = UIColor.white
            self.phone_view.backgroundColor = UIColor.white
        }
       
    }
    @objc func tapFunction(){
        let refreshAlert = UIAlertController(title: "Deactivate!", message: "Are you sure, you want to deactivate your account?", preferredStyle: UIAlertController.Style.alert)
             
             refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.account_deactive_switch.isOn = true
                 self.deactiveAccountFunc()
             }))
             
             refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                self.account_deactive_switch.isOn = false
                 print("Handle Cancel Logic here")
             }))
             
             self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func deactiveAccountFunc() {
        SVProgressHUD.show(withStatus: "Deactivating...")
        if user_id != nil {
            let updateProfile_URL = main_URL+"api/UserDeactiveAccount"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateProfile_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        if result == "1" {
                            let storyboardVC = UIStoryboard(name: "Main", bundle: nil)
                            let showVC = storyboardVC.instantiateViewController(withIdentifier: "homeScreen") as! UINavigationController
                            self.present(showVC, animated: true, completion: nil)
                            
                        } else {
                            SVProgressHUD.showError(withStatus: message)
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
            let alert = UIAlertController(title: "Error", message: "Please enter your username", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showProfile() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let editProfileData_URL = main_URL+"api/userProfileDetail"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(editProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("edit Profile jsonData is \(jsonData)")
//
                        let emailNotif = jsonData[0]["email_notification"].stringValue
                        if emailNotif == "0" {
                            self.emailSwitch_btn.isOn = true
                        } else {
                            self.emailSwitch_btn.isOn = false
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

    @IBAction func darkMode_btn(_ sender: Any) {
    }
    
    @IBAction func email_btn(_ sender: Any) {
        if self.emailSwitch_btn.isOn == true {
            emailNotification = "ON"
            emailNotificationFunc()
        }else{
            print("handle the email off function")
            emailNotification = "OFF"
            emailNotificationFunc()
        }
    }
    
    
    
    func emailNotificationFunc() {
        SVProgressHUD.show(withStatus: "Please wait...")
        if user_id != nil {
            let updateNotification_URL = main_URL+"api/UserNotificationSettingUpdate"
            let parameters : Parameters = ["user_id" : user_id!, "emailNotification" : emailNotification]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateNotification_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        if result == "1" {
                            SVProgressHUD.showSuccess(withStatus: message)
                        } else {
                            SVProgressHUD.showError(withStatus: message)
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
            
        }
    }
}

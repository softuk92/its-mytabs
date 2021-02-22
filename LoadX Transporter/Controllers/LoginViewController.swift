//
//  LoginViewController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/25/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import AuthenticationServices

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

var user_id : String?
var user_email : String?
var userPass : String?
var user_name : String?
var user_phone : String?
var user_type : String?
var user_image : String?
var del_id : String?
var jb_id : String?
var payment_id : String?
var driver_id : String?
var job_title : String?
var transporter_id : String?
var protected: Bool?
var frbi_id: String?
var userToken: String?
var isLoadxDriver: String?

//var job_id : String = ""
//var bidId : String = ""
//var new_price : String = ""
//var result = ""
//var resultID = ""
//var signInSegue = ""
//var driver_id = ""
//var job_title = ""
//var driver_name = ""
//var inbox_id = ""
//var personalImage = ""
//
//var long_pickup = ""
//var long_dropoff = ""
//var lat_pickup = ""
//var lat_dropoff = ""
//var imageI = ""
//var imageII = ""
//var imageIII = ""
//var delivery_date = ""
//var detail_description = ""
//var min_price : String?
//var max_price = ""
//var add_comments = ""
//var pickUp = ""
//var dropOff = ""
//var distance_map = ""
//var vehicleType = ""

//@available(iOS 13.0, *)
class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInDelegate {
    
    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let Login_URL = main_URL+"api/loginapi"

    @IBOutlet var background_view: UIView!
    @IBOutlet weak var logo_View: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    @IBOutlet weak var loginWithApple: UIButton!
    @IBOutlet weak var forget_btn: UIButton! // textcolor 404040
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var login_with_lbl: UILabel!
    @IBOutlet weak var dontHaveAccount_lbl: UILabel!
    @IBOutlet weak var signUp_btn: UIButton!
    @IBOutlet weak var updateView: UIView!
    
    let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    var window: UIWindow?
    let date = Date()
    let calendar = Calendar.current
    
//    let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontNames(forFamilyName: "Ubuntu"), .foregroundColor: UIColor.black, .underlineStyle:NSUnderlineStyle.single.rawValue]
                  //.double.rawValue, .thick.rawValue
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Log In"
        let layoutConstraintsArr = loginButton.constraints
        self.navigationController?.navigationBar.isHidden = true
        // Iterate over array and test constraints until we find the correct one:
        for lc in layoutConstraintsArr { // or attribute is NSLayoutAttributeHeight etc.
            if ( lc.constant == 28 ){
                // Then disable it...
                lc.isActive = false
                break
            }
        }
       
        user_type = "driver"
        loginButton.readPermissions = ["email"]
        loginButton.delegate = self


        userName.delegate = self
        _password.delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
            print("token is \(token)")
        }
        

        let components = calendar.dateComponents([.year, .month, .day], from: date)
    
//        let year =  components.year
        let month = components.month
        let day = components.day
        
        if (month == 2 && day! <= 29) || (month == 3 && day! < 30) {
            
            
        } else {
            DispatchQueue.global().async {
                do {
                let update = try self.isUpdateAvailable()
                    DispatchQueue.main.async {
                        if update == true {
                                self.updateView.isHidden = false
                        } else {
                            self.updateView.isHidden = true
                        }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }

        loginWithApple.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)

            }

        @objc func actionHandleAppleSignin() {

            if #available(iOS 13.0, *) {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()

                request.requestedScopes = [.fullName, .email]

                let authorizationController = ASAuthorizationController(authorizationRequests: [request])

                authorizationController.delegate = self

                authorizationController.presentationContextProvider = self

                authorizationController.performRequests()
            }
            
            }
        
    //MARK: - Version Update Func
   /***************************************************************/

        func isUpdateAvailable() throws -> Bool {
    
            guard let info = Bundle.main.infoDictionary,
                let currentVersion = info["CFBundleShortVersionString"] as? String,
                let identifier = info["CFBundleIdentifier"] as? String,
                let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                    throw VersionError.invalidBundleInfo
            }
    
    
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                throw VersionError.invalidResponse
            }
            if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                print("previous version is \(version) && current version is \(currentVersion)")
                let  DeviceCurrentVersion = Float(currentVersion)!
                let  appStoreVersion = Float(version)!
    
                return DeviceCurrentVersion > appStoreVersion
    //            return version != currentVersion
            }
            throw VersionError.invalidResponse
        }
    //MARK: - Google Integration
    /***************************************************************/
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }

        if let fullName = user.profile.name {
            user_name = fullName
            user_email = user.profile.email
            print("email is \(String(describing: user_email))")
            loginWithFacebook()
        }
    }

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }

    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {

    }

    // Dismiss the "Sign in with Google" view

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {

    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

    }


    //MARK: - Facebook Integration
    /***************************************************************/

    func fetchProfile() {
        print("fetch Profile")
        SVProgressHUD.show(withStatus: "Signing In")
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, first_name, relationship_status"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                if let fbDetails = result as? NSDictionary {
                    print("FB Details are \(fbDetails)")
                    user_email = fbDetails["email"] as? String
                    user_name = fbDetails["name"] as? String
                    print("email is \(user_email ?? "") and name is \(String(describing: user_name))")
                    self.loginWithFacebook()
                    SVProgressHUD.dismiss()
                }
            }
        })
    }


    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Completed login")
        if result.isCancelled {
            print("Triggered cancel")
        } else {
            print("Triggered Yes")
            fetchProfile()
        }

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let manager = FBSDKLoginManager()
        manager.logOut()
    }


    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        //        loginWithFacebook()
        print("Trigggered login buttin will login")
        return true
    }

    func loginWithFacebook() {
        print("login with facebook function triggered")
        if user_email != nil && user_name != nil && userToken != nil {
            let parameters : Parameters = ["email" : user_email!, "name" : user_name!, "token" : userToken!]
            let loginFb_URL = main_URL+"api/LoginWithFacebook"
            Alamofire.request(loginFb_URL, method : .post, parameters : parameters).responseJSON {
                response in

                if response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    let jsonData : JSON = JSON(response.result.value!)
                    print("facebook login data is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                    let message = jsonData[0]["message"].stringValue
                    if result == "false" {
                        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else if result == "1" {
                        user_id = jsonData[0]["user_id"].stringValue
                        self.loginWithFacebookUserType()
                    } else {
                        user_type = jsonData[0]["user_type"].stringValue
                        user_id = jsonData[0]["user_id"].stringValue
                        user_email = jsonData[0]["user_email"].stringValue
                        user_name = jsonData[0]["user_name"].stringValue
                        user_phone = jsonData[0]["user_phone"].stringValue
                        user_image = jsonData[0]["user_image"].stringValue
                        isLoadxDriver = jsonData[0]["is_loadx_driver"].stringValue
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(user_id, forKey: "user_id")
                        userDefaults.set(user_name, forKey: "user_name")
                        userDefaults.set(user_email, forKey: "user_email")
                        userDefaults.set(userPass, forKey: "userPass")
                        userDefaults.set(user_phone, forKey: "user_phone")
                        userDefaults.set(user_image, forKey: "user_image")
                        userDefaults.set(user_type, forKey: "user_type")
                        userDefaults.set(isLoadxDriver, forKey: "isLoadxDriver")
                        userDefaults.set(true, forKey: "userLoggedIn")
                        userDefaults.synchronize()
                        self.AppDelegate.moveToHome()
//                        self.performSegue(withIdentifier: "user", sender: self)
                    }
                } else {
                    SVProgressHUD.dismiss()
                    print("Error \(String(describing: response.result.error))")
                    let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription ?? "Please Check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert", message: "Please revoke permission of apple id usage from password and security in profile settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loginWithFacebookUserType() {
        if user_id != nil && user_type != nil {
            SVProgressHUD.show(withStatus: "Signing in...")
            let parameters : Parameters = ["user_id" : user_id!, "user_type" : user_type!]
            let loginFb_URL = main_URL+"api/addusertype"
            Alamofire.request(loginFb_URL, method : .post, parameters : parameters).responseJSON {
                response in
                
                if response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    let jsonData : JSON = JSON(response.result.value!)
                    print("user type login data is \(jsonData)")
                    let result = jsonData[0]["result"].stringValue
                    let message = jsonData[0]["message"].stringValue
                    if result == "false" {
                        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        user_type = jsonData[0]["user_type"].stringValue
                        user_id = jsonData[0]["user_id"].stringValue
                        user_email = jsonData[0]["user_email"].stringValue
                        user_name = jsonData[0]["user_name"].stringValue
                        user_phone = jsonData[0]["user_phone"].stringValue
                        user_image = jsonData[0]["user_image"].stringValue
                        isLoadxDriver = jsonData[0]["is_loadx_driver"].stringValue
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(user_id, forKey: "user_id")
                        userDefaults.set(user_name, forKey: "user_name")
                        userDefaults.set(user_email, forKey: "user_email")
                        userDefaults.set(userPass, forKey: "userPass")
                        userDefaults.set(user_phone, forKey: "user_phone")
                        userDefaults.set(user_image, forKey: "user_image")
                        userDefaults.set(user_type, forKey: "user_type")
                        userDefaults.set(isLoadxDriver, forKey: "isLoadxDriver")
                        userDefaults.set(true, forKey: "userLoggedIn")
                        userDefaults.synchronize()
//                        self.performSegue(withIdentifier: "user", sender: self)
                        self.AppDelegate.moveToHome()
                    }
                    
                } else {
                    SVProgressHUD.dismiss()
                    print("Error \(String(describing: response.result.error))")
                    let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription ?? "Please Check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert", message: "Please revoke permission of apple id usage from password and security in profile settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


    @IBAction func logIn(_ sender: Any) {
        userLogin()
    }
    
    func userLogin() {
        SVProgressHUD.show(withStatus: "Signing In...")
        if self.userName.text != "" && self._password.text != "" {
            let login_URL = main_URL+"api/loginapi"
            let parameters : Parameters = ["email" : self.userName.text!, "password" : self._password.text!, "token" : userToken ?? ""]
            if Connectivity.isConnectedToInternet() {
                print("username is \(self.userName.text!) n password is \(self._password.text!)")
                
                Alamofire.request(login_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("login jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        if result == "false" {
                            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let userType = jsonData[0]["user_type"].stringValue
                            if userType == "driver" {
                            user_type = jsonData[0]["user_type"].stringValue
                            user_id = jsonData[0]["user_id"].stringValue
                            user_email = jsonData[0]["user_email"].stringValue
                            user_name = jsonData[0]["user_name"].stringValue
                            user_phone = jsonData[0]["user_phone"].stringValue
                            user_image = jsonData[0]["user_image"].stringValue
                                isLoadxDriver = jsonData[0]["is_loadx_driver"].stringValue
                                
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(user_id, forKey: "user_id")
                            userDefaults.set(user_name, forKey: "user_name")
                            userDefaults.set(user_email, forKey: "user_email")
                            userDefaults.set(self._password.text ?? "", forKey: "userPass")
                            userDefaults.set(user_phone, forKey: "user_phone")
                            userDefaults.set(user_image, forKey: "user_image")
                            userDefaults.set(user_type, forKey: "user_type")
                                userDefaults.set(isLoadxDriver, forKey: "isLoadxDriver")
                            userDefaults.set(true, forKey: "userLoggedIn")
                            userDefaults.synchronize()
                          
                                
                                self.AppDelegate.moveToHome()
                             
                                
                            } else {
                                let alert = UIAlertController(title: "Alert", message: "Wrong Email or Password", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
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
            let alert = UIAlertController(title: "Error", message: "Please enter email or password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func signUp_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
              self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forget_pass_action(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordController") as! ForgetPasswordController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func google_signIn_Btn(_ sender: Any) {
        googleSignIn.sendActions(for: .touchUpInside)
    }


    @IBAction func facebook_signIn_btn(_ sender: Any) {
        loginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func updateApp(_ sender: Any) {
        rateApp { (sucess) in
            print(sucess)
        }
    }
    
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1458875857?mt=8") else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {

     // ASAuthorizationControllerDelegate function for authorization failed

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        print(error.localizedDescription)

    }

       // ASAuthorizationControllerDelegate function for successful authorization

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            // Create an account as per your requirement

//            let appleId = appleIDCredential.user
//
//            let appleUserFirstName = appleIDCredential.fullName?.givenName
//
//            let appleUserLastName = appleIDCredential.fullName?.familyName
//
//            let appleUserEmail = appleIDCredential.email
            let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            if appleIDCredential.email != nil {
                UserDefaults.standard.setValue(fullName, forKey: "appleName")
                UserDefaults.standard.setValue(appleIDCredential.email ?? "", forKey: "appleEmail")
                user_name = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
                user_email = appleIDCredential.email
            } else {
                if let name = UserDefaults.standard.string(forKey: "appleName"), let email = UserDefaults.standard.string(forKey: "appleEmail") {
                user_name = name
                user_email = email
                }
            }
//            user_name = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
//            user_email = appleIDCredential.email
//            print("email is \(String(describing: user_email))")
            
            loginWithFacebook()

        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {

            let appleUsername = passwordCredential.user

            let applePassword = passwordCredential.password

            //Write your code

        }

    }

}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {

    //For present window

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }

}

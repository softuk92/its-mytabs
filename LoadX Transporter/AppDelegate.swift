//
//  AppDelegate.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import IQKeyboardManagerSwift
import DropDown
import ZDCChat
import SVProgressHUD
var main_URL = "https://www.loadx.co.uk/"

//test api
//var main_URL = "http://www.test.loadx.co.uk/"

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
     var window: UIWindow?
     let sb = UIStoryboard(name: "Main", bundle: nil)
     var searchBtn_bool = false
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        userToken = token
        print("Device Token: \(token)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "testidentified" {
            print("handling  notification with the identifier test identifir")
        }
        
        if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
            let message = parseRemoteNotification(notification: notification)
            print(message as Any)
        }
        
        completionHandler()
    }
    
    private func parseRemoteNotification(notification:[String:AnyObject]) -> String? {
        if let aps = notification["aps"] as? [String:AnyObject] {
            let alert = aps["alert"] as? String
            return alert
        }
        
        return nil
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "TextfieldTextColor")
        application.isStatusBarHidden = true
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
        
        if #available(iOS 13.0, *) {
            if UserDefaults.standard.bool(forKey: "dark") == true || UITraitCollection.current.userInterfaceStyle == .dark {
            UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
            }
        } else {
            UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
            }
        }
        }
        SVProgressHUD.setDefaultMaskType(.clear)
         //new apikey when live the app: AIzaSyANwnbbxW4h3wwHSUjKLk2EVg_H0YNtSi4
        //new apikey with new account when live the app: AIzaSyCRPL-6sONXqdXDX0uZhSXuE25JoHQPmB8
                
        GMSServices.provideAPIKey("AIzaSyD-Al_YFLY-eWSmQjxJVT83SIiRYmrh9rs")
        GMSPlacesClient.provideAPIKey("AIzaSyD-Al_YFLY-eWSmQjxJVT83SIiRYmrh9rs")
                

        //    old one    "AIzaSyC3RxDUypkGErC40MjOc5xOx91MwCuKJ58"
       // testing api key : AIzaSyD-Al_YFLY-eWSmQjxJVT83SIiRYmrh9rs
              
        UIApplication.shared.registerForRemoteNotifications()
        //MARK:- Autologin
       
        let login = self.sb.instantiateViewController(withIdentifier: "SplashScreen_ViewController") as! SplashScreen_ViewController
               let nvc: UINavigationController = UINavigationController(rootViewController: login)
               self.window?.rootViewController = nvc
//               self.window?.makeKeyAndVisible()
//        let navigat = UINavigationController()
       
//        let userDefaults = UserDefaults.standard
//
//        if userDefaults.bool(forKey: "userLoggedIn") {
//            user_id = userDefaults.string(forKey: "user_id") ?? ""
//            user_name = userDefaults.string(forKey: "user_name") ?? ""
//            user_email = userDefaults.string(forKey: "user_email") ?? ""
//            userPass = userDefaults.string(forKey: "userPass") ?? ""
//            user_phone = userDefaults.string(forKey: "user_phone") ?? ""
//            user_image = userDefaults.string(forKey: "user_image") ?? ""
//            user_type = userDefaults.string(forKey: "user_type") ?? ""
//
//            self.moveToHome()
//            
//        } else {
//
//            self.moveToLogInVC()
//        }
        
        //MARK:- API KEYS
        
        
//        PayPalEnvironmentSandbox: "AZvmba7Zz0KuM4ooDZoq_Qdm0n7y48ScVWaqaK_GDfpqvLM5-teB529TgkqGzVw1uRgvnsIU5szPfEZl"]
        
         
        // this is for Live paypal integration
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "Ab04RiFx19BpvbWQ7e5qMRgzd7yJtC-UXBiwb0yygzUfy3U5NLnBsO_IZGIMfDlxR7QJzr08ynxI9xtj"])
        
        // this is for test paypal integration
//        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AZvmba7Zz0KuM4ooDZoq_Qdm0n7y48ScVWaqaK_GDfpqvLM5-teB529TgkqGzVw1uRgvnsIU5szPfEZl"])
               
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "587172480915-vfmq9iep5qedimh9eso3kp286un2dof0.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance()?.delegate = self
        ZDCChat.initialize(withAccountKey: "4k8uFpslgPe7adeBdxoacCrRhCOyELOL")
        
        return true
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance()?.handle(url)
        
//        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
//                                                                sourceApplication: sourceApplication,
//                                                                annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return facebookDidHandle || ((googleDidHandle) != nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func moveToLogInVC() {
        if #available(iOS 13.0, *) {
            let login = self.sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: login)
            self.window?.rootViewController = nvc
            self.window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
        }
        
    }

    func moveToHome() {
        let mainController = self.sb.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        let baseVC: UINavigationController = UINavigationController(rootViewController: mainController)
        
        self.window?.rootViewController = baseVC
        self.window?.makeKeyAndVisible()
    }
    
    func moveToUpdateScreen() {
        let mainController = self.sb.instantiateViewController(withIdentifier: "UpdateAppViewController") as! UpdateAppViewController
        let baseVC: UINavigationController = UINavigationController(rootViewController: mainController)
        
        self.window?.rootViewController = baseVC
        self.window?.makeKeyAndVisible()
    }

}

//

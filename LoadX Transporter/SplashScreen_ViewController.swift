//
//  SplashScreen_ViewController.swift
//  LoadX Transporter
//
//  Created by AIR BOOK on 07/04/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SwiftyGif

class SplashScreen_ViewController: UIViewController {

    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let date = Date()
    let calendar = Calendar.current
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                print("Dark mode")
                 do {
                        let gif = try UIImage(gifName: "splashScreenDark.gif")
                        let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
                    imageview.contentMode = .scaleAspectFit
                    let x =  (self.view.frame.size.width / 2) - (self.view.frame.size.width / 2)
                    let y =  (self.view.frame.size.height / 2) - ((self.view.frame.size.height * 0.7) / 2)
                    imageview.frame = CGRect(x: x, y: y, width: self.view.frame.size.width , height: self.view.frame.size.height * 0.7)
                        view.addSubview(imageview)
                    self.view.backgroundColor = UIColor(red: 25/255, green: 30/255, blue: 31/255, alpha: 1)
                    } catch {
                        print(error)
                    }
            }
            else {
                print("Light mode")
                 do {
                        let gif = try UIImage(gifName: "splashScreenLight.gif")
                    let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
                    imageview.contentMode = .scaleAspectFit
                    let x =  (self.view.frame.size.width / 2) - (self.view.frame.size.width / 2)
                    let y =  (self.view.frame.size.height / 2) - ((self.view.frame.size.height * 0.7) / 2)
                    imageview.frame = CGRect(x: x, y: y, width: self.view.frame.size.width , height: self.view.frame.size.height * 0.7)
                        view.addSubview(imageview)
                    self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
                    } catch {
                        print(error)
                    }
            }
        }
        
   
         self.imageView.delegate = self
         super.viewDidLoad()
    }
     override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: { [weak self] in
                guard let self = self else { return }
                let userDefaults = UserDefaults.standard
                let components = self.calendar.dateComponents([.year, .month, .day], from: Date())
                    
                    let month = components.month
                    let day = components.day
                if userDefaults.bool(forKey: "userLoggedIn") {
                    user_id = userDefaults.string(forKey: "user_id") ?? ""
                    user_name = userDefaults.string(forKey: "user_name") ?? ""
                    user_email = userDefaults.string(forKey: "user_email") ?? ""
                    userPass = userDefaults.string(forKey: "userPass") ?? ""
                    user_phone = userDefaults.string(forKey: "user_phone") ?? ""
                    user_image = userDefaults.string(forKey: "user_image") ?? ""
                    user_type = userDefaults.string(forKey: "user_type") ?? ""
                
                    
                    do {
                        let update = try self.isUpdateAvailable()
                        if update == true {
                            if (month == 12 && day! <= 31) || (month == 1 && day! < 30) {
                                self.AppDelegate.moveToHome()
                            } else {
                            self.AppDelegate.moveToUpdateScreen()
                            }
                        } else {
                            self.AppDelegate.moveToHome()
                        }
                    } catch  {
                        print(error)
                    }
                    
                } else {
                           
                self.AppDelegate.moveToLogInVC()
            }
                
            })
            
        }
    
    //MARK: - Version Update Func
    /***************************************************************/
   func isUpdateAvailable() -> Bool {
    
            guard let info = Bundle.main.infoDictionary,
                let currentVersion = info["CFBundleShortVersionString"] as? String,
                let identifier = info["CFBundleIdentifier"] as? String,
                let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                return false
            }
    
    
            let data = try? Data(contentsOf: url)
            guard let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: [.allowFragments]) as? [String: Any] else {
                return false
//                VersionError.invalidResponse
            }
            if let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                print("previous version is \(version) && current version is \(currentVersion)")
                let  DeviceCurrentVersion = Float(currentVersion)!
                let  appStoreVersion = Float(version)!
    
                return DeviceCurrentVersion > appStoreVersion
    //            return version != currentVersion
            }
//            throw NSError.init(domain: "", code: 420, userInfo: [:])
//    VersionError.invalidResponse
    return false
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    }

extension SplashScreen_ViewController: SwiftyGifDelegate {
        func gifDidStop(sender: UIImageView) {
            imageView.isHidden = true
        }
        
    }



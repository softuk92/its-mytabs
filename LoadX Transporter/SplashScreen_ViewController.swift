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
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        
//         let jeremyGif =  UIImage(gifName: "splashLight.gif")
//
//            self.imageView = UIImageView(gifImage: jeremyGif )
//
//
//         view.addSubview(imageView)
//        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                print("Dark mode")
                 do {
                        let gif = try UIImage(gifName: "splashScreenDark.gif")
                        let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
                //        imageview.frame = view.bounds
                        imageview.frame = CGRect(x: 20.0, y: 150, width: self.view.frame.size.width - 20, height: 370.0)
                        view.addSubview(imageview)
                    } catch {
                        print(error)
                    }
            }
            else {
                print("Light mode")
                 do {
                        let gif = try UIImage(gifName: "splashScreenLight.gif")
                        let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
                //        imageview.frame = view.bounds
                        imageview.frame = CGRect(x: 20.0, y: 150, width: self.view.frame.size.width - 20, height: 370)
                        view.addSubview(imageview)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
               
                let userDefaults = UserDefaults.standard
                       
                if userDefaults.bool(forKey: "userLoggedIn") {
                    user_id = userDefaults.string(forKey: "user_id") ?? ""
                    user_name = userDefaults.string(forKey: "user_name") ?? ""
                    user_email = userDefaults.string(forKey: "user_email") ?? ""
                    userPass = userDefaults.string(forKey: "userPass") ?? ""
                    user_phone = userDefaults.string(forKey: "user_phone") ?? ""
                    user_image = userDefaults.string(forKey: "user_image") ?? ""
                    user_type = userDefaults.string(forKey: "user_type") ?? ""
                          
                self.AppDelegate.moveToHome()
                           
                } else {
                           
                self.AppDelegate.moveToLogInVC()
            }
                
            })
            
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



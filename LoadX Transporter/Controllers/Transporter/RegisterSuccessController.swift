//
//  RegisterSuccessController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baig on 29/05/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class RegisterSuccessController: UIViewController {

    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func checkEmail(_ sender: Any) {
        let optionMenu = UIAlertController(title: "Emails", message: "Choose App", preferredStyle: .actionSheet)
        // 2
        let cameraAction = UIAlertAction(title: "GMAIL", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let googleUrlString = "googlegmail:///co?subject=Hello&body=Hi"
            if let googleUrl = NSURL(string: googleUrlString) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(googleUrl as URL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(googleUrl as URL)
                    }
                }
            }
            
        })
        
        let photoAction = UIAlertAction(title: "MAIL", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let email = "foo@bar.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
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
    
    @IBAction func Login_action(_ sender: Any) {
         self.AppDelegate.moveToLogInVC()
    }
}

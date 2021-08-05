//
//  ContactUsViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 19/10/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var callUsBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    let pakNumber: String = "(+92) 4238938836"
    let otherNumber: String = "02080570111"
    let pakEmail: String = "info@loadx.pk"
    let otherEmail: String = "info@loadx.co.uk"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        if AppUtility.shared.country == .Pakistan {
            callUsBtn.setTitle(pakNumber, for: .normal)
            emailBtn.setTitle(pakEmail, for: .normal)
        } else {
            callUsBtn.setTitle(otherNumber, for: .normal)
            emailBtn.setTitle(otherEmail, for: .normal)
        }
        
    }
    
    @IBAction func callUs(_ sender: UIButton) {
        let phoneN = AppUtility.shared.country == .Pakistan ? pakNumber : otherNumber
           if let url = URL(string: "tel://\(phoneN)"), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10, *) {
                   UIApplication.shared.open(url)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
           
       }
       
       @IBAction func openEmail(_ sender: Any) {
        let email = AppUtility.shared.country == .Pakistan ? pakEmail : otherEmail
           if let url = URL(string: "mailto:\(email)") {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url)
               } else {
                   UIApplication.shared.openURL(url)
               }
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
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    
}

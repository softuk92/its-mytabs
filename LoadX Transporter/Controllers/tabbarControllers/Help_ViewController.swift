//
//  Help_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 04/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SafariServices

class Help_ViewController: UIViewController, SFSafariViewControllerDelegate {

     let sb = UIStoryboard(name: "Main", bundle: nil)
    
    let termsAndConditionsURL = URL(string: "https://www.loadx.pk/terms-and-conditions/app")
    let privacyPolicyURL = URL(string: "https://www.loadx.pk/privacy-policy/app")
    let faqUrl = URL(string: "https://www.loadx.pk/transporter-faq/app")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    
    @IBAction func privacy_action(_ sender: Any) {
        if let url = privacyPolicyURL {
            let vc = SFSafariViewController.init(url: url)
            present(vc, animated: true)
        }
//
//        let showVC = sb.instantiateViewController(withIdentifier: "PrivacyPolicyController") as? PrivacyPolicyController
//        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func terms_action(_ sender: Any) {
        if let url = termsAndConditionsURL {
            let vc = SFSafariViewController.init(url: url)
            present(vc, animated: true)
        }
        
//        let showVC = sb.instantiateViewController(withIdentifier: "TermsAndConditionController") as? TermsAndConditionController
//        self.navigationController?.pushViewController(showVC!, animated: true)
    }

    @IBAction func Faqs_Action(_ sender: Any) {
        if let url = faqUrl {
            let vc = SFSafariViewController.init(url: url)
            present(vc, animated: true)
        }
//
//        let showVC = sb.instantiateViewController(withIdentifier: "FAQSTableViewController") as? FAQSTableViewController
//        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func Appintro_Action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "AppIntro_ViewController") as? AppIntro_ViewController
    self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func AppInfo_action(_ sender: Any) {
        let showVC = sb.instantiateViewController(withIdentifier: "AppInfo_ViewController") as? AppInfo_ViewController
        self.navigationController?.pushViewController(showVC!, animated: true)
    }
}

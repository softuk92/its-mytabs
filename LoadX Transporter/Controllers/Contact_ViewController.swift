//
//  Contact_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 30/01/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Contact_ViewController: UIViewController {

    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var receiverInformationView: UIView!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var receiverPhone: UILabel!
    
    var selectJob: Bool?
    
    var name: String?
    var phone: String?
    var email: String?
    var address: String?
//    var jsonData : JSON
    var jsonData : JSON = []
    var receiverN: String?
    var receiverP: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactView.layer.shadowColor = UIColor.darkGray.cgColor
        contactView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contactView.layer.shadowOpacity = 0.4
        contactView.layer.shadowRadius = 3.0
        
        name = jsonData[0]["user_name"].stringValue.capitalized
        phone = jsonData[0]["user_phone"].stringValue
        email = jsonData[0]["user_email"].stringValue
        address = jsonData[0]["user_address"].stringValue

    }
    override func viewWillAppear(_ animated: Bool) {
        if selectJob == true {
        name_lbl.text = name
        phone_lbl.text = "[phone protected]"
        receiverInformationView.isHidden = true
       } else {
        name_lbl.text = name
        phone_lbl.text = phone
        if receiverN == nil || receiverN == "" {
            receiverInformationView.isHidden = true
        }
        receiverName.text = receiverN
        receiverPhone.text = receiverP
       }
    }
    
    @IBAction func phone_call(_ sender: Any) {
              if selectJob == true {
              }else{
            makePhoneCall(phoneNumber: phone!)
        }
//        guard let number = URL(string: "tel://" + phone!) else { return }
//        UIApplication.shared.open(number)
//    }
    }
    func makePhoneCall(phoneNumber: String) {

        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

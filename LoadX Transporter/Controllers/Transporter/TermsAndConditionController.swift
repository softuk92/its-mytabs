//
//  OurServicesViewController.swift
//  CTSmove
//
//  Created by Fahad Baig on 08/02/2018.
//  Copyright © 2018 Fahad Inco. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TermsAndConditionController: UIViewController {

    @IBOutlet weak var definition_1_lbl: UILabel!
    
    @IBOutlet weak var access_lbl_2: UILabel!
    @IBOutlet weak var prohibited_3: UILabel!
    @IBOutlet weak var intellectual_5: UILabel!
    
    @IBOutlet weak var information_4: UILabel!
    @IBOutlet weak var reliance_6: UILabel!
    @IBOutlet weak var our_liability_7: UILabel!
    
    @IBOutlet weak var uploadingMaterial_8: UILabel!
    
    @IBOutlet weak var information_9: UILabel!
    
    @IBOutlet weak var linking_10: UILabel!
    @IBOutlet weak var jurisdiction_11: UILabel!
    @IBOutlet weak var general_information_12: UILabel!
    @IBOutlet weak var terms_condition: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var f_rule_lbl: UILabel!
    var initialChargesApi : String?
    
    @IBOutlet weak var e_rule_lbl: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Terms & Conditions"
        
       definition_1_lbl.attributedText = NSAttributedString(string: "1. Definition of Terms We Use", attributes:
       [.underlineStyle: NSUnderlineStyle.single.rawValue])
       
        access_lbl_2.attributedText = NSAttributedString(string: "2. Access to Loadx", attributes:
              [.underlineStyle: NSUnderlineStyle.single.rawValue])
              
        prohibited_3.attributedText = NSAttributedString(string: "3. Prohibited Conduct ", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        information_4.attributedText = NSAttributedString(string: "4. Information Standard", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                    
        intellectual_5.attributedText = NSAttributedString(string: "5. Intellectual Property Rights", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                    
        reliance_6.attributedText = NSAttributedString(string: "6. Reliance on information posted", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        
         our_liability_7.attributedText = NSAttributedString(string: "7. Our Liability", attributes:
                     [.underlineStyle: NSUnderlineStyle.single.rawValue])
              
        uploadingMaterial_8.attributedText = NSAttributedString(string: "8. Uploading Material to our Website", attributes:
                            [.underlineStyle: NSUnderlineStyle.single.rawValue])
                     
        information_9.attributedText = NSAttributedString(string: "9. Information about you and your visits to our website", attributes:
                            [.underlineStyle: NSUnderlineStyle.single.rawValue])
                     
        linking_10.attributedText = NSAttributedString(string: "10. Linking to and from our website", attributes:
                            [.underlineStyle: NSUnderlineStyle.single.rawValue])
                     
        jurisdiction_11.attributedText = NSAttributedString(string: "11. Jurisdiction and Applicable Law", attributes:
                                                [.underlineStyle: NSUnderlineStyle.single.rawValue])
                        
    general_information_12.attributedText = NSAttributedString(string: "12. General Information and Your Concerns", attributes:
                                   [.underlineStyle: NSUnderlineStyle.single.rawValue])
                            
        terms_condition.attributedText = NSAttributedString(string: "Terms and Conditions for Users and Transporters", attributes:
                                   [.underlineStyle: NSUnderlineStyle.single.rawValue])
                            
       
        charges_api()
        
       
    }
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func charges_api(){
         let charges_url = main_URL+"api/getLoadXCharges"
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(charges_url, method : .get, parameters : nil).responseJSON {
                response in
        
                let jsonData : JSON = JSON(response.result.value!)
                print("initial deposit value is: \n \(jsonData)")
                self.initialChargesApi = jsonData[0]["loadxCharges"].stringValue
                
            
            
            let value = 100 - Int(self.initialChargesApi!)!
            
            self.f_rule_lbl.text = "F. Rules for Users" +
             "User cannot submit his/her own price quotation for his/her own job, in an attempt to beat price quotations from other transporters." +
             "Neither Users nor Transporters may interfere with a transaction or offer to buy or supply transport in response to a User's Listing outside of the website." +
            " Personal contact details or any private information must not be shared between the User and the Transporter except through LoadX website. This is to prevent any mishaps, or info-leaks that may cause damage/loss to either parties. LoadX will not be responsible in any way if the latter is to happen." +
            " You can provide feedback about the Transporter after a job is completed. Feedback should be strictly related to the service provided by the Transporter. The feedback helps us to offer you improved service in the future." +
             "In the event of a user bypassing the website, or placing fabricated price quotations in an attempt to avoid website fees, LoadX reserves the right to charge the equivalent to what the fee should have been based on the agreed amount. If no quotation has been given or price agreed, LoadX will determine the deposit/fee price based on LoadX market value. In addition, LoadX will charge a £8 administration fee on all transactions." +
                "Upon booking your job, you must pay " + "\(self.initialChargesApi!)" + "% (deposit) of the total job amount to secure your job." +
             "You can book as many jobs as you like however you cannot book any false job and cause inconvenience to the transport providers." +
            " You must pay the transport provider the remaining amount upon the completion of the job."
            
            self.e_rule_lbl.text = "E. Rules for Transporters" +
             "Transporters must honor the transaction contract formed with the User." +
             "Transporters must include all the fees, taxes, including VAT payable by the User for the transportation services in the price quotation." +
             "Transporters are not allowed to quote a price against their own quote or let anyone else do so, on purpose." +
             "Transporters cannot violate the terms represented in their quotation to the Users." +
            "Transporters cannot refuse to accept payment once their Bid is accepted by the User." +
             "You must provide us with all the documentation which proves that you have all the right insurances to work as a transport provider with Loadx." +
             "Please ensure that your vehicle is compatible with the requirements of the job." +
             "You must complete the job properly as requested by the users." +
             "You will be paid " + "\(value)" + "% of the quoted price with the remainder being LoadX service charges We will provide you with invoicing receipts which you must fill accordingly and keep one copy for yourself and the other must be given to the user." +
            " You need to inform the administration team of Loadx whether you would like to receive amount from the user via cash, bank transfer or cheque."
       }
        }else {
           let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
       
    }
    
}

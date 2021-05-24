//
//  JobPickupDropoffViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 24/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit

class JobPickupDropoffViewController: UIViewController {

    @IBOutlet weak var PickupOrDropOff: UILabel!
    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var timeEta: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var jobBookedFor: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var additionalDetailsTableView: UITableView!
    @IBOutlet weak var jobDescriptionTableView: UITableView!
    @IBOutlet weak var arrivedBtn: UIButton!
    @IBOutlet weak var runningLateBtn: UIButton!
    @IBOutlet weak var uploadImagesBtn: UIButton!
    @IBOutlet weak var leavingForDropoffBtn: UIButton!
    
//    var pickupAddress : String?
//    var dropoffAddress: String?
//    var customerName: String?
//    var phoneNumber: String?
//    var jobBookedFor

//    required init(pickupAddress: String?, dropoffAddress: String?, customerName: String, phoneNumber: String, jobBookedFor: String?) {
//        if let pickupAdd = pickupAddress {
//            
//        } else if let dropoffAdd = dropoffAddress {
//            
//            required init?(coder: NSCoder) {
//                fatalError("init(coder:) has not been implemented")
//            }
//            
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func arrivedAct(_ sender: Any) {
        
    }

    @IBAction func runningLateAct(_ sender: Any) {
        
    }
    
    @IBAction func uploadImagesAct(_ sender: Any) {
        
    }
    @IBAction func leavingForDropoffAct(_ sender: Any) {
        
    }
    
}

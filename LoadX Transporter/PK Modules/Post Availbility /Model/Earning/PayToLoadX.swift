//
//  PayToLoadX.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 03/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - WelcomeElement
struct PayToLoadX {
    let totalPendingPayToLoadx: Int
    var jobLists: [PayToLoadXItme]
    init(json: JSON?) {
        self.totalPendingPayToLoadx = json?[0]["total_pending_pay_to_loadx"].intValue ?? 0
        self.jobLists = []
        if let json = json?[0]["job_lists"]{
            for item in json{
                let item = PayToLoadXItme(json: item.1)
                self.jobLists.append(item)
            }
        }
    }
}

// MARK: - PayToLoadXJobs
struct PayToLoadXItme{
    let delID, jobID, vehicleType, date: String
    let loadxShare, buttonHeading: String
    init(json: JSON) {
        delID = json["del_id"].string  ?? ""
        jobID = json["job_id"].string  ?? ""
        vehicleType = json["vehicle_type"].string  ?? ""
        date = json["date"].string  ?? ""
        loadxShare = json["loadx_share"].string  ?? ""
        buttonHeading = json["button_heading"].string  ?? ""
    }
}




import Foundation

// MARK: - WelcomeElement
struct UploadReceipt {
    let bankName, accNo, accHolder: String
    let totalAmountToPay: Int
    var jobLists = [JobList]()
    init(json: JSON?) {
        self.bankName = json?[0]["bank_name"].string ?? ""
        self.accNo = json?[0]["acc_no"].string ?? ""
        self.accHolder = json?[0]["acc_holder"].string ?? ""
        self.totalAmountToPay = json?[0]["total_amount_to_pay"].intValue ?? 0
        self.jobLists = []
        if let json = json?[0]["job_ids"]{
            for item in json{
                let item = JobList(json: item.1)
                self.jobLists.append(item)
            }
        }
    }
}

// MARK: - JobList
struct JobList {
    let jobIDS: String
    init(json: JSON){
        self.jobIDS = json["job_ids"].string  ?? ""
    }
}


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
//    let totalPendingPayToLoadx: Int
	let summary: PendingJobsSummary
    var jobLists: [PayToLoadXItme] = []

	/*init(json: JSON?) {
        self.totalPendingPayToLoadx = json?[0]["total_pending_pay_to_loadx"].intValue ?? 0
        self.jobLists = []
        if let json = json?[0]["job_lists"]{
            for item in json{
                let item = PayToLoadXItme(json: item.1)
                self.jobLists.append(item)
            }
        }
    }*/

	init(json: JSON?) {
		var dataArray = json?.array ?? []
		let summaryData = dataArray.removeLast()
		summary = PendingJobsSummary(json: summaryData)
		jobLists = dataArray.map{PayToLoadXItme(json: $0)}
		jobLists = jobLists + jobLists + jobLists + jobLists
	}
}

struct PendingJobsSummary {
	let balance: Int
	let balanceDetail: String
	let balanceType: String
	let weekNo: String
	let weekRange: String

	init(json: JSON) {
		balance = json["balance"].intValue
		balanceDetail = json["balance_detail"].stringValue
		balanceType = json["balance_type"].stringValue
		weekNo = json["week_no"].stringValue
		weekRange = json["week_no_w_range"].stringValue
	}
}

// MARK: - PayToLoadXJobs
struct PayToLoadXItme{
    let delID, jobID, vehicleType, date: String
    let loadxShare, buttonHeading: String
	let vehicle, jType, jTypeStatus: String
    init(json: JSON) {
        delID = json["del_id"].string  ?? ""
        jobID = json["job_id"].string  ?? ""
        vehicleType = json["vehicle_type"].string  ?? ""
        date = json["date"].string  ?? ""
        loadxShare = json["loadx_share"].string  ?? ""
        buttonHeading = json["button_heading"].string  ?? ""
        vehicle = json["Svehicle"].string  ?? ""
		jType = json["j_type"].string  ?? ""
		jTypeStatus = json["j_type_status"].string  ?? ""
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
        if let json = json?[0]["job_lists"]{
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


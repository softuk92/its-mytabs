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
//	var totalPrice
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
	var loadXShare: Int {
		jobLists.filter{$0.jType == .loadXShare}.reduce(0){$0+$1.price}
	}
	var transporterShare: Int {
		jobLists.filter{$0.jType == .transporterShare}.reduce(0){$0+$1.price}
	}

	init(json: JSON?) {
		var dataArray = json?.array ?? []
		let summaryData = dataArray.removeLast()
		summary = PendingJobsSummary(json: summaryData)
		jobLists = dataArray.map{PayToLoadXItme(json: $0)}
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

enum TransactionType: String {
	case loadXShare = "LoadX Share"
	case transporterShare = "Transporter Share"
}

enum TransactionStatus: String {
	case loadXFeePending = "Loadx Fee (Pending)"
	case transporterSharePending = "Transporter Share (Pending)"
}

// MARK: - PayToLoadXJobs
struct PayToLoadXItme{
    let delID, jobID, vehicleType, date, buttonHeading, vehicle: String
	let loadxShare, transporterShare: Int
	let jType: TransactionType
	private let jTypeStatus: TransactionStatus
	var price: Int {
		switch jType {
		case .loadXShare:
			return loadxShare
		case .transporterShare:
			return transporterShare
		}
	}
    init(json: JSON) {
        delID = json["del_id"].string  ?? ""
        jobID = json["job_id"].string  ?? ""
        vehicleType = json["vehicle_type"].string  ?? ""
        date = json["date"].string  ?? ""
		let loadxShare = json["loadx_share"].string  ?? ""
		self.loadxShare = Int(loadxShare) ?? 0
		let transporterShare = json["transporter_share"].string  ?? ""
		self.transporterShare = Int(transporterShare) ?? 0
        buttonHeading = json["button_heading"].string  ?? ""
		if let vehicle = json["SVehivle"].string, !vehicle.isEmpty {
			self.vehicle = vehicle
		}else {
			vehicle = json["Svehicle"].string  ?? ""
		}
		let jType = json["j_type"].string  ?? ""
		self.jType = TransactionType(rawValue: jType) ?? .loadXShare
		let jTypeStatus = json["j_type_status"].string  ?? ""
		self.jTypeStatus = TransactionStatus(rawValue: jTypeStatus) ?? .loadXFeePending
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


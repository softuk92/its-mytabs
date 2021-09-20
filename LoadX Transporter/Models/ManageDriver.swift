//
//  File.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 20/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
class ManageDriver: Codable {
    let userID, tcID, userName, userEmail: String
    let userPhone, status, vanType: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case tcID = "tc_id"
        case userName = "user_name"
        case userEmail = "user_email"
        case userPhone = "user_phone"
        case status
        case vanType = "van_type"
    }

    init(userID: String, tcID: String, userName: String, userEmail: String, userPhone: String, status: String, vanType: String) {
        self.userID = userID
        self.tcID = tcID
        self.userName = userName
        self.userEmail = userEmail
        self.userPhone = userPhone
        self.status = status
        self.vanType = vanType
    }
}

class DriverDetail: Codable {
    let userID, userName, userEmail, userPhone: String
    let vanType, truckRegestration, cnicFront, cnicBack: String
    let cfStatus, cbStatus, status: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userEmail = "user_email"
        case userPhone = "user_phone"
        case vanType = "van_type"
        case truckRegestration = "truck_regestration"
        case cnicFront = "cnic_front"
        case cnicBack = "cnic_back"
        case cfStatus = "cf_status"
        case cbStatus = "cb_status"
        case status
    }

    init(userID: String, userName: String, userEmail: String, userPhone: String, vanType: String, truckRegestration: String, cnicFront: String, cnicBack: String, cfStatus: String, cbStatus: String, status: String) {
        self.userID = userID
        self.userName = userName
        self.userEmail = userEmail
        self.userPhone = userPhone
        self.vanType = vanType
        self.truckRegestration = truckRegestration
        self.cnicFront = cnicFront
        self.cnicBack = cnicBack
        self.cfStatus = cfStatus
        self.cbStatus = cbStatus
        self.status = status
    }
}

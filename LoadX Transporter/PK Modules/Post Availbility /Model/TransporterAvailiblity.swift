//
//  TransporterAvailiblity.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 01/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
class TransporterAvailability: Codable {
    let paID, tID, vanType, vanImg: String
    let startPoint, endPoint, taDate, status: String

    enum CodingKeys: String, CodingKey {
        case paID = "pa_id"
        case tID = "t_id"
        case vanType = "van_type"
        case vanImg = "van_img"
        case startPoint = "start_point"
        case endPoint = "end_point"
        case taDate = "ta_date"
        case status
    }

    init(paID: String, tID: String, vanType: String, vanImg: String, startPoint: String, endPoint: String, taDate: String, status: String) {
        self.paID = paID
        self.tID = tID
        self.vanType = vanType
        self.vanImg = vanImg
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.taDate = taDate
        self.status = status
    }
}

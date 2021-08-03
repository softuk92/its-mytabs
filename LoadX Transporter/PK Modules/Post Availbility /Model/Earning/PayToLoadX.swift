//
//  PayToLoadX.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 03/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

// MARK: - WelcomeElement
struct PayToLoadX: Codable {
    let totalPendingPayToLoadx: Int
    let jobLists: JobLists

    enum CodingKeys: String, CodingKey {
        case totalPendingPayToLoadx = "total_pending_pay_to_loadx"
        case jobLists = "job_lists"
    }
}

// MARK: - JobLists
struct JobLists: Codable {
    let the75: The75

    enum CodingKeys: String, CodingKey {
        case the75 = "75"
    }
}

// MARK: - The75
struct The75: Codable {
    let delID, jobID, vehicleType, date: String
    let loadxShare, buttonHeading: String

    enum CodingKeys: String, CodingKey {
        case delID = "del_id"
        case jobID = "job_id"
        case vehicleType = "vehicle_type"
        case date
        case loadxShare = "loadx_share"
        case buttonHeading = "button_heading"
    }
}

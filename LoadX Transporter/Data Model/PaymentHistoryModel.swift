//
//  PaymentHistoryModel.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct PaymentHistoryModel : Decodable {
    
    let del_id: String?
    let moving_item: String?
    let job_posted_date: String?
    let payment_id: String?
    let amount: String?
    let payment_type: String?
    let pay_date: String?
    let is_booked_job: String?
    
}

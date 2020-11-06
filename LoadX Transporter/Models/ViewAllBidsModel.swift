//
//  ViewAllBidsModel.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/14/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct ViewAllBidsModel : Decodable {
    
    let transporter_id: String
    let transporter_img: String
    let user_phone: String
    let avg_feedback: String
    let current_bid: String
    let user_email: String
    let transporter_name: String
    let driver_license: String
    
}

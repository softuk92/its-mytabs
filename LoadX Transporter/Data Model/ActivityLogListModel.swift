//
//  ActivityLogList.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/26/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct ActivityLogListModel: Decodable  {
    
    let ual_id: String
    let user_id: String
    let activity_description: String
    let activity_time: String
    let activity_date: String

}


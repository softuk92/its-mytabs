//
//  DriversList.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 20/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct DriversListMO: Codable {
    let userName, userID, vanType, vanUserName: String

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userID = "user_id"
        case vanType = "van_type"
        case vanUserName = "van_user_name"
    }
}

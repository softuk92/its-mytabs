//
//  NotificationsModel.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 15/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct NotificationsModel: Codable {
    let unID, unNotificationTitle, unMessage, unUserID: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case unID = "un_id"
        case unNotificationTitle = "un_notification_title"
        case unMessage = "un_message"
        case unUserID = "un_user_id"
        case createdAt = "created_at"
    }
}

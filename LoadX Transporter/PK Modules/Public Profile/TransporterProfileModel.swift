//
//  TransporterProfileModel.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 17/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct TransporterProfileModel: Decodable {
    let avgfdbck: Int
    let vanType, userPhone, cnicBacksideStatus, joinDate: String
    let userName, truckRegistration: String
    let totalCountOnBudgetYes, jobsDone: Int
    let cnicFront, vanImg, cnicBack, aboutMe: String
    let experience, userImageURL: String
    let totalCountOnTimeYes: Int
    let driverID: String
    let driverFeedback: [DriverFeedback]
    let userID, cnicFrontsideStatus, paymentOption: String
    let driverCompletedJobs: Int
    let userEmail: String

    enum CodingKeys: String, CodingKey {
        case avgfdbck
        case vanType = "van_type"
        case userPhone = "user_phone"
        case cnicBacksideStatus = "cnic_backside_status"
        case joinDate = "join_date"
        case userName = "user_name"
        case truckRegistration = "truck_registration"
        case totalCountOnBudgetYes = "total_count_on_budget_yes"
        case jobsDone = "jobs_done"
        case cnicFront = "cnic_front"
        case vanImg = "van_img"
        case cnicBack = "cnic_back"
        case aboutMe = "about_me"
        case experience
        case userImageURL = "user_image_url"
        case totalCountOnTimeYes = "total_count_on_time_yes"
        case driverID = "driver_id"
        case driverFeedback = "driver_feedback"
        case userID = "user_id"
        case cnicFrontsideStatus = "cnic_frontside_status"
        case paymentOption = "payment_option"
        case driverCompletedJobs = "driver_completed_jobs"
        case userEmail = "user_email"
    }
}

// MARK: - DriverFeedback
struct DriverFeedback: Codable {
    let feedBackStar, jobTitle, feedDate, senderName: String
    let driverFeedbackDescription: String

    enum CodingKeys: String, CodingKey {
        case feedBackStar = "feed_back_star"
        case jobTitle = "job_title"
        case feedDate = "feed_date"
        case senderName = "sender_name"
        case driverFeedbackDescription = "description"
    }
}


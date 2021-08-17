//
//  TransporterProfileModel.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 17/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct TransporterProfileModel: Decodable {
        let userID, userName, userEmail, userPhone: String
        let userImageURL, vanImg, joinDate, truckRegistration: String
        let cnicFront, cnicBack, experience, cnicBacksideStatus: String
        let cnicFrontsideStatus: String
        let jobsDone: Int
        let vanType, paymentOption, aboutMe: String
        let driverCompletedJobs, avgfdbck, totalCountOnBudgetYes, totalCountOnTimeYes: Int
        let driverID: String
//        let driverFeedback: []

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case userName = "user_name"
            case userEmail = "user_email"
            case userPhone = "user_phone"
            case userImageURL = "user_image_url"
            case vanImg = "van_img"
            case joinDate = "join_date"
            case truckRegistration = "truck_registration"
            case cnicFront = "cnic_front"
            case cnicBack = "cnic_back"
            case experience
            case cnicBacksideStatus = "cnic_backside_status"
            case cnicFrontsideStatus = "cnic_frontside_status"
            case jobsDone = "jobs_done"
            case vanType = "van_type"
            case paymentOption = "payment_option"
            case aboutMe = "about_me"
            case driverCompletedJobs = "driver_completed_jobs"
            case avgfdbck
            case totalCountOnBudgetYes = "total_count_on_budget_yes"
            case totalCountOnTimeYes = "total_count_on_time_yes"
            case driverID = "driver_id"
//            case driverFeedback = "driver_feedback"
        }
    
}

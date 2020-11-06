//
//  TransporterProfileFeedbackModel.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/27/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct TransporterProfileFeedbackModel: Decodable  {
    
    let user_id: String
    let user_name: String
    let user_email: String
    let user_phone: String
    let user_image_url: String
    let van_img: String
    let join_date: String
    let fd_id: String
    let job_id: String
    let job_title: String
    let on_budget: String
    let on_time: String
    let description: String
    let feed_back_star: String
    let feed_date: String
}

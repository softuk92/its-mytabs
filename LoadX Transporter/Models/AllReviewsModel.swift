//
//  AllReviewsModel.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/6/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct AllReviewsModel: Decodable {
    
    let del_id: String
    let user_id: String
    let user_name: String
    let fd_id: String
    let job_title: String
    let on_budget: String
    let on_time: String
    let description: String
    let feed_back_star: String
    let feed_date: String
    
    
}


//
//  File.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 4/5/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct SearchFreebieModel: Decodable {
    
    let frbi_id: String
    let image1: String?
    let image2: String?
    let image3: String?
    let moving_item: String
    let pick_up: String
    let lat_pickup: String
    let long_pickup: String
    let add_type: String
    let date: String
    let timeslot: String
    let pu_city: String
    let pu_route: String
    let pu_street: String
    let pu_post_code: String
    let posted_job: String
    let countAllFreeBiesJobs: Int
    
}

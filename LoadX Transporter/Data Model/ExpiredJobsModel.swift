//
//  ExpiredJobsModel.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/8/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct ExpiredJobsModel : Decodable {
    
    let long_pickup: String
    let image1: String?
    let date: String
    let moving_item: String
    let pick_up: String
    let image2: String?
    let distance: String
    let long_dropoff: String
    let drop_off: String
    let lat_pickup: String
    let lat_dropoff: String
    let del_id: String
    let timeslot: String
    let image3: String?
    let add_type: String
    
}

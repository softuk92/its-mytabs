//
//  SearchDelivariesModel.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct SearchDelivariesModel: Decodable {
    
    let del_id: String
    let image1: String?
    let image2: String?
    let image3: String?
    let moving_item: String
    let pick_up: String
    let pu_route: String
    let pu_street: String
    let pu_city: String
    let pu_post_code: String
    let drop_off: String
    let do_route: String
    let do_street: String
    let do_city: String
    let do_post_code: String
    let lat_pickup: String
    let long_pickup: String
    let lat_dropoff: String
    let long_dropoff: String
    let distance: String
    let add_type: String
    let date: String
    let timeslot: String
    let totalbid: String
    let current_bid: String
    let job_posted_date: String
    let alljobs: Int
    let allTransporter: Int

}

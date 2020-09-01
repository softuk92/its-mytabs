//
//  ActiveJobsViewController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct ActiveJobsModel: Decodable  {
    
    let del_id: String
    let jb_id: String?
    let image1: String?
    let image2: String?
    let image3: String?
    let moving_item: String
    let pick_up: String
    let drop_off: String
    let lat_pickup: String
    let long_pickup: String
    let lat_dropoff: String
    let long_dropoff: String
    let distance: String
    let add_type: String
    let totalbid: String
    let current_bid: String
    let date: String
    let pu_city: String
    let pu_route: String
    let pu_street: String
    let pu_post_code: String
    let do_city: String
    let do_route: String
    let do_street: String
    let do_post_code: String
    let min_bid: String
    let max_bid: String
    
}

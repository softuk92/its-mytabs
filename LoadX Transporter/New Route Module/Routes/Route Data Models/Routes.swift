//
//  AllRoutes.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 10/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation


public struct Routes : Decodable {
    
    let lr_id: String
    let lr_no_of_stops: String
    let lr_start_location: String
    let lr_end_location: String
    let pu_route: String
    let pu_street: String
    let pu_state: String
    let pu_country: String
    let pu_city: String
    let pu_post_code: String
    let pu_town: String
    let do_route: String
    let do_street: String
    let do_state: String
    let do_country: String
    let do_city: String
    let do_post_code: String
    let do_town: String
    let lr_total_price: Double?
    let lr_date: String
    let lr_total_distance: String?
    let lr_total_transport_time: String
    let countAllRoutes: Int?
    
}

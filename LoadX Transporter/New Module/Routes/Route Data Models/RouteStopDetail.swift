//
//  RouteStopDetail.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 18/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation

public struct RouteStopDetail: Codable {
    
    let stop_no: Int
    let lrh_id : String
    let lrh_lr_id : String
    let lrh_job_id : String
    let lrh_type : String
    let is_t_arrive: String
    let inform_running_late: String
    let cash_received_at_pickup: String
    let cash_received: String
    let is_damage: String
    let lrh_postcode: String
    let lrh_distance: String
    let price: String
    let payment_type: String
    let pickup_door_no: String
    let dropoff_door_no: String
    let lrh_time_slot: String
    let lrh_arrival_time: String
    let lrh_departure_time: String
    let lrh_waiting_time: String
    let is_completed: String
    let stop_id: String
    let pickup_lrh_stop_no: String
    let job_status: String
    let customer_name: String
    let phone_number: String
    let company: String
    let created_date: String
    let job_id: String
    let route: String
    let street: String
    let state: String
    let country: String
    let city: String
    let post_code: String
    
}

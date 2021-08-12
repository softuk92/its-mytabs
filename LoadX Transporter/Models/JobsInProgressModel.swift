//
//  JobsInProgressModel.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct JobsInProgressModel: Decodable  {
    
    let distance: String
    let current_bid: String?
    let long_pickup: String
    let lat_dropoff: String
    let del_id: String
    let contact_mail: String
    let jb_id: String
    let date: String
    let image3: String?
    let long_dropoff: String
    let pick_up: String
    let add_type: String
    let moving_item: String
    let lat_pickup: String
    let drop_off: String
    let contact_phone: String
    let user_id: String
    let image2: String?
    let contact_person: String
    let image1: String?
    let is_booked_job: String
    let is_company_job: String
    let is_cz: String?
    let payment_type: String
    let pu_house_no: String?
    let do_house_no: String?
    let is_job_started: String?
    let working_hours: String?
    let timeslot: String?
    let job_payment_type: String?
    let loadx_share: String?
    let transporter_share: String?
    let price: Int?
    let formated_job_id : String?
}

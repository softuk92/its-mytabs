//
//  CompletedJobsModelBusiness.swift
//  CTS Move Transporter
//
//  Created by CTS Move on 07/08/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct CompletedJobsModelBusiness: Decodable  {
    
    let del_id: String
    let user_id: String
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
    let contact_person: String
    let contact_phone: String
    let date: String
    let min_bid: String
    let driver_get_job_payment: String
    let payment_type: String
    let is_company_job: String
    let due_amount_status: String
    let do_house_no : String?
    let pu_house_no: String?
}

//
//  JobStatus.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 25/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct JobStatus: Decodable {
    let is_job_started: String
    let arrival_at_pickup: String
    let job_completed: String
    let p_running_late: String
    let p_leaving_f_dropoff: String
    let d_arrived: String
    let result: String
}

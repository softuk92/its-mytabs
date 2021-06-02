//
//  JobStatus.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 25/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct JobStatus: Decodable {
    var is_job_started: String
    var arrival_at_pickup: String
    var job_completed: String
    var d_cash_received: String
    var p_running_late: String
    var p_leaving_f_dropoff: String
    var d_arrived: String
    var is_img_uploaded: String
    var result: String
}

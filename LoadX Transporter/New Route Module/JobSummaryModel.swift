//
//  JobSummaryModel.swift
//  LoadX Transporter
//
//  Created by CTS Move on 28/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct JobSummaryModel: Decodable {
    let TotalTimetakenforjob: String
    let jobBookedtime: String
    let jobExtratime: String
    let extraCharges: String
    let result: String
}

//
//  ViewAllQueriesModel.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/28/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct ViewAllQueriesModel : Decodable {
    
    let created_at: String
    let jobid: String
    let dq_qid: String
    let pdescription: String
    let pcategory: String
    let job_posted_date: String
    let pstatus: String
    
}

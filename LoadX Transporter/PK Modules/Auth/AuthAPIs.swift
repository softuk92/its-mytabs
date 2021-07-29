//
//  AuthAPIs.swift
//  LoadX Transporter
//
//  Created by Muhammad Fahad Baig on 19/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AuthAPIs {
    
    static func login(phone: String, password: String, completion: @escaping (Data?, JSON?, Error?) -> ()) {
        APIManager.apiPost(serviceName: AppConstants.login, parameters: ["phone_no" : phone, "password": password]) { (data, json, error) in
            completion(data, json, error)
        }
    }
}

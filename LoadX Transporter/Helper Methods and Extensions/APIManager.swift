//
//  ApiManager.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 10/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager: NSObject {

class func apiGet(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (Data?, JSON?, NSError?) -> ()) {

    Alamofire.request(main_URL+serviceName, method: .get, parameters: parameters).responseJSON { (response) in

        switch(response.result) {
        case .success(_):
            if let data = response.result.value{
                let json = JSON(data)
                completionHandler(response.data,json,nil)
            }
            break

        case .failure(_):
            completionHandler(nil, nil,response.result.error as NSError?)
            break

        }
    }
}

class func apiPost(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (Data?, JSON?, NSError?) -> ()) {

    Alamofire.request(main_URL+serviceName, method: .post, parameters: parameters).responseJSON { (response) in

        switch(response.result) {
        case .success(_):
            if let data = response.result.value{
                let json = JSON(data)
                completionHandler(response.data,json,nil)
            }
            break

        case .failure(_):
            completionHandler(nil,nil,response.result.error as NSError?)
            break
        }
    }
}

}

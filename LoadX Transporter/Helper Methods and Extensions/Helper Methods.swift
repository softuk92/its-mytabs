//
//  Helper Methods.swift
//  LoadX Transporter
//
//  Created by CTS Move on 17/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit

public func showAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
    return alert
}

public func convertDateFormatter(_ date: String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let date = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "dd-MMMM-yyyy"
    return  dateFormatter.string(from: date!)
    
}

public func convertDateFormatter2(_ date: String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let date = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "dd-MMMM-yyyy"
    return  dateFormatter.string(from: date!)
    
}

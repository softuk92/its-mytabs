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

public func convertDateYearFirst(_ date: String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "dd-MMMM-yyyy"
    return  dateFormatter.string(from: date!)
    
}

//get address
public func getAddress(street: String, route: String, city: String, postcode: String) -> String {
    var address1 = ""
    var address2 = ""
    var fullAddress = ""
    if street != "" || route != "" {
        address1 = street+" "+route+","
    } else {
        address1 = ""
    }
    if city != "" {
        address2 = address1+" "+city+","
    } else {
        address2 = address1
    }
    if postcode != "" {
        let spaceCount = postcode.filter{$0 == " "}.count
        if spaceCount > 0 {
            if let first = postcode.components(separatedBy: " ").first {
                fullAddress = address2+" "+first
            }
        } else if spaceCount == 0 {
            fullAddress = address2+" "+postcode
        }
    }
    if street == "" && route == "" && postcode == "" && city != "" {
        return city.capitalized
    } else {
    return fullAddress
    }
}

//get address
public func getAddress(street: String, route: String, city: String, postcode: String, town: String) -> String {
    var address1 = ""
    var address2 = ""
    var fullAddress = ""
    if street != "" || route != "" {
        address1 = street+" "+route+","
    } else {
        address1 = ""
    }
    if city != "" {
        address2 = address1+" "+city+","
    } else {
        address2 = address1
    }
    if postcode != "" {
        let spaceCount = postcode.filter{$0 == " "}.count
        if spaceCount > 0 {
            if let first = postcode.components(separatedBy: " ").first {
                fullAddress = address2+" "+first
            }
        } else if spaceCount == 0 {
            fullAddress = address2+" "+postcode
        }
    }
    
    if town != "" && postcode != "" {
        let spaceCount = postcode.filter{$0 == " "}.count
        if spaceCount > 0 {
            if let first = postcode.components(separatedBy: " ").first {
                fullAddress = town+", "+first
            }
        } else if spaceCount == 0 {
            fullAddress = town+", "+postcode
        }
    }
    if street == "" && route == "" && postcode == "" && city != "" {
        return city.capitalized
    } else {
    return fullAddress
    }

}

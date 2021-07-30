//
//  AppUtility.swift
//  LoadX Transporter
//
//  Created by Muhammad Fahad Baig on 07/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

public enum CurrentCountry {
    case UnitedKingdom
    case Pakistan
}

class AppUtility: NSObject, CLLocationManagerDelegate {
    
    static let shared = AppUtility()
    private var disposeBag = DisposeBag()
    
    private override init() {
        super.init()
    }
    
    //check current Country
    var country : CurrentCountry = .Pakistan
//        {
//        if Locale.current.regionCode?.lowercased() == "pk" {
//            return .Pakistan
//        } else {
//            return .UnitedKingdom
//        }
//    }
    
    var currencySymbol : String {
        return "Rs. " // Locale.current.regionCode?.lowercased() == "pk" ? "Rs. " : "£"
    }
    
    func getVehiclesList() {
        
    }

}

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

struct VehiclesMO: Decodable {
    let vt_id: String
    let vehicle_name: String
}

struct BankList: Decodable {
    let bank_id: String
    let bank_name: String
}

class AppUtility: NSObject, CLLocationManagerDelegate {
    
    static let shared = AppUtility()
    private var disposeBag = DisposeBag()
    private var vehicles = [VehiclesMO]()
    private var bankList = [BankList]()
    
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
    
    func getVehiclesList(completion:@escaping (Result<[VehiclesMO], Error>) -> Void) {
            
        //return vehicle if already fetched
        guard vehicles.isEmpty else {
            completion(.success(vehicles))
            return
        }
        
        //fetch vehicles from server
        APIManager.apiGet(serviceName: "api/getVehicleList", parameters: [:]) { [unowned self] (data, json, error) in
            //handle error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            //data is snil
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Data is nil"])))
                return
            }
            
            //parse data
            do {
                let vehiclesList = try JSONDecoder().decode([VehiclesMO].self, from: data)
                self.vehicles = vehiclesList
                completion(.success(vehiclesList))
            }catch {
                completion(.failure(error))
            }
            
        }
    }
    
//    func getBankList(completion:@escaping (Result<[BankList], Error>) -> Void) {
//
//        //return vehicle if already fetched
//        guard bankList.isEmpty else {
//            completion(.success(banks))
//            return
//        }
//
//        //fetch vehicles from server
//        APIManager.apiGet(serviceName: "api/getVehicleList", parameters: [:]) { [unowned self] (data, json, error) in
//            //handle error
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            //data is snil
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Data is nil"])))
//                return
//            }
//
//            //parse data
//            do {
//                let vehiclesList = try JSONDecoder().decode([VehiclesMO].self, from: data)
//                self.vehicles = vehiclesList
//                completion(.success(vehiclesList))
//            }catch {
//                completion(.failure(error))
//            }
//
//        }
//    }

}

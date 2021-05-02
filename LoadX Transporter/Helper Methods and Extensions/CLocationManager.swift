//
//  LocationManagerViewController.swift
//  BBMerchant
//
//  Created by Fahad Baig on 04/11/2020.
//  Copyright © 2020 Techtix. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class CLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = CLocationManager()
    let locationManager : CLLocationManager
    var locationInfoCallBack: ((_ info:LocationInformation)->())!
    var tId: String? = "74"
    var delId: String? = "7"
    var transporterStatus: String? = "Yes"
    let locationTimer = PublishSubject<CLLocationCoordinate2D>()
    let locationAPIError = PublishSubject<String>()
    
    private var disposeBag = DisposeBag()
    
    private override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

//    func start(locationInfoCallBack:@escaping ((_ info:LocationInformation)->())) {
//        self.locationInfoCallBack = locationInfoCallBack
//        locationManager.requestAlwaysAuthorization()
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startUpdatingLocation()
//        locationManager.pausesLocationUpdatesAutomatically = false
//    }
    
    func startLocationUpdates() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationTimer.debug("Location is triggered after 10 seconds", trimOutput: true).throttle(.seconds(15), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (location) in
            self?.sendLocationToServer(lat: location.latitude, lng: location.longitude)
        }).disposed(by: disposeBag)
    }

    func stop() {
        transporterStatus = "No"
        sendLocationToServer(lat: 0.0, lng: 0.0)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        locationTimer.onNext(mostRecentLocation.coordinate)
        
    }
//        let info = LocationInformation()
//        info.latitude = mostRecentLocation.coordinate.latitude
//        info.longitude = mostRecentLocation.coordinate.longitude


        //now fill address as well for complete information through lat long ..
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(mostRecentLocation) { [weak self] (placemarks, error) in
//            guard let self = self else { return }
//            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
//            if let city = placemark.locality,
//                let state = placemark.administrativeArea,
//                let zip = placemark.postalCode,
//                let locationName = placemark.name,
//                let thoroughfare = placemark.thoroughfare,
//                let country = placemark.country {
//                info.city     = city
//                info.state    = state
//                info.zip = zip
//                info.address =  locationName + ", " + (thoroughfare as String)
//                info.country  = country
//            }
//            self.locationInfoCallBack(info)
//        }
        
//        locationManager.stopUpdatingLocation()
//    }
    
    func sendLocationToServer(lat: Double, lng: Double) {
        APIManager.apiPost(serviceName: "api/updateLatestLatNdLong", parameters: ["latitude" : lat, "longitude": lng, "t_id": tId ?? 0, "del_id" : delId ?? 0, "transporter_status" : transporterStatus ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                print("API Error")
                self.locationAPIError.onNext(error?.localizedDescription ?? "")
            } else {
                print("API Successful")
            }
            let msg = json?[0]["message"].stringValue
            let result = json?[0]["result"].stringValue
            if result == "1" {

            } else {
                self.locationAPIError.onNext(msg ?? "")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse:
//            break
//        case .authorizedAlways:
//            break
//        case .restricted:
//            print("restricted")
//        case .denied:
//            break
//        default:
//            break
//        }
//    }
}

class LocationInformation {
    var city:String?
    var address:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var zip:String?
    var state :String?
    var country:String?
    init(city:String? = "",address:String? = "",latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0),zip:String? = "",state:String? = "",country:String? = "") {
        self.city    = city
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.zip        = zip
        self.state = state
        self.country = country
    }
}


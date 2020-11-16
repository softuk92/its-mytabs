//
//  BookedJobsExtensions.swift
//  LoadX Transporter
//
//  Created by CTS Move on 17/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation
import SVProgressHUD
import SwiftyJSON
import Alamofire
import SDWebImage
import DropDown
import IBAnimatable
import GoogleMaps
import GooglePlaces
import CoreLocation

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension SearchBookedJobs: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewConqtroller: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if locationPicked == 1 {
            //            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            pickupLocation.text = place.formattedAddress
            
            if let placeFormat = place.formattedAddress {
                self.pickup_city = placeFormat
            }
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                }else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    
                    print("city is \(String(describing: placemarks?.first?.locality))")
                }
                
            })
            
            
        }
        else if locationPicked == 2 {
            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            dropOff.text = place.formattedAddress
            if let placeFormat = place.formattedAddress {
                self.dropoff_city = placeFormat
            }
            
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                }else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    self.dropoff_city = city
                    print("city is \(String(describing: placemarks?.first?.locality))")
                    
                }
            })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

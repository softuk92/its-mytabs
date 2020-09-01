//
//  location_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 30/01/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class location_ViewController: UIViewController, GMSMapViewDelegate{
   
    @IBOutlet weak var pickUp_lbl: UILabel!
    @IBOutlet weak var dropOff_lbl: UILabel!
    @IBOutlet weak var distance_lbl: UILabel!
    @IBOutlet weak var fuelCost_lbl: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mapViewX: GMSMapView!
   
    var long_dropoff : Double?
    var long_pickup : Double?
    var lat_pickup : Double?
    var lat_dropoff : Double?

    var pickUp: String?
    var dropOff: String?
    var distance: String?
    var fuelCost: String?
    
    var jsonData : JSON = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.layer.shadowColor = UIColor.darkGray.cgColor
        detailView.layer.shadowOffset = CGSize(width: 2, height: 2)
        detailView.layer.shadowOpacity = 0.4
        detailView.layer.shadowRadius = 3.0
        mapViewX.layer.cornerRadius = 10.0
        mapViewX.delegate = self
        mapViewX.settings.zoomGestures = false
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark   {
               do {
                
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                           mapViewX.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                         } else {
                           NSLog("Unable to find style.json")
                         }
                       } catch {
                         NSLog("One or more of the map styles failed to load. \(error)")
                       }
                
        } else {
            // Fallback on earlier versions
               
        }
        }
        // Do any additional setup after loading the view.
        long_dropoff = Double(jsonData[0]["long_dropoff"].stringValue)
        long_pickup =  Double(jsonData[0]["long_pickup"].stringValue)
        lat_pickup =  Double(jsonData[0]["lat_pickup"].stringValue)
        lat_dropoff =  Double(jsonData[0]["lat_dropoff"].stringValue)
       
        pickUp_lbl.text =  jsonData[0]["pu_house_no"].stringValue  + " " + jsonData[0]["pick_up"].stringValue
        dropOff_lbl.text = jsonData[0]["do_house_no"].stringValue + " " + jsonData[0]["drop_off"].stringValue
        
        let distance1 = jsonData[0]["distance"].stringValue
        
        if distance1 != "" {
            let resultFuel = Double(distance1)! / Double(6)
            let roundedFuel = Double(resultFuel).rounded(toPlaces: 2)
//            self.distance = distance1
            self.fuelCost_lbl.text = "£"+String(roundedFuel)
        
        if let roundedValue1 = Double(distance1)?.rounded(toPlaces: 2) {
           // roundedValue1.rounded()
          //  print(roundedValue1)
            let distanceString = String(roundedValue1)+" miles"
            self.distance_lbl.text = (distanceString)
            }
        }
        
//        self.long_dropoff = Double(jsonData[0]["long_dropoff"].stringValue)
//        self.long_pickup = Double(jsonData[0]["long_pickup"].stringValue)
//        self.lat_pickup = Double(jsonData[0]["lat_pickup"].stringValue)
//        self.lat_dropoff = Double(jsonData[0]["lat_dropoff"].stringValue)
        jobDetailMap()
    }
    @IBAction func pickupTap(_ sender: UITapGestureRecognizer) {
              let alert = UIAlertController(title: "Pickup Location", message: "", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
       }

    
    func jobDetailMap() {
        let sessionManager = SessionManager()
        
        if lat_pickup != nil && lat_dropoff != nil && long_pickup != nil && long_dropoff != nil {
            let start = CLLocationCoordinate2D(latitude: lat_pickup!, longitude: long_pickup!)
            
            let end = CLLocationCoordinate2D(latitude: lat_dropoff!, longitude: long_dropoff!)
            
            sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in
                
                if let error = error {
                    print("Something went wrong, abort drawing!\nError: \(error)")
                } else {
                    // Create a GMSPolyline object from the GMSPath
                    let polyline = GMSPolyline(path: path!)
                    
                    // Add the GMSPolyline object to the mapView
                   
                    polyline.map = self.mapViewX
                    
                    // Move the camera to the polyline
                    let bounds = GMSCoordinateBounds(path: path!)
                    let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
                    self.mapViewX.animate(with: cameraUpdate)
                    
                    let position = CLLocationCoordinate2D(latitude: self.lat_pickup!, longitude: self.long_pickup!)
                    let marker = GMSMarker(position: position)
                    marker.title = "Pickup Location"
                    marker.map = self.mapViewX
                    
                    let position2 = CLLocationCoordinate2D(latitude: self.lat_dropoff!, longitude: self.long_dropoff!)
                    let marker2 = GMSMarker(position: position2)
                    marker2.title = "Drop off Location"
                    marker2.map = self.mapViewX
                }
            })
        } else {
            
            print("Location is not available")
        }
    }
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            
            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Google Maps not found", message: "Please install Google Maps in your device.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            
            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Google Maps not found", message: "Please install Google Maps in your device.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

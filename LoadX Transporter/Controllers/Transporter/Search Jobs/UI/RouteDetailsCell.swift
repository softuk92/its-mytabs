//
//  RouteDetailsCellTableViewCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 16/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

open class RouteDetailsCell: UITableViewCell, NibReusable {

    @IBOutlet weak var routeId: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dropoffStopNumber: UILabel!
    @IBOutlet weak var seeDetails: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var btnView: UIView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        customizedView()
    }
    
    open var dataSource: RouteStopDetail! {
        didSet {
            guard let route = dataSource else {return}
            bindLabels(route: route)
        }
    }
    
    open func bindLabels(route: RouteStopDetail) {
        stops.text = String(route.stop_no)
        pickup.text = getAddress(street: route.street, route: route.route, city: route.city, postcode: route.post_code)
        routeId.text = "LS2020J"+route.lrh_job_id
        addressLabel.text = (route.lrh_type == "Pickup Shipment") ? "Pickup" : "Dropoff"
        price.text = "£"+route.price
        if route.pickup_lrh_stop_no != "N/A" || route.pickup_lrh_stop_no != "" {
            dropoffStopNumber.isHidden = false
            dropoffStopNumber.text = "Drop Off of Stop \(route.pickup_lrh_stop_no)"
        } else {
            dropoffStopNumber.isHidden = true
        }
        name.text = "Customer Name:"
        phone.text = route.customer_name
        time.text = route.lrh_arrival_time
        
    }

    private func customizedView() {
        stopView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5)
        nameView.roundCorners(corners: [.bottomLeft], radius: 5)
        btnView.roundCorners(corners: [.bottomRight], radius: 5)
    }
    
}

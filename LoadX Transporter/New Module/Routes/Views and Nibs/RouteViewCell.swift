//
//  RouteViewCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 10/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

open class RouteViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var movingItem: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var dropoff: UILabel!
    @IBOutlet weak var noOfHelpers: UILabel!
    @IBOutlet weak var routePrice: UILabel!
    @IBOutlet weak var routeDate: UILabel!

    open var dataSource: Routes! {
        didSet {
            guard let route = dataSource else {return}
            bindLabels(route: route)
        }
    }
    
    open func bindLabels(route: Routes) {
        stops.text = "No of Stops: \(route.lr_no_of_stops)"
        pickup.text = route.lr_start_location
        dropoff.text = route.lr_end_location
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        customizedView()
    }
    
    private func customizedView() {
        self.layer.cornerRadius = 5
    }

}

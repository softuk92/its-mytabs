//
//  RouteDetailsCellTableViewCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 16/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

class RouteDetailsCell: UITableViewCell, NibReusable {

    @IBOutlet weak var routeId: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var seeDetails: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var btnView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizedView()
    }
    
    open func bindLabels(route: Routes) {
        stops.text = "No of Stops: \(route.lr_no_of_stops)"
        pickup.text = route.lr_start_location
        
    }

    private func customizedView() {
        stopView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5)
        nameView.roundCorners(corners: [.bottomLeft], radius: 5)
        btnView.roundCorners(corners: [.bottomRight], radius: 5)
    }
    
}

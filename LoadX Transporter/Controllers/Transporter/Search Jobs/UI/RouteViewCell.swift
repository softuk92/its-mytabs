//
//  RouteViewCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 10/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

open class RouteViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var movingItem: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var dropoff: UILabel!
    @IBOutlet weak var routePrice: UILabel!
    @IBOutlet weak var routeDate: UILabel!
    @IBOutlet weak var acceptRoute: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var leftBtnView: UIView!

    private var disposeBag = DisposeBag()
    weak var parentViewController : UIViewController!
    open var dataSource: Routes! {
        didSet {
            guard let route = dataSource else {return}
            bindLabels(route: route)
            
        }
    }
    
    open func bindLabels(route: Routes) {
        stops.text = "No of Stops: \(route.lr_no_of_stops)"
        distance.text = "\(route.lr_total_distance ?? "") miles"
        pickup.text = getAddress(street: route.pu_street, route: route.pu_route, city: route.pu_city, postcode: route.pu_post_code)
        dropoff.text = getAddress(street: route.do_street, route: route.do_route, city: route.do_city, postcode: route.do_post_code)
        routePrice.text = "£"+String(format: "%.2f", route.lr_total_price ?? 0.0)
        movingItem.text = "LR00"+route.lr_id
        routeDate.text = convertDateYearFirst(route.lr_date)
        bindActions(routeId: route.lr_id)
    }
    
    func bindActions(routeId: String) {
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        customizedView()
    }
    
    private func customizedView() {
        innerView.layer.cornerRadius = 5
//        leftBtnView.roundCorners(corners: [.bottomLeft], radius: 5)
//        acceptRoute.roundCorners(corners: [.bottomRight], radius: 5)
    }

}

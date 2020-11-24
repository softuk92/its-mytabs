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

open class RouteBookedView: UITableViewCell, NibReusable {
    
    @IBOutlet weak var movingItem: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var dropoff: UILabel!
    @IBOutlet weak var routePrice: UILabel!
    @IBOutlet weak var routeDate: UILabel!
    @IBOutlet weak var startRoute: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var leftBtnView: UIView!

    private var disposeBag = DisposeBag()
    weak var parentViewController : UIViewController!
    open var dataSource: BookedRoute! {
        didSet {
            guard let route = dataSource else {return}
            bindLabels(route: route)
        }
    }
    
    open func bindLabels(route: BookedRoute) {
        stops.text = "No of Stops: \(route.lr_no_of_stops)"
        distance.text = "\(route.lr_total_distance) miles"
        pickup.text = route.lr_start_location
        dropoff.text = route.lr_end_location
        routePrice.text = "£"+String(format: "%.2f", Double(route.lr_total_price) ?? 0.0)
        movingItem.text = "LR00"+route.lr_id
        routeDate.text = convertDateYearFirst(route.lr_date)
        bindActions(routeId: route.lr_id)
    }
    
    func bindActions(routeId: String) {
        startRoute.rx.tap.subscribe(onNext: { [weak self] (_) in
//            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteDetailsViewController") as? RouteDetailsViewController {
//                vc.routeId = routeId
//                self?.parentViewController.navigationController?.pushViewController(vc, animated: true)
//            }
        }).disposed(by: disposeBag)
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        customizedView()
    }
    
    private func customizedView() {
        innerView.layer.cornerRadius = 5
        leftBtnView.roundCorners(corners: [.bottomLeft], radius: 5)
        startRoute.roundCorners(corners: [.bottomRight], radius: 5)
    }

}

//
//  InventoryCell.swift
//  LoadX Transporter
//
//  Created by CTS Move on 19/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

open class RouteInventoryCell: UITableViewCell, NibReusable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var numberView: UIView!
    
//    open var dataSource: RouteStopDetail! {
//        didSet {
//            guard let route = dataSource else {return}
//            bindLabels(route: route)
//        }
//    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

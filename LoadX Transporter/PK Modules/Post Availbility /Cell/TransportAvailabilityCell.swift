//
//  TableViewCell.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 29/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
protocol TableViewDelegate: AnyObject{
    func didTapButton(cell:UITableViewCell, selected: Bool?)
}

class TransportAvailabilityCell: UITableViewCell,NibReusable {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var vanType: UILabel!
    @IBOutlet weak var startPoint: UILabel!
    @IBOutlet weak var endPoint: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var status: UILabel!
    weak var cellDelegate:TableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.bottomShadow(color: UIColor.black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    func setData(data: TransporterAvailability) {
        vanType.text = data.vanType
        startPoint.text = data.startPoint
        endPoint.text = data.endPoint
        availability.text = data.taDate
        status.text = data.status
        cellDelegate?.didTapButton(cell: self, selected: nil)
    }
    
}

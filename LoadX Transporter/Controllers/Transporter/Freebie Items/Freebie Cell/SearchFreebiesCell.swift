//
//  SearchDeliveriesCell.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class SearchFreebiesCell: UITableViewCell {

    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    
    var bidNowRow: ((SearchFreebiesCell) -> Void)?
    var getDetail: ((SearchFreebiesCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchFreebiesCell.tapFunction))
        moving_item.isUserInteractionEnabled = true
        moving_item.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func bidNowBtn(_ sender: Any) {
        bidNowRow?(self)
    }
    
    @objc func tapFunction() {
        getDetail?(self)
    }

}

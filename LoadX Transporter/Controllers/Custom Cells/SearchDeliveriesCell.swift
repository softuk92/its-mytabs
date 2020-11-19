//
//  SearchDeliveriesCell.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class SearchDeliveriesCell: UITableViewCell {

    @IBOutlet weak var cell_background_view: UIView!
    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropOffLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var lowest_bid: UILabel!
    @IBOutlet weak var quotes: UILabel!
    @IBOutlet weak var bidNowBtn: UIButton!
                    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var businessPatti: UIImageView!
    @IBOutlet weak var postedDate_lbl: UILabel!
   
   
    @IBOutlet weak var deliverDate_lbl: UILabel!
    @IBOutlet weak var Dates_View: UIView!
    
    var bidNowRow: ((SearchDeliveriesCell) -> Void)?
    var getDetail: ((SearchDeliveriesCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchDeliveriesCell.tapFunction))
        moving_item.isUserInteractionEnabled = true
        moving_item.addGestureRecognizer(tap)
        self.innerView.dropShadow(color: .black, offSet: CGSize(width: -1, height: 1))
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

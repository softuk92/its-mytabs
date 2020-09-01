//
//  AcceptBidCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/14/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Cosmos

class AcceptBidCell: UITableViewCell {

    @IBOutlet weak var transporter_name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var current_bid: UILabel!
    @IBOutlet weak var transporter_img: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var feedback_stars: UILabel!
    @IBOutlet weak var ratingNotAvailable: UILabel!
    @IBOutlet weak var nullView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tickImage: UIImageView!
    
    var transporterProfileRow: ((AcceptBidCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(AcceptBidCell.viewTransporterDetails))
        transporter_name.isUserInteractionEnabled = true
        transporter_name.addGestureRecognizer(tap)
    }
    
    @objc func viewTransporterDetails() {
        transporterProfileRow?(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

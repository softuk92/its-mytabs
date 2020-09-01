//
//  ManageReviewsCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/4/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Cosmos

class ManageReviewsCell: UITableViewCell {

    @IBOutlet weak var job_title: UILabel!
    @IBOutlet weak var transporter_name: UILabel!
    @IBOutlet weak var job_description: UILabel!
    @IBOutlet weak var feed_date: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var feedback_stars: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var feed_date_icon: UIImageView!
    
    var viewDescriptionRow: ((ManageReviewsCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ManageReviewsCell.viewDescription))
        job_description.isUserInteractionEnabled = true
        job_description.addGestureRecognizer(tap)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func viewDescription() {
        viewDescriptionRow?(self)
    }
    
}

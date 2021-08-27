//
//  ReviewsCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 27/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Cosmos
import Reusable

class ReviewsCell: UITableViewCell, NibReusable {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var ratingDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ActivityLogListCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class ActivityLogListCell: UITableViewCell {

    @IBOutlet weak var activity_description: UILabel!
    @IBOutlet weak var activity_time: UILabel!
    @IBOutlet weak var activity_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

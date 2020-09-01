//
//  HeadTableViewCell.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/28/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class HeadTableViewCell: UITableViewCell {

    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

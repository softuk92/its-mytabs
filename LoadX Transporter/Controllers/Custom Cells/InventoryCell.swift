//
//  InventoryCell.swift
//  LoadX Transporter
//
//  Created by Ahmed Durrani on 02/07/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit

class InventoryCell: UITableViewCell {

    @IBOutlet weak var lblInventoryName: UILabel!
    @IBOutlet weak var lblInventoryNum: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

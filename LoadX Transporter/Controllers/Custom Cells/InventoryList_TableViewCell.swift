//
//  InventoryList_TableViewCell.swift
//  LoadX Transporter
//
//  Created by AIR BOOK on 15/06/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit

class InventoryList_TableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQty_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

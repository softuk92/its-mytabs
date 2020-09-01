//
//  ActivityLogListCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class ViewAllQueriesCell: UITableViewCell {

    @IBOutlet weak var pcategory: UILabel!
    @IBOutlet weak var pdescription: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var pstatus: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var cell_view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pstatus.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

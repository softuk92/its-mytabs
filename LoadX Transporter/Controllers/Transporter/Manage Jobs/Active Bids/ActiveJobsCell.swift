//
//  ActiveJobsCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/30/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class ActiveJobsCell: UITableViewCell {

    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var totalBidLabel: UILabel!
    @IBOutlet weak var max_bid: UILabel!
    @IBOutlet weak var min_bid: UILabel!
    
    var deleteRow: ((ActiveJobsCell) -> Void)?
    var detailJobRow: ((ActiveJobsCell) -> Void)?
    var updatePriceRow: ((ActiveJobsCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ActiveJobsCell.viewDetails))
        moving_item.isUserInteractionEnabled = true
        moving_item.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func viewDetails(sender: UITapGestureRecognizer) {
        detailJobRow?(self)
    }
    
    @IBAction func deleteJobBtn(_ sender: Any) {
        deleteRow?(self)
    }
    
    @IBAction func updatePrice(_ sender: Any) {
        updatePriceRow?(self)
    }
    
}

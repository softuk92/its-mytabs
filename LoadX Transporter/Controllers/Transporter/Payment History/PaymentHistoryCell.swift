//
//  PaymentHistoryCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {

    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var job_posted_date: UILabel!
    @IBOutlet weak var invoice_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var viewInvocie_btn: UIButton!
    
    var viewInvoiceRow: ((PaymentHistoryCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewInvoice(_ sender: Any) {
        viewInvoiceRow?(self)
    }
    
}

//
//  PaymentHistoryCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import RxSwift

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
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cell_view.layer.cornerRadius = 5
        cell_view.bottomShadow(color: .black)
        
        Config.shared.currentLanguage.subscribe(onNext: { [weak self] (lang) in
            self?.viewInvocie_btn.setTitle(lang == .en ? "View Invoice" : "رسید دیکھیں", for: .normal)
        }).disposed(by: disposeBag)
        
        viewInvocie_btn.setTitle(Config.shared.currentLanguage.value == .en ? "View Invoice" : "رسید دیکھیں", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewInvoice(_ sender: Any) {
        viewInvoiceRow?(self)
    }
    
}

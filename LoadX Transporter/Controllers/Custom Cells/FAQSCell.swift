//
//  Cell.swift
//  CollapseableCell
//
//  Created by Mehsam Saeed on 22/09/2020.
//  Copyright © 2020 Mehsam Saeed. All rights reserved.
//

import UIKit
protocol myProtocolr:AnyObject {
    func didTapButton(cell:UITableViewCell)
}
class FAQSCell: UITableViewCell {
    @IBOutlet weak var separatorView: UIView!
    weak var delegate:myProtocolr?
   
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var titleText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    @IBAction func buttonTap(_ sender: Any) {
        delegate?.didTapButton(cell: self)
        
    }
  
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

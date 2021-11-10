//
//  JobNatureCell.swift
//  LoadX
//
//  Created by AIR BOOK on 04/11/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class JobNatureCell: UITableViewCell {
    
    @IBOutlet weak var lblJobNature : UILabel!
    @IBOutlet weak var bottomLineView: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()
        bottomLineView.isHidden = false
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

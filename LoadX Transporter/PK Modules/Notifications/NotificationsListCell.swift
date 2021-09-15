//
//  NotificationsListCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 15/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

class NotificationsListCell: UITableViewCell, NibReusable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 10
        innerView.bottomShadow(color: .black)
    }
    
    func setData(model: NotificationsModel) {
        title.text = model.unNotificationTitle.capitalized
        dateTime.text = convertDateFormatter(model.createdAt)
        notificationDescription.text = model.unMessage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

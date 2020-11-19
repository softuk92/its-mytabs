//
//  HeaderView.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 19/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

public class HeaderView: UIView, NibOwnerLoadable {
    
    //MARK: - IBOutlets
    @IBOutlet weak public var title: UILabel!
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func customizeUI() {
        self.backgroundColor = .clear
    }

}

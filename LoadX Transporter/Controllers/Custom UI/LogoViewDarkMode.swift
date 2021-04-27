//
//  LogoViewDarkMode.swift
//  LoadX Transporter
//
//  Created by CTS Move on 27/04/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

public class LogoViewDarkMode: UIView, NibOwnerLoadable {
    
    //MARK: - IBOutlets
  
    //MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        customizeUI()
    }
    
    
    private func customizeUI() {
      
    }

}

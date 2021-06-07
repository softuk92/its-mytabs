//
//  JobSuccessController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 07/06/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit

class JobSuccessController: UIViewController {

    @IBOutlet weak var ensure: UILabel!
    @IBOutlet weak var okayBtn: UIButton!
    
    weak var delegate: JobDetailSetupDelegate?
    
    var ensureText: String?
    var buttonText: String?
    var isFromImagesVC: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = ensureText {
            ensure.text = text
        }
        
        if let buttonTxt = buttonText {
            okayBtn.setTitle(buttonTxt.uppercased(), for: .normal)
        }
            
    }
    
    @IBAction func okayAct(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if self.isFromImagesVC {
            self.delegate?.setView()
            } 
        }
    }

}

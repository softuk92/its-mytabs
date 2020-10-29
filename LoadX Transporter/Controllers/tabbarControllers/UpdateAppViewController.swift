//
//  UpdateAppViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 29/10/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit

class UpdateAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func updateApp(_ sender: Any) {
        rateApp { (sucess) in
            print(sucess)
        }
    }
    
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1458875857?mt=8") else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

}

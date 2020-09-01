//
//  SearchJobController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baig on 25/05/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchJobController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search Jobs"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func offerBidBtn(_ sender: Any) {
    self.performSegue(withIdentifier: "bookedJobs", sender: self)
    }
    
    @IBAction func searchBookedBtn(_ sender: Any) {
    self.performSegue(withIdentifier: "searchJobs", sender: self)
    }
    
}

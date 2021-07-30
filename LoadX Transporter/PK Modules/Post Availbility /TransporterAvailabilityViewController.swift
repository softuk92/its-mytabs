//
//  TransporterAvailabilityViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 29/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
class TransporterAvailabilityViewController: UIViewController, StoryboardSceneBased{
    static let sceneStoryboard = R.storyboard.transporterAvailability()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: TransportAvailabilityCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        let view = UIView()
        view.backgroundColor = R.color.background_color()
        tableView.backgroundView = view
        tableView.rowHeight = 250
    }
    
    @IBAction func backButtonTap(sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(sender: Any){
//        let sb = R.storyboard.transporterAvailability()
        let showVC = PostAvailabilityFormViewController.instantiate()
       self.navigationController?.pushViewController(showVC, animated: true)
    }

}
extension TransporterAvailabilityViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TransportAvailabilityCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    
}


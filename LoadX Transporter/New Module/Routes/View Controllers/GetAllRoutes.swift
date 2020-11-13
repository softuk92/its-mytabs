//
//  GetAllRoutes.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 10/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class GetAllRoutes: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var routes = [Routes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        apiCalls()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: RouteViewCell.self)
    }
    
    func apiCalls() {
        
    }
    

}

extension GetAllRoutes: UITableViewDelegate {
    
}

extension GetAllRoutes: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RouteViewCell.self)
        
        return cell
    }
    
    
}

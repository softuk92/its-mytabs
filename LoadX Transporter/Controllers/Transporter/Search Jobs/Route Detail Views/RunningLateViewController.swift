//
//  RunningLateViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 06/12/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class RunningLateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var select: UIButton!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var back: UIButton!
    
    var list = ["5 Minutes","10 Minutes","15 Minutes"]
    private var disposeBag = DisposeBag()
    var lrh_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blurView.isHidden = true
        innerView.layer.cornerRadius = 15
        tableView.register(UINib(nibName: "DropDownViewCell", bundle: nil) , forCellReuseIdentifier: "DropDownViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        setupBtn()
    }
    
    func setupBtn() {
        select.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.blurView.isHidden = false
        }).disposed(by: disposeBag)

        send.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.select.titleLabel?.text == "5 Minutes" {
                self?.driverLateRunning(late: "5")
            } else if self?.select.titleLabel?.text == "10 Minutes" {
                self?.driverLateRunning(late: "10")
            } else {
                self?.driverLateRunning(late: "15")
            }
        }).disposed(by: disposeBag)
        
        back.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func driverLateRunning(late: String) {
        APIManager.apiPost(serviceName: "api/transporterLateRunning", parameters: ["lrh_id": lrh_id, "late_running_time" : late]) { (data, json, error) in
            if error != nil {
                
            }
            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LateTimeSubmitted") as? SuccessController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print("transporter late running json \(String(describing: json))")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownViewCell") as! DropDownViewCell
               cell.selectionStyle = UITableViewCell.SelectionStyle.none
               cell.backgroundView = nil
               cell.backgroundColor = nil
               
        cell.label.text = list[indexPath.row]
               
               return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.blurView.isHidden = true
        self.select.setTitle(self.list[indexPath.row], for: .normal)
    }
  

}

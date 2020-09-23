//
//  FAQSTableViewController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/28/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class cellData {
   var title:String = ""
    var isExpanded:Bool = false
    var detail:String = ""
    init(title:String,isExpanded:Bool,detail:String) {
        self.title = title
        self.isExpanded = isExpanded
        self.detail = detail
    }
}

class FAQSTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FAQS"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FAQSCell", bundle: nil), forCellReuseIdentifier: "FAQSCell")

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
//      tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        data = [cellData.init(title: "1. How do I register and what documents do I need?", isExpanded: false, detail: "In order to register, please go to 'transporter sign up'. Fill in the form and upload required documents (copy of insurance & driving licence) and then click on registered now button."), cellData.init(title: "2. How can I login into my dashboard?", isExpanded: false, detail: "Once you have completed the initial registration process you will receive an email containing your login details."), cellData.init(title: "3. How do I get job from booked jobs?", isExpanded: false, detail: "On our website or through the app click on the search jobs and then click on find booked jobs. All you need to do is click on get job now and instantaneously it will appear on your dashboard."), cellData.init(title: "4. How will I know my job schedule?", isExpanded: false, detail: "On your dashboard there is a button called booked jobs which contains all the details of all your booked jobs."), cellData.init(title: "5. Do I need to provide any proof that the job has been successfully completed?", isExpanded: false, detail: "Once your job is completed, go to your dashboard and under booked jobs click on job complete button and upload the image of the delivery location and enter the receiver's name and click on update button.")]
    }
    @IBAction func backFAQs_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return tableViewData.count
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableViewData[section].opened == true {
//            return tableViewData[section].sectionData.count + 1
//        } else {
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let dataIndex = indexPath.row - 1
//        if indexPath.row == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeadTableViewCell else { return UITableViewCell()}
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            cell.backgroundView = nil
//            cell.backgroundColor = nil
//            cell.layer.borderWidth = 1.0
//            cell.layer.cornerRadius = 0.5
//            cell.layer.borderColor =  UIColor.darkGray.cgColor
//
//            cell.headerText.text = tableViewData[indexPath.section].title
//            if indexPath.row == 0 {
//                if tableViewData[indexPath.section].opened == true {
//                    cell.arrowImage.image = UIImage(named: "downArrow")
//                } else {
//                    cell.arrowImage.image = UIImage(named: "upArrowColor")
//                }
//            }
//            return cell
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as? FooterTableViewCell else { return UITableViewCell()}
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            cell.backgroundView = nil
//            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = UIColor.darkGray.cgColor
//
//            cell.layer.cornerRadius = 0.5
//
//            cell.textView.text = tableViewData[indexPath.section].sectionData[dataIndex]
//
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeadTableViewCell else { return }
//        if tableViewData[indexPath.section].opened == true {
//           tableViewData[indexPath.section].opened = false
//            cell.arrowImage.image = UIImage(named: "downArrow")
//        let sections = IndexSet.init(integer: indexPath.section)
//        tableView.reloadSections(sections, with: .none)
//        } else {
//            tableViewData[indexPath.section].opened = true
//            cell.arrowImage.image = UIImage(named: "upArrowColor")
//            let sections = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(sections, with: .none)
//        }
//        }
//    }
    
}

extension FAQSTableViewController:UITableViewDelegate,myProtocolr{
    func didTapButton(cell: UITableViewCell) {
        guard let path = tableView.indexPath(for: cell) else {return}
        let cell = tableView.cellForRow(at: path) as? FAQSCell
        let cellData = data[path.row]
        cellData.isExpanded = !cellData.isExpanded
        let isExpanded = cellData.isExpanded
        cell?.detailText.text = isExpanded ? cellData.detail : ""
        cell?.separatorView.isHidden = isExpanded ? true:false
        cell?.button.isSelected = isExpanded
        tableView.beginUpdates()
        tableView.endUpdates()
    }
   
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = data[indexPath.row]
        if cellData.isExpanded{
            return UITableView.automaticDimension
        }
        return 100
    }
    
}
extension FAQSTableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "FAQSCell", for: indexPath) as? FAQSCell
        let cellData = data[indexPath.row]
        cell?.delegate = self
        cell?.titleText.text = cellData.title
        cell?.detailText.text = ""
        return cell ?? UITableViewCell()
    }
    
}

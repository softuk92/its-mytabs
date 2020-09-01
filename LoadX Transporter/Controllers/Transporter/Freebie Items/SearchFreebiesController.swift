//
//  Search Deliveries Controller.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import SDWebImage
import DropDown
import IBAnimatable
import GoogleMaps
import GooglePlaces
import CoreLocation

class SearchFreebiesController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    lazy var searchFreebiesModel = [SearchFreebieModel]()
    var locationPicked = 0
    var pickup_city = ""
    var dropoff_city = ""
    var menuShowing = false
    var HEADER_HEIGHT = 130
    var refresher: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var selectCategory: AnimatableTextField!
    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var keywords: AnimatableTextField!
    @IBOutlet weak var pickup_radius: AnimatableTextField!
    @IBOutlet weak var pickup_radiusView: UIView!
    @IBOutlet weak var availableJobs: UILabel!
    @IBOutlet weak var searchFilter: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    let categoryList = ["Furniture and General Items", "Home Appliances", "Electronics items","Cars and Vehicles", "Others"]
    let radiusList = ["20 Miles", "40 Miles", "60 Miles", "80 Miles", "100 Miles"]
    let dropDown1 = DropDown()
    let dropDown2 = DropDown()
    var pageNumber = 1
    var isLoading = false
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    var doStreet_Route = ""
    var do_City_Route = ""
    var do_allAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Get any item for free"
        spinner.isHidden = true
        pickupLocation.delegate = self
        selectCategory.delegate = self
        pickup_radius.delegate = self
        searchFilter.isHidden = true
        dropDown1.anchorView = pickup_radiusView
        dropDown1.backgroundColor = UIColor.white
        dropDown1.dataSource = radiusList
        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
            self.pickup_radius.text = item
            self.keywords.becomeFirstResponder()
        }
        dropDown1.direction  = .bottom
        dropDown1.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
        
        dropDown2.anchorView = selectCategoryView
        dropDown2.backgroundColor = UIColor.white
        dropDown2.dataSource = categoryList
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectCategory.text = item
            self.selectCategoryView.isHidden = true
            self.keywords.becomeFirstResponder()
        }
        dropDown2.direction  = .bottom
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown2.anchorView?.plainView.bounds.height)!)
        
        searchDeliveriesFunc {
            if  self.searchFreebiesModel.isEmpty {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                self.stackView.isHidden = false
                self.tableView.backgroundView = nil
            } else {
                SVProgressHUD.dismiss()
                self.stackView.isHidden = true
                self.tableView.reloadData()
                self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
            }
        }
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = topView
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        tableView.register(UINib(nibName: "SearchFreebiesCell", bundle: nil) , forCellReuseIdentifier: "allDeliveries")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(SearchFreebiesController.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    @objc func populate() {
        pickupLocation.text = ""
        selectCategory.text = ""
        keywords.text = ""
        pickup_radius.text = ""
        self.searchFreebiesModel.removeAll()
        searchDeliveriesFunc {
            if  self.searchFreebiesModel.isEmpty {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                self.stackView.isHidden = false
                self.tableView.backgroundView = nil
            }   else {
                SVProgressHUD.dismiss()
                self.stackView.isHidden = true
                self.tableView.reloadData()
                self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
            }
        }
        self.refresher.endRefreshing()
    }
    
    @IBAction func searchFilterBtn(_ sender: Any) {
        dropDownFunc()
        if menuShowing == false && searchFreebiesModel.count == 0 {
            stackView.isHidden = false
        }else{
            stackView.isHidden = true
        }
    }
    
    func dropDownFunc() {
        if menuShowing == false {
            if ( UI_USER_INTERFACE_IDIOM() == .pad )
            {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchFilter.isHidden = false
                    self.menuShowing = true
                    self.HEADER_HEIGHT = 562
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.arrowImage.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchFilter.isHidden = false
                    self.menuShowing = true
                    self.HEADER_HEIGHT = 562
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.arrowImage.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            }
            
        } else if menuShowing == true {
            UIView.animate(withDuration: 0.1, animations: {
                self.searchFilter.isHidden = true
                self.menuShowing = false
                self.HEADER_HEIGHT = 130
                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                self.tableView.tableHeaderView = self.topView
                self.tableView.layoutIfNeeded()
                self.arrowImage.image = UIImage(named: "downArrow-1")
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pickup_radius {
            dropDown1.show()
            pickup_radius.endEditing(true)
            view.endEditing(true)
        } else if textField == selectCategory {
            dropDown2.show()
            selectCategory.endEditing(true)
            view.endEditing(true)
        }
    }
    
    //MARK: - Pickuplocation for UITEXTFIELD
    /***************************************************************/
    
    @IBAction func pickupLocationButton(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "UK"
        autocompleteController.autocompleteFilter = filter
        locationPicked = sender.tag
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    //back function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    //MARK: - Function of Search Deliveries
    /***************************************************************/
    
    func searchDeliveriesFunc(completed: @escaping () -> ()) {
        SVProgressHUD.show(withStatus: "Getting Jobs...")
        let url = URL(string: main_URL+"api/searchFreeBies")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    
                    self.searchFreebiesModel = try JSONDecoder().decode([SearchFreebieModel].self, from: data!)
                    SVProgressHUD.dismiss()
                    print("Search all jobs json is \(self.searchFreebiesModel)")
                    
                    DispatchQueue.main.async {
                        completed()
                        SVProgressHUD.dismiss()
                    }
                } catch {
                    SVProgressHUD.dismiss()
                    print(error)
                    DispatchQueue.main.async {
                        self.stackView.isHidden = false
                        self.tableView.backgroundView = nil
                        
                    }
                    
                }
            }
            }.resume()
    }

    //MARK: - UITABLEVIEW Delegate methods
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (pageNumber * 10 > searchFreebiesModel.count) {
            return searchFreebiesModel.count
        } else {
            return pageNumber * 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            let indexPath = IndexPath(row: searchFreebiesModel.count-1, section: 0)
            
            if indexPath.row == searchFreebiesModel.count - 1 {
                pageNumber = pageNumber + 1
                self.spinner.isHidden = false
                self.spinner.startAnimating()
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadTable() {
        self.tableView.reloadData()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allDeliveries") as! SearchFreebiesCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.layer.shadowRadius = 5
        
        let searchDeliveriesRow = searchFreebiesModel[indexPath.row]
        let movingItem = searchDeliveriesRow.moving_item
        cell.moving_item.text = movingItem.capitalized

//        let puStreet = searchDeliveriesRow.pu_street
//        let puRoute = searchDeliveriesRow.pu_route
//        let puCity = searchDeliveriesRow.pu_city
//        let puPostCode = searchDeliveriesRow.pu_post_code
//
//        if puStreet != "" || puRoute != "" {
//            puStreet_Route = puStreet+" "+puRoute+","
//            cell.pickupLabel.text = puStreet
//        }
//        if puCity != "" {
//            pu_City_Route = puStreet_Route+" "+puCity+","
//            cell.pickupLabel.text = pu_City_Route
//        }
//        if puPostCode != "" {
//            let spaceCount = puPostCode.filter{$0 == " "}.count
//            if spaceCount > 0 {
//            if let first = puPostCode.components(separatedBy: " ").first {
//            pu_allAddress = pu_City_Route+" "+first
//            cell.pickupLabel.text = pu_allAddress
//            }
//            } else if spaceCount == 0 {
//            pu_allAddress = pu_City_Route+" "+puPostCode
//            cell.pickupLabel.text = pu_allAddress
//            }
//        }
        cell.pickupLabel.text = searchDeliveriesRow.pick_up
//        let stringDate = searchDeliveriesRow.posted_job
//        let convertedDate = self.convertDateFormatter(stringDate)
        cell.postedDateLabel.text = searchDeliveriesRow.posted_job
        
        let stringDate2 = searchDeliveriesRow.date
        let convertedDate2 = self.convertDateFormatter(stringDate2)
        cell.deliveryDateLabel.text = convertedDate2
    
        let allJobs = String(searchDeliveriesRow.countAllFreeBiesJobs)
        self.availableJobs.text = allJobs

        cell.bidNowRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let refreshAlert = UIAlertController(title: "Alert", message: "Download CTS User application to get this freebie item", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Download", style: .default, handler: { (action: UIAlertAction!) in
                self.rateApp(appId: "id1388340701?mt=8") { (success) in
                    print("Rateapp \(success)")
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        cell.getDetail = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
                frbi_id = self.searchFreebiesModel[indexPath.row].frbi_id
                self.performSegue(withIdentifier: "detail", sender: self)
        }
        
        //image Download
        let image_cell1 = searchDeliveriesRow.image1
        let image_cell2 = searchDeliveriesRow.image2
        let image_cell3 = searchDeliveriesRow.image3
        
        if image_cell1 != nil && image_cell1 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell1!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.image1.image = imageCell
                    }
                }
            }
            
        } else if image_cell2 != nil && image_cell2 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell2!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.image1.image = imageCell
                    }
                }
            }
        } else if image_cell3 != nil && image_cell3 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell3!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.image1.image = imageCell
                    }
                }
            }
        } else {
            let imageCell = UIImage(named: "notfound")
            cell.image1.image = imageCell
        }
        
        return cell
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    
    //MARK:- search jobs
    
    @IBAction func searchJobs(_ sender: Any) {
        searchJobsFunc()
    }
    
    func searchJobsFunc() {
        SVProgressHUD.show(withStatus: "Search Jobs...")
        if pickupLocation.text != "" || selectCategory.text != "" {
            let activeJobs_URL = main_URL+"api/searchFreeBies"
            let parameters : Parameters = ["pickup_location" : pickup_city, "job_type" : selectCategory.text ?? "", "keyword" : keywords.text ?? "", "radious" : self.pickup_radius.text ?? "", "latitude" : String(currentCoordinate.latitude), "longititude" : String(currentCoordinate.longitude)]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        self.searchFreebiesModel.removeAll()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("active Jobs jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        
                        if result == "0" {
                            self.tableView.reloadData()
                            self.stackView.isHidden = false
                            self.tableView.backgroundView = nil
                            SVProgressHUD.showError(withStatus: message)
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.searchFreebiesModel = try JSONDecoder().decode([SearchFreebieModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.searchFreebiesModel)
                                    
                                    for items in self.searchFreebiesModel {
                                        self.availableJobs.text = String(items.countAllFreeBiesJobs)
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.stackView.isHidden = true
                                        self.tableView.reloadData()
                                        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                    }
                                    
                                } catch {
                                    print(error)
                                    let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Error \(response.result.error!)")
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error", message: "Please enter job category or pickup / drop off location", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func convertDateFormatter(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension SearchFreebiesController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if locationPicked == 1 {
            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            pickupLocation.text = place.formattedAddress
            
            if let placeFormat = place.formattedAddress {
                
            }
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                } else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    self.pickup_city = city
                    print("city is \(String(describing: placemarks?.first?.locality))")
                }
                
            })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

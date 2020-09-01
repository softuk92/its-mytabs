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

class SearchDeliveriesController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    lazy var searchDeliveriesModel = [SearchDelivariesModel]()
    var locationPicked = 0
    var pickup_city = ""
    var dropoff_city = ""
    var menuShowing = false
    var HEADER_HEIGHT = 220
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var dropOff: UITextField!
    @IBOutlet weak var selectCategory: iOSDropDown!
    @IBOutlet weak var keywords: AnimatableTextField!
    @IBOutlet weak var pickup_radius: iOSDropDown!
    @IBOutlet weak var availableJobs: UILabel!
    @IBOutlet weak var transporterPartners: UILabel!
    @IBOutlet weak var searchFilter: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var no_record_found: UIImageView!
    
    let categoryList = ["Antiques & Special Care Items", "Bikes & Motorcycles", "Boats","Boxes", "Business & Industrial Goods", "Food & Agriculture", "Freight", "Furniture & General Items", "Machine & Vehicle Parts", "Manpower Assistance","Moving Home", "Office Relocation", "Parcels & Packaged Items","Passenger", "Pets & Livestock", "Piano Moving", "Plant & Heavy Equipment","Vehicle Transportation", "Waste Removal", "Other"]
    let radiusList = ["20 Miles", "40 Miles", "60 Miles", "80 Miles", "100 Miles"]
   
    var pageNumber = 1
    var isLoading = false
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    var doStreet_Route = ""
    var do_City_Route = ""
    var do_allAddress = ""
    var refresher: UIRefreshControl!
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search Deliveries"
        spinner.isHidden = true
        pickupLocation.delegate = self
        dropOff.delegate = self
        selectCategory.delegate = self
        pickup_radius.delegate = self
        keywords.delegate = self
        searchFilter.isHidden = true
        createDatePicker()
        
        selectCategory.optionArray = categoryList
        selectCategory.isSearchEnable = false
        
        selectCategory.didSelect{(selectedText , index ,id) in
            self.selectCategory.text = selectedText
        }
        
        pickup_radius.optionArray = radiusList
        pickup_radius.isSearchEnable = false
        
        pickup_radius.didSelect{(selectedText , index ,id) in
            self.pickup_radius.text = selectedText
        }
        
        searchDeliveriesFunc {
            if  self.searchDeliveriesModel.isEmpty {
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
        tableView.register(UINib(nibName: "SearchDeliveriesCell", bundle: nil) , forCellReuseIdentifier: "allDeliveries")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(SearchDeliveriesController.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
    }
    
    @objc func populate() {
        pickupLocation.text = ""
        dropOff.text = ""
        selectCategory.text = ""
        keywords.text = ""
        pickup_radius.text = ""
        searchDeliveriesFunc {
            if  self.searchDeliveriesModel.isEmpty {
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
        self.refresher.endRefreshing()
    }
    
    @IBAction func searchFilterBtn(_ sender: Any) {
        dropDownFunc()
    }
    
    func dropDownFunc() {
        if menuShowing == false {
            if ( UI_USER_INTERFACE_IDIOM() == .pad )
            {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchFilter.isHidden = false
                    self.menuShowing = true
                    self.HEADER_HEIGHT = 745
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
                    self.HEADER_HEIGHT = 745
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.arrowImage.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            }
            
        } else if menuShowing == true {
            if ( UI_USER_INTERFACE_IDIOM() == .pad )
            {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchFilter.isHidden = true
                    self.menuShowing = false
                    self.HEADER_HEIGHT = 300
                    
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.arrowImage.image = UIImage(named: "downArrow-1")
                    self.view.layoutIfNeeded()
                })
            } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.searchFilter.isHidden = true
                self.menuShowing = false
                self.HEADER_HEIGHT = 220
                
                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                self.tableView.tableHeaderView = self.topView
                self.tableView.layoutIfNeeded()
                self.arrowImage.image = UIImage(named: "downArrow-1")
                self.view.layoutIfNeeded()
            })
        }
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
    
    @IBAction func dropOffLocation(_ sender: UITextField) {
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
        let url = URL(string: main_URL+"api/SearchAlllJobs")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.searchDeliveriesModel.removeAll()
                    self.searchDeliveriesModel = try JSONDecoder().decode([SearchDelivariesModel].self, from: data!)
                    SVProgressHUD.dismiss()
                    print("Search all jobs json is \(self.searchDeliveriesModel)")
                    
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
        if (pageNumber * 10 > searchDeliveriesModel.count) {
            return searchDeliveriesModel.count
        } else {
            return pageNumber * 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//        UIView.animate(withDuration: 0.2) {
//            cell.transform = CGAffineTransform.identity
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            let indexPath = IndexPath(row: searchDeliveriesModel.count-1, section: 0)
            
            if indexPath.row == searchDeliveriesModel.count - 1 {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "allDeliveries") as! SearchDeliveriesCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.layer.shadowRadius = 5
        cell.innerView.layer.cornerRadius = 5
        cell.businessPatti.isHidden = true
        let searchDeliveriesRow = searchDeliveriesModel[indexPath.row]
        
        let movingItem = searchDeliveriesRow.moving_item
        cell.moving_item.text = movingItem.capitalized
        cell.dropOffLabel.text = searchDeliveriesRow.drop_off
        let totalBid = searchDeliveriesRow.totalbid
        if totalBid == "0" {
            cell.quotes.text = "0"
        } else {
            cell.quotes.text = totalBid
        }
        
        let puStreet = searchDeliveriesRow.pu_street
        let puRoute = searchDeliveriesRow.pu_route
        let puCity = searchDeliveriesRow.pu_city
        let puPostCode = searchDeliveriesRow.pu_post_code

        if puStreet != "" || puRoute != "" {
            puStreet_Route = puStreet+" "+puRoute+","
            cell.pickupLabel.text = puStreet
            print("pu street route is \(puStreet_Route)")
        } else {
            puStreet_Route = ""
        }
        
        if puCity != "" {
            pu_City_Route = puStreet_Route+" "+puCity+","
            cell.pickupLabel.text = pu_City_Route
        } else {
            pu_City_Route = puStreet_Route
        }
        if puPostCode != "" {
            let spaceCount = puPostCode.filter{$0 == " "}.count
            if spaceCount > 0 {
            if let first = puPostCode.components(separatedBy: " ").first {
            pu_allAddress = pu_City_Route+" "+first
            cell.pickupLabel.text = pu_allAddress
            }
            } else if spaceCount == 0 {
            pu_allAddress = pu_City_Route+" "+puPostCode
            cell.pickupLabel.text = pu_allAddress
            }
        }
        
        let doStreet = searchDeliveriesRow.do_street
        let doRoute = searchDeliveriesRow.do_route
        let doCity = searchDeliveriesRow.do_city
        let doPostCode = searchDeliveriesRow.do_post_code
        
        if doStreet != "" || doRoute != "" {
            doStreet_Route = doStreet+" "+doRoute+","
            cell.dropOffLabel.text = doStreet
        } else {
            doStreet_Route = ""
        }
        if doCity != "" {
            do_City_Route = doStreet_Route+" "+doCity+","
            cell.dropOffLabel.text = do_City_Route
        } else {
            do_City_Route = doStreet_Route
        }
        if doPostCode != "" {
            let spaceCount = doPostCode.filter{$0 == " "}.count
            if spaceCount > 0 {
                if let first = doPostCode.components(separatedBy: " ").first {
                    do_allAddress = do_City_Route+" "+first
                    cell.dropOffLabel.text = do_allAddress
                }
            } else if spaceCount == 0 {
                do_allAddress = do_City_Route+" "+doPostCode
                cell.dropOffLabel.text = do_allAddress
            }
        }
        
//        let stringDate = searchDeliveriesRow.job_posted_date
//        let convertedDate = self.convertDateFormatter(stringDate)
        cell.postedDateLabel.text = searchDeliveriesRow.job_posted_date
        
        let stringDate2 = searchDeliveriesRow.date
        let convertedDate2 = self.convertDateFormatter(stringDate2)
        cell.deliveryDateLabel.text = convertedDate2
    
        let currentBid = searchDeliveriesRow.current_bid
        let allJobs = String(searchDeliveriesRow.alljobs)
        let allTransporters = String(searchDeliveriesRow.allTransporter)

        self.availableJobs.text = allJobs
        self.transporterPartners.text = allTransporters

        if currentBid != "NoBid" {
        cell.lowest_bid.text = "£"+searchDeliveriesRow.current_bid
        } else {
            cell.lowest_bid.text = "N/A"
        }
        cell.bidNowRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            if user_id != nil {
            del_id = self.searchDeliveriesModel[indexPath.row].del_id
            self.performSegue(withIdentifier: "placeBid", sender: self)
            } else {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
        
        cell.getDetail = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            if user_id != nil {
                del_id = self.searchDeliveriesModel[indexPath.row].del_id
                self.performSegue(withIdentifier: "placeBid", sender: self)
            } else {
                del_id = self.searchDeliveriesModel[indexPath.row].del_id
                self.performSegue(withIdentifier: "detail", sender: self)
            }
        }
        
        //image Download
        let image_cell1 = searchDeliveriesRow.image1
        let image_cell2 = searchDeliveriesRow.image2
        let image_cell3 = searchDeliveriesRow.image3
        
        if image_cell1 != nil && image_cell1 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell1!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //                        print(received, expected)
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
                    //                        print(received, expected)
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
                    //                        print(received, expected)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if user_id != nil {
        del_id = self.searchDeliveriesModel[indexPath.row].del_id
        self.performSegue(withIdentifier: "placeBid", sender: self)
        } else {
            del_id = self.searchDeliveriesModel[indexPath.row].del_id
            self.performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    //MARK:- search jobs
    
    @IBAction func searchJobs(_ sender: Any) {
        searchJobsFunc()
    }
    
    func searchJobsFunc() {
        SVProgressHUD.show(withStatus: "Search Jobs...")
            let activeJobs_URL = main_URL+"api/SearchAlllJobs"
            let parameters : Parameters = ["pickup_location" : pickup_city, "dropof_location" : dropoff_city, "job_type" : selectCategory.text ?? "", "del_date" : keywords.text ?? "", "radious" : self.pickup_radius.text ?? "", "latitude" : String(currentCoordinate.latitude), "longititude" : String(currentCoordinate.longitude)]
//      String(currentCoordinate.latitude)
            print("pickup radius \(self.pickup_radius.text!)")
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        self.searchDeliveriesModel.removeAll()
                        
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
                                    self.searchDeliveriesModel = try JSONDecoder().decode([SearchDelivariesModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.searchDeliveriesModel)
                                    
                                    for items in self.searchDeliveriesModel {
                                        self.availableJobs.text = String(items.alljobs)
                                        self.transporterPartners.text = String(items.allTransporter)
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.stackView.isHidden = true
                                        self.tableView.reloadData()
                                        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                        self.view.layoutIfNeeded()
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
    }
    
    func convertDateFormatter(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
    //MARK: - Function for UIDatepicker
    /***************************************************************/
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        keywords.inputAccessoryView = toolbar
        keywords.inputView = picker
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        keywords.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension SearchDeliveriesController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if locationPicked == 1 {
            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            pickupLocation.text = place.formattedAddress
            
            if let placeFormat = place.formattedAddress {
                self.pickup_city = placeFormat
            }
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                }else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    
                    print("city is \(String(describing: placemarks?.first?.locality))")
                }
                
            })
            
            
        }
        else if locationPicked == 2 {
            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            dropOff.text = place.formattedAddress
            if let placeFormat = place.formattedAddress {
                self.dropoff_city = placeFormat
            }

            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                }else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    self.dropoff_city = city
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

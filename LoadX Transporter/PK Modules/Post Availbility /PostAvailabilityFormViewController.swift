//
//  PostAvailbilityFormViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 30/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import GoogleMaps
import GooglePlaces
import Alamofire
import SVProgressHUD
class PostAvailabilityFormViewController: UIViewController,StoryboardSceneBased {
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var availableLocationTF: UITextField!
    @IBOutlet weak var endLocationTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    
    @IBOutlet weak var availableDateView: UIView!
    @IBOutlet weak var availableLocationView: UIView!
    @IBOutlet weak var endLocationView: UIView!
    var picker = UIDatePicker()
    var dataPosted: (()->(Void))?
    
    var openDestination = 0
    static var sceneStoryboard: UIStoryboard = R.storyboard.transporterAvailability()
    var autocompleteController : GMSAutocompleteViewController = GMSAutocompleteViewController()
    var isAvailableLocationTapped: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 23
        
        submitButton.setTitle(string.submit, for: .normal)
        setupAutoCompleteController()
        
        submitButton.titleLabel?.font = Config.shared.getFont()
    }
        
    func setupAutoCompleteController() {
        autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                // self.traitCollection.userInterfaceStyle == .dark
                autocompleteController.primaryTextColor = UIColor.white
                autocompleteController.secondaryTextColor = UIColor.lightGray
                autocompleteController.tableCellSeparatorColor = UIColor.lightGray
                autocompleteController.tableCellBackgroundColor = UIColor.darkGray
            } else {
                autocompleteController.primaryTextColor = UIColor.black
                autocompleteController.secondaryTextColor = UIColor.lightGray
                autocompleteController.tableCellSeparatorColor = UIColor.lightGray
                autocompleteController.tableCellBackgroundColor = UIColor.white
            }
        }
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = AppUtility.shared.country == .Pakistan ? "PK" : "UK"
        autocompleteController.autocompleteFilter = filter
    }
    
    @IBAction func openDestinationButtonTapped(sender: UIButton){
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
        self.openDestination = sender.isSelected == true ? 1:0
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else {return}
            self.endLocationView.isHidden = !isSelected
        }

    }
    
    @IBAction func backButtonTapped(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Function for UIDatepicker
    /***************************************************************/
    func createDatePicker() {
        picker = UIDatePicker(frame:CGRect(x: 0 , y: self.view.bounds.height-200, width: self.view.bounds.width, height: 200))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
    
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        dateTF.inputAccessoryView = toolbar
        dateTF.inputView = picker
        picker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            self.picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func textDidChanged(sender: UITextField)  {
        createDatePicker()
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        dateTF.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonTap(sender: UIButton){

        let endDestination = openDestination == 0 ? (endLocationTF.text ?? "") : ""
        guard let date = self.dateTF.text, let startP = self.availableLocationTF.text ,let userId = user_id else {return}
        let params: Parameters = ["pa_date":date,"start_point":startP,"end_point":endDestination,"transporter_id":userId,"end_point_checkbox":openDestination]
        guard date.count > 0, startP.count > 0 else {return}
        SVProgressHUD.show()

        APIManager.apiPost(serviceName: "api/transporterPostAvailabilityAPI", parameters: params) {[weak self] data, json, error in
            if error ==  nil{
                self?.reloadData()
            }
            else{
                print(error?.localizedDescription)
            }
            SVProgressHUD.dismiss()

        }
    }
    
    func reloadData() {
        dataPosted?()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func availableLocationAct(_ sender: Any) {
        isAvailableLocationTapped = true
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func endLocationAct(_ sender: Any) {
        isAvailableLocationTapped = false
        self.present(autocompleteController, animated: true, completion: nil)
    }

}


//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension PostAvailabilityFormViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        if isAvailableLocationTapped {
        self.availableLocationTF.text = place.formattedAddress
        } else {
        self.endLocationTF.text = place.formattedAddress
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

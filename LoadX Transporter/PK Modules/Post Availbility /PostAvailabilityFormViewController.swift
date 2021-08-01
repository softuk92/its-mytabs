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
class PostAvailabilityFormViewController: UIViewController,StoryboardSceneBased {
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var availableLocationTF: UITextField!
    @IBOutlet weak var endLocationTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    
    @IBOutlet weak var availableDateView: UIView!
    @IBOutlet weak var availableLocationView: UIView!
    @IBOutlet weak var endLocationView: UIView!
    var picker = UIDatePicker()

    static var sceneStoryboard: UIStoryboard = R.storyboard.transporterAvailability()
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 23
        createDatePicker()
        
    }
    
    @IBAction func openDestinationButtonTapped(sender: UIButton){
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
        endLocationView.isHidden = !isSelected
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
        
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        dateTF.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonTap(sender: UIButton){
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
        self.endLocationView.isHidden = !isSelected
        
      // guard let date = self.dateTF.text, let to
        
    }
    
    
    @IBAction func address_btn(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark   {
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
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        filter.country = AppUtility.shared.country == .Pakistan ? "PK" : "UK"
        
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }

}


//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension PostAvailabilityFormViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        self.availableLocationTF.text = place.formattedAddress
        
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

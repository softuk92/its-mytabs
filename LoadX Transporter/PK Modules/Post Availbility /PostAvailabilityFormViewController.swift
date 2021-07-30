//
//  PostAvailbilityFormViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 30/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
class PostAvailabilityFormViewController: UIViewController,StoryboardSceneBased {
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var availableLocationTF: UITextField!
    @IBOutlet weak var endLocationTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    
    @IBOutlet weak var availableDateView: UIView!
    @IBOutlet weak var availableLocationView: UIView!
    @IBOutlet weak var endLocationView: UIView!

    static var sceneStoryboard: UIStoryboard = R.storyboard.transporterAvailability()
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 23
    }
    
    @IBAction func openDestinationButtonTapped(sender: UIButton){
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
        endLocationView.isHidden = !isSelected
    }
    
    @IBAction func backButtonTapped(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTap(sender: UIButton){
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
       
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else {return}
            self.endLocationView.isHidden = !isSelected
        }
    }

}

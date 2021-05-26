//
//  JobDetailButtonsAlgorithm.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 26/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension JobPickupDropoffViewController {
    //algorithm for buttons configuration against transporter status
    
     func setJobStatus() {
        let status = input.jobStatus
        
            //if job is not started hide
        guard status.is_job_started == "1" else {
                //hide all actions
            bottomButtonsStackView.isHidden = true
                return
            }
            configureJobActions()
        }
    
        private func configureJobActions() {
            //pick, dropoff
            let deliveryState = input.jobStatus.p_leaving_f_dropoff
            if deliveryState == "0" {
                configurePickupActions()
            } else {
                configureDropOffActions()
            }
        }
    
        private func configurePickupActions() {
            //onwayToPickup,arrivedAtPickup
            let status = input.jobStatus
            let pickupState = status.arrival_at_pickup
            
            if pickupState == "0" { //does not arrive at pickup
                upperButtonView.isHidden = false
                bottomButtonView.isHidden = true
                dropoffArrivedBtn.isHidden = true
                uploadImagesBtn.isHidden = true
                
                pickupArrivedBtn.isHidden = false
                
                //show running late if running late is false
                runningLateBtn.isHidden = !(status.p_running_late == "0")
            } else { //if pickupState == "arrivedAtPickup"
                upperButtonView.isHidden = false
                bottomButtonView.isHidden = false
                pickupArrivedBtn.isHidden = true
                dropoffArrivedBtn.isHidden = true
                runningLateBtn.isHidden = true
                jobCompletedBtn.isHidden = true
                
                //show upload image
                uploadImagesBtn.isHidden = false
                //show leaving for drop off
                leavingForDropoffBtn.isHidden = false
            }
        }
    
        private func configureDropOffActions() {
            //onwayToDropOff, arrivedAtDropOff
            let status = input.jobStatus
            let dropoffState = status.d_arrived
            if dropoffState == "0" { // dropoffState == "onwayToDropOff"
                //show arrived
                bottomButtonView.isHidden = true
                uploadImagesBtn.isHidden = true
                runningLateBtn.isHidden = true
                pickupArrivedBtn.isHidden = true
                
                upperButtonView.isHidden = false
                dropoffArrivedBtn.isHidden = false
                
            } else {// if dropoffState == "arrivedAtDropOff" {
                //show job complete
                upperButtonView.isHidden = true
                bottomButtonView.isHidden = false
                leavingForDropoffBtn.isHidden = true
                
                jobCompletedBtn.isHidden = false
            }
        }
}

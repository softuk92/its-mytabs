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
            PickupOrDropOff.text = "Pickup"
            address.text = input.pickupAddress
            configurePickupActions()
        } else {
            PickupOrDropOff.text = "Dropoff"
            address.text = input.dropoffAddress
            configureDropOffActions()
        }
    }
    
    private func configurePickupActions() {
        //onwayToPickup,arrivedAtPickup
        let status = input.jobStatus
        let pickupState = status.arrival_at_pickup
        
        if pickupState == "0" { //does not arrive at pickup
            upperButtonView.isHidden = false
            sendPaymentLinkBtn.isHidden = true
            bottomButtonView.isHidden = false
            dropoffArrivedBtn.isHidden = true
            uploadImagesBtn.isHidden = true
            cashCollectedBtn.isHidden = true
            leavingForDropoffBtn.isHidden = true
            viewJobSummaryBtn.isHidden = true
            pickupArrivedBtn.isHidden = false
            
            //show running late if running late is false
            bottomButtonView.isHidden = !(status.p_running_late == "0" || status.p_running_late == "")
            runningLateBtn.isHidden = !(status.p_running_late == "0" || status.p_running_late == "")
        } else { //if pickupState == "arrivedAtPickup"
            upperButtonView.isHidden = false
            sendPaymentLinkBtn.isHidden = true
            bottomButtonView.isHidden = false
            pickupArrivedBtn.isHidden = true
            dropoffArrivedBtn.isHidden = true
            runningLateBtn.isHidden = true
            jobCompletedBtn.isHidden = true
            cashCollectedBtn.isHidden = true
            viewJobSummaryBtn.isHidden = true
            
            //show upload image
            uploadImagesBtn.isHidden = !(input.jobStatus.is_img_uploaded == "0" || input.jobStatus.is_img_uploaded == "")
            upperButtonView.isHidden = !(input.jobStatus.is_img_uploaded == "0" || input.jobStatus.is_img_uploaded == "")
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
            sendPaymentLinkBtn.isHidden = true
            pickupArrivedBtn.isHidden = true
            cashCollectedBtn.isHidden = true
            viewJobSummaryBtn.isHidden = true
            
            upperButtonView.isHidden = false
            dropoffArrivedBtn.isHidden = false
            
        } else if status.d_cash_received == "0" {
            if input.addType == "Man & Van" || input.addType == "Man and Van" {
                bottomButtonView.isHidden = true
                uploadImagesBtn.isHidden = true
                runningLateBtn.isHidden = true
                pickupArrivedBtn.isHidden = true
                dropoffArrivedBtn.isHidden = true
                upperButtonView.isHidden = false
                cashCollectedBtn.isHidden = true
                sendPaymentLinkBtn.isHidden = true
                
                viewJobSummaryBtn.isHidden = false
                
            } else {
                bottomButtonView.isHidden = true
                uploadImagesBtn.isHidden = true
                runningLateBtn.isHidden = true
                pickupArrivedBtn.isHidden = true
                dropoffArrivedBtn.isHidden = true
                viewJobSummaryBtn.isHidden = true
                upperButtonView.isHidden = false
                
                if input.paymentType == .Account {
                    sendPaymentLinkBtn.isHidden = false
                    cashCollectedBtn.isHidden = true
                } else {
                    cashCollectedBtn.isHidden = false
                    sendPaymentLinkBtn.isHidden = true
                }
            }
        } else {// if dropoffState == "arrivedAtDropOff" and cash collected/send payment link {
            //show job complete
            upperButtonView.isHidden = true
            bottomButtonView.isHidden = false
            runningLateBtn.isHidden = true
            leavingForDropoffBtn.isHidden = true
            
            jobCompletedBtn.isHidden = false
        }
    }
}

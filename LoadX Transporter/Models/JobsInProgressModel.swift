//
//  JobsInProgressModel.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import Foundation

struct JobsInProgressModel: Codable {
    let jbID, contactPerson, isBookedJob: String
    let isJobStarted: String?
    let formatedJobID, longPickup, paymentType: String
    let loadxShare: String?
    let addType, contactPhone, userID: String
    let latDropoff, contactMail: String
    let isCompanyJob: String?
    let transporterShare: String?
    let longDropoff: String
    let price: String?
    let distance, dropOff: String
    let receiverName, receiverPhone: String?
    let puHouseNo: String?
    let movingItem, date, pickUp: String
    let jobPaymentType: String?
    let latPickup, delID, isCod: String
    let doHouseNo: String?
    let workingHours, timeSlot: String?
    let isCz: String?
    let currentBid: String?
    let driverName: String?
    let driverPhone: String?
    
    enum CodingKeys: String, CodingKey {
        case jbID = "jb_id"
        case isJobStarted = "is_job_started"
        case contactPerson = "contact_person"
        case isBookedJob = "is_booked_job"
        case formatedJobID = "formated_job_id "
        case loadxShare = "loadx_share"
        case longPickup = "long_pickup"
        case paymentType = "payment_type"
        case receiverPhone = "receiver_phone"
        case addType = "add_type"
        case contactPhone = "contact_phone"
        case userID = "user_id"
        case isCompanyJob = "is_company_job"
        case latDropoff = "lat_dropoff"
        case contactMail = "contact_mail"
        case transporterShare = "transporter_share"
        case longDropoff = "long_dropoff"
        case price
        case receiverName = "receiver_name"
        case distance
        case dropOff = "drop_off"
        case puHouseNo = "pu_house_no"
        case movingItem = "moving_item"
        case date
        case pickUp = "pick_up"
        case jobPaymentType = "job_payment_type"
        case latPickup = "lat_pickup"
        case delID = "del_id"
        case doHouseNo = "do_house_no"
        case isCod = "is_cod"
        case workingHours = "working_hours"
        case timeSlot = "timeslot"
        case isCz = "is_cz"
        case currentBid = "current_bid"
        case driverName = "driver_name"
        case driverPhone = "driver_phone"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.jbID = try container.decode(String.self, forKey: .jbID)
        self.isJobStarted = try container.decode(String.self, forKey: .isJobStarted)
        self.contactPerson = try container.decode(String.self, forKey: .contactPerson)
        self.isBookedJob = try container.decode(String.self, forKey: .isBookedJob)
        self.formatedJobID = try container.decode(String.self, forKey: .formatedJobID)
        self.loadxShare = try container.decode(String.self, forKey: .loadxShare)
        self.longPickup = try container.decode(String.self, forKey: .longPickup)
        self.paymentType = try container.decode(String.self, forKey: .paymentType)
        self.receiverPhone = try container.decodeIfPresent(String.self, forKey: .receiverPhone)
        self.addType = try container.decode(String.self, forKey: .addType)
        self.contactPhone = try container.decode(String.self, forKey: .contactPhone)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.isCompanyJob = try container.decode(String.self, forKey: .isCompanyJob)
        self.latDropoff = try container.decode(String.self, forKey: .latDropoff)
        self.contactMail = try container.decode(String.self, forKey: .contactMail)
        self.transporterShare = try container.decode(String.self, forKey: .transporterShare)
        self.longDropoff = try container.decode(String.self, forKey: .longDropoff)
        
        if user_type == TransportationCompany {
            self.price = try container.decode(String.self, forKey: .price)
        } else {
            self.price = "\(try container.decode(Int.self, forKey: .price))"
        }
        
        self.receiverName = try container.decodeIfPresent(String.self, forKey: .receiverName)
        self.distance = try container.decode(String.self, forKey: .distance)
        self.dropOff = try container.decode(String.self, forKey: .dropOff)
        self.puHouseNo = try container.decodeIfPresent(String.self, forKey: .puHouseNo)
        self.movingItem = try container.decode(String.self, forKey: .movingItem)
        self.date = try container.decode(String.self, forKey: .date)
        self.pickUp = try container.decode(String.self, forKey: .pickUp)
        self.jobPaymentType = try container.decodeIfPresent(String.self, forKey: .jobPaymentType)
        self.latPickup = try container.decode(String.self, forKey: .latPickup)
        self.delID = try container.decode(String.self, forKey: .delID)
        self.doHouseNo = try container.decodeIfPresent(String.self, forKey: .doHouseNo)
        self.isCod = try container.decode(String.self, forKey: .isCod)
        self.workingHours = try container.decodeIfPresent(String.self, forKey: .workingHours)
        self.timeSlot = try container.decodeIfPresent(String.self, forKey: .timeSlot)
        self.isCz = try container.decodeIfPresent(String.self, forKey: .isCz)
        self.currentBid = try container.decodeIfPresent(String.self, forKey: .currentBid)
        self.driverName = try container.decodeIfPresent(String.self, forKey: .driverName)
        self.driverPhone = try container.decodeIfPresent(String.self, forKey: .driverPhone)
    }
}

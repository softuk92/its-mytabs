//
//  BookedRoute.swift
//  LoadX Transporter
//
//  Created by CTS Move on 23/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation

public struct BookedRoute: Codable {
    let lr_id: String
    let lr_no_of_stops: String
    let lr_start_location: String
    let lr_end_location: String
    let lr_total_price: Double
    let lr_date: String
    let lr_total_distance: String
    let lr_total_transport_time: String
    let is_route_started: String?
//    public let lrID, lrNoOfStops, lrStartLocation, lrEndLocation: String
//    public let lrTotalPrice: Int
//    public let lrDate, lrTotalDistance, lrTotalTransportTime, isRouteStarted: String
//
//    enum CodingKeys: String, CodingKey {
//        case lrID = "lr_id"
//        case lrNoOfStops = "lr_no_of_stops"
//        case lrStartLocation = "lr_start_location"
//        case lrEndLocation = "lr_end_location"
//        case lrTotalPrice = "lr_total_price"
//        case lrDate = "lr_date"
//        case lrTotalDistance = "lr_total_distance"
//        case lrTotalTransportTime = "lr_total_transport_time"
//        case isRouteStarted = "is_route_started"
//    }
}

// MARK: Convenience initializers

//extension BookedRoute {
//    init?(data: Data) {
//        guard let me = try? JSONDecoder().decode(BookedRoute.self, from: data) else { return nil }
//        self = me
//    }
//
//}


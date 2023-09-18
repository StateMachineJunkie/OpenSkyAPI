//
//  Flight.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/28/23.
//

import Foundation

extension OpenSkyService {

    public struct Flight: Decodable, Equatable, Hashable {
        public let icao24: String                           // Transponder address
        public let firstSeen: UInt                          // Time this flight was first seen in seconds since (Unix) epoch?
        public let estDepartureAirport: String?
        public let lastSeen: UInt                           // Time this flight was last seen in seconds since (Unix) epoch?
        public let estArrivalAirport: String?
        public let callsign: String?
        public let estDepartureAirportHorizDistance: Int?   // Horizontal distance (units?) from departure airport
        public let estDepartureAirportVertDistance: Int?    // Vertical distance (units?) from departure airport
        public let estArrivalAirportHorizDistance: Int?     // Horizontal distance (units?) from arrival airport
        public let estArrivalAirportVertDistance: Int?      // Vertical distance (units?; direct vector or altitude?) from arrival airport
        public let departureAirportCandidatesCount: Int
        public let arrivalAirportCandidatesCount: Int
    }
}

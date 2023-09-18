//
//  Track.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/26/23.
//

import Foundation

extension OpenSkyService {
    public struct Waypoint: Hashable {
        public let time: UInt           // Seconds since (Unix) epoch
        public let latitude: Float?     // WGS-84 latitude in degrees
        public let longitude: Float?    // WGS-84 longitude in degrees
        public let altitude: Float?     // Barometric altitude in meters
        public let trueTrack: Float?    // Track in decimal degrees clockwise from north (north = 0º)
        public let isOnGround: Bool     // Indicates if the position was retrieved from a surface position report
    }
}

extension OpenSkyService.Waypoint: Codable {
    private enum CodingKeys: String, CodingKey {
        case time
        case latitude
        case longitude
        case altitude = "baro_altitude"
        case trueTrack = "true_track"
        case isOnGround = "on_ground"
    }

    public init(from decoder: Decoder) throws {
        // Use and unkeyed container to decode the path (waypoint) array
        var container   = try decoder.unkeyedContainer()
        time            = try container.decode(UInt.self)
        latitude        = try container.decodeIfPresent(Float.self)
        longitude       = try container.decodeIfPresent(Float.self)
        altitude        = try container.decodeIfPresent(Float.self)
        trueTrack       = try container.decodeIfPresent(Float.self)
        isOnGround      = try container.decode(Bool.self)
    }
}

extension OpenSkyService {
    public struct Track: Hashable {
        public let icao24: String       // ICAO 24-Bit address in lower-case hexadecimal
        public let startTime: UInt      // Time of the first waypoint in seconds since (Unix) epoch
        public let endTime: UInt        // Time of the last waypoint in seconds since (Unix) epoch
        public let callsign: String?    // Callsign (8 characters) that holds for the whole track.
        public let path: [Waypoint]
    }
}

extension OpenSkyService.Track: Codable {
    private enum CodingKeys: String, CodingKey {
        case icao24
        case startTime
        case endTime
        case callsign
        case path
    }
}

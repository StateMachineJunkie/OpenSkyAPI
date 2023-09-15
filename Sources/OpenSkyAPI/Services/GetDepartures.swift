//
//  GetDepartures.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation

// Get departures by airport.
//
// Retrieve flights for the given airport that departed within the given time interval [begin, end].
//
// - Parameters:
//   - airport: ICAO identifier for the airport.
//   - timeInterval: `ClosedRange` [begin, end] in seconds from (Unix) epoch.
// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
//            matching the given parameters.
// - Note: The interval range must be less than or equal to seven days.
public class GetDepartures: OpenSkyService {

	private let airport: String
    private let timeInterval: ClosedRange<UInt>

    override public var maxTimeInterval: UInt {
        60 * 60 * 24 * 7    // Override default with a value of 7 days for this interval.
    }

    public init(from airport: String, in timeInterval: ClosedRange<UInt>) throws {
        // TODO: Consider adding verification for the ICAO parameter
        self.airport = airport
        self.timeInterval = timeInterval
        super.init()
        try validateOpenSkyTimeInterval(timeInterval)
    }

    public func invoke() async throws -> [OpenSkyService.Flight] {
        let params: [String : Any] = [
            "airport" : airport,
            "begin" : String(timeInterval.lowerBound),
            "end" : String(timeInterval.upperBound)
        ]

        let queryItems: [URLQueryItem] = params.queryItems!
        let url = URL(string: "flights/departure", relativeTo: OpenSkyService.apiBaseURL)!
        let request: URLRequest

        if let authentication {
            request = URLRequest(url: url.appending(queryItems: queryItems), authentication: authentication)
        } else {
            request = URLRequest(url: url.appending(queryItems: queryItems))
        }

        return try await invoke(with: request)
    }
}

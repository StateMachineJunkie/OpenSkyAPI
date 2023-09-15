//
//  GetAllFlights.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation

// Get flights for a given time interval.
//
// - Parameter timeInterval: `ClosedRange` [begin, end] in seconds from (Unix) epoch.
// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
//            matching the given time interval.
// - Note: The interval range must be less than or equal to two hours.
public class GetAllFlights: OpenSkyService {

    private let timeInterval: ClosedRange<UInt>

    init(within timeInterval: ClosedRange<UInt>) throws {
        self.timeInterval = timeInterval
        super.init()
        try validateOpenSkyTimeInterval(timeInterval)
    }

    func invoke() async throws -> [OpenSkyService.Flight] {
        let params: [String : Any] = [
            "begin" : String(timeInterval.lowerBound),
            "end" : String(timeInterval.upperBound)
        ]

        let queryItems = params.queryItems!

        let url = URL(string: "flights/all", relativeTo: OpenSkyService.apiBaseURL)!
        let request: URLRequest

        if let authentication {
            request = URLRequest(url: url.appending(queryItems: queryItems), authentication: authentication)
        } else {
            request = URLRequest(url: url.appending(queryItems: queryItems))
        }

        return try await invoke(with: request)
    }
}

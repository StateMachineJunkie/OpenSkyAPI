//
//  GetFlights.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation

// Get flights for a given set of aircraft within a given time interval.
//
// - Parameters:
//   - transponders: Array of aircraft transponders identifiers. These are unique ICAO24 values.
//   - timeInterval: `ClosedRange` [begin, end] in seconds from (Unix) epoch.
// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
//            matching the given parameters.
// - Note: The transponder array must contain at least one value in order for the service to complete successfully.
// - Note: The interval range must be less than or equal to thirty days and must be a non-zero value.
public class GetFlights: OpenSkyService {

    private let timeInterval: ClosedRange<UInt>
	private let transponders: [OpenSkyService.ICAO24]

    public init(for transponders: [OpenSkyService.ICAO24], in timeInterval: ClosedRange<UInt>) throws {
        guard transponders.count > 0 else {
            throw OpenSkyService.Error.invalidTransponderParameter
        }

        self.transponders = transponders
        self.timeInterval = timeInterval
        super.init()

        try validateOpenSkyTimeInterval(timeInterval)
    }

    public func invoke() async throws -> [OpenSkyService.Flight] {
        var queryItems: [URLQueryItem] = transponders.queryItems(withKey: "icao24")
        queryItems.append(URLQueryItem(name: "begin", value: String(timeInterval.lowerBound)))
        queryItems.append(URLQueryItem(name: "end", value: String(timeInterval.upperBound)))

        let url = URL(string: "flights/aircraft", relativeTo: OpenSkyService.apiBaseURL)!

        let request: URLRequest

        if let authentication {
            request = URLRequest(url: url.appending(queryItems: queryItems), authentication: authentication)
        } else {
            request = URLRequest(url: url.appending(queryItems: queryItems))
        }

        return try await invoke(with: request)
    }
}

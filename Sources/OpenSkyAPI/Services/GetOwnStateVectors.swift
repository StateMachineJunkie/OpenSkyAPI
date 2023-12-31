//
//  GetAllStateVectors.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation

// Get state-vectors for your own sensors without any rate limitations.
//
// - Parameters:
//   - transponders: An array containing one or more ICAO24 transponder addresses in lower-cased hexadecimal string
//                   representation.
//   - time: Time in seconds since (Unix) epoch. This time coordinate represents the time stamp to retrieve states
//           for. If this parameter is not provided then the current time will be used in its place.
//   - serials: This parameter will filter the states of a subset of your receivers.
//   - authentication: Required in order to invoke this API call.
//   - isIncludingCategory: Boolean indicating whether or not the aircraft category should be included with each
//                          state-vector returned from this invocation.
//
// - Returns: A `StateVectors` value, which can be empty if no results were found to match the provided parameters.
public class GetOwnStateVectors: OpenSkyService {

    private let transponders: [OpenSkyService.ICAO24]

    public var isIncludingCategory: Bool = false
    public var serials: [Int]?
    public var time: UInt = UInt(Date().timeIntervalSince1970)

    public init(with transponders: [OpenSkyService.ICAO24]) {
        self.transponders = transponders
    }

    public func invoke() async throws -> OpenSkyService.StateVectors {
        var queryItems: [URLQueryItem] = transponders.queryItems(withKey: "icao24")

        if let serials, serials.count > 0 {
            queryItems.append(contentsOf: serials.queryItems(withKey: "serials"))
        }

        var params: [String : Any] = [:]
        params["time"] = time

        if isIncludingCategory {
            params["extended"] = 1
        }

        if let paramQueryItems = params.queryItems {
            queryItems.append(contentsOf: paramQueryItems)
        }

        let url = URL(string: "states/own", relativeTo: OpenSkyService.apiBaseURL)!
        let request: URLRequest

        if let authentication {
            request = URLRequest(url: url.appending(queryItems: queryItems), authentication: authentication)
        } else {
            request = URLRequest(url: url.appending(queryItems: queryItems))
        }

        return try await invoke(with: request)
    }
}

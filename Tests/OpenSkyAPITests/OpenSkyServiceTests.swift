//
//  OpenSkyServiceTests.swift
//  OpenSky Flight TrackerTests
//
//  Created by Michael Crawford on 9/6/23.
//

import XCTest
@testable import OpenSkyAPI

final class OpenSkyServiceTests: XCTestCase {

    // If these tests run successfully, we are happy. They only verify the happy-path to make sure that the basic
    // implementation for wrapping the API works against the live service. This is a first step and may be the only
    // step due to the simplicity of the API. Thus, these tests are more of a demo than uni-tests; not the
    // intended use of XCTestCase but since it moves me forward, I'll take it.

    // NOTE: These tests should not be run together with the MockOpenSkyServiceTests, if this constraint is not
    //       followed, all of the OpenSkyServiceTests will fail. I believe it is an interaction with the URLProtocol
    //       implementation and XCTest runtimes. If you run both suites individually, they should both pass.

    private let auth: OpenSkyService.Authentication? = {
        return OpenSkyService.Authentication(username: "your-username", password: "your-password")
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getAllStateVectors() async throws {
        let service = GetAllStateVectors()
        let stateVectors = try await service.invoke()
        print("GetAllStateVectors returned \(stateVectors.states.count) states.")
    }

    func test_getAllStateVectors_with_area() async throws {
        let service = GetAllStateVectors()
        let area = OpenSkyService.WGS84Area(lamin: 31.64, lomin: -114.40, lamax: 37.0, lomax: -109.21)
        service.area = area
        service.authentication = auth
        service.isIncludingCategory = true

        let stateVectors = try await service.invoke()
        print("GetAllStateVectors for a given area returned \(stateVectors.states.count) states.")
    }

    func test_getArrivals() async throws {
        let service = try GetArrivals(at: "EDDF", in: 1517227200...1517230800)
        service.authentication = auth
        let flights = try await service.invoke()
        print("GetArrivals returned \(flights.count) flights.")
    }

    func test_getDepartures() async throws {
        let service = try GetDepartures(from: "EDDF", in: 1517227200...1517230800)
        service.authentication = auth
        let flights = try await service.invoke()
        print("GetDepartures returned \(flights.count) flights.")
    }

    /// Fetch fetch tracking information for flights that have taken off in the last hour.
    ///
    /// - NOTE: This test can fail with a 404 from time to time based on the absence of real data.
    func test_getFlights() async throws {
        // Fetch flights for the last hour.
        let now = Date()
        let oneHourInterval: TimeInterval = 3_600
        let dateInterval = DateInterval(start: Date(timeInterval: -oneHourInterval, since: now), end: now)
        let range = UInt(dateInterval.start.timeIntervalSince1970)...UInt(dateInterval.end.timeIntervalSince1970)
        let flightService = try GetAllFlights(within: range)
        flightService.authentication = auth
        let flights = try await flightService.invoke()

        // Of the results select and track the one that most recently took off.
        XCTAssert(flights.count > 0)    // No flights anywhere in the world for the last hour would be unusual.

        let sortedFlights = flights.sorted { $0.firstSeen < $1.lastSeen }
        let flight = sortedFlights.last!

        let trackService = try GetTracks(for: OpenSkyService.ICAO24(icao24String: flight.icao24)!)
        trackService.authentication = auth
        let track = try await trackService.invoke()
        print(track)
    }
}

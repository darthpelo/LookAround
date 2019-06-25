//
//  FoursquareManagerTests.swift
//  LookAroundTests
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

@testable import LookAround
import MapKit
import XCTest

class FoursquareManagerTests: XCTestCase {
    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private func getJSONSample(fileName: String) throws -> Data? {
        if let filepath = Bundle.main.url(forResource: fileName, withExtension: "json") {
            return try Data(contentsOf: filepath)
        }
        return nil
    }

    func testSearchVenuesDecode() {
        do {
            let data = try getJSONSample(fileName: "searchVenuesStub")

            let venues = try jsonDecoder.decode(Response<SearchResponse>.self, from: data!)

            XCTAssertEqual(venues.response.venues.count, 1)
            XCTAssertEqual(venues.response.venues.first!.venueId, "5642aef9498e51025cf4a7a5")

        } catch {
            XCTFail("Should not have failed for SearchResponse with json searchVenuesStub: \(error)")
        }
    }

    func testVenueDetailDecode() {
        do {
            let data = try getJSONSample(fileName: "venueDetailStub")

            let venues = try jsonDecoder.decode(Response<DetailResponse>.self, from: data!)

            XCTAssertEqual(venues.response.venue.venueId, "412d2800f964a520df0c1fe3")
            XCTAssertEqual(venues.response.venue.name, "Central Park")

        } catch {
            XCTFail("Should not have failed for SearchResponse with json searchVenuesStub: \(error)")
        }
    }

    func testAnnotation() {
        let sut = VenueAnnotation(venueID: Stub.veuneID, title: nil, coordinate: Stub.coordinate)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.coordinate.latitude, Stub.latitude)
        XCTAssertEqual(sut.coordinate.longitude, Stub.longitude)
    }
}

extension XCTestCase {
    struct Stub {
        static let latitude = 0.0
        static let longitude = 0.0
        static let coordinate = CLLocationCoordinate2D(latitude: Stub.latitude, longitude: Stub.longitude)
        static let veuneID = "test"
    }
}

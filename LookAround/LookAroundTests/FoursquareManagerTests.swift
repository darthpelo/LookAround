//
//  FoursquareManagerTests.swift
//  LookAroundTests
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

@testable import LookAround
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

    func testSearchVenuesStubDecode() {
        do {
            let data = try getJSONSample(fileName: "searchVenuesStub")

            let venues = try jsonDecoder.decode(Response<SearchResponse>.self, from: data!)

            XCTAssertEqual(venues.response.venues.count, 1)
            XCTAssertEqual(venues.response.venues.first!.venueId, "5642aef9498e51025cf4a7a5")

        } catch {
            XCTFail("Should not have failed for SearchResponse with json searchVenuesStub: \(error)")
        }
    }
}

//
//  Mocks.swift
//  LookAroundTests
//
//  Created by Alessio Roberto on 25/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

@testable import LookAround
import MapKit
import XCTest

class MockAppDependencies: AppDependenciesProtocol {
    var foursquareClientable: FoursquareClientable

    init(_ foursquareClientable: FoursquareClientable) {
        self.foursquareClientable = foursquareClientable
    }
}

protocol FoursquareManagerMockable {
    var getVenuesCallsCount: Int { get }
    var getVenuesCalled: Bool { get }
}

class FoursquareManagerMock: FoursquareClientable, FoursquareManagerMockable {
    private var shouldFails: Bool

    init(shouldFails: Bool = false) {
        self.shouldFails = shouldFails
    }

    var getVenuesCallsCount = 0
    var getVenuesCalled: Bool {
        return getVenuesCallsCount > 0
    }

    func getVenues(parameter: [String: String], completion: @escaping ([Venue]?) -> Void) {
        getVenuesCallsCount += 1

        let latlong = parameter["ll"]
        let radius = parameter["radius"]

        XCTAssertEqual(latlong, "0.0,0.0")
        XCTAssertEqual(radius, "500.0")

        completion(nil)
    }

    var getDetailCallsCount = 0
    var getDetailCalled: Bool {
        return getDetailCallsCount > 0
    }

    func getDetail(venueID: String, completion: @escaping (VenueDetail?) -> Void) {
        getDetailCallsCount += 1

        if shouldFails {
            completion(nil)
        } else {
            completion(VenueDetail(venueId: venueID,
                                   name: "",
                                   location: Location(address: nil,
                                                      latitude: Stub.latitude,
                                                      longitude: Stub.longitude)))
        }
    }
}

struct Stub {
    static let latitude = 0.0
    static let longitude = 0.0
    static let coordinate = CLLocationCoordinate2D(latitude: Stub.latitude, longitude: Stub.longitude)
    static let veuneID = "test"
}

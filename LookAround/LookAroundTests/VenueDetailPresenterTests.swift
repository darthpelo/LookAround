//
//  VenueDetailPresenterTests.swift
//  LookAroundTests
//
//  Created by Alessio Roberto on 25/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

@testable import LookAround
import MapKit
import XCTest

class VenueDetailPresenterTests: XCTestCase {
    typealias Dependencies = HasFoursquareClientable

    func testVdenueDetailFails() {
        let view = MockVenueDetailView()
        let foursquareManager = FoursquareManagerMock(shouldFails: true)
        let dependencies = MockAppDependencies(foursquareManager)
        let sut = VenueDetailPresenter(view: view, dependencies: dependencies)

        sut.getVenueDetail(venueId: Stub.veuneID)

        XCTAssertEqual(view.updateVenueCallsCount, 0)
    }

    func testVdenueDetailSuccess() {
        let view = MockVenueDetailView()
        let foursquareManager = FoursquareManagerMock()
        let dependencies = MockAppDependencies(foursquareManager)
        let sut = VenueDetailPresenter(view: view, dependencies: dependencies)

        let expectedResult = expectation(description: "Async request")

        sut.getVenueDetail(venueId: Stub.veuneID)
        view.testCallback = { result in
            XCTAssertEqual(result, 1)
            expectedResult.fulfill()
        }

        waitForExpectations(timeout: 3.0, handler: nil)
    }
}

private final class MockVenueDetailView: UIViewController, VenueDetailView {
    var testCallback: ((Int) -> Void)?

    var updateVenueCallsCount = 0

    func updateVenue(name _: String, and _: String?) {
        updateVenueCallsCount += 1
        testCallback?(updateVenueCallsCount)
    }
}

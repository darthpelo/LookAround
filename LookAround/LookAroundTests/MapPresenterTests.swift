//
//  MapPresenterTests.swift
//  LookAroundTests
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

@testable import LookAround
import MapKit
import XCTest

class MapPresenterTests: XCTestCase {
    typealias Dependencies = HasFoursquareClientable
    var dependencies: Dependencies?
    var foursquareManager: FoursquareManagerMock?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        foursquareManager = FoursquareManagerMock()
        dependencies = MockAppDependencies(foursquareManager!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegionChanged() {
        let sut = MapPresenter(view: MockMapView(), dependencies: dependencies!)
        sut.regionChanged(CLLocationCoordinate2D(latitude: Stub.latitude, longitude: Stub.longitude))

        XCTAssertTrue(foursquareManager!.getVenuesCalled)
        XCTAssertEqual(foursquareManager!.getVenuesCallsCount, 1)
    }

    func testSearchNewVenues() {
        let sut = MapPresenter(view: MockMapView(), dependencies: dependencies!)
        sut.searchNewVenues()

        XCTAssertFalse(foursquareManager!.getVenuesCalled)
        XCTAssertEqual(foursquareManager!.getVenuesCallsCount, 0)
    }
}

private final class MockMapView: UIViewController, MapView {
    func updateMap(region _: MKCoordinateRegion) {}

    func addAnnotation(_: VenueAnnotation) {}
}

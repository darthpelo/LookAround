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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dependencies = MockAppDependencies()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegionChanged() {
        let sut = MapPresenter(view: MockMapView(), dependencies: dependencies!)
        sut.regionChanged(CLLocationCoordinate2D(latitude: Stub.latitude, longitude: Stub.longitude))
    }

    func testSearchNewVenues() {
        let sut = MapPresenter(view: MockMapView(), dependencies: dependencies!)
        sut.searchNewVenues()
    }
}

private final class MockMapView: UIViewController, MapView {
    func updateMap(region _: MKCoordinateRegion) {}

    func addAnnotation(_: VenueAnnotation) {}
}

private class MockAppDependencies: AppDependenciesProtocol {
    var foursquareClientable: FoursquareClientable = FoursquareManagerMock()
}

private final class FoursquareManagerMock: FoursquareClientable {
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
}

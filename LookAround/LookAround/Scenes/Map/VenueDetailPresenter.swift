//
//  VenueDetailPresenter.swift
//  LookAround
//
//  Created by Alessio Roberto on 25/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import Foundation

protocol VenueDetailPresentable {
    func getVenueDetail(venueId: String)
}

protocol VenueDetailView {
    func updateVenue(name: String, and address: String?)
}

struct VenueDetailPresenter: VenueDetailPresentable {
    typealias Dependencies = HasFoursquareClientable

    private var dependencies: Dependencies?
    private var view: VenueDetailView?

    init(view: VenueDetailView, dependencies: Dependencies = AppDependencies()) {
        self.view = view
        self.dependencies = dependencies
    }

    func getVenueDetail(venueId: String) {
        dependencies?.foursquareClientable.getDetail(venueID: venueId) { detail in
            if let detail = detail {
                DispatchQueue.main.async {
                    self.view?.updateVenue(name: detail.name, and: detail.location.address)
                }
            } else {}
        }
    }
}

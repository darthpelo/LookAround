//
//  VenueDetailViewController.swift
//  LookAround
//
//  Created by Alessio Roberto on 25/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var otherLabel: UILabel!

    var venueID: String?
    private lazy var presenter: VenueDetailPresentable = VenueDetailPresenter(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let venueId = venueID else { return }

        presenter.getVenueDetail(venueId: venueId)
    }

    @IBAction func closeButtonTapped(_: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VenueDetailViewController: VenueDetailView {
    func updateVenue(name: String, and address: String?) {
        titleLabel.text = name
        otherLabel.text = address
    }
}

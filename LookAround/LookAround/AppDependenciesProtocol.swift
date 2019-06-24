//
//  AppDependenciesProtocol.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import Foundation

protocol AppDependenciesProtocol: HasFoursquareClientable {}

class AppDependencies: AppDependenciesProtocol {
    var foursquareClientable: FoursquareClientable = FoursquareManager()
}

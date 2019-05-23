//
//  Capital.swift
//  Project16
//
//  Created by Rahul Sharma on 5/23/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import MapKit
import Foundation

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
}

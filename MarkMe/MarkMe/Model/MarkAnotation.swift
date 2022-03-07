//
//  MarkAnotation.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 7.03.22.
//

import Foundation
import MapKit

class MarAnnotation: NSObject, MKAnnotation {
    var title: String?
    var creator: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, creator: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.creator = creator
        self.coordinate = coordinate
    }
}

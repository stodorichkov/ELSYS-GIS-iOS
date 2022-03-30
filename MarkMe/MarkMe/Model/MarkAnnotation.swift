//
//  MarkAnotation.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 7.03.22.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var markInfo: Mark
    
    init(markInfo: Mark) {
        self.markInfo = markInfo
        super.init()
    }
}
